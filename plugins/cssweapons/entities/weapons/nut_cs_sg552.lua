if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "SG-552"			
	SWEP.Author				= "Black Tea"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
end

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_nutcs_base"
SWEP.Category			= "NutScript 1.1 Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_sg552.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_sg552.Single" )
SWEP.Primary.Recoil			= 1.1
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
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
SWEP.ShellAng = Angle(-15, 0, 0)
SWEP.WShellAng = Angle(0, 120, 0)
SWEP.muzAdjust = Angle(0, 0, 0)
SWEP.originMod = Vector(0, -7, 0)