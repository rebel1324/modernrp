SCHEMA.name = "Modern RP Base" -- Change this name if you're going to create new schema.
SCHEMA.author = "Black Tea"
SCHEMA.desc = "An example modern RP schema that is very basic."

-- TODO: Vehicles
-- TODO: Lottery
-- TODO: Drugs? maybe?
-- TODO: Make Item Spawner Default.
-- TODO: Permastash

nut.util.include("sh_configs.lua")
nut.util.include("sv_hooks.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sh_hooks.lua")
nut.util.include("sh_commands.lua")
nut.util.include("meta/sh_player.lua")
nut.util.include("meta/sh_entity.lua")
nut.util.include("meta/sh_character.lua")
nut.util.include("sh_dev.lua") -- Developer Functions