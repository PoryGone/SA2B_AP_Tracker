
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
