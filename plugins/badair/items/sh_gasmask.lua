ITEM.name = "Respirator"
ITEM.desc = "A Gas-mask type Respirator that protects you from bad airs."
ITEM.model = "models/barneyhelmet_faceplate.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.gasMask = true
ITEM.iconCam = {
	ang	= Angle(-28.700408935547, -49.785682678223, 0),
	fov	= 3.382306512871,
	pos	= Vector(-106.45804595947, 124.09488677979, -88.828506469727)
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
					v:setData("equip", false)
					v:setData("health", char:getVar("gasMaskHealth", DEFAULT_GASMASK_HEALTH))
					v:setData("filter", char:getVar("gasMaskFilter", DEFAULT_GASMASK_FILTER))

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
					netstream.Start(client, "mskInit", char:getVar("gasMaskHealth"))

					char:setVar("gasMask", true)
					char:setVar("gasMaskHealth", v:getData("health", DEFAULT_GASMASK_HEALTH))
					char:setVar("gasMaskFilter", v:getData("filter", DEFAULT_GASMASK_FILTER))
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
