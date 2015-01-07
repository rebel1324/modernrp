-- Set the 'nice' display name for the class.
CLASS.name = "Black Market Dealer"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_CITIZEN

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
end

CLASS.business = {
	-- Ammunition
	["357ammo"] = 1,	
	["pistolammo"] = 1,	
	["shotgunammo"] = 1,	
	["smg1ammo"] = 1,	

	-- Illegal
	["mlgbot"] = 1,	
	["weed"] = 1,	
	["steroid"] = 1,	
	["moneyprinter"] = 1,

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
	["pot"] = 1,
	["skullmask"] = 1,

	-- Misc
	["note"] = 1,
	["spraycan"] = 1,
}


-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_BLACKDEALER = CLASS.index