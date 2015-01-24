-- Driveable GTA Cars (TDM Base)
-- http://steamcommunity.com/sharedfiles/filedetails/?id=323285641
-- Made for example.

ITEM.name = "Gauntlet"
ITEM.model = "models/tdmcars/gtav/gauntlet.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxGas = 1000
ITEM.price = 35000
ITEM.vehicleData = {
	type = TYPE_GENERIC,
	model = ITEM.model,
	script = "scripts/vehicles/TDMCars/gtav/gauntlet.txt",
	name = ITEM.name,
	physDesc = ITEM.physDesc,
	maxGas = ITEM.maxGas,
	seats = {
		{
			pos = Vector(17.626285552979, -1.5526386499405, 8.8950691223145),
			ang = Angle(0, 0, 0),
		}
	}
}