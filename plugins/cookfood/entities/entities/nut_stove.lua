AddCSLuaFile()

ENT.Base = "nut_microwave"
ENT.Type = "anim"
ENT.PrintName = "Stove"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.Category = "NutScript"
ENT.invType = "stove"
nut.item.registerInv(ENT.invType, 2, 2)

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/furnitureStove001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:setNetVar("active", false)
		self:SetUseType(SIMPLE_USE)
		self.loopsound = CreateSound(self, "ambient/fire/fire_small_loop1.wav")
		self.receivers = {}
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end

		nut.item.newInv(0, self.invType, function(inventory)
			self:setInventory(inventory)
			inventory.noBags = true

			function inventory:onCanTransfer(client, oldX, oldY, x, y, newInvID)
				return hook.Run("StorageCanTransfer", inventory, client, oldX, oldY, x, y, newInvID)
			end
		end)
	end

	function ENT:activate(seconds)
		if (self:getNetVar("gone")) then
			return
		end

		local timerName = self:GetClass():lower() .. "_" .. self:EntIndex() .. "_stoveThink"
		if (seconds != 0 and !self:getNetVar("active")) then
			seconds = math.abs(seconds)

			timer.Create(timerName, seconds, 1, function()
				if (self and self:IsValid()) then
					self:activate(0)
				end
			end)
		else
			timer.Destroy(timerName)
		end

		self:setNetVar("active", !self:getNetVar("active"))
		self:EmitSound("ambient/fire/mtov_flame2.wav", 75, 250)

		if (self:getNetVar("active")) then
			self.loopsound:Play()
			self.loopsound:ChangeVolume(.7, 0)
		else
			self.loopsound:Stop()
		end
	end

	local heatCooks = {
		{0, 3, 1},
		{3, 5, 3},
		{5, 15, 4},
		{15, 16, 5},
	}
	function ENT:Think()
		if (self:getNetVar("gone")) then
			return
		end

		if (self:getNetVar("active")) then
			local items = self:getInv():getItems(true)

			for k, v in pairs(items) do
				v:setData("heat", v:getData("heat", 0) + 1)

				if (v.ammo) then
					if (v:getData("heat") > 3) then
						self:explode()
					end
				end

				if (v.isFood and v.cookable) then
					local heat = v:getData("heat")
					local cookLevel = v:getData("cooked", 0)
					local overheat = true

					for _, range in ipairs(heatCooks) do
						if (heat >= range[1] and heat < range[2]) then
							if (cookLevel != range[3]) then
								v:setData("cooked", range[3])
							end
							overheat = false

							break
						end
					end

					if (overheat) then
						if (cookLevel != 2) then
							v:setData("cooked", 2)
						end
					end
				end
			end

			self:NextThink(CurTime() + 1)
			return true
		end
	end
else
	function ENT:Initialize()
		self.emitter = ParticleEmitter(self:GetPos())
		self.nextEmit = 0
	end

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	function ENT:DrawTranslucent()
		if self:getNetVar("active") then
			local position = 	self:GetPos() + ( self:GetUp() *20 ) + 	( self:GetRight() * 11) + ( self:GetForward() *3)
			local size = 20 + math.sin( RealTime()*15 ) * 5
			render.SetMaterial(GLOW_MATERIAL)
			render.DrawSprite(position, size, size, Color( 255, 162, 76, 255 ) )
			
			if self.nextEmit < CurTime() then
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
				self.nextEmit = CurTime() + .1
			end
		end
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
end

/*AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Stove"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "NutScript"

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/furnitureStove001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:setNetVar("active", false)
		self:SetUseType(SIMPLE_USE)
		self.loopsound = CreateSound( self, "ambient/fire/fire_small_loop1.wav" )
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end
	end

	function ENT:startCook(activator, id)
		local item = nut.item.instances[id]
		if (self:getNetVar("active")) then
			activator:notify("Stove is in use.")

			return false
		end

		if (item:getOwner() != activator) then
			--self:notify("HAX")
			return false
		end

		if (item.cookable == false) then
			return false
		end

		self:setNetVar("active", true)
		self:EmitSound( "ambient/fire/mtov_flame2.wav", 75, 100 )
		self.loopsound:Play()
		self:setNetVar("cooking", id)

		timer.Simple(2, function()
			self:stopCook(activator)
		end)

		return true
	end

	function ENT:stopCook(activator)
		local id = self:getNetVar("cooking")
		local item = nut.item.instances[id]

		if (item) then
			local random = (math.random()^.8) * (#COOKLEVEL - 2) -- uncooked is not counted.
			random = math.Round(random) + 2 -- random goes 0 to #COOKLEVEL. we add 2 for make uncooked not count and lua indexes starts from 1.
			
			item:setData("cooked", random)
		end

		activator:EmitSound("items/battery_pickup.wav")
		self:setNetVar("active", false)
		self:EmitSound( "ambient/fire/mtov_flame2.wav", 75, 250 )
		self.loopsound:Stop()
	end

	function ENT:Use(activator)
		if (!self:getNetVar("active")) then
			netstream.Start(activator, "nutStoveFrame")
		else
			activator:notify("Stove is in use.")
		end
	end
else
	
end
*/