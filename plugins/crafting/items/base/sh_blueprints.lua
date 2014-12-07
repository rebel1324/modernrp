ITEM.name = "Blueprint"
ITEM.desc = "A blueprint to make another item."
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.recipe = {
	
}

function ITEM:onRegistered()
	local RECIPE = {}
	RECIPE.uniqueID = self.uniqueID
	RECIPE.name = "Test Recipe"
	RECIPE.desc = "A Test Recipe that does not requires any blueprints."
	RECIPE.requireditems = ITEM.requireditems
	RECIPE.resultItems = ITEM.resultItems
	RECIPE.requireTable = ITEM.requireTable or false
	RECIPE.removeItems = ITEM.removeItems or true
	RECIPE.removeItemsOnFail = ITEM.removeItemsOnFail or false
	RECIPE.blueprint = true

--	nut.item.registerRecipe(self.uniqueID, RECIPE)
end