ITEM.name = "Respirator"
ITEM.desc = "A Gas-mask type Respirator that protects you from bad airs."
ITEM.model = "models/barneyhelmet_faceplate.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.gasMask = true
ITEM.price = 250
ITEM.category = "Outfit"
ITEM.iconCam = {
	ang	= Angle(29.00287437439, 411.06158447266, 0),
	fov	= 4.2897785277726,
	pos	= Vector(-111.17874145508, -135.5086517334, 96.315162658691)
}
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(8.4950472228229e-005, -66.922698974609, -89.999969482422),
					["UniqueID"] = "3085914138",
					["ClassName"] = "model",
					["Size"] = 0.95,
					["EditorExpand"] = true,
					["Model"] = "models/barneyhelmet_faceplate.mdl",
					["Position"] = Vector(3.3733520507813, -1.6019897460938, -0.10595703125),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "2607460179",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
}


local defaultDesc = "A Gas-mask type Respirator that protects you from bad airs."
function ITEM:getDesc()
	local str
	
	if (!self.entity or !IsValid(self.entity)) then
		local health = self:getData("health", DEFAULT_GASMASK_HEALTH)
		str = defaultDesc

		if (health <= 0) then
			str = str .. "\nThis mask is broken."
		elseif (health < DEFAULT_GASMASK_HEALTH * .2) then
			str = str .. "\nThis mask is barely functional."
		end

		return str
	else
		return defaultDesc
	end
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
else
	hook.Add("PlayerDeath", "UnequipGasmasks", function(client)
		local char = client:getChar()
		if (char) then
			client.deadMaskChar = char:getID()

			for k, v in pairs(char:getInv():getItems()) do
				local itemTable = nut.item.instances[v.id]

				if (itemTable.gasMask and itemTable:getData("equip")) then
					-- SAVE TEMP MASKVARS
					itemTable:setData("equip", false)
					itemTable:setData("health", char:getVar("gasMaskHealth", DEFAULT_GASMASK_HEALTH))
					itemTable:setData("filter", char:getVar("gasMaskFilter", DEFAULT_GASMASK_FILTER))

					char:setVar("gasMaskHealth", nil)
					char:setVar("gasMaskFilter", nil)
					break
				end
			end
		end
	end)

	-- This hook notices you the death penalty that you've got by the server.
	hook.Add("PlayerSpawn", "UnequipGasMasks", function(client)
		local char = client:getChar()

		if (char) then
			if (client.deadMaskChar and client.deadMaskChar == char:getID() and char:getVar("gasMask", nil)) then
				-- REMOVE TEMP MASKVARS
				char:setVar("gasMask", nil)
				char:removePart("gasmask")
			end
				
			client.deadMaskChar = nil
		end
	end)
	

	hook.Add("PlayerLoadout", "UnequipGasMasks", function(client)
		local char = client:getChar()

		if (char) then
			local inv = char:getInv()

			for k, v in pairs(inv:getItems()) do
				local itemTable = nut.item.instances[v.id]

				if (itemTable.gasMask and itemTable:getData("equip")) then
					-- INITIALIZE TEMP MASKVARS
					char:setVar("gasMask", true)
					char:setVar("gasMaskHealth", itemTable:getData("health", DEFAULT_GASMASK_HEALTH))
					char:setVar("gasMaskFilter", itemTable:getData("filter", DEFAULT_GASMASK_FILTER))

					netstream.Start(client, "mskInit", char:getVar("gasMaskHealth"))
					break
				end
			end
		end
	end)
end

ITEM:hook("drop", function(item)
	if (item:getData("equip") == true) then
		local char = item.player:getChar()

		item:setData("equip", false)
		item:setData("health", char:getVar("gasMaskHealth", DEFAULT_GASMASK_HEALTH))
		item:setData("filter", char:getVar("gasMaskFilter", DEFAULT_GASMASK_FILTER))

		char:setVar("gasMask", nil)
		char:setVar("gasMaskHealth", nil)
		char:setVar("gasMaskFilter", nil)
		item.player:EmitSound("gasmaskoff.wav", 80)
	end
end)

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local char = item.player:getChar()
		-- REMOVE TEMP VARS
		-- SAVE TEMP VARS
		item.player:EmitSound("gasmaskoff.wav", 80)
		item:setData("equip", false)
		item:setData("health", char:getVar("gasMaskHealth", DEFAULT_GASMASK_HEALTH))
		item:setData("filter", char:getVar("gasMaskFilter", DEFAULT_GASMASK_FILTER))
		char:removePart(item.uniqueID)

		char:setVar("gasMask", nil)
		char:setVar("gasMaskHealth", nil)
		char:setVar("gasMaskFilter", nil)
		item.player:ScreenFade(1, Color(0, 0, 0, 255), 1, 0)
		
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local char = item.player:getChar()
		local inv = char:getInv()

		for k, v in pairs(inv:getItems()) do
			if (v.id != item.id) then
				local itemTable = nut.item.instances[v.id]

				if (itemTable.gasMask and itemTable:getData("equip")) then
					item.player:notify("You're already wearing mask")

					return false
				end
			end
		end

		-- INITIALIZE TEMP MASKVARS
		item:setData("equip", true)

		char:setVar("gasMask", true)
		char:setVar("gasMaskHealth", item:getData("health", DEFAULT_GASMASK_HEALTH))
		char:setVar("gasMaskFilter", item:getData("filter", DEFAULT_GASMASK_FILTER))
		char:addPart(item.uniqueID)

		netstream.Start(item.player, "mskInit", char:getVar("gasMaskHealth"))

		item.player:EmitSound("gasmaskon.wav", 80)
		item.player:ScreenFade(1, Color(0, 0, 0, 255), 1, 0)

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") != true)
	end
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	return !self:getData("equip")
end

-- Called when a new instance of this item has been made.
function ITEM:onInstanced(invID, x, y)
	self:setData("equip", false)
	self:setData("health", DEFAULT_GASMASK_HEALTH)
	self:setData("filter", DEFAULT_GASMASK_FILTER)
end