-- Set the 'nice' display name for the class.
CLASS.name = "Cook"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_CITIZEN

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
end

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

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_COOK = CLASS.index