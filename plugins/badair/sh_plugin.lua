local PLUGIN = PLUGIN
PLUGIN.name = "Bad Air"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Fuck the air mate."
PLUGIN.toxicAreas = PLUGIN.toxicAreas or {}

DEFAULT_GASMASK_HEALTH = 100
DEFAULT_GASMASK_FILTER = 600

if (CLIENT) then
	local gasmaskTexture2 = Material("gasmask_fnl")
	local gasmaskTexture = Material("shtr_01")
	local w, h, gw, gh, margin, move, healthFactor, ft
	local nextBreath = CurTime()
	local exhale = false

	-- Local function for condition.
	local function canEffect(client)
		return (client:getChar() and client:getChar():getVar("gasMask") == true and !client:ShouldDrawLocalPlayer() and (!nut.gui.char or !nut.gui.char:IsVisible()))
	end

	shtrPos = {}

	-- Draw the Gas Mask Overlay. But other essiential stuffs must be visible.
	function PLUGIN:HUDPaintBackground()
		if (canEffect(LocalPlayer())) then
			w, h = ScrW(), ScrH()
			gw, gh = h/3*4, h

			
			surface.SetMaterial(gasmaskTexture)
			for k, v in ipairs(shtrPos) do
				surface.SetDrawColor(255, 255, 255)
				surface.DrawTexturedRectRotated(v[1], v[2], 512*v[3], 512*v[3], v[4])
			end

			render.UpdateScreenEffectTexture()
			surface.SetMaterial(gasmaskTexture2)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(w/2 - gw/2, h/2 - gh/2, gw, gh)

			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(0, 0, w/2 - gw/2, h)
			surface.DrawRect(0, 0, w, h/2 - gh/2)
			surface.DrawRect(0, h/2 + gh/2, w, h/2 - gh/2)
			surface.DrawRect(w/2 + gw/2, 0, w/2 - gw/2, h)
		end
	end

	-- Gas Mask Think.
	function PLUGIN:Think()
		for k, client in ipairs(player.GetAll()) do
			if (client:getChar() and client:Alive() and client:getChar():getVar("gasMask") == true) then
				healthFactor = math.Clamp(client:Health()/client:GetMaxHealth(), 0, 1)

				if (!client.nextBreath or client.nextBreath < CurTime()) then
					client:EmitSound(!exhale and "gmsk_in.wav" or "gmsk_out.wav", 
					(LocalPlayer() == client and client:ShouldDrawLocalPlayer() or client:getChar():getVar("gasMaskHealth") <= 0) and 20 or 50, math.random(90, 100) + 15*(1 - healthFactor))
					client.nextBreath = CurTime() + 1 + healthFactor*.5 + (exhale == true and .5*healthFactor or 0)
					exhale = !exhale
				end
			end
		end
	end

	-- Local functions for the Visibility of the crack.
	local function addCrack()
		table.insert(shtrPos, {math.random(0, ScrW()), math.random(0, ScrH()), math.Rand(.9, 2), math.random(0, 360)})
	end

	local function initCracks(crackNums)
		for i = 1, math.max(crackNums, 1) do
			addCrack()
		end
	end

	netstream.Hook("mskInit", function(maskHealth)
		if (maskHealth) then
			local crackNums = math.Round((1 - maskHealth/DEFAULT_GASMASK_HEALTH)*6)
			shtrPos = {}
			if (crackNums > 1) then
				initCracks(crackNums)
			end
		end
	end)

	netstream.Hook("mskAdd", function()
		LocalPlayer():EmitSound("player/bhit_helmet-1.wav")
		addCrack()
	end)
else
	-- gets two vector and gives min and max vector for Vector:WithinAA(min, max)
	local function sortVector(vector1, vector2)
		local minVector = Vector(0, 0, 0)
		local maxVector = Vector(0, 0, 0)

		for i = 1, 3 do
			if (vector1[i] >= vector2[i]) then
				maxVector[i] = vector1[i]
				minVector[i] = vector2[i]
			else
				maxVector[i] = vector2[i]
				minVector[i] = vector1[i]
			end
		end

		return minVector, maxVector
	end

	nut.badair = nut.badair or {}

	-- get all bad air area.
	function nut.badair.getAll()
		return PLUGIN.toxicAreas
	end

	-- Add toxic bad air area.
	function nut.badair.addArea(vMin, vMax)
		print(vMin, vMax)
		vMin, vMax = sortVector(vMin, vMax)

		if (vMin and vMax) then
			table.insert(PLUGIN.toxicAreas, {vMin, vMax})
		end
	end

	-- This hook simulates the damage of the Gas Mask.
	function PLUGIN:EntityTakeDamage(client, dmgInfo)
		if (client and client:IsPlayer()) then
			local char = client:getChar()

			if (char and char:getVar("gasMask")) then
				local maskHealth = char:getVar("gasMaskHealth", DEFAULT_GASMASK_HEALTH)
				maskHealth = maskHealth - dmgInfo:GetDamage() * .5
				char:setVar("gasMaskHealth", math.max(maskHealth, 0))

				local crackNums = math.Round((1 - char:getVar("gasMaskHealth")/DEFAULT_GASMASK_HEALTH)*6)

				if (self.curCracks and self.curCracks < crackNums) then
					netstream.Start(client, "mskAdd")
				end

				self.curCracks = crackNums
			end
		end
	end

	function PLUGIN:SaveData()
		self:setData(nut.badair.getAll())
	end
	
	function PLUGIN:LoadData()
		PLUGIN.toxicAreas = self:getData()
	end

	-- This timer does the effect of bad air.
	timer.Create("badairTick", 1, 0, function()
		for _, client in ipairs(player.GetAll()) do
			local char = client:getChar()
			local clientPos = client:GetPos() + client:OBBCenter()
			client.currentArea = nil

			for index, vec in ipairs((nut.badair.getAll() or {})) do
				if (clientPos:WithinAABox(vec[1], vec[2])) then
					if (client:IsAdmin()) then
						client.currentArea = index
					end

					if (client:Alive() and char) then
						local gasFilter = char:getVar("gasMaskFilter")
						local gasHealth = char:getVar("gasMaskHealth")
						local bool = (gasFilter and gasHealth) and (gasFilter > 0 and gasHealth > 0)

						if (bool) then
							char:setVar("gasMaskFilter", math.min(gasFilter - 1, 0))
						else
							client:TakeDamage(3)
							client:ScreenFade(1, ColorAlpha(color_white, 100), .5, 0)
						end		

						break
					end
				end
			end
		end
	end)

	netstream.Start("addArea", function(client, v1, v2)
		if (!client:IsAdmin()) then
			client:notify("no permission")	
		end

		client:notify("added new toxic area")
		nut.badair.addArea(v1, v2)
	end)
end

-- This hook is for my other plugin, "Grenade" Plugin.
function PLUGIN:CanPlayerTearGassed(client)
	local char = client:getChar()

	return (!char:getVar("gasMask") or char:getVar("gasMaskHealth") <= 0)
end

-- If the player is wearing Gas Mask, His some voice should be muffled a bit.
function PLUGIN:EntityEmitSound(sndTable)
	local ent = sndTable.Entity

	if (ent and IsValid(ent) and ent:IsPlayer() and ent:getChar() and ent:getChar():getVar("gasMask")) then
		local sndName = sndTable.SoundName:lower()
		
		if (sndName:find("male")) then
			sndTable.DSP = 15
		end
	
		return true
	end
end

nut.command.add("badairadd", {
	syntax = "",
	onRun = function(client, arguments)
		local pos = client:GetEyeTraceNoCursor().HitPos

		if (!client:getNetVar("badairMin")) then
			netstream.Start(client, "displayPosition", pos)

			client:setNetVar("badairMin", pos, client)
			client:notify(L("badairCommand", client))
		else
			local vMin = client:getNetVar("badairMin")
			local vMax = pos

			netstream.Start(client, "displayPosition", pos)
			nut.badair.addArea(vMin, vMax)

			client:setNetVar("badairMin", nil, client)
			client:notify(L("badairAdded", client))
		end
	end
})

nut.command.add("badairremove", {
	syntax = "",
	onRun = function(client, arguments)
		if (client.currentArea) then
			client:notify(L("badairRemove", client))

			table.remove(PLUGIN.toxicAreas, client.currentArea)	
		end
	end
})
