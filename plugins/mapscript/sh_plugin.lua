local PLUGIN = PLUGIN
PLUGIN.name = "Map Script"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "A Script that run on map"

local path = PLUGIN.folder
nut.util.includeDir(path .. "/maps/" .. string.lower(game.GetMap()), true)
/*
local a, b = file.Find("modernrp/gamemode/maps/"..string.lower(game.GetMap())..".lua", "LUA")
for k, v in pairs(a) do
	if v == string.lower(game.GetMap()) .. ".lua" then
		AddCSLuaFile("maps/"..string.lower(game.GetMap())..".lua")
		include("maps/"..string.lower(game.GetMap())..".lua")
	end
end
*/