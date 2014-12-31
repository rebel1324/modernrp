SCHEMA.name = "Modern RP Base" -- Change this name if you're going to create new schema.
SCHEMA.author = "Black Tea"
SCHEMA.desc = "An example modern RP schema that is very basic."

-- TODO: Vehicles
-- TODO: Lottery
-- TODO: Drugs? maybe?
-- TODO: Make Item Spawner Default.
-- TODO: Permastash

-- Schema Help Menu. You can add more stuffs in cl_hooks.lua.
SCHEMA.helps = {
	["About the schema"] = 
	[[If you're watching this default help menu text, There is two meaning of that.
	<br>
	<br>First of all, This schema is under a development and in very early stage, The developer/owner of this schema does not even edited defualt menu text.
	<br>Second, If you're just a user, The server owner/developer is just lazy as hell. Because, they didn't even touched this text.
	<br>
	<br>To modify or delete this text, You must go to schema/sh_schema.lua and modify some of texts.]],
	["What is this?"] = 
	[[This schema is Modern RP Base.
	<br>This schema can be anything. The author of shcema, Black Tea Za rebel1324 just made this schema to show what NutScript can do. 
	<br>You can make this as complete schema. Such as Real City Life Schema, Zombie Survival Schema or Another Original Schema.]],
	["About the author"] = 
	[[This schema's author is Black Tea za rebel1324(https://github.com/rebel1324).
	<br>I'm is gone to army in 2014. Feb. 9. So, After this date, There is no way to get further support from me.
	<br>This could be my last official schema release.
	<br>But, I beileve you. You can make awesome stuffs with NutScript.
	<br>Also you can send me some cheer mail to me: rebel1324@gmail.com]]
}

nut.util.include("sh_configs.lua")
nut.util.include("sv_hooks.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sh_hooks.lua")
nut.util.include("sh_commands.lua")
nut.util.include("meta/sh_player.lua")
nut.util.include("meta/sh_entity.lua")
nut.util.include("meta/sh_character.lua")
nut.util.include("sh_dev.lua") -- Developer Functions
nut.dialogue.loadFromDir(SCHEMA.folder .. "/schema/dialogues")