if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "P90"			
	SWEP.Author				= "Black Tea"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
end

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_nutcs_base"
SWEP.Category			= "NutScript 1.1 Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_P90.Single" )
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.032
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.07
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
SWEP.originMod = Vector(-3, -5, 1)
SWEP.MuzSize = .3
SWEP.spreadData = {
	rcvrRecoilRate = .15,
	incrRecoilRate = 1,
	maxRecoil = 2,

	rcvrSpreadRate = .05,
	incrSpreadRate = 1,
	maxSpread = 5,
	minSpread = 0,
}