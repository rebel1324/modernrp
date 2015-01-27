local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = PLUGIN.stashData or {}

local langkey = "english"
do
	local langTable = {
		stash = "Stash",
		stashMenu = "Stash Menu",
		stashIn = "Store Item",
		stashOut = "Pick Item",
		stashError = "An error occured while processing stash trasfer",
		stashDesc = "You can store your items safe in here",
		stashFar = "You're too far away from the stash",
	}

	table.Merge(nut.lang.stored[langkey], langTable)
end

local charMeta = FindMetaTable("Character")

function charMeta:getStash()
	return self:getData("stash", {})
end

if (SERVER) then
    function PLUGIN:PreCharDelete(client, char)
    	-- get character stash items and eradicate item data from the DATABASE.
    	if (char) then
			local stashItems = char:getStash()
			local queryTable = {}
			for k, v in pairs(stashItems) do
				table.insert(queryTable, k)
			end

			-- Check all stash items of the character.
			nut.item.loadItemByID(queryTable, 0, nil)
			for k, v in pairs(stashItems) do
				local item = nut.item.instances[k]

				-- Remove all items in stash.
				if (item) then
					item:remove()
				end
			end
		end
    end

	function PLUGIN:LoadData()
		local savedTable = self:getData() or {}

		for k, v in ipairs(savedTable) do
			local stash = ents.Create("nut_stash")
			stash:SetPos(v.pos)
			stash:SetAngles(v.ang)
			stash:Spawn()
			stash:Activate()

			local physicsObject = stash:GetPhysicsObject()

			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion()
			end
		end
	end
	
	function PLUGIN:SaveData()
		local savedTable = {}

		for k, v in ipairs(ents.GetAll()) do
			if (v:GetClass() == "nut_stash") then
				table.insert(savedTable, {pos = v:GetPos(), ang = v:GetAngles()})
			end
		end

		self:setData(savedTable)
	end
	
	function charMeta:setStash(tbl)
		self:setData("stash", tbl)
	end

	function requestStash(client)
		local stashItems = client:getChar():getStash()
		local queryTable = {}
		local nearStash = false

		-- Check if the client is near the stash.
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:GetClass() == "nut_stash") then
				nearStash = true
				break
			end
		end

		if (nearStash == false) then
			client:notify(L("stashFar", client))
			return
		end

		-- Insert items to load.
		for k, v in pairs(stashItems) do
			table.insert(queryTable, k)
		end

		-- Load item informations.
		nut.item.loadItemByID(queryTable, 0, nil)

		-- Check if item's information is loaded, if does not, do not load the item.
		for k, v in pairs(stashItems) do
			local item = nut.item.instances[k]

			if (item) then
				netstream.Start(client, "item", item.uniqueID, k, item.data, 0)
			end
		end

		-- Send stash menu to the client.
		netstream.Start(client, "stashMenu", stashItems)
	end

	netstream.Hook("stashIn", function(client, itemID)
		local char = client:getChar()
		local item = nut.item.instances[itemID]
		local nearStash = false

		-- Check if the client is near the stash.
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:GetClass() == "nut_stash") then
				nearStash = true
				break
			end
		end

		-- If client is far away from the stash, don't do any interaction.
		if (nearStash == false) then
			client:notify(L("stashFar", client))
			return
		end

		-- If item information is valid.
		if (item) then
			local clientStash = char:getStash()

			-- If client is trying to put bag in the stash, reject the request.
			if (item.base == "base_bags" or clientStash[itemID] or item:getOwner() != client) then
				client:notify(L("stashError", client))
				return
			end

			-- Make an attempt to put item into the stash.
			if (item:transfer(nil, nil, nil, client, nil, true)) then
				clientStash[itemID] = true

				char:setStash(clientStash)
				netstream.Start(client, "stashIn")
			else
				client:notify(L("stashError", client))
			end
		end
	end)

	netstream.Hook("stashOut", function(client, itemID)
		local char = client:getChar()
		local item = nut.item.instances[itemID]
		local nearStash = false

		-- Check if the client is near the stash.
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:GetClass() == "nut_stash") then
				nearStash = true
				break
			end
		end

		-- If client is far away from the stash, don't do any interaction.
		if (nearStash == false) then
			client:notify(L("stashFar", client))
			return
		end

		-- If item information is valid.
		if (item) then
			local clientStash = char:getStash()

			-- If the activator does not owns the item, reject request.
			if (!clientStash[itemID]) then
				client:notify(L("stashError", client))
				return
			end

			-- Make an attempt to take item from the stash.
			if (item:transfer(char:getInv():getID(), nil, nil, client)) then
				clientStash[itemID] = nil

				char:setStash(clientStash)
				netstream.Start(client, "stashOut")
			else
				client:notify(L("stashError", client))
			end
		end
	end)
else
	-- I'm so fucking lazy
	-- Stash vgui needs more better sync.
	netstream.Hook("stashIn", function(id)
		if (nut.gui.stash and nut.gui.stash:IsVisible()) then
			nut.gui.stash:setStash()
			surface.PlaySound("items/ammocrate_open.wav")
		end
	end)

	netstream.Hook("stashOut", function(id)
		if (nut.gui.stash and nut.gui.stash:IsVisible()) then
			nut.gui.stash:setStash()
			surface.PlaySound("items/ammocrate_open.wav")
		end
	end)

	netstream.Hook("stashMenu", function(items)
		local stash = vgui.Create("nutStash")
		stash:setStash(items)
	end)
end