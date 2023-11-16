
ScriptHost:LoadScript("scripts/autotracking/mission_data.lua")


function CalculateCannonsCoreCost()
	local cost = Tracker:ProviderCountForCode("cannons_core_cost")
	return cost
end
	
function CannonsCoreAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = CalculateCannonsCoreCost()
	return emblemCount + 1 - emblemReqCount
end

function ChaoRaceBeginnerAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_race_beginner_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoRaceIntermediateAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_race_intermediate_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoRaceExpertAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_race_expert_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoKarateBeginnerAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_karate_beginner_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoKarateStandardAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_karate_intermediate_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoKarateExpertAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_karate_expert_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoKarateSuperAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_karate_super_cost")
	return emblemCount + 1 - emblemReqCount
end

function BlackMarketAvailable(slot)
	local black_market_tokens = Tracker:ProviderCountForCode("black_market_tokens")
	local black_market_unlock_costs = Tracker:ProviderCountForCode("black_market_unlock_costs")
	local mult = 0.5
	if tonumber(black_market_unlock_costs) == 1 then mult = 0.75
	elseif tonumber(black_market_unlock_costs) == 2 then mult = 1.0
	end
	return black_market_tokens >= math.floor(tonumber(slot) * mult)
end

function NotChaoPrizeOnly()
	local chao_prize_only = Tracker:ProviderCountForCode("chao_prize_only")
	return 1 - chao_prize_only
end

function NotKeysanity()
	local keysanity = Tracker:ProviderCountForCode("keysanity")
	return 1 - keysanity
end

function BossAvailable(boss_index)
	local emblemCount = Tracker:ProviderCountForCode("emblems")
    local gate_cost_1 = Tracker:ProviderCountForCode("gate_cost_1")
    local gate_cost_2 = Tracker:ProviderCountForCode("gate_cost_2")
    local gate_cost_3 = Tracker:ProviderCountForCode("gate_cost_3")
    local gate_cost_4 = Tracker:ProviderCountForCode("gate_cost_4")
    local gate_cost_5 = Tracker:ProviderCountForCode("gate_cost_5")

	local boss_available = false
	if tonumber(boss_index) == 1 then boss_available = (emblemCount >= gate_cost_1)
	elseif tonumber(boss_index) == 2 then boss_available = (emblemCount >= gate_cost_2)
	elseif tonumber(boss_index) == 3 then boss_available = (emblemCount >= gate_cost_3)
	elseif tonumber(boss_index) == 4 then boss_available = (emblemCount >= gate_cost_4)
	elseif tonumber(boss_index) == 5 then boss_available = (emblemCount >= gate_cost_5)
	end

	return boss_available
end

function BossRushAvailable()
	local goal = Tracker:FindObjectForCode("goal")
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local cannon_core_cost = CalculateCannonsCoreCost()
	
	local boss_available = false
    if goal.CurrentStage == 3 then
		boss_available = true
    elseif goal.CurrentStage == 4 then
		boss_available = (emblemCount >= cannon_core_cost)
    elseif goal.CurrentStage == 5 then
		local emerald_1 = Tracker:ProviderCountForCode("white_chaos_emerald")
		local emerald_2 = Tracker:ProviderCountForCode("red_chaos_emerald")
		local emerald_3 = Tracker:ProviderCountForCode("blue_chaos_emerald")
		local emerald_4 = Tracker:ProviderCountForCode("cyan_chaos_emerald")
		local emerald_5 = Tracker:ProviderCountForCode("yellow_chaos_emerald")
		local emerald_6 = Tracker:ProviderCountForCode("purple_chaos_emerald")
		local emerald_7 = Tracker:ProviderCountForCode("green_chaos_emerald")

		if emerald_1 > 0 and emerald_2 > 0 and emerald_3 > 0 and emerald_4 > 0 and emerald_5 > 0 and emerald_6 > 0 and emerald_7 > 0 then
			boss_available = true
		end
	end

	return boss_available
end

function MissionAccess(level_num, mission_num, glitched)
    local mission_order_id = MISSION_MAPPING[tonumber(level_num)][1]
    local level_name_str = MISSION_NAME_MAPPING[tonumber(level_num)][1]
    local mission_order = Tracker:ProviderCountForCode(mission_order_id)

	for i=2,5 do
		if MISSION_ORDERS[mission_order][i] == tonumber(mission_num) then
			local location_str = '@' .. level_name_str .. '/Mission ' .. tostring(MISSION_ORDERS[mission_order][i-1])
			local location = Tracker:FindObjectForCode(location_str)

			--print(location_str .. ' | ' .. location.AccessibilityLevel .. ' | ' .. AccessibilityLevel.SequenceBreak .. ' | ' .. AccessibilityLevel.Normal)

			if tonumber(glitched) == 1 then
				return (location.AccessibilityLevel >= AccessibilityLevel.SequenceBreak)
			else
				return (location.AccessibilityLevel >= AccessibilityLevel.Normal)
			end
		end
	end

	return true
end

function MissionActive(level_num, mission_num)
	local show_missions = Tracker:ProviderCountForCode("show_missions")
    if show_missions > 0 then
		return 1
	end

    local mission_order_id = MISSION_MAPPING[tonumber(level_num)][1]
    local mission_order = Tracker:ProviderCountForCode(mission_order_id)

    local mission_count_id = MISSION_COUNT_MAPPING[tonumber(level_num)][1]
    local mission_count = Tracker:ProviderCountForCode(mission_count_id)

	for i=1, mission_count do
		if MISSION_ORDERS[mission_order][i] == tonumber(mission_num) then
			return 1
		end
	end
	
	return 0
end

function IsNoLevelGoal()
	local show_missions = Tracker:FindObjectForCode("goal")
    if show_missions.CurrentStage == 2 then
		return 0
	end
	
	return 1
end

function ChaoStatCallback(code)
    local stat_swim         = Tracker:FindObjectForCode("@Chao Stat - Swim/Level")
    local stat_fly          = Tracker:FindObjectForCode("@Chao Stat - Fly/Level")
    local stat_run          = Tracker:FindObjectForCode("@Chao Stat - Run/Level")
    local stat_power        = Tracker:FindObjectForCode("@Chao Stat - Power/Level")
    local stat_stamina      = Tracker:FindObjectForCode("@Chao Stat - Stamina/Level")
    local stat_luck         = Tracker:FindObjectForCode("@Chao Stat - Luck/Level")
    local stat_intelligence = Tracker:FindObjectForCode("@Chao Stat - Intelligence/Level")

    local chao_stats = Tracker:FindObjectForCode("chao_stats")
    local chao_stats_frequency = Tracker:FindObjectForCode("chao_stats_frequency")

    stat_swim.AvailableChestCount         = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
    stat_fly.AvailableChestCount          = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
    stat_run.AvailableChestCount          = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
    stat_power.AvailableChestCount        = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
    stat_stamina.AvailableChestCount      = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
    stat_luck.AvailableChestCount         = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
    stat_intelligence.AvailableChestCount = math.ceil(chao_stats.AcquiredCount / chao_stats_frequency.AcquiredCount)
end

function ChaoStatFrequencyCallback(code)
	ChaoStatCallback(code)
end


function ShowMissionsCallback(code)
    local show_missions = Tracker:FindObjectForCode("show_missions")
	Tracker:FindObjectForCode("city_escape_available").Active = show_missions.Active
	Tracker:FindObjectForCode("wild_canyon_available").Active = show_missions.Active
	Tracker:FindObjectForCode("prison_lane_available").Active = show_missions.Active
	Tracker:FindObjectForCode("metal_harbor_available").Active = show_missions.Active
	Tracker:FindObjectForCode("green_forest_available").Active = show_missions.Active
	Tracker:FindObjectForCode("pumpkin_hill_available").Active = show_missions.Active
	Tracker:FindObjectForCode("mission_street_available").Active = show_missions.Active
	Tracker:FindObjectForCode("aquatic_mine_available").Active = show_missions.Active
	Tracker:FindObjectForCode("route_101_available").Active = show_missions.Active
	Tracker:FindObjectForCode("hidden_base_available").Active = show_missions.Active
	Tracker:FindObjectForCode("pyramid_cave_available").Active = show_missions.Active
	Tracker:FindObjectForCode("death_chamber_available").Active = show_missions.Active
	Tracker:FindObjectForCode("eternal_engine_available").Active = show_missions.Active
	Tracker:FindObjectForCode("meteor_herd_available").Active = show_missions.Active
	Tracker:FindObjectForCode("crazy_gadget_available").Active = show_missions.Active
	Tracker:FindObjectForCode("final_rush_available").Active = show_missions.Active
	Tracker:FindObjectForCode("iron_gate_available").Active = show_missions.Active
	Tracker:FindObjectForCode("dry_lagoon_available").Active = show_missions.Active
	Tracker:FindObjectForCode("sand_ocean_available").Active = show_missions.Active
	Tracker:FindObjectForCode("radical_highway_available").Active = show_missions.Active
	Tracker:FindObjectForCode("egg_quarters_available").Active = show_missions.Active
	Tracker:FindObjectForCode("lost_colony_available").Active = show_missions.Active
	Tracker:FindObjectForCode("weapons_bed_available").Active = show_missions.Active
	Tracker:FindObjectForCode("security_hall_available").Active = show_missions.Active
	Tracker:FindObjectForCode("white_jungle_available").Active = show_missions.Active
	Tracker:FindObjectForCode("route_280_available").Active = show_missions.Active
	Tracker:FindObjectForCode("sky_rail_available").Active = show_missions.Active
	Tracker:FindObjectForCode("mad_space_available").Active = show_missions.Active
	Tracker:FindObjectForCode("cosmic_wall_available").Active = show_missions.Active
	Tracker:FindObjectForCode("final_chase_available").Active = show_missions.Active
	Tracker:FindObjectForCode("cannons_core_available").Active = show_missions.Active
end

ScriptHost:AddWatchForCode("update_chao_stats", "chao_stats", ChaoStatCallback)
ScriptHost:AddWatchForCode("update_chao_stats_frequency", "chao_stats_frequency", ChaoStatFrequencyCallback)
ScriptHost:AddWatchForCode("update_show_missions", "show_missions", ShowMissionsCallback)
