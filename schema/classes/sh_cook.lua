CLASS.name = "Cook"
CLASS.faction = FACTION_CITIZEN
CLASS.business = {
	-- Foods
	["burger"] = 1,	
	["cannedbean"] = 1,	
	["chilidog"] = 1,	
	["chinese"] = 1,	
	["doughnut"] = 1,	
	["sodabottle"] = 1,	
	["sodacan"] = 1,	
	["stew"] = 1,	
	["watermelon"] = 1,	
}

function CLASS:OnSet(client)
end

CLASS_COOK = CLASS.index