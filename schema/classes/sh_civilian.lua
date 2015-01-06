-- Set the 'nice' display name for the class.
CLASS.name = "Civilian"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_CITIZEN
CLASS.isDefault = true

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
end

-- CLASS.index is defined internall when the class is registered.
-- It is basically the class's numeric ID.
-- We set a global variable to save this index for easier reference.
CLASS_CIVILIAN = CLASS.index