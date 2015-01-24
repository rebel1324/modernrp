local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = PLUGIN.stashData or {}

local langkey = "english"
do
	local langTable = {
		stash = "Stash",
		stashIn = "Store Item",
		stashOut = "Pick Item",
		stashError = "An error occured while processing stash trasfer"
	}

	table.Merge(nut.lang.stored[langkey], langTable)
end

local charMeta = FindMetaTable("Character")

function charMeta:getStash()
	return self:getData("stash", {})
end

if (SERVER) then
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
		local stashItems = client:getChar():getData("stashItems", {})

		nut.item.loadItemByID(table.SortByKey(stashItems), 0, nil)
		for k, v in pairs(stashItems) do
			local item = nut.item.instances[k]

			if (item) then
				netstream.Start(client, "item", item.uniqueID, k, item.data, 0)
			end
		end

		netstream.Start(client, "stashMenu", stashItems)
	end

	netstream.Hook("stashIn", function(client, itemID)
		local char = client:getChar()
		local item = nut.item.instances[itemID]

		if (item) then
			local clientStash = char:getStash()

			if (clientStash[itemID] or item:getOwner() != client) then
				client:notify(L("stashError", client))
				return
			end

			if (item:transfer(nil, nil, nil, client, nil, true)) then
				clientStash[itemID] = true

				char:setStash(clientStash)
				netstream.Start(client, "stashIn")
			end
		end
	end)

	netstream.Hook("stashOut", function(client, itemID)
		local char = client:getChar()
		local item = nut.item.instances[itemID]
		if (item) then
			local clientStash = char:getStash()

			if (!clientStash[itemID]) then
				client:notify(L("stashError", client))
				return
			end

			if (item:transfer(char:getInv():getID(), nil, nil, client)) then
				clientStash[itemID] = nil

				char:setStash(clientStash)
				netstream.Start(client, "stashOut")
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