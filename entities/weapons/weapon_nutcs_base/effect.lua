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
	p:SetStartAlpha(math.Rand(80,150))
	p:SetEndAlpha(0)
	p:SetStartSize(math.random(5,11)*self.scale)
	p:SetEndSize(math.random(55,88)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(150,150,150)
	p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
	
	local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(-1, 0, 0))
	p:SetVelocity(math.Rand(60, 80)*Vector(1, 0, 0)*(self.scale))
	p:SetDieTime(maxLife(.06, .06))
	p:SetStartAlpha(200)
	p:SetEndAlpha(80)
	p:SetStartSize(math.random(22,33)*self.scale)
	p:SetEndSize(math.random(33,44)*self.scale)
	p:SetStartLength(40*math.Rand(.9, 1.1)*self.scale)
	p:SetEndLength(60*math.Rand(.9, 1.1)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	
	local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(1, 0, 0))
	p:SetVelocity(math.Rand(144, 188)*Vector(1, 0, 0)*(self.scale*2))
	p:SetDieTime(maxLife(.06, .07))
	p:SetStartAlpha(255)
	p:SetEndAlpha(144)
	p:SetStartSize(math.random(16,22)*self.scale)
	p:SetEndSize(math.random(33,44)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))

	local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(1, 0, 0))
	p:SetVelocity(math.Rand(44, 55)*Vector(1, 0, 0)*(self.scale*2))
	p:SetDieTime(maxLife(.06, .07))
	p:SetStartAlpha(200)
	p:SetEndAlpha(80)
	p:SetStartSize(math.random(11,15)*self.scale/2)
	p:SetEndSize(math.random(22,33)*self.scale/2)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))

	local p = self.emitter:Add("particle/Particle_Glow_04_Additive", Vector(3, 0, 0))
	p:SetVelocity(150*Vector(1, 0, 0)*self.scale)
	p:SetDieTime(maxLife(.1, .12))
	p:SetStartAlpha(math.Rand(144,180))
	p:SetEndAlpha(0)
	p:SetStartSize(math.random(5,11)*self.scale)
	p:SetEndSize(math.random(80,100)*self.scale)
	p:SetRoll(math.Rand(180,480))
	p:SetRollDelta(math.Rand(-3,3))
	p:SetColor(245,120,100 )
	p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )

	if (self.muzPattern) then
		if (self.muzPattern == 2) then
			local dang = Vector(1, 0, 0):Angle()
			local a1, a2 = dang:Right(), dang:Up()
			dang:RotateAroundAxis(a1, 90)

			for i = 1, 2 do
				dang:RotateAroundAxis(a1, math.random(160, 200))
				local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(-1, 0, 0))
				p:SetVelocity(math.Rand(60, 80)*dang:Forward()*(self.scale))
				p:SetDieTime(maxLife(.05, .06))
				p:SetStartAlpha(150)
				p:SetEndAlpha(50)
				p:SetStartSize(math.random(22,33)*self.scale)
				p:SetEndSize(math.random(33,44)*self.scale)
				p:SetStartLength(22*math.Rand(.9, 1.1)*self.scale)
				p:SetEndLength(44*math.Rand(.9, 1.1)*self.scale)
				p:SetRoll(math.Rand(180,480))
				p:SetRollDelta(math.Rand(-3,3))
			end
		elseif (self.muzPattern == 3) then
			local dang = Vector(1, 0, 0):Angle()
			local a1, a2 = dang:Forward(), dang:Up()
			dang:RotateAroundAxis(a1, math.random(30, 60))

			for i = 1, 3 do
				dang:RotateAroundAxis(a1, 120)
				local p = self.emitter:Add(muzzleMaterials[math.random(1, 8)], Vector(-1, 0, 0))
				p:SetVelocity(math.Rand(60, 80)*dang:Right()*(self.scale))
				p:SetDieTime(maxLife(.05, .06))
				p:SetStartAlpha(150)
				p:SetEndAlpha(50)
				p:SetStartSize(math.random(22,33)*self.scale)
				p:SetEndSize(math.random(33,44)*self.scale)
				p:SetStartLength(22*math.Rand(.9, 1.1)*self.scale)
				p:SetEndLength(44*math.Rand(.9, 1.1)*self.scale)
				p:SetRoll(math.Rand(180,480))
				p:SetRollDelta(math.Rand(-3,3))
			end
		end
	end
end

function EFFECT:FreeParticle(at)
	local dir = self.dir
end

function EFFECT:Init(data)
	self.ent = data:GetEntity()
	self.scale = math.Clamp(data:GetScale() + math.Rand(-.1, .2), .01, 1)
	self.origin = data:GetOrigin()
	self.dir = data:GetNormal()
	self.muzPattern = data:GetMagnitude() or 0
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
	
local EFFECT = {}
function EFFECT:Init( data ) 
	self:SetNoDraw(true)
	local pos = data:GetOrigin()
	local dir = data:GetNormal()
	local scale = data:GetScale() or 1
	WORLDEMITTER = WORLDEMITTER or ParticleEmitter(Vector(0, 0, 0))
	self.emitter = WORLDEMITTER
	local scol = 55

	local dang = dir:Angle()
	local a1= dang:Forward()
	local smi = 3
	dang:RotateAroundAxis(a1, math.random(10, 40))

	for i = 0, smi do
		dang:RotateAroundAxis(a1, 360/smi)

		local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + VectorRand()*10)
		smoke:SetVelocity(dang:Right()*math.random(250, 290)*scale)
		smoke:SetDieTime(math.Rand(.2,.4))
		smoke:SetStartAlpha(math.Rand(188,211))
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(math.random(0,5)*scale)
		smoke:SetEndSize(math.random(55,66)*scale)
		smoke:SetRoll(math.Rand(180,480))
		smoke:SetRollDelta(math.Rand(-3,3))
		smoke:SetColor(scol, scol, scol)
		smoke:SetGravity( Vector( 0, 0, 20 ) )
		smoke:SetAirResistance(450)
	end

	local spi = 5 * math.max(scale, .5)
	for i = 0, spi do
		local mid = (math.max(spi, spi/2)/spi)
		local dang = dir:Angle()
		local a1, a2, a3 = dang:Right(), dang:Up(), dang:Forward()
		dang:RotateAroundAxis(a1, math.random(-66, 66))
		dang:RotateAroundAxis(a2, math.random(-66, 66))

		local adf = dang:Forward()
		local dt = a3:Dot(adf)
		local smoke = self.emitter:Add( "effects/spark", pos + VectorRand()*1)
		smoke:SetVelocity(adf*math.random(333, 355)*scale*mid*dt)
		smoke:SetDieTime(math.Rand(.1,.2))
		smoke:SetStartAlpha(255)
		smoke:SetEndAlpha(0)
		smoke:SetEndLength(math.random(15, 25)*mid*dt)
		smoke:SetStartLength(math.random(5, 7)*dt)
		smoke:SetStartSize(math.random(4,5)*scale)
		smoke:SetEndSize(0)
		smoke:SetGravity( Vector(0, 0, -600)*.5 )
	end

	for i = 0, 3 do
		local dang = dir:Angle()
		local a1, a2 = dang:Right(), dang:Up()
		dang:RotateAroundAxis(a1, math.random(-15, 15))
		dang:RotateAroundAxis(a2, math.random(-15, 15))

		local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + VectorRand()*10)
		smoke:SetVelocity(dang:Forward()*math.random(600, 1500)*((i + 3)/(5 + 3))*scale)
		smoke:SetDieTime(math.Rand(.3,.6))
		smoke:SetStartAlpha(math.Rand(188,211))
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(math.random(2,5)*scale)
		smoke:SetEndSize(math.random(44,55)*scale)
		smoke:SetRoll(math.Rand(180,480))
		smoke:SetRollDelta(math.Rand(-3,3))
		smoke:SetColor(scol, scol, scol)
		smoke:SetGravity( Vector( 0, 0, 20 ) )
		smoke:SetAirResistance(450)
	end

	local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + dir * 5)
	smoke:SetVelocity(dir*350*scale)
	smoke:SetDieTime(math.Rand(.07,.12))
	smoke:SetStartAlpha(255)
	smoke:SetEndAlpha(0)
	smoke:SetStartSize(math.random(22,33)*scale)
	smoke:SetEndSize(math.random(66,77)*scale)
	smoke:SetRoll(math.Rand(180,480))
	smoke:SetRollDelta(math.Rand(-3,3))
	smoke:SetColor(scol*1.5, scol*1.5, scol*1.5)
	smoke:SetGravity( Vector( 0, 0, 20 ) )
	smoke:SetAirResistance(250)

	local smoke = self.emitter:Add( "effects/muzzleflash" .. math.random(1, 4), pos + VectorRand()*1)
	smoke:SetVelocity(dir*300*scale)
	smoke:SetDieTime(math.Rand(.05,.1))
	smoke:SetStartAlpha(255)
	smoke:SetEndAlpha(155)
	smoke:SetStartSize(math.random(5,8)*scale)
	smoke:SetEndSize(math.random(11,22)*scale)
	smoke:SetRoll(math.Rand(180,480))
	smoke:SetRollDelta(math.Rand(-3,3))
	smoke:SetGravity( Vector( 0, 0, 20 ) )
	smoke:SetAirResistance(250)

	local smoke = self.emitter:Add( "particle/Particle_Glow_04_Additive", pos + dir * 1)
	smoke:SetVelocity(dir*400*scale)
	smoke:SetDieTime(math.Rand(.05,.1))
	smoke:SetStartAlpha(44)
	smoke:SetEndAlpha(11)
	smoke:SetStartSize(math.random(5,8)*scale)
	smoke:SetEndSize(math.random(44,55)*scale)
	smoke:SetRoll(math.Rand(180,480))
	smoke:SetRollDelta(math.Rand(-3,3))
	smoke:SetGravity(Vector(0, 0, 20))
	smoke:SetColor(255, 200, 50)
	smoke:SetAirResistance(250)

	local smoke = self.emitter:Add( "effects/muzzleflash" .. math.random(1, 4), pos + dir * 6)
	smoke:SetVelocity(dir*300*scale)
	smoke:SetDieTime(math.Rand(.05,.1))
	smoke:SetStartAlpha(100)
	smoke:SetEndAlpha(0)
	smoke:SetStartSize(math.random(11,22)*scale)
	smoke:SetEndSize(math.random(33,44)*scale)
	smoke:SetRoll(math.Rand(180,480))
	smoke:SetRollDelta(math.Rand(-3,3))
	smoke:SetGravity( Vector( 0, 0, 20 ) )
	smoke:SetAirResistance(250)
end

effects.Register( EFFECT, "btImpact" )


local EFFECT = {}
function EFFECT:Init( data ) 
	self.tOrigin = data:GetStart()	
	self.tEnd = data:GetOrigin()
	self.tWeapon = data:GetEntity()
	self.tAtt = data:GetAttachment()
	self.tOrigin = self:GetTracerShootPos( self.tOrigin, self.tWeapon, self.tAtt )
	self.tDir = self.tEnd - self.tOrigin
	self.tDir:Normalize()

	self:SetRenderBoundsWS( self.tOrigin, self.tEnd )
	self.Length = .1
	
	-- Die when it reaches its target
	self.life = 10
	self.lifeTime = CurTime() + self.life
	self.trav = 0
end

local tracerLength = 150
function EFFECT:Think( )
	if (self.lifeTime < CurTime()) then
		return false
	end

	local dir2 = self.tEnd - (self.tOrigin + self.tDir * (self.trav + tracerLength))
	dir2:Normalize()

	if (self.tDir:Dot(dir2) < 0) then
		self.impact = true
	end
	
	return true
end

local tracerMats = {
	Material("effects/spark"),
	Material("effects/gunshiptracer"),
	Material("effects/bluespark"),
	Material("effects/tool_tracer"),
	Material("effects/bloodstream"),
	Material("effects/laser_tracer"),
}
local smokeTrail = Material("trails/smoke")
function EFFECT:Render( )	
	render.SetMaterial(tracerMats[1])
	
	local factor = 1 - ((self.lifeTime - CurTime()) / self.life)
	if (!self.impact) then
		local pos = self.tDir * (self.trav)

		render.DrawBeam( self.tOrigin + self.tDir * (self.trav + tracerLength*.7), 		
						 self.tOrigin + self.tDir * (self.trav),
						 9,					
						 1,					
						 0,				
						 Color( 255, 255, 255, 255 ) )

		self.trav = self.trav + FrameTime() * 8000 * math.Rand(.9, 1)
	end
					 
end

effects.Register( EFFECT, "btTracer" )