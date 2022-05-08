ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

LEVEL_UNLOCKS = {}

CUR_INDEX = -1
SLOT_DATA = nil


function updateGateUnlocks(newEmblemCount)
    for k,v in pairs(LEVEL_UNLOCKS) do
        if v <= newEmblemCount then
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
    
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
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
    local v = LOCATION_MAPPING[location_id]

    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])     
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    end
end


Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
