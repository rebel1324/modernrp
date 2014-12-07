AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Fort-12"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 0.6
	SWEP.ZoomAmount = 5
	SWEP.AimPos = Vector(2.8, 0, 1.69)
	SWEP.AimAng = Vector(0, 0, 0)
	SWEP.thirdEjectAdjust = Vector( 0, 4, -5 )
end

SWEP.Category = "NutScript - Spy Base"
SWEP.PlayBackRate = 1
SWEP.SpeedDec = 10
SWEP.Mags = 4
SWEP.BulletLength = 9
SWEP.CaseLength = 18

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.HoldType = "pistol"
SWEP.Base = "spy_base"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModel		= "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_p228.mdl"
SWEP.AnimPrefix		= "fist"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.FireDelay = 0.01
SWEP.FireSound = Sound("Weapon_P228.Single")
SWEP.Recoil = 0.7


SWEP.Spread = 0.015
SWEP.CrouchSpread = 0.012
SWEP.VelocitySensitivity = 1.4
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.25
SWEP.Shots = 1
SWEP.Damage = 18
SWEP.DeployTime = 1
SWEP.ReloadTime = 2.5
SWEP.muzScale = .25
SWEP.ShellAngle = Vector( -40, -50, -90)
SWEP.ShellSize = .8
SWEP.AimPos = Vector(-5.95, -4, 3)
SWEP.AimAng = Vector(-.7, 0, 0)