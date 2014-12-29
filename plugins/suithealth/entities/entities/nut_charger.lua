ENT.Type = "anim"
ENT.PrintName = "Health Charger"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Category = "NutScript"
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.denySound = Sound("items/medshotno1.wav")
ENT.useSound = Sound("items/medshot4.wav")
ENT.chargeSound = "items/medcharge4.wav"
ENT.restoreRate = .1
ENT.restoreAmount = 1
ENT.restoreCost = .03
ENT.restoreCool = 5

function ENT:getUsed()
	return self:getNetVar("used", 0)
end

function ENT:isActive()
	return self:getNetVar("active", false)
end

if (SERVER) then
	function ENT:SpawnFunction(client, trace, className)
		if (!trace.Hit or trace.HitSky) then return end

		local pos = trace.HitPos + trace.HitNormal * 1
		local divider = 10
		local ent = ents.Create(className)

		if divider <= 0 then
			divider = 1
		end

		for i = 1, 3 do
			pos[i] = pos[i] / divider
			pos[i] = math.Round(pos[i])
			pos[i] = pos[i] * divider
		end
		ent:SetPos(pos)


		ent:Spawn()
		ent:SetAngles(trace.HitNormal:Angle())
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/props_combine/health_charger001.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:setNetVar("used", 0)
		self.rechargeTime = CurTime()
		self.usedCharge = 0
		local phys = self:GetPhysicsObject()

		if (IsValid(phys)) then
			phys:Wake()
			phys:EnableMotion()
		end

		timer.Simple(0, function()
			self.loopSound = CreateSound(self, self.chargeSound)
		end)
	end

	function ENT:OnRemove()
		self.loopSound:Stop()
	end

	local dist = 0

	function ENT:finishUse(noService)
		self:setNetVar("active", false)
		self.loopSound:Stop()
		self:EmitSound(self.denySound)

		-- Make user pay tokens
		self.user:notify(Format("You paid %s for Medical Care.", nut.currency.get(math.Round(self.usedCharge*100))))

		self.user.onCharge = nil
		self.user = nil
		self.usedCharge = 0
	end
	
	function ENT:Think()
		if (self:getNetVar("active") and self.user and IsValid(self.user)) then
			dist = self.user:GetPos():Distance(self:GetPos())
			if (dist > 64*1.5 or !self.user:KeyDown(IN_USE) or self:getUsed() >= 1 or self.user:Health() >= self.user:GetMaxHealth()) then
				self:finishUse(self:getUsed() >= 1 or self.user:Health() >= self.user:GetMaxHealth())
				return
			end

			self.user:SetHealth(self.user:Health() + self.restoreAmount)
			self.usedCharge = math.Clamp(self:getUsed() + self.restoreCost, 0, 1)
			self:setNetVar("used", math.Clamp(self:getUsed() + self.restoreCost, 0, 1))
			self.rechargeTime = CurTime() + self.restoreCool
		else
			if (self.rechargeTime < CurTime()) then
				self:setNetVar("used", math.Clamp(self:getUsed() - self.restoreCost * .8, 0, 1))
			end
		end

		self:NextThink(CurTime() + self.restoreRate)
		return true
	end

	function ENT:Use(client)
		if (!client.onCharge and !self.user and !IsValid(self.user) and self:getUsed() <= 1 and client:Health() < client:GetMaxHealth()) then
			client.onCharge = true
			self.user = client
			self:setNetVar("active", true)
			self.loopSound:Play()
			self.loopSound:ChangeVolume(1, 0)
			self:EmitSound(self.useSound)
		else
			self:EmitSound(self.denySound)
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Initialize()
		self.smoothUsed = 0
	end

	local bone, idxHealth, idxSpinner, position, ft
	local light = 0
	local GLOW_MATERIAL = Material("particle/Particle_Glow_04_Additive.vmt")
	local COLOR_ACTIVE = Color(0, 255, 255, 50)
	local COLOR_INACTIVE = Color(255, 0, 0, 50)
	function ENT:DrawTranslucent()
		ft = FrameTime()
		idxHealth = self:LookupBone("healthbar")
		idxSpinner = self:LookupBone("roundcap")

		self.smoothUsed = math.Approach(self.smoothUsed, self:getUsed(), ft*(self.restoreRate + self.restoreCost)*2)
		
		if (idxSpinner and idxSpinner != 0) then
			self:ManipulateBoneAngles(idxSpinner, Angle(0, self.smoothUsed * 250, 0))
			self:ManipulateBonePosition(idxSpinner, Vector(0, 0, -4 * self.smoothUsed))
		end

		if (idxHealth and idxHealth != 0) then
			self:ManipulateBonePosition(idxHealth, Vector(1 + (-8 * self.smoothUsed), 0, 0))
		end

		light = light + ft * (self:isActive() and 4 or 1)
		position = self:GetPos() + self:GetForward() * 7.5 + self:GetUp() * -.5 + self:GetRight() * 2.5
		render.SetMaterial(GLOW_MATERIAL)
		render.DrawSprite(position, 8 + math.sin(light), 8 + math.sin(light), self:getUsed() >= 1 and COLOR_INACTIVE or COLOR_ACTIVE)
	end
end