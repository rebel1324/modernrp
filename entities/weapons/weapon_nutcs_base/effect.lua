local META = FindMetaTable("CLuaEmitter")
if not META then return end
function META:DrawAt(pos, ang, fov)
	local pos, ang = WorldToLocal(EyePos(), EyeAngles(), pos, ang)
	
	cam.Start3D(pos, ang, fov)
		self:Draw()
	cam.End3D()
end

WORLDEMITTER = WORLDEMITTER or ParticleEmitter(Vector(0, 0, 0))

local EFFECT = {}

local muzzleMaterials = {}
for i = 1, 8 do
	muzzleMaterials[i] = Material("effects/fas_muzzle" .. i .. ".png", "unlitgeneric")
	muzzleMaterials[i]:SetInt("$additive", 1)
	muzzleMaterials[i]:SetInt("$vertexcolor", 1)
	muzzleMaterials[i]:SetInt("$vertexalpha", 1)
end

function EFFECT:FixedParticle()
	local function maxLife(min, max)
		return math.Rand(math.min(min, self.lifeTime), math.min(max or self.lifeTime, self.lifeTime))
	end	

	local p = self.emitter:Add("particle/smokesprites_000"..math.random(4,9), Vector(3, 0, 0))
	p:SetVelocity(300*Vector(1, 0, 0)*self.scale)
	p:SetDieTime(maxLife(.08, .11))
	p:SetStartAlpha(math.Rand(50,120))
	p:SetEndAlpha(0)
	p:SetStartSize(math.random(5,11)*self.scale)
	p:SetEndSize(math.random(55,88)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(150,150,150)
	p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
	
	local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(-1, 0, 0))
	p:SetVelocity(math.Rand(60, 80)*Vector(1, 0, 0)*(self.scale))
	p:SetDieTime(maxLife(.05, .06))
	p:SetStartAlpha(255)
	p:SetEndAlpha(155)
	p:SetStartSize(math.random(22,33)*self.scale)
	p:SetEndSize(math.random(33,44)*self.scale)
	p:SetStartLength(33*math.Rand(.9, 1.1)*self.scale)
	p:SetEndLength(80*math.Rand(.9, 1.1)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	
	local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(1, 0, 0))
	p:SetVelocity(math.Rand(144, 188)*Vector(1, 0, 0)*(self.scale*2))
	p:SetDieTime(maxLife(.05, .07))
	p:SetStartAlpha(255)
	p:SetEndAlpha(155)
	p:SetStartSize(math.random(11,22)*self.scale)
	p:SetEndSize(math.random(33,44)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))

	local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(1, 0, 0))
	p:SetVelocity(math.Rand(44, 55)*Vector(1, 0, 0)*(self.scale*2))
	p:SetDieTime(maxLife(.06, .07))
	p:SetStartAlpha(255)
	p:SetEndAlpha(255)
	p:SetStartSize(math.random(11,15)*self.scale/2)
	p:SetEndSize(math.random(22,33)*self.scale/2)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))

	local p = self.emitter:Add("particle/Particle_Glow_04_Additive", Vector(3, 0, 0))
	p:SetVelocity(150*Vector(1, 0, 0)*self.scale)
	p:SetDieTime(maxLife(.1, .12))
	p:SetStartAlpha(math.Rand(110,130))
	p:SetEndAlpha(0)
	p:SetStartSize(math.random(5,11)*self.scale)
	p:SetEndSize(math.random(80,100)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(245,120,100 )
	p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
	
	
end

function EFFECT:FreeParticle(at)
	local dir = self.dir
end

function EFFECT:Init(data)
	self.ent = data:GetEntity()
	self.scale = math.Clamp(data:GetScale() + math.Rand(-.1, .2), .01, 1)
	self.origin = data:GetOrigin()
	self.dir = data:GetNormal()
	self.lifeTime = .2
	self.decayTime = CurTime() + self.lifeTime
	self.emitter = self.ent.emitter
	WORLDEMITTER = WORLDEMITTER or ParticleEmitter(Vector(0, 0, 0))
	self.freeEmitter = WORLDEMITTER
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
		self:Remove()
		return false
	end

	return true
end

effects.Register(EFFECT, "btMuzzleFlash")



local EFFECT = {}
EFFECT.Models = {}
EFFECT.Models[0] = Model( "models/shells/shell_9mm.mdl" )
EFFECT.Models[1] = Model( "models/shells/shell_556.mdl" )
EFFECT.Models[2] = Model( "models/shells/shell_556.mdl" )
EFFECT.Models[3] = Model( "models/shells/shell_762nato.mdl" )
EFFECT.Models[4] = Model( "models/shells/shell_12gauge.mdl" )
EFFECT.Models[5] = Model( "models/shells/shell_338mag.mdl" )
EFFECT.Models[6] = Model( "models/weapons/rifleshell.mdl" )
 
EFFECT.Sounds = {}
EFFECT.Sounds[0] = { Pitch = 120, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[1] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[2] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[3] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[4] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[5] = { Pitch = 90, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[6] = { Pitch = 90, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[7] = { Pitch = 80, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
 
function EFFECT:Init( data )
	if not ( data:GetEntity() ):IsValid() then
		self.Entity:SetModel( "models/shells/shell_9mm.mdl" )
		self.RemoveMe = true
		return
	end

	// ORIGIN: SPAWN POS
	// DIR: EJECT DIR
	// SCALE: SHELL SCALE
	// RADIUS: ??
	// START: VECTOR
	// ANGLES: ANGLES
	// MAGNITUDE: NUM

	local bulletType = data:GetMagnitude()
	local pos, dir = data:GetOrigin(), data:GetNormal()
	self.Scale = data:GetScale() or 1
	self.Entity:SetPos( pos )
	self.Entity.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.Entity:SetModel(EFFECT.Models[bulletType or 1])
	self.Entity:PhysicsInitBox( Vector(-1,-1,-1), Vector(1,1,1) )
	self.Entity:SetModelScale(1, 0 )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ( phys ):IsValid() then
		phys:Wake()
		phys:SetDamping( 0, 15 )
		phys:SetVelocity( dir * math.random( 150, 200 ) )
		self.Entity.spinVector = ( VectorRand() * 500 )
		phys:AddAngleVelocity( self.Entity.spinVector )
		phys:SetMass( .1 )
		phys:SetMaterial( "gmod_silent" )
	end
	
	self.Entity:SetAngles(AngleRand())
	
	self.HitSound = table.Random( self.Sounds[bulletType].Wavs )
	self.HitPitch = self.Sounds[bulletType].Pitch + math.random(-10,10)
	
	self.SoundTime = CurTime() + math.Rand( 0.5, 0.75 )
	self.LifeTime = CurTime() + 1.6
end
 
function EFFECT:Think( ) 
 	if self.SoundTime then
		if (!self.endSmoke) then
			local phys = self.Entity:GetPhysicsObject()

			if ( phys ):IsValid() then
				phys:AddAngleVelocity( self.Entity.spinVector )
			end
		end
	end

	if self.LifeTime < CurTime() then
		self:Remove()
		return false
	end
 
	return true
end

function EFFECT:PhysicsCollide(colData, collider)
	if (!self.endSmoke) then
		sound.Play( self.HitSound, self.Entity:GetPos(), 55, self.HitPitch )
	end

	self.endSmoke = true
end

function EFFECT:Render()
	self.Entity:DrawModel()
	/*
		if (!self.endSmoke and (!self.Entity.nextEmit or self.Entity.nextEmit < CurTime())) then
			local emit = self.Entity.Emitter
			local Smoke = emit:Add("particle/smokesprites_000"..math.random(1,9), self.Entity:GetPos() + self.Entity:GetForward()*2*self.Scale )
			--local Smoke = self.Emitter:Add("modulus/particles/smoke"..math.random(1,6), self.Origin )
			Smoke:SetVelocity( Vector(0,0,0) )
			Smoke:SetDieTime(math.Rand(0.1,0.5))
			Smoke:SetStartAlpha(math.Rand(55,88))
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(math.random(1,2))
			Smoke:SetEndSize(math.random(5,7))
			Smoke:SetRoll(math.Rand(180,480))
			Smoke:SetRollDelta(math.Rand(-3,3))
			Smoke:SetLighting(true)
			Smoke:SetColor(100,100,100)
			Smoke:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
			Smoke:SetAirResistance(250)
			self.Entity.nextEmit = CurTime() + .04
		end
	*/
end
effects.Register( EFFECT, "btShellEject" )
	