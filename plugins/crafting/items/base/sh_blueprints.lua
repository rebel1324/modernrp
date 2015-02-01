ITEM.name = "Blueprint"
ITEM.desc = "A blueprint to make another item."
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1

function ITEM:onRegistered()
	local RECIPE = {}
	if (self.uniqueID) then
		RECIPE.uniqueID = self.uniqueID
		RECIPE.name = self.blueprintName
		RECIPE.desc = self.blueprintDesc
		RECIPE.requireditems = self.requireditems
		RECIPE.resultItems = self.resultItems
		RECIPE.requireTable = self.requireTable or false
		RECIPE.removeItems = self.removeItems or true
		RECIPE.removeItemsOnFail = self.removeItemsOnFail or false
		RECIPE.canCraft = self.canCraft or false
		RECIPE.onCraft = self.onCraft or false
		RECIPE.blueprint = true

		--nut.item.registerRecipe(self.uniqueID, RECIPE)
	end
end