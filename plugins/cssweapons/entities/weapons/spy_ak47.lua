AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "AK-47"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 0.6
	SWEP.ZoomAmount = 5
	SWEP.AimPos = Vector(-4.62, -6.18, 1.5)
	SWEP.AimAng = Vector(2.2, 0, 0)
	SWEP.Adjust = Vector( -2, -15, 1.5 )

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

SWEP.ViewModel		= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_ak47.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModelFOV	= 65
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FireDelay = 0.12
SWEP.FireSound = Sound("Weapon_AK47.Single")
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
SWEP.muzScale = .4
SWEP.ShellAngle = Vector( -20, -40, 0)
SWEP.Shell = 2
SWEP.ShellSize = .6
SWEP.LowerAngles = Angle(45, -15, -15)
SWEP.AimPos = Vector(-4.62, -5, 1.5)
SWEP.AimAng = Vector(2.5, 0, 0)


local META = FindMetaTable("CLuaEmitter")
if not META then return end
function META:DrawAt(pos, ang, fov)
	local pos, ang = WorldToLocal(EyePos(), EyeAngles(), pos, ang)
	cam.Start3D(pos, ang, fov)
		self:Draw()
	cam.End3D()
end

local EFFECT = {}

function EFFECT:FixedParticle()
	local function maxLife(min, max)
		return math.Rand(math.min(min, self.lifeTime), math.min(max or self.lifeTime, self.lifeTime))
	end
	
	local p = self.emitter:Add("particle/smokesprites_000"..math.random(4,9), Vector(3, 0, 0))
	p:SetVelocity(200*Vector(1, 0, 0))
	p:SetDieTime(maxLife(.06, .1))
	p:SetStartAlpha(math.Rand(44,100))
	p:SetEndAlpha(0)
	p:SetStartSize(math.random(5,11)*self.scale)
	p:SetEndSize(math.random(44,66)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(150,150,150)
	p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
	

	local p = self.emitter:Add("effects/muzzleflash" .. math.random(1, 2), Vector(0, 0, 0))
	p:SetVelocity(math.Rand(120, 150)*Vector(1, 0, 0)*(self.scale*2))
	p:SetDieTime(maxLife(.07, .09))
	p:SetStartAlpha(150)
	p:SetEndAlpha(50)
	p:SetStartSize(math.random(16,12)*self.scale)
	p:SetEndSize(math.random(33,44)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(255,255,255)

	local p = self.emitter:Add("effects/muzzleflash" .. math.random(1, 4), Vector(-1, 0, 0))
	p:SetVelocity(math.Rand(60, 80)*Vector(1, 0, 0)*(self.scale))
	p:SetDieTime(maxLife(.07, .09))
	p:SetStartAlpha(255)
	p:SetEndAlpha(150)
	p:SetStartSize(math.random(20,30)*self.scale)
	p:SetEndSize(math.random(8,16)*self.scale)
	p:SetStartLength(30*math.Rand(.9, 1.5))
	p:SetEndLength(80*math.Rand(.9, 1.5))
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(255,255,255)
	
	
	local max = 2
	for i = 1, max do
		local p = self.emitter:Add("effects/muzzleflash" .. math.random(1, 4), Vector(i*2 + i, 0, 0))
		p:SetVelocity(math.Rand(120, 150)*Vector(1, 0, 0)*(self.scale*2))
		p:SetDieTime(maxLife(.05, .07))
		p:SetStartAlpha(255)
		p:SetEndAlpha(150)
		p:SetStartSize(math.random(16,20)*self.scale*(max - i))
		p:SetEndSize(math.random(20,22)*self.scale*(max - i/6)/2)
		p:SetRoll(math.Rand(180,480))
		p:SetRollDelta(math.Rand(-3,3))
		p:SetColor(255,255,255)
	end

	local max = 2
	for i = 1, max do
		local p = self.emitter:Add("effects/muzzleflash" .. math.random(1, 4), Vector(i*2 + i, 0, 0))
		p:SetVelocity(math.Rand(120, 150)*Vector(1, 0, 0)*(self.scale*2))
		p:SetDieTime(maxLife(.05, .07))
		p:SetStartAlpha(255)
		p:SetEndAlpha(150)
		p:SetStartSize(math.random(16,20)*self.scale*(max - i))
		p:SetEndSize(math.random(20,22)*self.scale*(max - i/6)/2)
		p:SetRoll(math.Rand(180,480))
		p:SetRollDelta(math.Rand(-3,3))
		p:SetColor(255,255,255)
	end

	/*
	local max = 5
	for i = 1, max do
		local dang = Vector(1, 0, 0):Angle()
		local a1, a2, a3 = dang:Right(), dang:Up(), dang:Forward()
		dang:RotateAroundAxis(a1, math.random(-66, 66))
		dang:RotateAroundAxis(a2, math.random(-66, 66))
		local adf = dang:Forward()
		local dt = a3:Dot(adf)

		local p = self.emitter:Add("effects/spark", Vector(math.Rand(0, 1), 0, 0))
		p:SetVelocity(dang:Forward() * math.random(150, 300) * self.scale * dt)
		p:SetDieTime(maxLife(.07, .1))
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(math.Rand(1,1)*self.scale)
		p:SetEndSize(math.Rand(1,1)*self.scale)
		p:SetStartLength(1)
		p:SetEndLength(2)
		p:SetRoll(math.Rand(180,480))
		p:SetRollDelta(math.Rand(-3,3))
		p:SetColor(255,255,255)
		p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
	end
	*/
end

function EFFECT:FreeParticle(at)
	local p = self.freeEmitter:Add("particle/smokesprites_000"..math.random(1,9), self.origin)
	local dir = self.dir
end

function EFFECT:Init(data)
	self.ent = data:GetEntity()
	--self.scale = data:GetScale()
	self.scale = math.Rand(.3, 1)
	self.origin = data:GetOrigin()
	self.dir = data:GetNormal()
	self.lifeTime = .2
	self.decayTime = CurTime() + self.lifeTime
	self.emitter = self.ent.emitter
	self.freeEmitter = ParticleEmitter(Vector(0, 0, 0))
	local hvec = Vector(65536, 65536, 65536)
	self:SetRenderBounds(-hvec, hvec)
	self.emitter:SetNoDraw(false)

	self:FreeParticle()
	self:FixedParticle()
end

function EFFECT:Render()
	return false
end

function EFFECT:Think()
	if (self.decayTime < CurTime()) then
		-- garbage collecting process

		self:Remove()
		return false
	end

	return true
end

effects.Register(EFFECT, "TurretGunBurst")

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
		/*
		local e = EffectData()
		e:SetOrigin( atpos.Pos )
		e:SetNormal( atpos.Ang:Forward() * 1 )
		e:SetScale( self.muzScale or .2 )
		util.Effect( "muzzleflosh" , e)
		*/

		self:BeLight( atpos.Pos )
	end
end

if (CLIENT) then
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		local at = vm:LookupAttachment("1")
		local atpos = vm:GetAttachment(at)

		self.emitter:DrawAt(atpos.Pos, atpos.Ang)
	end
end