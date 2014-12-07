local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = {}
PLUGIN.stashSize = 10

nut.util.include("cl_vgui.lua")

if (SERVER) then
	function PLUGIN:SaveStash(id)
		local schema = string.lower(SCHEMA.folder)
		local path = Format("%s/%s.txt", schema, id)
		local encoded = self.stashData[id]

		if (encoded) then
			encoded = pon.encode(encoded)

			file.Write(path, encoded)
		end
	end

	function PLUGIN:LoadStash(id)
		local schema = string.lower(SCHEMA.folder)
		local path = Format("%s/%s.txt", schema, id)
		local stash

		if (file.Exists(path, "DATA")) then
			stash = file.Read(path, "DATA")
		end

		if (stash and stash != "") then
			stash = pon.decode(stash)

			return stash or {}
		end

		return {}
	end

	function PLUGIN:GetStash(id)
		if (!self.stashData[id]) then
			self.stashData[id] = self:LoadStash() or {}
		end

		return self.stashData[id]
	end

	function PLUGIN:CanPlayerUseStash(client)
		return true
	end

	function requestStash(client)
		local char = client:getChar()

		if (hook.Run("CanPlayerUseStash", client) == false) then
			return
		end

		if (char and char.player == client) then
			local stashInv = PLUGIN:GetStash(char.id)

			netstream.Start(client, "nutStashFrame", stashInv)
		else
			client:notify("Wrong request.")
		end

	end

	netstream.Hook("SthAdd", function(client, id, itemID)
		if (hook.Run("CanPlayerUseStash", client) == false) then
			return
		end

		local itemTable = nut.item.instances[itemID]
		local char = client:getChar()

		if (char and char:getInv() and itemTable) then
			self.stashData[id] = self.stashData[id] or {}
			self.stashData[id][itemID] = self.stashData[id][itemID]

			table.insert(self.stashData[id][itemID], itemTable.data or {})
			char:remove(itemID)
		end
	end)

	netstream.Hook("SthRmv", function(client, id, itemid)
		if (hook.Run("CanPlayerUseStash", client) == false) then
			return
		end

	end)
else
	netstream.Hook("nutStashFrame", function(stashInv)
		if (stashMenu and stashMenu:IsVisible()) then
			stashMenu:Close()
			stashMenu = nil
		end

		stashMenu = vgui.Create("nutStashFrame")
		stashMenu:loadStash(stashInv)
	end)

	netstream.Hook("SthRmv", function(client, id, itemid)
		-- remove hook.
	end)
end



/*
	STASH STRUCTURE

	stashData[characterID] = {
		[uniqueID] = {
			DATA,
			DATA,
			DATA,
		}
	}
*/