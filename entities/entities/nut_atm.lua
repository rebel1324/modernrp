AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "ATM"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Category = "NutScript"
ENT.RenderGroup 		= RENDERGROUP_BOTH

if (SERVER) then
	function ENT:SpawnFunction(client, trace, className)
		if (!trace.Hit or trace.HitSky) then return end

		local pos = trace.HitPos + trace.HitNormal * 5
		local ent = ents.Create(className)
		ent:SetPos(nut.util.gridVector(pos, 5))
		ent:Spawn()
		ent:SetAngles(trace.HitNormal:Angle())
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_smallmonitor001.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion()
		end
	end

	function ENT:OnRemove()
	end

	function ENT:Use(activator)
		netstream.Start(activator, "nutBank")
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	local pos, ang, renderAng, dist, dFactor
	local gradient = nut.util.getMaterial("vgui/gradient-u")
	local w, h, maxDistance = 330, 300, 1024
	function ENT:DrawTranslucent()
		pos = self:GetPos()
		dist = LocalPlayer():GetPos():Distance(pos)
		dFactor = 1 - math.Clamp(dist/maxDistance - .15, 0, 1)
		if (dist < maxDistance) then
			ang = self:GetAngles()

			pos = pos + ang:Up() * 11.4
			pos = pos + ang:Right() * -1.2
			pos = pos + ang:Forward() * 13.2

			renderAng = Angle(ang[1], ang[2], ang[3])
			renderAng:RotateAroundAxis(ang:Forward(), 90)
			renderAng:RotateAroundAxis(ang:Up(), 89)

			cam.Start3D2D(pos, renderAng, .05)
				draw.RoundedBox(0, -w/2, -h/2, w, h, Color( 0, 0, 0, 255*dFactor ) )
				surface.SetDrawColor(33, 33, 33, 255*dFactor)
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(-w/2, -h/2, w, h)
				draw.SimpleText("ATM", "nutBigFont", 0, -h/3*1, ColorAlpha(color_white, 255*dFactor), 1, 1)
			cam.End3D2D()
		end
	end
end