AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Vendor"
ENT.Author = "Chessnut and Black Tea"
ENT.Spawnable = true
ENT.Category = "NutScript"

function ENT:SpawnFunction(client, trace, className)
	if (!trace.Hit or trace.HitSky) then return end

	local spawnPosition = trace.HitPos + trace.HitNormal * 16

	local ent = ents.Create(className)
	ent:SetPos(spawnPosition)
	ent:Spawn()
	ent:Activate()

	local config = DEFAULTVENDOR
	config.id = math.random(0, 9999999)
	ent:loadConfig(config)

	return ent
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/mossman.mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)
		self:DropToFloor()

		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
			physicsObject:Sleep()
		end
	else
		self:CreateBubble()
	end

	self:SetAnim()
end

function ENT:SetAnim()
	for k, v in pairs(self:GetSequenceList()) do
		if (string.find(string.lower(v), "idle")) then
			if (v != "idlenoise") then
				self:ResetSequence(k)

				return
			end
		end
	end

	self:ResetSequence(4)
end

function ENT:getInv()
	return self.inv
end

function ENT:hasMoney(amount)
	return amount
end

function ENT:getMoney()
	return self:getNetVar("money")
end

function ENT:setMoney(amount)
	return self:setNetVar("money", amount)
end

function ENT:addMoney(amount)
	return self:setMoney(self:getMoney() + amount)
end

function ENT:takeMoney(amount)
	return self:setMoney(self:getMoney() - amount)
end

function ENT:loadConfig(configTable)
	self.id = configTable.id
	self:setNetVar("name", configTable.name)
	self:setNetVar("desc", configTable.desc)
	self:SetModel(configTable.model)
	self:setNetVar("money", configTable.money)
	self:setNetVar("inv", configTable.inventory)
	self:setNetVar("size", {configTable.w, configTable.h})

	local configs = {}
	for k, v in pairs(configTable.configs) do
		configs[k] = v
	end
	self:setNetVar("config", configs)
end

function ENT:getConfig()
	return self:getNetVar("config", {})
end

if (CLIENT) then
	function ENT:onShouldDrawEntityInfo()
		return true
	end

	function ENT:onDrawEntityInfo(alpha)
		local bone = self:LookupBone("ValveBiped.Bip01_Head1")
		local bonepos = (bone != 0 and self:GetBonePosition(bone) + Vector(0, 0, 10)) or (self:GetPos() + Vector(0, 0, 70))
		local position = bonepos:ToScreen()
		local x, y = position.x, position.y

		nut.util.drawText(self:getNetVar("name"), x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
		nut.util.drawText(self:getNetVar("desc"), x, y + 16, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
	end

	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.5, 0)
	end

	function ENT:Think()
		if (!IsValid(self.bubble)) then
			self:CreateBubble()
		end

		self:SetEyeTarget(LocalPlayer():GetPos())
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetAngles(Angle(0, realTime * 120, 0))
			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.03))
		end

		self:DrawModel()
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end
else
	function ENT:Use(activator)
		netstream.Start(activator, "nutVendorFrame", self)
	end
end