-- The 'nice' name of the faction.
FACTION.name = "Law Enforcers"
-- A description used in tooltips in various menus.
FACTION.desc = "The people who enforces the laws of the land."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(70, 70, 220)
-- Set the male model choices for character creation.
FACTION.models = {
	"models/police.mdl"
}
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false
FACTION.isPublic = true

FACTION.salary = 20

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_CP = FACTION.index
