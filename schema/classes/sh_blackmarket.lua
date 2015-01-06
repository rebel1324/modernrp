-- Set the 'nice' display name for the class.
CLASS.name = "Black Market Dealer"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_CITIZEN

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
end

CLASS.business = {
	["weed"] = true,
	["mlgbot"] = true,
	["healthkit"] = true,
	["healvial"] = true,
}

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_BLACKDEALER = CLASS.index