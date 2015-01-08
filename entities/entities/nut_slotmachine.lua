AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Slot Machine"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Category = "NutScript"
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.slotMax = 10

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

	netstream.Hook("requestSlotM", function(client, entity)
		if (client and entity) then
			netstream.Start(player.GetAll(), "sendSlotM", client, entity, math.random(0, entity.slotMax))
		end
	end)
else
	netstream.Hook("sendSlotM", function(client, entity, number)
		if (client and entity and number) then
			entity.slotSlide = 0
			entity.slot = number
		end
	end)

	-- Some Local Variables for 3D2D and Think.
	local gradient = nut.util.getMaterial("vgui/gradient-u")

	-- This fuction is 3D2D Rendering Code.
	local size = 128
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

			local shifts = {}
			local maxSize = self.entity.slotMax * size/5 + self.entity.slotMax * size
			local FT = FrameTime()

			local targetSpin = 
				-- The position of the slot
				((self.entity.slot + 1) * size/5 + (self.entity.slot + 1) * size  + size/2) 
				-- Amount of spins
				+ maxSize * self.entity.spins

			local spinLeft = self.entity.spins - math.ceil(self.entity.slotSlide/maxSize)

			if (spinLeft < 0) then
				self.entity.slotSlide = math.ceil(Lerp(FT*2, self.entity.slotSlide, targetSpin))
			else
				self.entity.slotSlide = self.entity.slotSlide + FT*2000
			end

			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("effects/laser1"))
			surface.DrawTexturedRect(w/2 - 25, 0, 50, h - 50)

			for line = 0, self.entity.slotMax + 1 do
				local dax, day = -maxSize + self.entity.slotSlide%maxSize + line * size/5 + line * size, (h - 55)/2 - size/2
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
			netstream.Start("requestSlotM", self.entity)
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

		self.screen.entity = self
		self.slot = 4
		self.spins = 4
		self.slotSlide = 0
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