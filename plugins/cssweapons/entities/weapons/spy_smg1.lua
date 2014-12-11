AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "SMG"
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

SWEP.ViewModel		= "models/weapons/c_smg1.mdl"
SWEP.WorldModel		= "models/weapons/w_smg1.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFOV	= 65
SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FireDelay = 0.07
SWEP.FireSound = Sound("Weapon_SMG1.Single")
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
SWEP.ShellAngle = Vector(40, -40, 0)
SWEP.Shell = 1
SWEP.ShellSize = .6
SWEP.LowerAngles = Angle(45, -15, -15)
SWEP.AimPos = Vector(-4.36, -2, 1)
SWEP.AimAng = Vector(0, 0, 0)
SWEP.AdjustPos = Vector(-1.5, 1, -2)

function SWEP:ViewMuzzleFlash()
	if !self.Owner:ShouldDrawLocalPlayer() then
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		local at = vm:LookupAttachment( "1" )
		local atpos = vm:GetAttachment( at )

		local e = EffectData()
		e:SetEntity(self)
		e:SetScale(1)
		e:SetOrigin(atpos.Pos)
		e:SetNormal(atpos.Ang:Forward())
		util.Effect("TurretGunBurst", e)

		self:BeLight( atpos.Pos )
	end
end


if (CLIENT) then
	local function fFrameTime()
		return math.Clamp(FrameTime(), 1/60, 1)
	end


	function SWEP:PostDrawViewModel(vm, weapon, client)
		local vm = self.Owner:GetViewModel()
		local at = vm:LookupAttachment("muzzle")
		local atpos = vm:GetAttachment(at)

		self.emitter:DrawAt(atpos.Pos, atpos.Ang)
	end
end