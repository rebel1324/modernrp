-- Driveable GTA Cars (TDM Base)
-- http://steamcommunity.com/sharedfiles/filedetails/?id=323285641
-- Made for example.

ITEM.name = "Turismor"
ITEM.model = "models/tdmcars/gtav/turismor.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxGas = 1000
ITEM.price = 35000
ITEM.vehicleData = {
	type = TYPE_GENERIC,
	model = ITEM.model,
	script = "scripts/vehicles/TDMCars/gtav/turismor.txt",
	name = ITEM.name,
	physDesc = ITEM.physDesc,
	maxGas = ITEM.maxGas,
	seats = {
		{
			pos = Vector(14.188320159912, 8.272798538208, 1.2972664833069),
			ang = Angle(0, 0, 0),
		}
	}
}