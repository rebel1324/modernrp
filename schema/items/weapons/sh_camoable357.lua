-- This item is exact copy of sh_357.lua in nutscript framework.
-- A Camo Data is written on this lua file.
-- I hope you can manage to make your own camo and weapons with this example.

ITEM.name = "357 Camoable."
ITEM.desc = "A Weapon. You can draw a camo on this shit."
ITEM.model = "models/weapons/w_357.mdl"
ITEM.class = "weapon_357"
ITEM.weaponCategory = "sidearm"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	ang	= Angle(-17.581502914429, 250.7974395752, 0),
	fov	= 5.412494001838,
	pos	= Vector(57.109928131104, 181.7945098877, -60.738327026367)
}
ITEM.camo = {
	[1] = {
		worldMaterials = {
		},
		viewMaterials = {
			[1] = "camos/357/357_sheet",
		}
	},
}