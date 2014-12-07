AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Flagpoint"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")
		self:SetSolid(1)
		self:PhysicsInit(SOLID_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetTrigger(true)
		self.touched = {}

		local min, max = Vector(-32, -32, 0), Vector(32, 32, 75)

		self:PhysicsInitBox(min, max)
		self:SetCollisionBounds(min, max)
	end

	--function ENT:StartTouch(client)
	--end
	function ENT:Touch(client)
		if (client:IsPlayer()) then
			if (!self.touched[client]) then
				print(self:getNetVar("property"))
				if (!nut.property.getBusiness(self:getNetVar("property", "none"))) then
					if (client:IsAdmin()) then
						netstream.Start(client, "prpAssign", self)	
					end
				else
					netstream.Start(client, "prpMenu", self)	
				end

				self.touched[client] = true
			end
		end
	end

	function ENT:EndTouch(client)
		if (client:IsPlayer()) then
			if (self.touched[client]) then 
				self.touched[client] = false
			end
		end
	end
else
	/*
	function ENT:onShouldDrawEntityInfo()
		return true
	end

	function ENT:onDrawEntityInfo(alpha)
		local position = self:LocalToWorld(self:OBBCenter()):ToScreen()
		local x, y = position.x, position.y

		nut.util.drawText(nut.currency.get(self:getAmount()), x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
	end
	*/
	local circleData = {}
	circleData.points = 80
	circleData.radius = 32
	circleData.height = 75
	local circleMaterial = CreateMaterial ("<material id unique to your addon>", "UnlitGeneric",
	    {
	        ["$basetexture"] = "gui/gradient_up",
	        ["$vertexcolor"] = 1,
	        ["$vertexalpha"] = 1,
	        ["$translucent"] = 1
	    }
	)
	CIRCLEMESH = Mesh()
	UPDATE = false

	local function getCirclePoints(pos, ang, pnum, distance)
		if (pnum <= 2) then
			return
		end 

		local cpAngle = Angle(ang[1], ang[2], ang[3])
		local rotAngle = Angle(ang[1], ang[2], ang[3])
		local div = 360/pnum
		local points = {}

		for i = 1, pnum do
			rotAngle:RotateAroundAxis(cpAngle:Up(), div)
			points[i] = pos + rotAngle:Forward() * distance
		end

		return points
	end

	function createMesh()
		local angle = Angle(0, 0, 0)
		local pos = LocalPlayer():GetPos()
		local positions = getCirclePoints(pos, angle, circleData.points, circleData.radius)
		local positions2 = getCirclePoints(pos + angle:Up() * circleData.height, angle, circleData.points, circleData.radius)
		local verts = {}
		local curidx, nextidx
		local av = .99
		for i = 1, circleData.points do
			curidx = i
			nextidx = (i == circleData.points and 1) or (curidx + 1)
			local curvpos = positions[curidx]
			local nexvpos = positions[nextidx]
			local curuvpos = positions2[curidx]
			local nexuvpos = positions2[nextidx]
			local curvloc = WorldToLocal(curvpos, angle, pos, angle)
			local nexvloc = WorldToLocal(nexvpos, angle, pos, angle)
			local curuvloc = WorldToLocal(curuvpos, angle, pos, angle)
			local nexuvloc = WorldToLocal(nexuvpos, angle, pos, angle)
		
			table.insert(verts, {pos = nexvloc, u = -av, v = -av})
			table.insert(verts, {pos = curvloc, u = -0, v = -av})
			table.insert(verts, {pos = curuvloc,u = -0,v = -0})
			table.insert(verts, {pos = curuvloc,u = -0,v = -0})
			table.insert(verts, {pos = nexuvloc,u = -0,v = -0})
			table.insert(verts, {pos = nexvloc,u = -0,v = -av})
		end

		CIRCLEMESH:BuildFromTriangles( verts )
		UPDATE = true
	end

	function ENT:Draw()
	end

	function ENT:DrawTranslucent()
		if (!UPDATE) then
			createMesh()
			circleMaterial:SetVector("$color", Vector(1, 0, 0) )
			circleMaterial:SetFloat("$alpha", 100 / 255)
		end

		local color = Color(255, 0, 0, 150)
		local shirk = math.sin(RealTime()*2)

		local newMesh = CIRCLEMESH
		local mat = Matrix()
		mat:Translate(self:GetPos() + Vector(0, 0, 1)*circleData.height)
		mat:Rotate(Angle(0, 0, 180))
		mat:Scale(Vector(1 - shirk*.1,1 - shirk*.1, 1))

		render.SuppressEngineLighting(true)
		render.SetMaterial(circleMaterial)
		render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
		render.SetBlend(color.a/255)
		cam.PushModelMatrix(mat)
			render.CullMode(MATERIAL_CULLMODE_CW)
			newMesh:Draw()
			render.CullMode(MATERIAL_CULLMODE_CCW)
			newMesh:Draw()
		cam.PopModelMatrix()
		render.SetBlend(1)
		render.SetColorModulation(1,1,1)
		render.SuppressEngineLighting(false)
	end
end