AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Money Printer"
ENT.Author = "Black Tea"
ENT.Category = "NutScript"
ENT.RenderGroup = RENDERGROUP_BOTH

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/consolebox01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetDTBool(0, false)
		self.health = 100

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:Wake()
		end

		timer.Simple(self.interval or 30, function()
			if (self:IsValid()) then
				self:PrintMoney()
			end
		end)
	end

	function ENT:OnTakeDamage(dmginfo)
		local damage = dmginfo:GetDamage()
		self:setHealth(self.health - damage)

		if (self.health < 0) then
			self.onbreak = true
			self:Remove()

			hook.Run("OnMoneyPrinterDestoryed", entity, dmginfo)
		end
	end

	function ENT:OnRemove()
		if (self.onbreak) then
			local effectData = EffectData()
			effectData:SetStart(self:GetPos())
			effectData:SetOrigin(self:GetPos())
			util.Effect("Explosion", effectData, true, true)
			
			util.BlastDamage(self, self, self:GetPos() + Vector( 0, 0, 1 ), 256, 120 )
		end
	end

	function ENT:GoneWrong()
		self.exploding = true
		self:Ignite(3)

		timer.Simple(3, function() 
			if (!IsValid(self)) then return end
			self:Remove()
		end)
	end

	function ENT:PrintMoney()
		self:SetDTBool(0, true)
		self:EmitSound("ambient/machines/combine_terminal_idle4.wav", 110, 150)

		timer.Simple(2, function()
			if (!self:IsValid()) then
				return
			end

			if (hook.Run("CanGenerateMoney", self) != false) then
				local pos = self:GetPos() + self:OBBCenter() + Vector(0, 0, 25)
				local angle = self:GetAngles()
				local amount = hook.Run("OnGenerateMoney", self, self.amount) or self.amount or 100
				local dice = math.Rand(0, 100)

				nut.currency.spawn(pos, amount, angle)
				self:SetDTBool(0, false)

				if (dice < 10) then
					self:GoneWrong()
				end
			end

			timer.Simple(self.interval, function()
				if (!self:IsValid() or self.exploding) then 
					return
				end
				
				self:PrintMoney()
			end)
		end)
	end

	function ENT:setHealth(amount)
		self.health = amount
	end
	
	function ENT:setInterval(amount)
		self.interval = amount
	end

	function ENT:Use(activator)
	end
else
	function ENT:onShouldDrawEntityInfo()
		return true
	end

	function ENT:onDrawEntityInfo(alpha)
		local unique = self:getNetVar("id")
		if (unique) then
			local itemTable = nut.item.list[unique]

			if (itemTable) then
				local position = (self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 10)):ToScreen()
				local x, y = position.x, position.y

				nut.util.drawText(itemTable.name, x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
				nut.util.drawText(itemTable.desc, x, y + 16, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
			end		
		end
	end

	local glowMaterial = Material("sprites/glow04_noz")

	function ENT:DrawTranslucent()
		local pos = self:GetPos()
		pos = pos + self:GetUp() * 8
		pos = pos + self:GetForward() * 17
		pos = pos + self:GetRight() * -12

		render.SetMaterial(glowMaterial)
		if (self:GetDTBool(0)) then
			render.DrawSprite(pos, 12, 12, Color( 44, 255, 44, alpha ) )
		else
			render.DrawSprite(pos, 12, 12, Color( 255, 44, 44, alpha ) )
		end
	end
end