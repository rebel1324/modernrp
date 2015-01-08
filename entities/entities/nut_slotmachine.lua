AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Slot Machine"
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
		self:SetModel("models/props_lab/eyescanner.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionBounds(Vector(-10, -10, -10), Vector(10, 10, 10))
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

	-- If RECEIVE the slotsignal, oh YEAH!
else
	-- Some Local Variables for 3D2D and Think.
	local gradient = nut.util.getMaterial("vgui/gradient-u")

	-- This fuction is 3D2D Rendering Code.
	local function renderCode(self, ent, w, h)
		local char = LocalPlayer():getChar()

		if (char) then
			local bx, by, color, idxAlpha
			color = color_white

			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
			surface.SetDrawColor(33, 33, 33, 255)
			surface.SetMaterial(gradient)
			surface.DrawTexturedRect(0, 0, w, h)
 
			local bx, by = w/2, h - 30
			surface.SetFont("nutATMFont")
			local tx, ty = surface.GetTextSize("Start")

			if (self:cursorInBox(bx - tx/2, by - ty/2, tx, ty)) then
				color = Color(255 - (50 * 1), (1 - 1) * 255, (1 - 1) * 255)
			end

			draw.SimpleText("Start", "nutATMFontBlur", bx, by, ColorAlpha(color, 1 * 255), 1, 1)
			draw.SimpleText("Start", "nutATMFont", bx, by, ColorAlpha(color, 255), 1, 1)

			-- GAME SCREEN

			draw.RoundedBox(0, 0, 0, w, h - 55, Color(0, 0, 0, 255))

			local size = 128
			local shifts = {}
			local maxSize = 9 * size/5 + 9 * size
			for line = 0, 10 do
				local dax, day = -maxSize + RealTime()*250%maxSize + line * size/5 + line * size, (h - 55)/2 - size/2
				draw.RoundedBox(0, dax, day, size, size, Color(255, 0, 0, 255))

				dax = dax + size/2
				day = day + size/2
				draw.SimpleText(line, "nutATMFont", dax, day, Color(0, 255, 0), 1, 1)
			end
		end
	end

	-- This function called when client clicked(Pressed USE, Primary/Secondary Attack).
	local function onMouseClick(self, key)
		if (key) then
		end
	end

	function ENT:Initialize()
		-- Creates new Touchable Screen Object for this Entity.
		self.screen = nut.screen.new(12.5, 15, .05)
		
		-- Initialize some variables for this Touchable Screen Object.
		self.screen.fadeAlpha = 1
		self.screen.idxAlpha = {}

		-- Make the local "renderCode" function as the Touchable Screen Object's 3D2D Screen Rendering function.
		self.screen.renderCode = renderCode

		-- Make the local "onMouseClick" function as the Touchable Screen Object's Input event.
		self.screen.onMouseClick = onMouseClick
	end
	
	function ENT:Draw()
		-- Draw Model.
		self:SetModelScale(1.5, 0)
		self:DrawModel()
	end

	local pos, ang, renderAng
	local mc = math.Clamp
	function ENT:DrawTranslucent()
		-- Render 3D2D Screen.
		self.screen:render()
	end

	function ENT:Think()
		pos = self:GetPos()
		ang = self:GetAngles()

		-- Shift the Rendering Position.
		pos = pos + ang:Up() * 19.1
		pos = pos + ang:Right() * 0
		pos = pos + ang:Forward() * 5.6

		-- Rotate the Rendering Angle.
		renderAng = Angle(ang[1], ang[2], ang[3])
		renderAng:RotateAroundAxis(ang:Right(), 16)
		renderAng:RotateAroundAxis(ang:Up(), 0)

		-- Update the Rendering Position and angle of the Touchable Screen Object.
		self.screen.pos = pos
		self.screen.ang = renderAng

		-- Default Think must be in this place to make Touchable Screen's Input works.
		self.screen:think()
	end
end