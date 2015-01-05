function SCHEMA:BuildHelpMenu(tabs)
	tabs["schema"] = function(node)
		local body = ""

		for title, text in SortedPairs(self.helps) do
			body = body.."<h2>"..title.."</h2>"..text.."<br /><br />"
		end

		return body
	end
end

function SCHEMA:LoadFonts(font)
	-- The more readable font.
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