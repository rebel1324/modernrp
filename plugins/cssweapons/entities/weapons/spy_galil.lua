AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "GALIL"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 0.6
	SWEP.ZoomAmount = 5
	SWEP.AimPos = Vector(-4.38, -5.546, 1.1)
	SWEP.AimAng = Vector(-0.071, -0.002, 0)
	SWEP.Adjust = Vector( -2, -10, 1.5 )
end

SWEP.Category = "NutScript - Spy Base"
SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 30
SWEP.BulletLength = 5.45
SWEP.CaseLength = 39

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.HoldType = "ar2"
SWEP.Base = "spy_base"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModel		= "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_galil.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFOV	= 65
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FireDelay = 0.12
SWEP.FireSound = Sound("Weapon_Galil.Single")
SWEP.Recoil = 1

SWEP.Spread = 0.007
SWEP.CrouchSpread = 0.005
SWEP.VelocitySensitivity = 3.5
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.2
SWEP.Shots = 1
SWEP.Damage = 30
SWEP.DeployTime = 1
SWEP.ReloadTime = 1.75
SWEP.muzScale = .5
SWEP.ShellAngle = Vector( -20, -40, 0)
SWEP.Shell = 2
SWEP.ShellSize = .6
SWEP.LowerAngles = Angle(45, -15, -15)
SWEP.AimPos = Vector(-4.36, -2, 1)
SWEP.AimAng = Vector(0, 0, 0)