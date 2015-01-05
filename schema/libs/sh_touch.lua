-- Metasctruct Lua Screen
-- Metatable Conversion by Black Tea za rebel1324.

nut.screen = nut.screen or {}
nut.screen.list = nut.screen.list or {}

function nut.screen.new(w, h, scale)
	local screen = setmetatable(
		{
			w = w or 100,
			h = h or 100,
			scale = scale or 1,
		}, 
		FindMetaTable("TouchScreen"))
	screen.renderCode = function(scr, ent, wide, tall)
		print("DEFAULT")
	end
	return screen
end

local _R = debug.getregistry()

local SCREEN = _R.TouchScreen or {}
SCREEN.__index = SCREEN
SCREEN.w = 100
SCREEN.h = 100
SCREEN.pos = Vector(0, 0, 0)
SCREEN.ang = Angle(0, 0, 0)
SCREEN.scale = 1
SCREEN.filter = true
SCREEN.screenName = "Default"

function SCREEN:__tostring()
	return "[SCREEN OBJECT]"
end

local vec=Vector(0,0,0)
local function rayQuadIntersect(vOrigin, vDirection, vPlane, vX, vY)
        local vp = vDirection:Cross(vY)

        local d = vX:DotProduct(vp)

        if (d <= 0.0) then return end

        local vt = vOrigin - vPlane
        local u = vt:DotProduct(vp)
        if (u < 0.0 or u > d) then return end

        local v = vDirection:DotProduct(vt:Cross(vX))
        if (v < 0.0 or v > d) then return end

        return u / d,v / d
end
SCREEN.rayQuadIntersect = rayQuadIntersect

function SCREEN:isBehind(client)
	if ((client:EyePos() - self.pos):DotProduct(self.ang:Forward()) < 0) then
		return true
	end
end

function SCREEN:isAccessible(client)
	local w, h, pos, ang = self.w, self.h, self.pos, self.ang
	client = client or LocalPlayer()
	
	if (pos:Distance(client:EyePos()) > (w/2 + 64)) then
		return
	end

	if ((client:EyePos() - pos):DotProduct(ang:Forward()) < 0) then
		return
	end

	local plane = pos
	+ ang:Up() * h/2
	+ ang:Right() * (-w/2)

	local x = ang:Right() * w
	local y = ang:Up() * -h

	return rayQuadIntersect(client:GetShootPos(), client:GetAimVector(), plane, x, y)
end

if (CLIENT) then
	SCREEN.mx = -1
	SCREEN.my = -1

	function SCREEN:render()
		local pos, ang = self.pos, self.ang
		local scrDir = EyePos() - pos
		scrDir:Normalize()

		if (scrDir:DotProduct(ang:Forward()) < 0) then
			return
		end

		pos = pos + ang:Right() * (self.w / 2)
		pos = pos + ang:Up() * (self.h / 2)
		
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		local wide = self.w * (1 / self.scale)
		local tall = self.h * (1 / self.scale)

		cam.Start3D2D(pos, ang, self.scale)		
			local succ, err = pcall(self.renderCode, self, ent, wide, tall)	
		cam.End3D2D()
		
		if !succ then
			print(err)
			return err
		end
	end

	function SCREEN:getWide()
		return self.w * (1 / self.scale)
	end

	function SCREEN:getTall()
		return self.h * (1 / self.scale)
	end

	function SCREEN:mousePos()
		if (!self.mx) then 
			return false 
		end

		return (1 - self.mx) * self:getWide(), self.my * self:getTall() 
	end

	function SCREEN:cursorInBox(x, y, w, h)
		local mx, my = self:mousePos()

		if	(mx >= x and mx <= x + w
			and my >= y and my <= y + h) then

			return true
		end
	end

	-- No one should replace this until you know what the hell you're doing. 
	function SCREEN:think()
		local client = LocalPlayer()
		local mx, my = self:isAccessible()

		if mx then
			self.mx, self.my = mx, my
			self.hasFocus = true
			
			local key = client:KeyDown(bit.bor(IN_USE, IN_ATTACK, IN_ATTACK2))

			if (key and !self.IN_USE) then
				self.IN_USE = true

				if (self.onMouseClick) then
					self:onMouseClick(IN_USE)
				end
			elseif (!key and self.IN_USE) then
				self.IN_USE = false

				if (self.onMouseRelease) then
					self:onMouseRelease(IN_USE)
				end
			end
		else
			self.hasFocus = nil

			if (self.IN_USE) then
				self.IN_USE = false

				if (self.onMouseRelease) then
					self:onMouseRelease(IN_USE)
				end
			end
		end
	end

	function SCREEN:enableClipping(state)
		if (state) then
			local pos = self.pos
			local up = self.ang:Up()
			local right = self.ang:Right()
			local Height = up * self.h*0.5
			local Width = right * self.w*0.5

			if render.EnableClipping( true ) then
				self.__bClipping = true
			else
				self.__bClipping = false
			end
			
			render.PushCustomClipPlane(up, up:Dot( pos - h ))
			render.PushCustomClipPlane(-up, (-up):Dot( pos + h ))
			render.PushCustomClipPlane(right, right:Dot( pos - w ))
			render.PushCustomClipPlane(-right, (-right):Dot( pos + w ))
		else
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			render.EnableClipping( self.__bClipping )
		end
	end
end

_R.TouchScreen = SCREEN