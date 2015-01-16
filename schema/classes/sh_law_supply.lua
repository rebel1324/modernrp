CLASS.name = "Police Supply Manager"
CLASS.faction = FACTION_CP
CLASS.loadout = {
	["nut_cs_fiveseven"] = 40,
}

CLASS.business = {
	-- Ammunition
	["357ammo"] = 1,	
	["pistolammo"] = 1,	
	["shotgunammo"] = 1,	
	["smg1ammo"] = 1,	
	["ar2ammo"] = 1,	

	-- Medical Supplies
	["aidkit"] = 1,	
	["healthkit"] = 1,	
	["healvial"] = 1,	

	-- Communication
	["radio"] = 1,	
	["pager"] = 1,	
	["sradio"] = 1,	

	-- Grenades
	["teargas"] = 1,	
	["flare_g"] = 1,	
	["flare_b"] = 1,	
	["flare"] = 1,	
	["doorcharge"] = 1,	

	-- Outfit
	["gasmask"] = 1,

	-- Firearms
	["aug"] = 1,
	["fiveseven"] = 1,
	["m4a1"] = 1,
	["mp5"] = 1,
	["ump"] = 1,
	["usp"] = 1,
}

function CLASS:OnSet(client)
end

CLASS_LAW_SUPPLY = CLASS.index