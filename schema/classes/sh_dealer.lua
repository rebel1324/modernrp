-- Set the 'nice' display name for the class.
CLASS.name = "Dealer"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_CITIZEN

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
end

CLASS.business = {
	-- Storages
	["bagmid"] = 1,	
	["bagsmall"] = 1,	

	-- Medical Supplies
	["aidkit"] = 1,	
	["healthkit"] = 1,	
	["healvial"] = 1,	

	-- Communication
	["radio"] = 1,	
	["pager"] = 1,	

	-- Misc
	["note"] = 1,
	["spraycan"] = 1,

	-- Outfit
	["pot"] = 1,
	["skullmask"] = 1,

	-- Foods
	["cannedbean"] = 1,	
	["sodabottle"] = 1,	
	["sodacan"] = 1,	
}

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_DEALER = CLASS.index