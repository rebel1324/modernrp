local PLUGIN = PLUGIN
PLUGIN.name = "Bad Air"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Fuck the air mate."

DEFAULT_GASMASK_HEALTH = 100
DEFAULT_GASMASK_FILTER = 600


if (CLIENT) then
	local gasmaskTexture2 = Material("gasmask_fnl")
	local gasmaskTexture = Material("shtr_01")
	local w, h, gw, gh, margin, move, healthFactor, ft
	local nextBreath = CurTime()
	local exhale = false

	local function canEffect(client)
		return (client:getChar() and client:getChar():getVar("gasMask") == true and !client:ShouldDrawLocalPlayer() and (!nut.gui.char or !nut.gui.char:IsVisible()))
	end

	shtrPos = {}

	concommand.Add("refractgo", function()
		for i = 1, 10 do
			shtrPos[i] = {math.random(0, ScrW()), math.random(0, ScrH()), math.Rand(.9, 2), math.random(0, 360)}
		end
	end)

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

	local function addCrack()
		table.insert(shtrPos, {math.random(0, ScrW()), math.random(0, ScrH()), math.Rand(.9, 2), math.random(0, 360)})
	end

	local function initCracks(crackNums)
		for i = 1, math.max(crackNums, 1) do
			addCrack()
		end
	end

	netstream.Hook("mskInit", function(maskHealth)
		local crackNums = math.Round((1 - maskHealth/DEFAULT_GASMASK_HEALTH)*6)
		shtrPos = {}
		if (crackNums > 1) then
			initCracks(crackNums)
		end
	end)

	netstream.Hook("mskAdd", function()
		LocalPlayer():EmitSound("player/bhit_helmet-1.wav")
		addCrack()
	end)
else
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
end

function PLUGIN:CanPlayerTearGassed(client)
	local char = client:getChar()
	return (!char:getVar("gasMask") or char:getVar("gasMaskHealth") <= 0)
end

function PLUGIN:EntityEmitSound(sndTable)
	local ent = sndTable.Entity
	if (ent and ent:IsValid() and ent:IsPlayer() and ent:getChar() and ent:getChar():getVar("gasMask")) then
		local sndName = sndTable.SoundName:lower()
		
		if (sndName:find("male")) then
			sndTable.DSP = 15
		end
	
		return true
	end
end