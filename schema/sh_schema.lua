SCHEMA.name = "Modern RP Base" -- Change this name if you're going to create new schema.
SCHEMA.author = "Black Tea"
SCHEMA.desc = "An example modern RP schema that is very basic."

-- TODO: Vehicles
-- TODO: Drugs? maybe?
-- TODO: FAS2 Weapon Integration?
-- TODO: Make Item Spawner Default.
-- TODO: Permastash

-- HUD: Heartbeat 
/*
 1. [] [] [] [] 
 2. [] [] [] []
 3. [] [] [] []

 you can selct weapon slot 1, 2, 3
 you can change your weapon by changing slot number
 you pressing same number.
*/

nut.perk.loadFromDir("modernrp/schema/perks")

nut.util.include("sh_configs.lua")
nut.util.include("sh_meta.lua")
nut.util.include("sv_hooks.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sh_hooks.lua")
nut.util.include("sh_dev.lua") -- Developer Functions