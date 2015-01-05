PLUGIN.name = "Grenade Throwables"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Grenade Throwables."

function PLUGIN:Move(client, mv)
	if client:GetMoveType() != MOVETYPE_WALK then return end

	local teargas = client:getNetVar("teargas")

	if (teargas and teargas > CurTime()) then
		local m = .25
		local f = mv:GetForwardSpeed() 
		local s = mv:GetSideSpeed() 
		mv:SetForwardSpeed( f * .005 )
		mv:SetSideSpeed( s * .005 )
	end
end

if (SERVER) then
	function PLUGIN:PlayerSpawn(client)
		client:setNetVar("teargas", 0)
	end

	function PLUGIN:PlayerDeath(client)
		client:setNetVar("teargas", 0)
	end
else
	function PLUGIN:Think()
		for k, v in ipairs(player.GetAll()) do
			if (v:getChar()) then
				local teargas = LocalPlayer():getNetVar("teargas")

				if (teargas and teargas > CurTime() and v:Alive()) then
					if (!v.nextCough or v.nextCough < CurTime()) then
						v.nextCough = CurTime() + math.random(2, 5)

						v:EmitSound( Format( "ambient/voices/cough%d.wav", math.random( 1, 4 ) ) )
					end
				end
			end
		end
	end
	
	local trg = 0
	local cur = 0
	function PLUGIN:HUDPaint()
		if (!LocalPlayer():Alive()) then
			return
		end
		
		local teargas = LocalPlayer():getNetVar("teargas")

		if (teargas and teargas > CurTime()) then
			trg = 120 + math.abs(math.sin( RealTime()*2 )*70)
		else
			trg = 0
		end

		cur = Lerp(FrameTime()*3, cur, trg)
		surface.SetDrawColor(255, 255, 255, cur)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end