-- Set the 'nice' display name for the class.
CLASS.name = "Metrocop Recruit"
-- Set the faction that the class belongs to.
CLASS.faction = FACTION_CP

-- Set what happens when the player has been switched to this class.
-- It passes the player which just switched.
function CLASS:OnSet(client)
end

CLASS_CP_RCT = CLASS.index

if (SERVER) then
end
