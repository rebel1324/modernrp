-- EXAMPLE MAP ADDRESS
-- http://www.mediafire.com/download/4cy5j22lhdl771a/RP_Downtown_V2.bsp

WEAPONFACTORY_POS = Vector(1632.010376, -1534.968750, -128.953522)
WEAPONFACTORY_ANG = Angle(0, 90, 0)
JAILMANAGER_POS = Vector(-1704.031250, 280.280975, -130.669281)
JAILMANAGER_ANG = Angle(-0.000, 180.000, 0.000)
JAILBUZZER_POS = Vector(-2053.437988, 321.362732, -70.718750)

if (SERVER) then
	
	hook.Add("InitPostEntity", "aaoa", function()
		local wpnBtns = ents.FindByName("gunshop_gunmaker_buttons")

		for k, v in ipairs(wpnBtns) do
			v:Remove()
		end

		wpnBtns = ents.FindByName("lockedelevatorbutton")

		for k, v in ipairs(wpnBtns) do
			v:Fire("Unlock")

			v:SetKeyValue("OnPressed", "shlift,StartForward,,4,-1")
			v:SetKeyValue("OnPressed", "door_elevator_topsliding,Close,,3,-1")
			v:SetKeyValue("OnPressed", "shliftgate,SetAnimation,close,3,-1")
			v:SetKeyValue("OnPressed", "door_elevator_bottomsliding,Close,,3,-1")
			v:SetKeyValue("OnPressed", "shliftsound,PlaySound,,0,-1")
		end
	end)

	netstream.Hook("feedbackScreen", function(client)
		local dist = WEAPONFACTORY_POS:Distance(client:GetPos())

		if (dist < 128) then
			sound.Play("buttons/button3.wav", WEAPONFACTORY_POS + WEAPONFACTORY_ANG:Forward() * 10)

			local wpnSteam = ents.FindByName("gunshop_weaponmaker_steameffect")
			local wpnSteamSound = ents.FindByName("gunshop_weaponmakersound")
			local wpnSpawn = ents.FindByName("gunshop_itempistolammo_temp")

			for k, v in ipairs(wpnSteam) do
				v:Fire("TurnOn", "", "0")
				v:Fire("TurnOff", "", "3")
			end
			for k, v in ipairs(wpnSteamSound) do
				v:Fire("PlaySound", "", "0")
				v:Fire("StopSound", "", "3")
			end
			for k, v in ipairs(wpnSpawn) do
				v:Fire("ForceSpawn", "", "3")
			end
		end
	end)

	netstream.Hook("feedbackScreen2", function(client, num)
		local dist = JAILMANAGER_POS:Distance(client:GetPos())

		if (dist < 128) then
			sound.Play("buttons/button3.wav", JAILMANAGER_POS + JAILMANAGER_ANG:Forward() * 10)
			sound.Play("ambient/alarms/klaxon1.wav", JAILBUZZER_POS)

			local entities = ents.FindByName("policedpt_jailcelldoor_" .. (num + 1))

			for k, v in ipairs(entities) do
				if (v.toggled) then
					v:Fire("close", "", "1")
					v:Fire("lock", "", "1")
					v.toggled = false
				else
					v:Fire("unlock", "", "1")
					v:Fire("open", "", "1")
					v:Fire("lock", "", "1")
					v.toggled = true
				end
			end
		end
	end)
else
	do
		SCREEN_1 = SCREEN_1 or LuaScreen()
		SCREEN_1.pos = WEAPONFACTORY_POS
		SCREEN_1.noClipping = false
		SCREEN_1.w = 20
		SCREEN_1.h = 38
		SCREEN_1.scale = .08

		local scrollAmount
		local scrollPos = 0
		local scrollTargetPos
		local gradient = nut.util.getMaterial("vgui/gradient-d")
		local gradient2 = nut.util.getMaterial("vgui/gradient-u")
		SCREEN_1.renderCode = function(scr, ent, wide, tall)
			SCREEN_1.ang = Angle(WEAPONFACTORY_ANG[1], WEAPONFACTORY_ANG[2], WEAPONFACTORY_ANG[3])
			draw.RoundedBox(0, 0, 0, wide, tall, Color(50, 50, 50))

			local wm = wide/10
			local bw, bh = wide - wm*2, 100
			local bool = (scr:cursorInBox(wm, tall/2 - bh/2, bw, bh) and !scr.IN_USE)
			scr.canActivate = bool
			local alMul = (bool and 1.3 or 1)

			surface.SetDrawColor(46 * alMul, 204 * alMul, 113 * alMul)
			surface.DrawRect(wm, tall/2 - bh/2, bw, bh)
			surface.SetDrawColor(0, 0, 0, 150 * alMul)
			surface.SetMaterial((scr.IN_USE and scr:cursorInBox(wm, tall/2 - bh/2, bw, bh)) and gradient2 or gradient)
			surface.DrawTexturedRect(wm, tall/2 - bh/2, bw, bh)
			surface.SetDrawColor(39 * alMul, 174 * alMul, 96 * alMul)
			surface.DrawOutlinedRect(wm + 1, tall/2 - bh/2 + 1, bw - 2, bh - 2)

			nut.util.drawText("ACTIVATE", wide/2, tall/2, color_white, 1, 1, "nutATMFont")
		end
		SCREEN_1.onMouseClick = function(scr, key)
			if (key and scr.canActivate) then
				netstream.Start("feedbackScreen")
			end
		end
	end

	do
		SCREEN_2 = SCREEN_2 or LuaScreen()
		SCREEN_2.pos = JAILMANAGER_POS
		SCREEN_2.noClipping = false
		SCREEN_2.w = 20
		SCREEN_2.h = 38
		SCREEN_2.scale = .08

		local scrollAmount
		local scrollPos = 0
		local scrollTargetPos

		local function paintButton(x, y, w, h, text)
			surface.SetDrawColor(30, 30, 30, alpha)
			surface.DrawRect(x, y, w, h)

			surface.SetDrawColor(0, 0, 0, 180)
			surface.DrawOutlinedRect(x, y, w, h)

			surface.SetDrawColor(180, 180, 180, 2)
			surface.DrawOutlinedRect(x + 1,y + 1, w - 2, h - 2)

			nut.util.drawText(text, x + w/2, y + h/2, color_white, 1, 1, "nutATMFont")
		end

		SCREEN_2.renderCode = function(scr, ent, wide, tall)
			SCREEN_2.ang = Angle(JAILMANAGER_ANG[1], JAILMANAGER_ANG[2], JAILMANAGER_ANG[3])

			local btnTall = tall*.1
			local btnMargin = 10
			local drawPos = (tall/2) - (btnTall*3 - btnMargin*3)
			scr.curSelection = nil

			for i = 0, 3 do
				local bool = scr:cursorInBox(0, drawPos + btnTall*i + btnMargin*i, wide, btnTall)
				paintButton(0, drawPos + btnTall*i + btnMargin*i, wide, btnTall, "JAIL DOOR #" .. (i + 1), bool)

				if (bool) then
					scr.curSelection = i
				end
			end
			/*
			local wm = wide/10
			local bw, bh = wide - wm*2, 100
			local bool = (scr:cursorInBox(wm, tall/2 - bh/2, bw, bh) and !scr.IN_USE)
			scr.canActivate = bool
			local alMul = (bool and 1.3 or 1)

			surface.SetDrawColor(46 * alMul, 204 * alMul, 113 * alMul)
			surface.DrawRect(wm, tall/2 - bh/2, bw, bh)
			surface.SetDrawColor(0, 0, 0, 150 * alMul)
			surface.SetMaterial((scr.IN_USE and scr:cursorInBox(wm, tall/2 - bh/2, bw, bh)) and gradient2 or gradient)
			surface.DrawTexturedRect(wm, tall/2 - bh/2, bw, bh)
			surface.SetDrawColor(39 * alMul, 174 * alMul, 96 * alMul)
			surface.DrawOutlinedRect(wm + 1, tall/2 - bh/2 + 1, bw - 2, bh - 2)

			nut.util.drawText("ACTIVATE", wide/2, tall/2, color_white, 1, 1, "nutATMFont")
			*/
		end
		SCREEN_2.onMouseClick = function(scr, key)
			if (key and scr.curSelection) then
				netstream.Start("feedbackScreen2", scr.curSelection)
			end
		end
	end

	hook.Add("Think", "aaoa", function()
		if (LocalPlayer():getChar()) then
			SCREEN_1:think()
			SCREEN_2:think()
		end
	end)
	
	hook.Add("PostDrawTranslucentRenderables", "aaoa", function()
		if (LocalPlayer():getChar()) then
 			local dist = EyePos():Distance(SCREEN_1.pos)

			if (dist < 512) then
				SCREEN_1:render()
			end

 			dist = EyePos():Distance(SCREEN_2.pos)
			if (dist < 512) then
				SCREEN_2:render()
			end
		end
	end)
end