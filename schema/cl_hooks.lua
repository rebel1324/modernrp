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

function SCHEMA:Think()
end

local flesh = {
	[MAT_FLESH] = 1,
	[MAT_ALIENFLESH] = 0,
	[MAT_BLOODYFLESH] = 1,
	[70] = 1,
}
function SCHEMA:EntityFireBullets(ent, bulletTable)
	local oldCallback = bulletTable.Callback

	bulletTable.Callback = function(client, trace, dmgInfo)
		if (oldCallback) then
			oldCallback(client, trace, dmgInfo)
		end
		
		if (trace) then
			if (flesh[trace.MatType]) then
				local e = EffectData()
				e:SetScale(math.Rand(1.3, 1.65))
				e:SetOrigin(trace.HitPos + VectorRand() * 1)
				util.Effect("btBlood", e)
			else
				local e = EffectData()
				e:SetOrigin(trace.HitPos)
				e:SetNormal(trace.HitNormal)
				e:SetScale(math.Rand(.4, .5))
				util.Effect( "btImpact", e )
			end
		end
	end

	return true
end