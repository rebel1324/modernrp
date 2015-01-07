if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "AK-47"			
	SWEP.Author				= "Black Tea"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
end

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_nutcs_base"
SWEP.Category			= "NutScript 1.1 Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 2.2
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 1
SWEP.ShellAng = Angle(-15, 0, 0)
SWEP.WShellAng = Angle(0, 120, 0)
SWEP.muzAdjust = Angle(0, 0, 0)
SWEP.originMod = Vector(-2, -10, 2)