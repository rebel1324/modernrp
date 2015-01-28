do
	if (SERVER) then
		netstream.Hook("feedbackScreen", function()

		end)
	else
		local scrSize = 5
		SCREEN_1 = SCREEN_1 or LuaScreen()
		SCREEN_1.pos = Vector(623.968750, -176.183197, 335.747162)
		SCREEN_1.noClipping = false
		SCREEN_1.w = 16*scrSize
		SCREEN_1.h = 9*scrSize
		SCREEN_1.scale = .17

		MRKPOBJ = nut.markup.parse(
[[
<font=nutBigFont><color=200, 200, 80>THIS SCREEN IS EXAMPLE WORLD SCREEN</font>
<font=nutMediumFont>This screen example created by the Black Tea za rebel1324</color>

This screen has plenty of <color=255, 80, 80>pointless</color> text that is written by Black Tea.
This means, you can use this example to some map and make that map pretty unique. 
You can use this as some kind of Jail Door Manager or CCTV Manager or Current Arrest list.
As you code with this screen library, more awesome to your schema!

Well, I don't push you to develop stuffs.
But, You can make your stuffs more better.
Oh, Don't even ask why I'm using nut.markup.parse. Nutscript's markup language supports Good Unicode Sizing.
Default GMOD markup has huge issue: <color=255, 80, 80>Not able to measure unicode string's width.</color>
This happens because markup language searches all texts one byte to one byte.
But, Nutscript markup <color=255, 80, 80>searches all texts one 'character' by one character.</color>
This means, multiple byte character like unicode is supported.

Oh my god, What I'm saying... I'm saying same story again and again...
Well, I'm out here. If you can read this text, that means you can scroll this text with mouse.
I didn't made some kind of scroller but hey, it works :DD

So, I gotta get back to my army. Good luck, fellas.
<color=80, 255, 80>Cheers for very good schema of NutScript 1.1.</color>
]]
		, SCREEN_1:getWide() - 20)

		local scrollAmount
		local scrollPos = 0
		local scrollTargetPos
		SCREEN_1.renderCode = function(scr, ent, wide, tall)
			SCREEN_1.ang = Angle(180, 0, 180)
			draw.RoundedBox(0, 0, 0, wide, tall, Color(0, 0, 0, 150))

			scrollAmount = math.max(MRKPOBJ:getHeight() - tall + 20, 0)

			if (scr.hasFocus) then
				local mx, my = scr:mousePos()
				local prec = my/tall
				scrollTargetPos = (prec) * -scrollAmount
			else
				scrollTargetPos = (math.Clamp(((RealTime() / tall*10) % 1.7) - .2, 0, 1) * -scrollAmount)
			end

			scrollPos = Lerp(FrameTime()*7, scrollPos, scrollTargetPos)
			MRKPOBJ:draw(15, scrollPos + 10, 3, 2)
		end

		hook.Add("Think", "aaoa", function()
			SCREEN_1:think()
		end)
		
		hook.Add("PostDrawTranslucentRenderables", "aaoa", function()
			SCREEN_1:render()
		end)
	end
end