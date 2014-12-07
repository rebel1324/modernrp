AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Crafting Table"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "NutScript"

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/controlroom_desk001b.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:setNetVar("active", false)
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end
	end

	function ENT:startCook(activator)
		if (self:getNetVar("active")) then
			activator:notify("inuse.")

			return false
		end

		self:setNetVar("active", true)

		timer.Simple(2, function()
			self:stopCook(activator)
		end)

		return true
	end

	function ENT:stopCook(activator)
		local id = self:getNetVar("cooking")

		activator:EmitSound("items/battery_pickup.wav")
		self:setNetVar("active", false)
	end

	function ENT:Use(activator)
		if (!self:getNetVar("active")) then
			--netstream.Start(activator, "nutStoveFrame")
		else
			activator:notify("Stove is in use.")
		end
	end
else
	function ENT:Initialize()
		self.emitter = ParticleEmitter( self:GetPos() )
		self.emittime = CurTime()
	end
	
	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	function ENT:Draw()
		self:DrawModel()
		
		if self:getNetVar("active") then
			local position = 	self:GetPos() + ( self:GetUp() *20 ) + 	( self:GetRight() * 11) + ( self:GetForward() *3)
			local size = 20 + math.sin( RealTime()*15 ) * 5
			render.SetMaterial(GLOW_MATERIAL)
			render.DrawSprite(position, size, size, Color( 255, 162, 76, 255 ) )
			
			if self.emittime < CurTime() then
				local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), position	)
				smoke:SetVelocity(Vector( 0, 0, 120))
				smoke:SetDieTime(math.Rand(0.2,1.3))
				smoke:SetStartAlpha(math.Rand(150,200))
				smoke:SetEndAlpha(0)
				smoke:SetStartSize(math.random(0,5))
				smoke:SetEndSize(math.random(20,30))
				smoke:SetRoll(math.Rand(180,480))
				smoke:SetRollDelta(math.Rand(-3,3))
				smoke:SetColor(50,50,50)
				smoke:SetGravity( Vector( 0, 0, 10 ) )
				smoke:SetAirResistance(200)
				self.emittime = CurTime() + .1
			end
		end
		
	end
end
