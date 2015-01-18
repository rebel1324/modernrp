-- The 'nice' name of the faction.
FACTION.name = "Law Enforcers"
-- A description used in tooltips in various menus.
FACTION.desc = "The people who enforces the laws of the land."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(70, 70, 220)
-- Set the male model choices for character creation.
FACTION.models = {
	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_04.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl"
}
-- Set it so the faction requires a whitelist.
FACTION.isDefault = false
FACTION.isPublic = true

FACTION.salary = 200

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_LAW = FACTION.index
