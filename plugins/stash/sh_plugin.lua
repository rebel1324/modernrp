local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = PLUGIN.stashData or {}

nut.item.registerInv("stashInv", 8, 8)

if (SERVER) then
	 -- Create New Inventory when Character is Created
	 -- Set "stashinv" value to New Inventory's Index Value
	 -- When Character is deleted, delete that stashinv. 
	 -- Works like normal storage. 
	 -- I think this size limitation will help the oneself being big ass one man army.
	local charMeta = FindMetaTable("Character")

	function charMeta:getStash()
	end
else
end