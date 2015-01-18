if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "AUG"			
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

SWEP.ViewModel			= "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_aug.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AUG.Single" )
SWEP.Primary.Recoil			= 1.2
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.009
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 1
SWEP.ShellAng = Angle(0, 110, 0)
SWEP.muzAdjust = Angle(0, 0, 0)
SWEP.originMod = Vector(-3, -7, 1)
SWEP.muzPattern = 2
SWEP.WMuzSize = .45
SWEP.spreadData = {
	rcvrRecoilRate = .15,
	incrRecoilRate = 2,
	maxRecoil = 8,

	rcvrSpreadRate = .1,
	incrSpreadRate = .9,
	maxSpread = 4,
	minSpread = .1,
}