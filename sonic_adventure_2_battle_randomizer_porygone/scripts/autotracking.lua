ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/mission_data.lua")

LEVEL_UNLOCKS = {}



CUR_INDEX = -1
SLOT_DATA = nil


function updateGateUnlocks(newEmblemCount)
    print("updateGateUnlocks: ")
    local bosses_complete = Tracker:ProviderCountForCode("bosses_complete")
    for k,v in pairs(LEVEL_UNLOCKS) do
        local boss_beaten = false
        for k2, v2 in pairs(SLOT_DATA['GateCosts']) do
            if v == v2 then
                boss_beaten = bosses_complete >= tonumber(k2)
            end
        end
        if (v <= newEmblemCount) and boss_beaten then
            print(k, v, newEmblemCount, boss_beaten)
            local obj = Tracker:FindObjectForCode(LEVEL_MAPPING[tonumber(k)][1])
            if obj then
                obj.Active = true
            end
        end
    end
end

function setupGates(slot_data)
    for k,v in pairs(slot_data['RegionEmblemMap']) do
        LEVEL_UNLOCKS[k] = v
    end

    updateGateUnlocks(0)
end

function setupMissions(slot_data)
    for k,v in pairs(slot_data['MissionMap']) do
        print(k, v)
        local obj = Tracker:FindObjectForCode(MISSION_MAPPING[tonumber(k)][1])
        if obj then
            obj.AcquiredCount = v
        end
    end

    for k,v in pairs(slot_data['MissionCountMap']) do
        print(k, v)
        local obj = Tracker:FindObjectForCode(MISSION_COUNT_MAPPING[tonumber(k)][1])
        if obj then
            obj.AcquiredCount = v
        end
    end

end

function onClear(slot_data)
    SLOT_DATA = slot_data
    CUR_INDEX = -1

    for _, v in pairs(ITEM_MAPPING) do
        if v[1] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    if obj.Active then
                        obj.CurrentStage = 0
                    else
                        obj.Active = true
                    end
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                end
            end
        end
    end
    for _, v in pairs(SETTINGS_MAPPING) do
        if v[1] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                obj.AcquiredCount = 0
            end
        end
    end

    for k, v in pairs(LOCATION_MAPPING) do
        local loc_list = LOCATION_MAPPING[k]
        for i, loc in ipairs(loc_list) do
            local obj = Tracker:FindObjectForCode(loc)
            if obj then
                if loc:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            end
        end
    end

    if SLOT_DATA == nil then
        return
    end

    setupGates(slot_data)
    setupMissions(slot_data)

    if slot_data['IncludeMissions'] then
        local obj = Tracker:FindObjectForCode("mission_count")
        if obj then
            obj.AcquiredCount = slot_data['IncludeMissions']
        end
    end

    if slot_data['EmblemsForCannonsCore'] then
        local obj100 = Tracker:FindObjectForCode("cannons_core_cost_100")
        local obj10 = Tracker:FindObjectForCode("cannons_core_cost_10")
        local obj1 = Tracker:FindObjectForCode("cannons_core_cost_1")
        if obj100 and obj10 and obj1 then
            obj100.AcquiredCount = (slot_data['EmblemsForCannonsCore'] // 100)
            obj10.AcquiredCount = (math.fmod(slot_data['EmblemsForCannonsCore'], 100) // 10)
            obj1.AcquiredCount = (math.fmod(slot_data['EmblemsForCannonsCore'], 10))
        end
    end

    if slot_data['goal'] then
        local goal = Tracker:FindObjectForCode("goal")
        goal.Active =  tonumber(slot_data['goal']) > 0
    end

    if slot_data['keysanity'] then
        local keysanity = Tracker:FindObjectForCode("keysanity")
        keysanity.Active = (slot_data['keysanity'])
    end

    if slot_data['beetlesanity'] then
        local beetlesanity = Tracker:FindObjectForCode("beetlesanity")
        beetlesanity.Active = (slot_data['beetlesanity'])
    end

    if slot_data['whistlesanity'] then
        local pipesanity = Tracker:FindObjectForCode("pipesanity")
        local hiddensanity = Tracker:FindObjectForCode("hiddensanity")
        local whistlesanity_value = tonumber(slot_data['whistlesanity'])
        pipesanity.Active = (whistlesanity_value == 1 or whistlesanity_value == 3)
        hiddensanity.Active = (whistlesanity_value == 2 or whistlesanity_value == 3)
    end

    if slot_data['ChaoGardenDifficulty'] then
        local chao_diff = Tracker:FindObjectForCode("chao_garden_difficulty")
        chao_diff.AcquiredCount = (slot_data['ChaoGardenDifficulty'])
    end

    if slot_data['include_chao_karate'] then
        local chao_karate = Tracker:FindObjectForCode("chao_karate")
        chao_karate.Active = (slot_data['include_chao_karate'])
    end

    if slot_data['ChaoRaceChecks'] then
        local chao_prize = Tracker:FindObjectForCode("chao_prize_only")
        chao_prize.Active = (slot_data['ChaoRaceChecks'])
    end

    if slot_data['GateCosts'] then
        local chao_beg = Tracker:FindObjectForCode("chao_beginner_cost")
        local chao_int = Tracker:FindObjectForCode("chao_intermediate_cost")
        local chao_exp = Tracker:FindObjectForCode("chao_expert_cost")
        local gate_count = Tracker:FindObjectForCode("gate_count")

        if slot_data['GateCosts']["5"] then
            chao_beg.AcquiredCount = (slot_data['GateCosts']["1"])
            chao_int.AcquiredCount = (slot_data['GateCosts']["2"])
            chao_exp.AcquiredCount = (slot_data['GateCosts']["4"])
            gate_count.AcquiredCount = 5
        elseif slot_data['GateCosts']["4"] then
            chao_beg.AcquiredCount = (slot_data['GateCosts']["1"])
            chao_int.AcquiredCount = (slot_data['GateCosts']["2"])
            chao_exp.AcquiredCount = (slot_data['GateCosts']["3"])
            gate_count.AcquiredCount = 4
        elseif slot_data['GateCosts']["3"] then
            chao_beg.AcquiredCount = (slot_data['GateCosts']["0"])
            chao_int.AcquiredCount = (slot_data['GateCosts']["1"])
            chao_exp.AcquiredCount = (slot_data['GateCosts']["3"])
            gate_count.AcquiredCount = 3
        elseif slot_data['GateCosts']["2"] then
            chao_beg.AcquiredCount = (slot_data['GateCosts']["0"])
            chao_int.AcquiredCount = (slot_data['GateCosts']["1"])
            chao_exp.AcquiredCount = (slot_data['GateCosts']["2"])
            gate_count.AcquiredCount = 2
        elseif slot_data['GateCosts']["1"] then
            chao_beg.AcquiredCount = (slot_data['GateCosts']["0"])
            chao_int.AcquiredCount = (slot_data['GateCosts']["0"])
            chao_exp.AcquiredCount = (slot_data['GateCosts']["1"])
            gate_count.AcquiredCount = 1
        elseif slot_data['GateCosts']["0"] then
            chao_beg.AcquiredCount = (slot_data['GateCosts']["0"])
            chao_int.AcquiredCount = (slot_data['GateCosts']["0"])
            chao_exp.AcquiredCount = (slot_data['GateCosts']["0"])
            gate_count.AcquiredCount = 0
        end

        local gate_cost_1 = Tracker:FindObjectForCode("gate_cost_1")
        local gate_cost_2 = Tracker:FindObjectForCode("gate_cost_2")
        local gate_cost_3 = Tracker:FindObjectForCode("gate_cost_3")
        local gate_cost_4 = Tracker:FindObjectForCode("gate_cost_4")
        local gate_cost_5 = Tracker:FindObjectForCode("gate_cost_5")

        if slot_data['GateCosts']["1"] then gate_cost_1.AcquiredCount = slot_data['GateCosts']["1"] end
        if slot_data['GateCosts']["2"] then gate_cost_2.AcquiredCount = slot_data['GateCosts']["2"] end
        if slot_data['GateCosts']["3"] then gate_cost_3.AcquiredCount = slot_data['GateCosts']["3"] end
        if slot_data['GateCosts']["4"] then gate_cost_4.AcquiredCount = slot_data['GateCosts']["4"] end
        if slot_data['GateCosts']["5"] then gate_cost_5.AcquiredCount = slot_data['GateCosts']["5"] end
    end
end

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then return end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    
    local v = ITEM_MAPPING[item_id]
    if not v then
        return
    end

    if not v[1] then
        return
    end

    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
            if v[1] == "emblems" then
                updateGateUnlocks(obj.AcquiredCount)
            end
        end
    end
end

function onLocation(location_id, location_name)
    local loc_list = LOCATION_MAPPING[location_id]

    for i, loc in ipairs(loc_list) do
        if not loc then
            return
        end
        local obj = Tracker:FindObjectForCode(loc)
        if obj then
            if loc:sub(1, 1) == "@" then
                obj.AvailableChestCount = obj.AvailableChestCount - 1
            else
                obj.Active = true
            end
        end
    end

    if location_id == 0xFF0100 or location_id == 0xFF0101 or location_id == 0xFF0102 or location_id == 0xFF0103 or location_id == 0xFF0104 then
        local bosses_complete = Tracker:FindObjectForCode("bosses_complete")
        bosses_complete.AcquiredCount = bosses_complete.AcquiredCount + 1
        local emblem_count = Tracker:FindObjectForCode("emblems")
        updateGateUnlocks(emblem_count.AcquiredCount)
    end
end


Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
