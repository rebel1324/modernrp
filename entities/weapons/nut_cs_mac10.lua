if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "MAC10"			
	SWEP.Author				= "Black Tea"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
end

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_nutcs_base"
SWEP.Category			= "NutScript 1.1 Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_Mac10.Single" )
SWEP.Primary.Recoil			= .6
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 0
SWEP.ShellAng = Angle(-15, 0, 0)
SWEP.muzAdjust = Angle(0, 0, 0)
SWEP.originMod = Vector(0, -5, 0)
SWEP.MuzSize = .3
SWEP.spreadData = {
	rcvrRecoilRate = .1,
	incrRecoilRate = 1,
	maxRecoil = 3,

	rcvrSpreadRate = .1,
	incrSpreadRate = 2,
	maxSpread = 6,
	minSpread = 3,
}