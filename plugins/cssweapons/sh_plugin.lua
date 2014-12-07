PLUGIN.name = "More Weapons"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "WEAPONS"

-- Make a camo pack for a fucking weapon god damnit.
-- resource.AddWorkshop

local sndt = {
	channel = CHAN_USER_BASE + 50,
	volume = 2,
	soundlevel = 130,
	pitchstart = 100,
	pitchend = 100,
}

sndt.name = "Weapon_C_CombinePistol.Single"
sndt.sound = {
	"wepsnd/compis/set1_echo_fire3.wav",
}
sndt.pitchstart = 100
sndt.pitchend = 110
sound.Add( sndt )

sndt.name = "Weapon_C_Pistol.Single"
sndt.sound = {
	"wepsnd/pistol/glock-1.wav",
	"wepsnd/pistol/glock-2.wav",
	"wepsnd/pistol/glock-3.wav",
	"wepsnd/pistol/glock-4.wav",
	"wepsnd/pistol/glock-5.wav",
}
sndt.pitchstart = 100
sndt.pitchend = 110
sound.Add( sndt )

sndt.name = "Weapon_C_SMG.Single"
sndt.sound = {
	"wepsnd/smg1/ssg552-1.wav",
	"wepsnd/smg1/ssg552-2.wav",
	"wepsnd/smg1/ssg552-3.wav",
}
sndt.pitchstart = 80
sndt.pitchend = 110
sound.Add( sndt )

sndt.name = "Weapon_C_AR3.Single"
sndt.sound = {
	"wepsnd/ar3/elite-3.wav",
	"wepsnd/ar3/elite-4.wav",
	"wepsnd/ar3/elite-5.wav",
}
sndt.soundlevel = 300
sndt.pitchstart = 100
sndt.pitchend = 110
sound.Add( sndt )

sndt.name = "Weapon_C_AR3C.Single"
sndt.sound = {
	"wepsnd/ar3/elite-3.wav",
	"wepsnd/ar3/elite-4.wav",
	"wepsnd/ar3/elite-5.wav",
}
sndt.pitchstart = 130
sndt.pitchend = 150
sound.Add( sndt )

sndt.name = "Weapon_C_AR2.Single"
sndt.sound = {
	"wepsnd/ar2/ak47-1.wav",
	"wepsnd/ar2/ak47-2.wav",
	"wepsnd/ar2/ak47-3.wav",
}
sndt.soundlevel = 120
sndt.pitchstart = 80
sndt.pitchend = 110
sound.Add( sndt )

sndt.name = "Weapon_C_357.Single"
sndt.sound = {
	"wepsnd/357/deagle-1.wav",
	"wepsnd/357/deagle-2.wav",
	"wepsnd/357/deagle-3.wav",
	"wepsnd/357/deagle-4.wav",
}
sndt.pitchstart = 80
sndt.pitchend = 110
sound.Add( sndt )


sndt.name = "Weapon_C_Sniper.Single"
sndt.sound = {
	"wepsnd/sniper/awp-1.wav",
	"wepsnd/sniper/awp-2.wav",
}
sndt.pitchstart = 80
sndt.soundlevel = 160
sndt.pitchend = 110
sound.Add( sndt )

sndt.name = "Weapon_C_Sniper.Reload"
sndt.channel = CHAN_AUTO
--sndt.sound = "jaanus/ep2sniper_reload.wav"
sndt.sound = "wepsnd/sniper/sniper_reload.wav"
sndt.pitchstart = 150
sndt.pitchend = 160
sound.Add( sndt )

sndt.name = "Weapon_MP5k.Boltpull"
sndt.channel = SNDLVL_NORM
sndt.sound = "wepsnd/mp5k/bolt.wav"
sndt.pitchstart = 90
sndt.pitchend = 95
sound.Add( sndt )

sndt.name = "Weapon_MP5k.Reload"
sndt.channel = SNDLVL_NORM
sndt.sound = "wepsnd/mp5k/reload.wav"
sndt.pitchstart = 100
sndt.pitchend = 100
sound.Add( sndt )


if CLIENT then

	local META = FindMetaTable("CLuaEmitter")
	if not META then return end
	function META:DrawAt(pos, ang, fov)
		local pos, ang = WorldToLocal(EyePos(), EyeAngles(), pos, ang)
		cam.Start3D(pos, ang, fov)
			self:Draw()
		cam.End3D()
	end

	local EFFECT = {}

	function EFFECT:Init( data ) 
		
		local f_mult = math.Clamp( 60 - 1/FrameTime(), 0, 60 )/60 -- for who has shitty computer 
		-- Thanks Generic Default. Your code was really helpful!
		self.Origin = data:GetOrigin()
		self.Normal = data:GetNormal()
		self.Scale = data:GetScale()
		
		self.Origin = self.Origin
		self.DirVec = self.Normal
		self.Emitter = ParticleEmitter( self.Origin )
		self.MuzzleType = 1
		
		if not self.Emitter then return end 

			local Heatwave = self.Emitter:Add("sprites/heatwave", self.Origin )
			Heatwave:SetVelocity(130*self.DirVec)
			Heatwave:SetDieTime(math.Rand(0.15,0.2))
			Heatwave:SetStartSize(math.random(50,60)*self.Scale)
			Heatwave:SetEndSize(0)
			Heatwave:SetRoll(math.Rand(180,480))
			Heatwave:SetRollDelta(math.Rand(-1,1))
			Heatwave:SetGravity(Vector(0,0,100))
			Heatwave:SetAirResistance(160)


			for i=0,3 do
				local Smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9), self.Origin )
				--local Smoke = self.Emitter:Add("modulus/particles/smoke"..math.random(1,6), self.Origin )
				Smoke:SetVelocity(120*i*1.5*self.DirVec*(self.Scale*1.5))
				Smoke:SetDieTime(math.Rand(0.5,1.9))
				Smoke:SetStartAlpha(math.Rand(5,33))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(math.random(20,30)*self.Scale)
				Smoke:SetEndSize(math.random(40,55)*self.Scale*i)
				Smoke:SetRoll(math.Rand(180,480))
				Smoke:SetRollDelta(math.Rand(-3,3))
				Smoke:SetColor(255,255,255)
				Smoke:SetLighting(true)
				Smoke:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
				Smoke:SetAirResistance(501)
			end
		
			if ( self.MuzzleType == 1 || self.MuzzleType == 2 ) then
				
				if self.MuzzleType == 2 then
					local ang = self.DirVec:Angle()
					ang:RotateAroundAxis( self.DirVec:Angle():Forward(), math.random( -15, 15 ) )
					for a=0, 2 do
						ang:RotateAroundAxis( self.DirVec:Angle():Forward(), 120 )
						local Flash = self.Emitter:Add("effects/muzzleflash"..math.random(1,4),self.Origin )
						--local Flash = self.Emitter:Add("effects/muzzleflash"..math.random(1,4),self.Origin )
						Flash:SetVelocity( ang:Up()*100*i*2*(self.Scale*3*math.Rand( .5, 1.5) ) )
						Flash:SetDieTime( math.Rand(0.06, 0.08) )
						Flash:SetStartAlpha(255)
						Flash:SetEndAlpha(0)
						Flash:SetStartSize(200*self.Scale)
						Flash:SetEndSize(250*self.Scale )
						Flash:SetRoll(math.Rand(180,480))
						Flash:SetRollDelta(math.Rand(-1,1))
						Flash:SetColor(255,255,255)	
						Flash:SetStartLength( math.Rand( 20, 50 )*self.Scale  )
						Flash:SetEndLength( math.Rand( 20, 50  )*self.Scale  )
					end
				end
				
				
				for i=2, 4 do
					--local Gas = self.Emitter:Add("modulus/particles/fire"..math.random(1,8), self.Origin )
					local Gas = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Origin )
					--local Gas = self.Emitter:Add( "effects/combinemuzzle1", self.Origin )
					local fac = 1
					if ply == LocalPlayer() then
						fac = fac + 1.5
					end
					Gas:SetVelocity ( self.DirVec *i*600*self.Scale/1.05 * fac )
					Gas:SetDieTime( math.Rand(0.06, 0.08)  )
					Gas:SetStartAlpha( 80 )
					Gas:SetEndAlpha( 0 )
					Gas:SetStartSize( (50 - i*1.4)*self.Scale )
					Gas:SetEndSize( (40 - i*1.3)*self.Scale/2 )
					Gas:SetRoll( math.Rand(0, 360) )
					Gas:SetRollDelta( math.Rand(-50, 50) )			
					Gas:SetAirResistance( 500 ) 			 		
					Gas:SetColor( 255,220,220 )
				end
				
				
					for i = 1, 5 do
						local Flak = self.Emitter:Add("effects/spark", self.Origin )
						local goAfter = math.random( 100, 1200 )
						if ply == LocalPlayer() then
							goAfter = math.random( 200, 2500 )
						end
						Flak:SetVelocity ( self.DirVec*goAfter*self.Scale+ Vector( math.random( -100, 100 ) / 100, math.random( -100, 100 ) / 100, 0 ) * 65 )
						Flak:SetDieTime(math.Rand(0.06, 0.08) )
						Flak:SetStartAlpha(100)
						Flak:SetEndAlpha(0)
						Flak:SetStartSize(math.Rand( 5, 10 )*self.Scale*1.5  )
						Flak:SetEndSize(2*self.Scale )
						Flak:SetColor(255,200,200)	
						Flak:SetStartLength( math.Rand( 0, 1 )*self.Scale  )
						Flak:SetEndLength( math.Rand( 10, 20 )*self.Scale*1.1 )
					end
				
				--local Spear = self.Emitter:Add("modulus/particles/fire"..math.random(1,8), self.Origin )
				local Spear = self.Emitter:Add("effects/muzzleflash"..math.random(1,4), self.Origin )
				--local Flash = self.Emitter:Add("effects/combinemuzzle1", self.Origin)
				Spear:SetVelocity ( self.DirVec )
				Spear:SetDieTime(math.Rand(0.06, 0.08) )
				Spear:SetStartAlpha(255)
				Spear:SetEndAlpha(0)
				Spear:SetStartSize(30*self.Scale  )
				Spear:SetEndSize(0*self.Scale )
				Spear:SetColor(255,150,150)	
				Spear:SetStartLength( math.Rand( 20, 50 )*self.Scale  )
				local erand = math.Rand( 230, 200  )*self.Scale 
				if ply == LocalPlayer() then
					erand = erand + 60
				end
				Spear:SetEndLength( erand )
				
			end
		
	 end 
	   
	function EFFECT:Think( )
	end

	function EFFECT:Render()
	end

	effects.Register( EFFECT, "muzzleflosh" )

	--** Ejecting Shells
	--** Not made by me - black tea
	
	local EFFECT = {}
	EFFECT.Models = {}
	--** Def CSS Shells
	EFFECT.Models[1] = Model( "models/weapons/shell.mdl" )
	EFFECT.Models[2] = Model( "models/weapons/rifleshell.mdl" )
	EFFECT.Models[3] = Model( "models/shells/shell_556.mdl" )
	EFFECT.Models[4] = Model( "models/shells/shell_762nato.mdl" )
	EFFECT.Models[5] = Model( "models/shells/shell_12gauge.mdl" )
	EFFECT.Models[6] = Model( "models/shells/shell_338mag.mdl" )
	EFFECT.Models[7] = Model( "models/weapons/rifleshell.mdl" )
	--** New Workshop shells
	 
	EFFECT.Sounds = {}
	EFFECT.Sounds[1] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
	EFFECT.Sounds[2] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
	EFFECT.Sounds[3] = { Pitch = 90, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
	EFFECT.Sounds[4] = { Pitch = 90, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
	EFFECT.Sounds[5] = { Pitch = 110, Wavs = { "weapons/fx/tink/shotgun_shell1.wav", "weapons/fx/tink/shotgun_shell2.wav", "weapons/fx/tink/shotgun_shell3.wav" } }
	EFFECT.Sounds[6] = { Pitch = 80, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
	EFFECT.Sounds[7] = { Pitch = 70, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
	 
	function EFFECT:Init( data )
		   
			if not ( data:GetEntity() ):IsValid() then
					self.Entity:SetModel( "models/shells/shell_9mm.mdl" )
					self.RemoveMe = true
					return
			end

			self.Scale = data:GetScale()
			local bullettype = math.Clamp( ( data:GetRadius() or 1 ), 1, 6 )
			local angle, pos = self.Entity:GetBulletEjectPos( data:GetOrigin(), data:GetNormal(), data:GetEntity(), data:GetAttachment() )
			local angmod = data:GetStart() or Vector( 0, 0, 0 )
			angmod = angmod + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * 10
			angle:RotateAroundAxis( angle:Forward(), angmod.x )
			angle:RotateAroundAxis( angle:Right(), angmod.y )
			angle:RotateAroundAxis( angle:Up(), angmod.z )
		   
			local direction = angle:Forward()
			local ang = LocalPlayer():GetAimVector():Angle()

			self.Entity:SetPos( pos )
		   	self.Entity.Emitter = ParticleEmitter( self.Entity:GetPos() )
			self.Entity:SetModel( self.Models[ bullettype ] )
		   
			self.Entity:PhysicsInitBox( Vector(-1,-1,-1), Vector(1,1,1) )
		   
			self.Entity:SetModelScale( ( self.Scale or 1 ), 0 )
			self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
		   
			local phys = self.Entity:GetPhysicsObject()
		   
			if ( phys ):IsValid() then
		   
					phys:Wake()
					phys:SetDamping( 0, 15 )
					phys:SetVelocity( direction * math.random( 150, 200 ) )
					self.Entity.spinVector = ( VectorRand() * 50000 )
					phys:AddAngleVelocity( self.Entity.spinVector )
					phys:SetMass( .1 )
					phys:SetMaterial( "gmod_silent" )
		   
			end
		   
			self.Entity:SetAngles( ang )
		   
			self.HitSound = table.Random( self.Sounds[ bullettype ].Wavs )
			self.HitPitch = self.Sounds[ bullettype ].Pitch + math.random(-10,10)
		   
			self.SoundTime = CurTime() + math.Rand( 0.5, 0.75 )
			self.LifeTime = CurTime() + 1.6
			self.Alpha = 255
		   
	end
	 
	function EFFECT:GetBulletEjectPos( Position, Normal, Ent, Attachment )
	 
			if (!Ent:IsValid()) then return Normal:Angle(), Position end
			if (!Ent:IsWeapon()) then return Normal:Angle(), Position end
			// Shoot from the viewmodel
			if ( Ent:IsCarriedByLocalPlayer() && GetViewEntity() == LocalPlayer() ) then
		   
					local ViewModel = LocalPlayer():GetViewModel()
				   
					if ( ViewModel:IsValid() ) then
						   
							local att = ViewModel:GetAttachment( Attachment )
							if ( att ) then
									return att.Ang, att.Pos
							end
						   
					end
		   
			end
			return Normal:Angle(), Position
	 
	end
	 
	 
	function EFFECT:Think( )
	 
			if self.RemoveMe then return false end
	 
	 		if self.SoundTime then
				if self.SoundTime < CurTime() then
					self.SoundTime = nil
					sound.Play( self.HitSound, self.Entity:GetPos(), 75, self.HitPitch )
				else
					if !self.Entity.nextEmit or self.Entity.nextEmit < CurTime() then
						local phys = self.Entity:GetPhysicsObject()
						if ( phys ):IsValid() then
							phys:AddAngleVelocity( self.Entity.spinVector )
						end

						local emit = self.Entity.Emitter
						local Smoke = emit:Add("particle/smokesprites_000"..math.random(1,9), self.Entity:GetPos() + self.Entity:GetForward()*2*self.Scale )
						--local Smoke = self.Emitter:Add("modulus/particles/smoke"..math.random(1,6), self.Origin )
						Smoke:SetVelocity( Vector(0,0,0) )
						Smoke:SetDieTime(math.Rand(0.1,0.5))
						Smoke:SetStartAlpha(math.Rand(55,88))
						Smoke:SetEndAlpha(0)
						Smoke:SetStartSize(math.random(1,2))
						Smoke:SetEndSize(math.random(5,7))
						Smoke:SetRoll(math.Rand(180,480))
						Smoke:SetRollDelta(math.Rand(-3,3))
						Smoke:SetLighting(true)
						Smoke:SetColor(100,100,100)
						Smoke:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
						Smoke:SetAirResistance(250)
						self.Entity.nextEmit = CurTime() + .04
					end
				end
			end

			if self.LifeTime < CurTime() then
		   
							self:Remove()
						   
			end
	 
			return self.Alpha > 2
		   
	end
	 
	function EFFECT:Render()
	 
			self.Entity:DrawModel()
	 
	end
	effects.Register( EFFECT, "cusshell" )
	
	
	
end