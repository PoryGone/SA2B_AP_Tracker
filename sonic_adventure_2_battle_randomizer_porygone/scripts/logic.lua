
function CalculateCannonsCoreCost()
	local cost_hundreds = Tracker:ProviderCountForCode("cannons_core_cost_100")
	local cost_tens     = Tracker:ProviderCountForCode("cannons_core_cost_10")
	local cost_ones     = Tracker:ProviderCountForCode("cannons_core_cost_1")

	return (cost_hundreds * 100 + cost_tens * 10 + cost_ones)
end
	
function CannonsCoreAvailable()
	local emblemCount = Tracker:ProviderCountForCode("emblems")
	local emblemReqCount = CalculateCannonsCoreCost()
	return emblemCount >= emblemReqCount
end

function IncludeMission2()
	local mission_count = Tracker:ProviderCountForCode("mission_count")

	return (mission_count >= 2)
end

function IncludeMission3()
	local mission_count = Tracker:ProviderCountForCode("mission_count")

	return (mission_count >= 3)
end

function IncludeMission4()
	local mission_count = Tracker:ProviderCountForCode("mission_count")

	return (mission_count >= 4)
end

function IncludeMission5()
	local mission_count = Tracker:ProviderCountForCode("mission_count")

	return (mission_count >= 5)
end
