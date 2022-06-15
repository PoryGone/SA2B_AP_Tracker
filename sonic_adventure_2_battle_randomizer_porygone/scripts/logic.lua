
function CalculateCannonsCoreCost()
	local cost_hundreds = Tracker:ProviderCountForCode("cannons_core_cost_100")
	local cost_tens     = Tracker:ProviderCountForCode("cannons_core_cost_10")
	local cost_ones     = Tracker:ProviderCountForCode("cannons_core_cost_1")

	return (cost_hundreds * 100 + cost_tens * 10 + cost_ones)
end
	
function CannonsCoreAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = CalculateCannonsCoreCost()
	return emblemCount + 1 - emblemReqCount
end

function ChaoBeginnerAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_beginner_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoIntermediateAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_intermediate_cost")
	return emblemCount + 1 - emblemReqCount
end

function ChaoExpertAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = Tracker:ProviderCountForCode("chao_expert_cost")
	return emblemCount + 1 - emblemReqCount
end

function NotChaoPrizeOnly()
	local chao_prize_only = Tracker:ProviderCountForCode("chao_prize_only")
	return 1 - chao_prize_only
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
