if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= ".45 HK USP"			
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

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.011
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 0.18
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 0
SWEP.ShellAng = Angle(-0, -100, 0)
SWEP.WShellAng = -SWEP.ShellAng 
SWEP.muzAdjust = Angle(0, 90, 0)
SWEP.originMod = Vector(0, -5, 0)
SWEP.MuzSize = .3
SWEP.WMuzSize = .2
SWEP.spreadData = {
	rcvrRecoilRate = .2,
	incrRecoilRate = 1,
	maxRecoil = 5,

	rcvrSpreadRate = .05,
	incrSpreadRate = 2,
	maxSpread = 5,
	minSpread = 2,
}