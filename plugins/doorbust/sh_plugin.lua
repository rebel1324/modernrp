PLUGIN.name = "Door Bust Charges"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "A Charge that can blow up the door."

if (CLIENT) then
	

local EFFECT = {}
	function EFFECT:Init( data ) 
		self:SetNoDraw(true)
		local pos = data:GetStart()	
		local scale = 3
		self.emitter = ParticleEmitter(Vector(0, 0, 0))

		for i = 0, 15 do
			local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + VectorRand()*10)
			smoke:SetVelocity(VectorRand()*150*scale)
			smoke:SetDieTime(math.Rand(.5,.9))
			smoke:SetStartAlpha(math.Rand(222,255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(0,5)*scale)
			smoke:SetEndSize(math.random(22,44)*scale)
			smoke:SetRoll(math.Rand(180,480))
			smoke:SetRollDelta(math.Rand(-3,3))
			smoke:SetColor(33, 33, 33)
			smoke:SetGravity( Vector( 0, 0, 20 ) )
			smoke:SetAirResistance(250)
		end

		for i = 0, 5 do
			local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + VectorRand()*10)
			smoke:SetVelocity(VectorRand()*50*scale)
			smoke:SetDieTime(math.Rand(4,6))
			smoke:SetStartAlpha(math.Rand(222,255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(11,22)*scale)
			smoke:SetEndSize(math.random(55,77)*scale)
			smoke:SetRoll(math.Rand(180,480))
			smoke:SetRollDelta(math.Rand(-3,3))
			smoke:SetColor(33, 33, 33)
			smoke:SetGravity( Vector( 0, 0, 20 ) )
			smoke:SetAirResistance(250)
		end

		for i = 0, 2 do
			local smoke = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + VectorRand()*10)
			smoke:SetVelocity(VectorRand()*60*scale)
			smoke:SetDieTime(math.Rand(.5,.9))
			smoke:SetStartAlpha(math.Rand(222,255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(22,44)*scale)
			smoke:SetEndSize(math.random(44,66)*scale)
			smoke:SetRoll(math.Rand(180,480))
			smoke:SetRollDelta(math.Rand(-3,3))
			smoke:SetColor(33, 33, 33)
			smoke:SetGravity( Vector( 0, 0, 20 ) )
			smoke:SetAirResistance(250)
		end

		for i = 0, 4 do
			local smoke = self.emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + VectorRand()*10)
			smoke:SetVelocity(VectorRand()*20*scale)
			smoke:SetDieTime(math.Rand(.1,.15))
			smoke:SetStartAlpha(math.Rand(222,255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(0,5)*scale)
			smoke:SetEndSize(math.random(44,88)*scale)
			smoke:SetRoll(math.Rand(180,480))
			smoke:SetRollDelta(math.Rand(-3,3))
			smoke:SetColor(255, 255, 255)
			smoke:SetGravity( Vector( 0, 0, 20 ) )
			smoke:SetAirResistance(250)
		end

		for i = 0, 4 do
			local smoke = self.emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + VectorRand()*2)
			smoke:SetVelocity(VectorRand()*1*scale)
			smoke:SetDieTime(math.Rand(.1,.15))
			smoke:SetStartAlpha(math.Rand(222,255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(math.random(2,10)*scale)
			smoke:SetEndSize(math.random(4,20)*scale)
			smoke:SetStartLength(math.random(0,5)*scale)
			smoke:SetEndLength(math.random(88,120)*scale)
			smoke:SetRoll(math.Rand(180,480))
			smoke:SetRollDelta(math.Rand(-3,3))
			smoke:SetColor(255, 255, 255)
			smoke:SetAirResistance(250)
		end
	end

	effects.Register( EFFECT, "doorCharge" )
end