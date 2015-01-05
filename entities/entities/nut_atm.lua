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
		--netstream.Start(activator, "nutBank")
	end
else
	local gradient = nut.util.getMaterial("vgui/gradient-u")
	local commands = {
		{"deposit", "/bankdeposit"},
		{"withdraw", "/bankwithdraw"},
		{"transfer"},
	}

	local function drawMatrixString(str, font, x, y, scale, angle, color)
		surface.SetFont(font)
		local tx, ty = surface.GetTextSize(str)

		local matrix = Matrix()
		matrix:Translate(Vector(x, y, 1))
		matrix:Rotate(angle or Angle(0, 0, 0))
		matrix:Scale(scale)

		cam.PushModelMatrix(matrix)
			surface.SetTextPos(2, 2)
			surface.SetTextColor(color or color_white)
			surface.DrawText(str)
		cam.PopModelMatrix()
	end

	local function renderCode(self, ent, w, h)
		local char = LocalPlayer():getChar()

		if (self.hasFocus) then
			self.fadeAlpha = math.Clamp(self.fadeAlpha - FrameTime()*4, 0, 1)
		else
			self.fadeAlpha = math.Clamp(self.fadeAlpha + FrameTime(), 0, 1)
		end

		if (char) then
			local mx, my = self:mousePos()
			local scale = 1 / self.scale

			if (self.fadeAlpha < 1) then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
				surface.SetDrawColor(33, 33, 33, 255)
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(0, 0, w, h)

				local tx, ty = draw.SimpleText("8", "nutIconsBig", 2 * scale, 2 * scale, ColorAlpha(color_white, 255), 1, 1)
				tx, ty = draw.SimpleText(char:getReserve(), "nutBigFont", tx + 2 * scale, 2 * scale, ColorAlpha(color_white, 255), 3, 1)

				local bx, by, color
				self.curSel = -1
				surface.SetFont("nutBigFont")
				for i, v in ipairs(commands) do
					color = color_white
					tx, ty = surface.GetTextSize(v[1])
					bx, by = w/2, (6 + (i-1)*3) * scale

					if (self:cursorInBox(bx - tx/2, by - ty/2, tx, ty)) then
						color = Color(255, 0, 0)
						self.curSel = i
					end

					draw.SimpleText(L(v[1]), "nutBigFont", bx, by, ColorAlpha(color, 255), 1, 1)
				end
			end

			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, self.fadeAlpha * 255))
			draw.SimpleText("ATM", "nutBigFont", w/2, h/2, ColorAlpha(color_white, self.fadeAlpha * 150), 1, 1)
		end
	end

	local function onMouseClick(self, key)
		if (key) then
			if (self.curSel) then
				local dat = commands[self.curSel]
				if (dat and dat[2]) then
					Derma_StringRequest(
						L("enterAmount"),
						L("enterAmount"),
						0,
						function(a)
							LocalPlayer():ConCommand(Format("say %s %s", dat[2], a))
						end
					)
				end
			end
		end
	end

	function ENT:Initialize()
		self.screen = nut.screen.new(17, 17, .05)
		
		self.screen.fadeAlpha = 1
		self.screen.renderCode = renderCode
		self.screen.onMouseClick = onMouseClick
	end
	
	function ENT:Draw()
		self:DrawModel()
	end

	local pos, ang, renderAng
	function ENT:DrawTranslucent()
		self.screen:render()
	end

	function ENT:Think()
		pos = self:GetPos()
		ang = self:GetAngles()

		pos = pos + ang:Up() * 11.1
		pos = pos + ang:Right() * -1.4
		pos = pos + ang:Forward() * 13.2

		renderAng = Angle(ang[1], ang[2], ang[3])
		renderAng:RotateAroundAxis(ang:Forward(), 0)
		renderAng:RotateAroundAxis(ang:Up(), -2)

		self.screen.pos = pos
		self.screen.ang = renderAng
		self.screen:think()
	end
end