local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = PLUGIN.stashData or {}

local charMeta = FindMetaTable("Character")

function charMeta:getStash()
	return self:getData("stash", {})
end

if (SERVER) then
	/*
		There is one big virtual inventory.
		Player has a table of stored item.
	*/

	/*
		When player requests the stash menu:
		1. Get player's stored item.
		2. Load all item data of stored item.
		3. Send all item data of stored item.
		4. Now he has, the stored item menu.
	*/

	/*
		Networking list.
		1. Sync stash items.
	*/

	function charMeta:setStash(tbl)
		self:setData("stash", tbl)
	end

	function requestStash(client)
		local stashItems = client:getChar():getData("stashItems", {})

		for k, v in pairs(stashItems) do
			if (!nut.item.inventories[0][v]) then
				--nut.item.loadItemByID loads item data and syncs item data with the client.
				--itemID, targetInventory, recipient
				--nut.item.loadItemByID(v, 0, client)
			end
		end

		netstream.Start(client, "stashMenu", stashItems)
	end

	netstream.Hook("stashIn", function(client, itemID)
		local char = client:getChar()
		local item = nut.item.instances[itemID]
		if (item) then
			local clientStash = char:getStash()

			if (item:transfer(nil, nil, nil, client, nil, true)) then
				clientStash[itemID] = nut.item.instances[itemID]
				PrintTable(clientStash)

				char:setStash(clientStash)
			end
		end
	end)

	netstream.Hook("stashOut", function(client, itemID)
		local char = client:getChar()
		local item = nut.item.instances[itemID]
		if (item) then
			local clientStash = char:getStash()

			if (item:transfer(char:getInv():getID(), nil, nil, client)) then
				clientStash[itemID] = nil
				PrintTable(clientStash)

				char:setStash(clientStash)
			end
		end
	end)
else
	netstream.Hook("stashMenu", function(items)
		local stash = vgui.Create("nutStash")
		stash:setStash(items)
	end)
end