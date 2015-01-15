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
local gradient = nut.util.getMaterial("vgui/gradient-u")
function nut.bar.draw(x, y, w, h, value, color, barInfo)
	nut.util.drawBlurAt(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, 15)
	surface.DrawRect(x, y, w, h)
	surface.DrawOutlinedRect(x, y, w, h)

	local bw = w
	x, y, w, h = x + 2, y + 2, (w - 4) * math.min(value, 1), h - 4

	surface.SetDrawColor(color.r, color.g, color.b, 250)
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, 8)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(x, y, w, h)

	nut.util.drawText(L(barInfo.identifier), x + bw/2, y + h/2, ColorAlpha(color_white, color.a), 1, 1, nil, color.a)
end	