-- REGISTER TEST RECIPE
local RECIPE = {}
-- Simple Information about recipe
-- This is must be filled. 
RECIPE.uniqueID = "test"
RECIPE.name = "Test Recipe"
RECIPE.desc = "A Test Recipe that does not requires any blueprints."

-- This recipe requires 2 "test" items.
-- This is must be filled. 
RECIPE.requiredItems = {
	{itemID = "healvial", data = {}},
	{itemID = "healvial", data = {}},
}

-- Using this recipe will give you "test2" item in your inventory.
-- This is must be filled. 
RECIPE.resultItems = {
	{itemID = "healthkit", data = {}}
}

-- This item does not requires Craft Table.
-- Default: false
RECIPE.requireTable = false

-- When this parameter is 'true', delete craft items (not result items) from the inventory.
-- Default: true
RECIPE.removeItems = true

-- When this parameter is 'true', delete craft items whether craft is failed or not.
-- Default: false
RECIPE.removeItemsOnFail = true

-- Check if this recipe is blueprint recipe.
-- YOU CAN'T MAKE THIS 'TRUE' OUTSIDE OF sh_blueprints.lua!
-- When this is true, the crafting script automatically finds "blueprint_[recipeID]" in your inventory.
RECIPE.blueprint = false

-- This function allows you to craft the item or not.
-- requireTable is not related on this function 
-- (even if this is true, if you're not crating the item via Crafting table if requireTable is true, the craft get aborted.)
-- You may provide a reason when you're returning 'false' on the first return aregument.
-- Default: (true)
-- Return: <false/true>, <string Reason>
function RECIPE:canCraft(crafter, items)
	-- 'items' are table of items to be crafted.
	-- {Item(1), Item(4)}
	/*
	local owner = item.owner

	if (crafter:IsAdmin()) then
		print("The Item Crafter was an ADMIN!")
	end
	*/

	-- If this function returns 'false', abort the crafting process.
	-- return false, "faggot"
end

-- This function will be ran after you crafted the item.
function RECIPE:onCraft(crafter, items, resultItems)
	-- If you want to make specific item get discarded after the craft
	-- (ex. ham(1) + knife(2) = sliced ham(3) + knife(2)), you must set RECIPE.removeItems to false. 
end

nut.item.registerRecipe(RECIPE.uniqueID, RECIPE)
