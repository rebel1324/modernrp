-- This hook adds up some new stuffs in F1 Menu.
function SCHEMA:BuildHelpMenu(tabs)
	tabs["schema"] = function(node)
		local body = ""

		for title, text in SortedPairs(self.helps) do
			body = body.."<h2>"..title.."</h2>"..text.."<br /><br />"
		end

		return body
	end
end

-- This hook loads the fonts
function SCHEMA:LoadFonts(font)
	font = "Consolas"
	surface.CreateFont("nutATMTitleFont", {
		font = font,
		size = 72,
		weight = 1000
	})

	surface.CreateFont("nutATMFont", {
		font = font,
		size = 36,
		weight = 1000
	})

	surface.CreateFont("nutATMFontBlur", {
		font = font,
		size = 36,
		blursize = 6,
		weight = 1000
	})
end

-- This hook replaces the bar's look.
BAR_HEIGHT = 15
local gradient = nut.util.getMaterial("vgui/gradient-d")
function nut.bar.draw(x, y, w, h, value, color, barInfo)
	nut.util.drawBlurAt(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, 15)
	surface.DrawRect(x, y, w, h)
	surface.DrawOutlinedRect(x, y, w, h)

	local bw = w
	x, y, w, h = x + 2, y + 2, (w - 4) * math.min(value, 1), h - 4

	surface.SetDrawColor(color.r, color.g, color.b, 250)
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(0, 0, 0, 150)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(x, y, w, h)

	nut.util.drawText(L(barInfo.identifier or "noname"), x + bw/2, y + h/2, ColorAlpha(color_white, color.a), 1, 1, nil, color.a)
end	

local glowMaterial = Material("sprites/glow04_noz")
local glowColor = {
	[0] = Color(55, 0, 255),
	[1] = Color(255, 44, 44),
}
function SCHEMA:PostDrawTranslucentRenderables()
	for k, v in ipairs(ents.GetAll()) do
		if (v:getNetVar("policeCar")) then
			local itemTable = nut.item.list[v:getNetVar("policeCar")]

			if (itemTable) then
				local vehicleData = itemTable.vehicleData
				local light = v:getNetVar("lightOn", false)

				if (vehicleData.lights and light) then
					local lightCycle = math.Round(CurTime()%1)
					local glowPerc = math.abs(math.sin((CurTime() + v:EntIndex())*30))

					-- We need to create sound for all clients :((
					if (!v.pixHandle) then
						v.pixHandle = util.GetPixelVisibleHandle()
					end

					if (!v.loopSound) then
						v.loopSound = CreateSound(v, "policesiren.wav")
					end

					if (!v.loopSound:IsPlaying()) then
						v.loopSound:Play()
					end

					render.SetMaterial(glowMaterial)
					for lightIdx, pos in ipairs(vehicleData.lights[lightCycle]) do
						local pos = LocalToWorld(pos, Angle(), v:GetPos(), v:GetAngles())

						if (lightIdx == 1) then
							if (!v.nextLight or v.nextLight < CurTime()) then
								local dlight = DynamicLight(v:EntIndex())
								dlight.Pos = pos
								dlight.r = glowColor[lightCycle].r
								dlight.g = glowColor[lightCycle].g
								dlight.b = glowColor[lightCycle].b
								dlight.Brightness = 1
								dlight.Size = 512 
								dlight.Decay = 1024
								dlight.DieTime = CurTime() + .05

								v.nextLight = CurTime() + .1
							end
						end

						local visibleFactor = util.PixelVisible(pos, 32, v.pixHandle)	
						render.DrawSprite(pos, 32, 32, ColorAlpha(glowColor[lightCycle], visibleFactor*glowPerc*255))
					end
				else
					if (v.loopSound and v.loopSound:IsPlaying()) then
						v.loopSound:Stop()
					end
				end
			end
		end
	end
end

function SCHEMA:EntityRemoved(vehicle)
	if (vehicle.loopSound and vehicle.loopSound:IsPlaying()) then
		vehicle.loopSound:Stop()
	end
end

function SCHEMA:PlayerBindPress(client, bind, pressed)
	if (client:InVehicle()) then
		bind = bind:lower()
		
		if (bind:find("walk") and pressed) then
			netstream.Start("carLightToggle")
		end
	end
end