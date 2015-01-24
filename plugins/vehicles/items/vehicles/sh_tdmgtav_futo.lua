-- Driveable GTA Cars (TDM Base)
-- http://steamcommunity.com/sharedfiles/filedetails/?id=323285641
-- Made for example.

ITEM.name = "Futo"
ITEM.model = "models/tdmcars/gtav/futo.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxGas = 1000
ITEM.price = 35000
ITEM.vehicleData = {
	type = TYPE_GENERIC,
	model = ITEM.model,
	script = "scripts/vehicles/TDMCars/gtav/futo.txt",
	name = ITEM.name,
	physDesc = ITEM.physDesc,
	maxGas = ITEM.maxGas,
	seats = {
		{
			pos = Vector(10, -38.471366882324, 11.785566329956),
			ang = Angle(0, 0, 0),
		},
		{
			pos = Vector(-10, -38.471366882324, 11.785566329956),
			ang = Angle(0, 0, 0),
		},
		{
			pos = Vector(13.437628746033, -6.854612827301, 8.8288221359253),
			ang = Angle(0, 0, 0),
		}
	}
}