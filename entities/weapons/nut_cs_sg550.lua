if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "SG-550"			
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

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_sg550.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_sg550.Single" )
SWEP.Primary.Recoil			= 1.1
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 1
SWEP.ShellAng = Angle(-15, -140, 0)
SWEP.WShellAng = Angle(0, 120, 0)
SWEP.muzAdjust = Angle(0, 0, 0)
SWEP.originMod = Vector(-4, -10, 1)
SWEP.muzPattern = 2
SWEP.WMuzSize = .38
SWEP.spreadData = {
	rcvrRecoilRate = .15,
	incrRecoilRate = 2,
	maxRecoil = 7,

	rcvrSpreadRate = .1,
	incrSpreadRate = .9,
	maxSpread = 5,
	minSpread = .2,
}