
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
