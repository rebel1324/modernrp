local PLUGIN = PLUGIN
PLUGIN.name = "Crafting"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Allows you to make new stuffs with other stuffs"

nut.item = nut.item or {}
nut.item.recipes = {}

nut.util.include("cl_vgui.lua")

function nut.item.registerRecipe(uniqueID, recipeData)
	nut.item.recipes[uniqueID] = recipeData
end

nut.util.include("sh_recipes.lua")

local inventoryMeta = FindMetaTable("Inventory")
local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")

function entityMeta:isCrafter()
	return (self:GetClass() == "nut_crafttable")
end

function playerMeta:isNearCrafter()
	for k, v in ipairs(ents.FindInSphere(self:GetPos() + self:OBBCenter(), 128)) do
		if (v:isCrafter()) then
			return v
		end
	end
end

if (SERVER) then
	-- This means you can craft an item inside of other container/inventory.
	function inventoryMeta:canCraft(recipeID, crafter)
		local recipe = nut.item.recipes[recipeID]

		if (recipe) then
			-- Check if global hook 'CanPlayerCraft' is false
			local bool, reason = hook.Run("CanPlayerCraft", self, recipeID, crafter)

			if (bool == false) then
				return bool, reason
			end

			-- Check if recipe requires table to craft.
			if (recipe.requireTable) then
				local craftTable = crafter:isNearCrafter()

				-- Check if the crafttable is valid or crafttable has/ capable of crafting.	
				if ((!craftTable or !craftTable:IsValid())	
					or (craftTable.canCraft and craftTable.canCraft == false)) then
					return false
				end
			end

			-- Check if recipe is blueprint recipe
			local blueprint

			if (recipe.blueprint) then	
				-- Check if the inventory has the blueprint if it's blueprint recipe.
				blueprint = self:hasItem("blueprint_" .. recipeID)

				if (blueprint == false) then
					return false, "no blueprint"
				end
			end

			-- Check If inventory has enough items.
			-- 'craftedItems' collects the items that will be crafted with.
			local craftedItems = {}
			for k, v in ipairs(recipe.requiredItems) do
				local item = self:hasItem(v.itemID, v.data)
				if (item == false) then
					return false, "not enough items"
				else
					table.insert(craftedItems, item)
					
					item:transfer(0, nil, nil, nil, nil, true)
					print(item, "transfered")
				end
			end

			-- Check recipe custom canCraft.
			-- The Developer/User can put custom condition on this.
			if (recipe.canCraft) then
				local bool, reason = recipe:canCraft(crafter, craftedItems) == false

				if (bool == false) then
					return bool, reason, craftedItems
				end
			end

			return true, nil, craftedItems
		end

		return false, "recipe data is not present"
	end

	-- This means you can craft an item inside of other container/inventory.
	function inventoryMeta:craftItem(recipeID, crafter)
		-- Check if player can craft the item.
		local resultItems = {}
		local recipe = nut.item.recipes[recipeID]
		local canCraft, failReason, craftedItems = self:canCraft(recipeID)

		-- TODO: Gotta figure out space problem
		-- 1. Proceed Crafting
		-- 2. Move items into Logic Status (-1) <<FIRST PRIORITY>>
		-- 3. Give player result items (recursive)
		-- 4. If there is no space for it, drop it on the ground
		-- 5. Oky, We have plenty of profit 
		if (craftedItems) then 
			for k, v in pairs(craftedItems) do
				print(v.invID, self:getID())
				print(v:transfer(self:getID()))
				print(v, "transfered back to,", self:getID())
			end
		end
		/*
		if (canCraft == true) then
			for k, v in ipairs(recipe.resultItems) do
				local x, y = self:add(v.itemID, v.data)

				if (x != false) then
					table.insert(resultItems, {x, y})
				else
					-- create item on the ground.
					-- you fucking deserve it, mate.
				end
			end

			if (craftedItems) then
				for k, v in ipairs(craftedItems) do
					-- loool
				end
			end

			if (recipe.onCraft) then
				recipe:onCraft()
			end
			-- Check if the recipe discard the items after use.
		end
		*/

		return canCraft, failReason, secArg
	end

	-- Load Craft Tables
	function PLUGIN:LoadData()
		local savedTable = self:getData() or {}

		for k, v in ipairs(savedTable) do
			local stove = ents.Create(v.class)
			stove:SetPos(v.pos)
			stove:SetAngles(v.ang)
			stove:Spawn()
			stove:Activate()
		end
	end

	-- Save Craft Tables
	function PLUGIN:SaveData()
		local savedTable = {}

		for k, v in ipairs(ents.GetAll()) do
			if (v:isCrafter()) then
				table.insert(savedTable, {class = v:GetClass(), pos = v:GetPos(), ang = v:GetAngles()})
			end
		end

		self:setData(savedTable)
	end
end

nut.command.add("craftmenu", {
	onRun = function(client, arguments)
		-- Will open craft menu
	end
})

if (true) then	
	nut.command.add("crafttest", {
		onRun = function(client, arguments)
			local char = client:getChar()

			-- Dead person cannot craft.
			if (client and client:Alive() and char) then
				local inv = char:getInv()

				-- craftitem in the inventory
				inv:craftItem("test")
			end
		end
	})
end