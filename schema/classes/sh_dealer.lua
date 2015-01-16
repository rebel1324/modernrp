CLASS.name = "Dealer"
CLASS.faction = FACTION_CITIZEN
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

	-- Educational
	["endbook"] = 1,
	["gunskillbook"] = 1,
	["medicalbook"] = 1,
	["meleeskillbook"] = 1,
	["stmbook"] = 1,

	-- Outfit
	["pot"] = 1,
	["skullmask"] = 1,

	-- Foods
	["cannedbean"] = 1,	
	["sodabottle"] = 1,	
	["sodacan"] = 1,	
}

function CLASS:OnSet(client)
end

CLASS_DEALER = CLASS.index