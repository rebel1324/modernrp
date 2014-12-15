local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = PLUGIN.stashData or {}

if (SERVER) then
	// HOW STASH WORKS
	// 1. PLAYER SEND ITEM TO LOGIC INVENTORY.
	// 2. WHEN PLAYER SEND ITEM TO LOGIC INVENTORY, PUT ITEM INDEX TO CHARACTER'S STASH TABLE.
	// 3. THEN WE CAN SAVE ITEMS WITHOUT CORRUPTION OF ITEM DATA. 

	function PLUGIN:SaveStash(charID)
		local schema = string.lower(SCHEMA.folder)
		local path = Format("%s/%s.txt", schema, charID)
		local encoded = self.stashData[charID]

		if (encoded) then
			encoded = pon.encode(encoded)

			file.Write(path, encoded)
		end
	end

	function PLUGIN:NewStash()
		return {
			reserve = 0,
			items = {
				//itemindexes
			},
		}
	end

	function PLUGIN:LoadStash(charID)
		local schema = string.lower(SCHEMA.folder)
		local path = Format("%s/%s.txt", schema, charID)
		local stash

		if (file.Exists(path, "DATA")) then
			stash = file.Read(path, "DATA")
			stash = pon.decode(stash)
		else
			stash = self:NewStash()
		end

		return stash or self:NewStash()
	end

	function PLUGIN:GetStash(charID)
		if (!self.stashData[charID]) then
			self.stashData[charID] = self:LoadStash() or self:NewStash()
		end

		return self.stashData[charID]
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

	netstream.Hook("stashMove", function(client, charID, itemID, toStash)
		if (hook.Run("CanPlayerUseStash", client) == false) then
			return
		end

		if (toStash) then
		else
		end
	end)
else
	netstream.Hook("stashLoad", function(stashInv)
		if (stashMenu and stashMenu:IsVisible()) then
			stashMenu:Close()
			stashMenu = nil
		end

		stashMenu = vgui.Create("nutStash")
		stashMenu:loadStash(stashInv)
	end)

	netstream.Hook("stashSync", function(client, itemID, toStash)
		-- remove hook.
	end)
end