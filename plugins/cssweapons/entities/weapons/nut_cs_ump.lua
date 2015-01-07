if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= "UMP"			
	SWEP.Author				= "Black Tea"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
end

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_nutcs_base"
SWEP.Category			= "NutScript 1.1 Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_UMP45.Single" )
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 0
SWEP.ShellAng = Angle(-15, 0, 0)
SWEP.WShellAng = Angle(0, 120, 0)
SWEP.muzAdjust = Angle(0, 0, 0)
SWEP.originMod = Vector(0, -5, 0)