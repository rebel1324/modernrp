PLUGIN.name = "Chat Bubble"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Fancy Chat Bubble for Nutscript."

if (SERVER) then
	-- push settings
else
	-- player.chats
	PLUGIN.maxLines = 4
	PLUGIN.lineWidth = 600
	PLUGIN.chatQueue = {}
	PLUGIN.bigChat = {
		["w"] = "nutChatFontSmall",
		["y"] = "nutChatFontBig",
	}

	function PLUGIN:LoadFonts(font)
		surface.CreateFont("nutChatFontBig", {
			font = font,
			size = 26,
			weight = 500
		})

		surface.CreateFont("nutChatFontSmall", {
			font = font,
			size = 15,
			weight = 500
		})
	end

	function PLUGIN:OnChatReceived(client, chatType, text, anonymous)
		if (anonymous or chatType == "looc" or chatType == "ooc" or chatType == "radio") then
			return 
		end

		if (!client:GetNoDraw()) then
			local font = (self.bigChat[chatType] or "nutChatFont")
			local color = nut.config.get("chatColor")
			local t = Format("<font=%s><color=%s>%s</color></font>", font, Format("%s, %s, %s", color.r, color.g, color.b), text)

			local object = nut.markup.parse(t, self.lineWidth)

			self.chatQueue[client] = self.chatQueue[client] or {}
			table.insert(self.chatQueue[client], {object, RealTime() + 5, 0, 0})
		end
	end
	
	local function fpsFrameTime()
		local frameTime = FrameTime()

		return math.Clamp(frameTime, frameTime/30, 1)
	end

	local math_round = math.Round
	function PLUGIN:HUDPaint()
		local client = LocalPlayer()
		local frameTime = fpsFrameTime()

		for k, v in ipairs(player.GetAll()) do
			if (client:GetNoDraw() == true or client == v and !client:ShouldDrawLocalPlayer()) then
				continue
			end

			local queue = self.chatQueue[v]
			if (queue) then
				if (true) then return end
				local bone = v:LookupBone("ValveBiped.Bip01_Head1")
				local pos = (bone != 0 and v:GetBonePosition(bone) + Vector(0, 0, 10)) or (v:GetPos() + Vector(0, 0, 70))
				local scr = pos:ToScreen()
				local tx, ty = 0, 0
				local queueCount = table.Count(queue)

				for k, v in ipairs(table.Reverse(queue)) do
					local object = v[1]

					-- Move Text to Destination.
					v[3] = Lerp(frameTime * 5, v[3], ty)

					-- Fade the Text.
					if (k >= self.maxLines or v[2] < RealTime()) then
						v[4] = Lerp(frameTime * 5, v[4], 0)

						if (v[4] < 1) then
							table.remove(queue, k - queueCount)
						end
					else
						if (v[4] <= 255) then
							v[4] = Lerp(frameTime * 5, v[4], 255)
						end
					end

					ty = ty + object:getHeight()
					--object:draw(scr.x, scr.y - math_round(v[3]), 1, TEXT_ALIGN_TOP, math_round(v[4]))
				end
			end
		end
	end
end