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
		{"deposit", "/bankdeposit", 0},
		{"withdraw", "/bankwithdraw", 0},
		{"transfer", "/bankdeposit", 0},
	}

	local function renderCode(self, ent, w, h)
		local char = LocalPlayer():getChar()

		if (char) then
			local mx, my = self:mousePos()
			local scale = 1 / self.scale
			local bx, by, color, idxAlpha

			if (self.fadeAlpha < 1) then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
				surface.SetDrawColor(33, 33, 33, 255)
				surface.SetMaterial(gradient)
				surface.DrawTexturedRect(0, 0, w, h)

				local tx, ty = draw.SimpleText("8", "nutIconsBig", 2 * scale, 2 * scale, ColorAlpha(color_white, 255), 1, 1)
				tx, ty = draw.SimpleText(char:getReserve(), "nutATMFont", tx + 2 * scale, 2 * scale, ColorAlpha(color_white, 255), 3, 1)

				self.curSel = -1
				surface.SetFont("nutATMFont")

				for i, v in ipairs(commands) do
					idxAlpha = self.idxAlpha[i]
					color = color_white
					tx, ty = surface.GetTextSize(v[1])
					bx, by = w/2, (6 + (i-1)*3) * scale

					if (self:cursorInBox(bx - tx/2, by - ty/2, tx, ty)) then
						color = Color(255 - (50 * idxAlpha), (1 - idxAlpha) * 255, (1 - idxAlpha) * 255)

						self.curSel = i
					end

					draw.SimpleText(L(v[1]), "nutATMFontBlur", bx, by, ColorAlpha(color, idxAlpha * 255), 1, 1)
					draw.SimpleText(L(v[1]), "nutATMFont", bx, by, ColorAlpha(color, 255), 1, 1)
				end
			end

			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, self.fadeAlpha * 255))
			draw.SimpleText("ATM", "nutATMTitleFont", w/2, h/2, ColorAlpha(color_white, self.fadeAlpha * 150), 1, 1)
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
		self.screen.idxAlpha = {}
		self.screen.renderCode = renderCode
		self.screen.onMouseClick = onMouseClick
	end
	
	function ENT:Draw()
		self:DrawModel()
	end

	local pos, ang, renderAng
	local mc = math.Clamp
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

		if (self.screen.hasFocus) then
			self.screen.fadeAlpha = mc(self.screen.fadeAlpha - FrameTime()*4, 0, 1)
		else
			self.screen.fadeAlpha = mc(self.screen.fadeAlpha + FrameTime()*2, 0, 1)
		end

		for k, v in ipairs(commands) do
			self.screen.idxAlpha[k] = self.screen.idxAlpha[k] or 0

			if (self.screen.curSel == k) then
				self.screen.idxAlpha[k] = mc(self.screen.idxAlpha[k] + FrameTime()*10, 0, 1)
			else
				self.screen.idxAlpha[k] = mc(self.screen.idxAlpha[k] - FrameTime()*5, 0, 1)
			end
		end
	end
end