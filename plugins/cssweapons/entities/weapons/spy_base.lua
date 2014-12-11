AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.CurFOVMod = 0
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
	SWEP.ZoomAmount = 15
	SWEP.FadeOnAim = true
	SWEP.UseHands = true
	SWEP.Adjust = Vector( 0, 0, 0 )
	SWEP.thirdEjectAdjust = Vector( 0, 10, -5 )
end

SWEP.Category = "NutScript - Spy Base"
SWEP.AimMobilitySpreadMod = 0.5
SWEP.PenMod = 1
SWEP.RazborkaWeapon = true
SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "I modded it: Black Tea"

SWEP.ViewModelFOV	= 40
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.AnimPrefix		= "fist"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

SWEP.AddSpread = 0
SWEP.SpreadWait = 0
SWEP.AddSpreadSpeed = 1
SWEP.AdjustPos = Vector(0, 0, 0)

local math = math

function SWEP:CalculateEffectiveRange()
	self.EffectiveRange = self.CaseLength * 10 - self.BulletLength * 5 -- setup realistic base effective range
	self.EffectiveRange = self.EffectiveRange * 39.37 -- convert meters to units
	self.EffectiveRange = self.EffectiveRange / 3
	self.DamageFallOff = (100 - (self.CaseLength - self.BulletLength)) / 200
	self.PenStr = (self.BulletLength * 0.5 + self.CaseLength * 0.35) * (self.PenAdd and self.PenAdd or 1)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:CalculateEffectiveRange()
	
	self.CurCone = self.Spread
	
	if CLIENT then
		self.emitter = ParticleEmitter(Vector(0, 0, 0))

		if self.RequiresHands then -- ooh spy, is it bone merge!?
			self.Hands = ClientsideModel("models/weapons/c_arms_cstrike.mdl", RENDERGROUP_BOTH)
			self.Hands:SetNoDraw(true)
			self.Hands:AddEffects(EF_BONEMERGE)
		end
	end
end

function SWEP:SetupDataTables()
	self:DTVar("Bool", 0, "Aiming")
end

local vm, CT, aim, cone, vel, CT, tr
local td = {}

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.dt.Aiming = false
	self:SetNextPrimaryFire(CurTime() + self.DeployTime)
	return true
end

function SWEP:Holster()
	self.dt.Aiming = false
	return true
end

function SWEP:Reload()
	if self:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) == 0 then
		return
	end
	
	self.dt.Aiming = false
	self:DefaultReload(ACT_VM_RELOAD)
	self.Owner.SpeedModDelay = CurTime() + self.ReloadTime
	self.Owner:SetDTFloat(0, 0.75)
end

local reg = debug.getregistry()
local GetVelocity = reg.Entity.GetVelocity
local Length = reg.Vector.Length
local GetAimVector = reg.Player.GetAimVector

function SWEP:CalculateSpread()
	aim = GetAimVector(self.Owner)
	vel = Length(GetVelocity(self.Owner))
	CT = CurTime()
	
	if not self.Owner.LastView then
		self.Owner.LastView = aim
		self.Owner.ViewAff = 0
	else
		self.Owner.ViewAff = Lerp(0.25, self.Owner.ViewAff, (aim - self.Owner.LastView):Length() * 0.5)
		self.Owner.LastView = aim
	end
	
	self.CurCone = math.Clamp((self.Owner:Crouching() and self.CrouchSpread or self.Spread) + self.AddSpread + (vel / 10000 * self.VelocitySensitivity) * (self.dt.Aiming and self.AimMobilitySpreadMod or 1) + self.Owner.ViewAff, 0, 0.09 + self.MaxSpreadInc)
	
	if CT > self.SpreadWait then
		self.AddSpread = math.Clamp(self.AddSpread - 0.005 * self.AddSpreadSpeed, 0, self.MaxSpreadInc)
		self.AddSpreadSpeed = math.Clamp(self.AddSpreadSpeed + 0.05, 0, 1)
	end
end

local SP = game.SinglePlayer()

function SWEP:IndividualThink()
	if (SP and SERVER) or not SP then
		if self.dt.Aiming then
			if not self.Owner:OnGround() or Length(GetVelocity(self.Owner)) >= self.Owner:GetWalkSpeed() * 1.2 or not self.Owner:KeyDown(IN_ATTACK2) then
				CT = CurTime()
				self.dt.Aiming = false
				self:SetNextSecondaryFire(CT + 0.2)
			end
		end
	end
end

function SWEP:Think()
	if self.IndividualThink then
		self:IndividualThink()
	end
	if SERVER then
		if self.Owner:isWepRaised() then
			if self.Owner:KeyDown(IN_SPEED) and Length(GetVelocity(self.Owner)) >= self.Owner:GetWalkSpeed() then
				if self.Owner:isWepRaised() then
					self.Raised = true
				end
				self.Owner:setWepRaised(false)
			end
		end
		if Length(GetVelocity(self.Owner)) <= self.Owner:GetWalkSpeed()*1.5 then
			if self.Raised then
				self.Owner:setWepRaised(true)
				self.Raised = false
			end
		end
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyDown(IN_ATTACK) then
			if !self.keyPressed then
				self.Owner:setWepRaised(!self.Owner:isWepRaised())
				self.keyPressed = true
			end
		else
			self.keyPressed = false
		end
	end
	if (not SP and IsFirstTimePredicted()) or SP then
		self:CalculateSpread()
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	CT = CurTime()
	
	if self.FireAnimFunc then
		self:FireAnimFunc()
	else
		if self.dt.Aiming then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			
			if SP then
				if SERVER then
					self.Owner:GetViewModel():SetPlaybackRate(self.PlayBackRate or 1)
				end
			else
				if SERVER then
					self.Owner:GetViewModel():SetPlaybackRate(self.PlayBackRateSV or 1)
				else
					self.Owner:GetViewModel():SetPlaybackRate(self.PlayBackRate or 1)
				end
			end
		else
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		end
	end
	
	if IsFirstTimePredicted() then
		self:EmitSound(self.FireSound, 105, 100)
		self:FireBullet()
		self:MakeRecoil()
		
		self.SpreadWait = CT + self.SpreadCooldown
		
		self.AddSpread = math.Clamp(self.AddSpread + self.SpreadPerShot, 0, self.MaxSpreadInc)
		self.AddSpreadSpeed = math.Clamp(self.AddSpreadSpeed - 0.2, 0, 1)
		self.FireMove = 1
		
		if SP and SERVER then
			SendUserMessage("RazborkaRecoil", self.Owner)
		end
	end
	
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CT + self.FireDelay)
	self:SetNextSecondaryFire(CT + self.FireDelay)
end

local Dir, Dir2, dot, sp, ent, trace, seed, hm
local trace_normal = bit.bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER)
local trace_walls = bit.bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_MONSTER, CONTENTS_HITBOX)
local NoPenetration = {[MAT_SLOSH] = true}
local NoRicochet = {[MAT_FLESH] = true, [MAT_ANTLION] = true, [MAT_BLOODYFLESH] = true, [MAT_DIRT] = true, [MAT_SAND] = true, [MAT_GLASS] = true, [MAT_ALIENFLESH] = true}
local PenMod = {[MAT_SAND] = 0.5, [MAT_DIRT] = 0.8, [MAT_METAL] = 1.1, [MAT_TILE] = 0.9, [MAT_WOOD] = 1.2}
local bul = {}

local GetShootPos = reg.Player.GetShootPos
local GetCurrentCommand = reg.Player.GetCurrentCommand
local CommandNumber = reg.CUserCmd.CommandNumber
local SpreadAng = Angle(0, 0, 0)

function SWEP:FireBullet(m)
	sp = GetShootPos(self.Owner)
	math.randomseed(CommandNumber(GetCurrentCommand(self.Owner)))
	
	SpreadAng[1] = math.Rand(-self.CurCone, self.CurCone)
	SpreadAng[2] = math.Rand(-self.CurCone, self.CurCone)
	Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle() + SpreadAng * 25):Forward()
	
	m = m and m or 1
	
	for i = 1, self.Shots * m do
		Dir2 = Dir
		
		if self.ClumpSpread and self.ClumpSpread > 0 then
			Dir2 = Dir + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)) * self.ClumpSpread
		end
		
		bul.Num = 1
		bul.Src = sp
		bul.Dir = Dir2
		bul.Spread 	= Vector(0, 0, 0)
		bul.Tracer	= 4
		bul.Force	= self.Damage
		bul.Damage = math.Round(self.Damage)
		
		self.Owner:FireBullets(bul)
		
		td.start = sp
		td.endpos = td.start + Dir2 * 16384
		td.filter = self.Owner
		td.mask = trace_normal
		
		trace = util.TraceLine(td)
			
		if not NoPenetration[trace.MatType] then
			--dot = -Dir2:DotProduct(trace.HitNormal)
			ent = trace.Entity
		
			if not ent:IsNPC() and not ent:IsPlayer() then
				td.start = trace.HitPos
				td.endpos = td.start + Dir2 * self.PenStr * (PenMod[trace.MatType] and PenMod[trace.MatType] or 1) * self.PenMod
				td.filter = self.Owner
				td.mask = trace_walls
				
				trace = util.TraceLine(td)
				
				td.start = trace.HitPos
				td.endpos = td.start + Dir2 * 0.1
				td.filter = self.Owner
				td.mask = trace_normal
				
				trace = util.TraceLine(td) -- run ANOTHER trace to check whether we've penetrated a surface or not
				
				if not trace.Hit then
					bul.Num = 1
					bul.Src = trace.HitPos
					bul.Dir = Dir2
					bul.Spread 	= Vec0
					bul.Tracer	= 4
					bul.Force	= self.Damage * 0.5
					bul.Damage = bul.Damage * 0.5
					
					self.Owner:FireBullets(bul)
					
					bul.Num = 1
					bul.Src = trace.HitPos
					bul.Dir = -Dir2
					bul.Spread 	= Vec0
					bul.Tracer	= 4
					bul.Force	= self.Damage * 0.5
					bul.Damage = bul.Damage * 0.5
					
					self.Owner:FireBullets(bul)
				end
			end
			--[[else
				if not NoRicochet[trace.MatType] then
					Dir2 = Dir2 + (trace.HitNormal * dot) * 3
					Dir2 = Dir2 + VectorRand() * 0.06
					bul.Num = 1
					bul.Src = trace.HitPos
					bul.Dir = Dir2
					bul.Spread 	= Vec0
					bul.Tracer	= 0
					bul.Force	= self.Damage * 0.75
					bul.Damage = bul.Damage * 0.75
					
					self.Owner:FireBullets(bul)
				end
			end]]--
		end
	end
		
	td.mask = trace_normal
end

local ang

function SWEP:MakeRecoil(mod)
	mod = mod and mod or 1
	
	if self.Owner:Crouching() then
		mod = mod * 0.75
	end
	
	if self.dt.Aiming then
		mod = mod * 0.85
	end
	
	if (SP and SERVER) or (not SP and CLIENT) then
		ang = self.Owner:EyeAngles()
		ang.p = ang.p - self.Recoil * 0.5 * mod
		ang.y = ang.y + math.random(-1, 1) * self.Recoil * 0.5 * mod
	
		self.Owner:SetEyeAngles(ang)
	end
	
	self.Owner:ViewPunch(Angle(-self.Recoil * 1.25 * mod, 0, 0))
end

function SWEP:SecondaryAttack()
	if self.dt.Aiming then
		return
	end
	
	if not self.Owner:OnGround() or Length(GetVelocity(self.Owner)) >= self.Owner:GetWalkSpeed() * 1.2 then
		return
	end
	
	self.dt.Aiming = !self.dt.Aiming
	self:SetNextSecondaryFire(CurTime() + 0.1)
end

if CLIENT then
	local function fFrameTime()
		return math.Clamp(FrameTime(), 1/60, 1)
	end
	
	local EP, EA2, FT
	
	function SWEP:ViewModelDrawn()
		EP, EA2, FT = EyePos(), EyeAngles(), fFrameTime()
		local vm = self.Owner:GetViewModel()
		local at = vm:LookupAttachment("1")
		local atpos = vm:GetAttachment(at)
		if IsValid(self.emitter) then
			self.emitter:DrawAt(atpos.Pos, atpos.Ang)
		end

		if IsValid(self.Hands) then
			self.Hands:SetRenderOrigin(EP)
			self.Hands:SetRenderAngles(EA2)
			self.Hands:FrameAdvance(FT)
			self.Hands:SetupBones()
			self.Hands:SetParent(vm)
			self.Hands:DrawModel()
		end
	end
	
	local wm, pos, ang
	local GetBonePosition = debug.getregistry().Entity.GetBonePosition

	function SWEP:CalcView(ply, pos, ang, fov)
		FT, CT = fFrameTime(), CurTime()
		
		if self.dt.Aiming then
			self.CurFOVMod = Lerp(FT * 3, self.CurFOVMod, self.ZoomAmount)
		else
			self.CurFOVMod = Lerp(FT * 3, self.CurFOVMod, 0)
		end
		
		fov = fov - self.CurFOVMod
		
		return pos, ang, fov
	end

	function SWEP:AdjustMouseSensitivity()
		if self.dt.Aiming then
			return 0.75
		end
		
		return 1
	end
	
	local Right = reg.Angle.Right
	local Up = reg.Angle.Up
	local Forward = reg.Angle.Forward
	local RotateAroundAxis = reg.Angle.RotateAroundAxis
	
	SWEP.CrossAmount = 0
	SWEP.CrossAlpha = 255
	local ClumpSpread = surface.GetTextureID("VGUI/clumpspread_ring")
	local White = Color(255, 255, 255, 255)
	local x, y, x2, y2, lp, size
	
	SWEP.BlendPos = Vector(0, 0, 0)
	SWEP.BlendAng = Vector(0, 0, 0)
	SWEP.OldDelta = Angle(0, 0, 0)
	SWEP.AngleDelta = Angle(0, 0, 0)
	SWEP.FireMove = 0
	SWEP.ViewModelMovementScale = 1
	
	local Vec0 = Vector(0, 0, 0)
	local TargetPos, TargetAng, cos1, sin1, tan, ws, rs, mod, EA, delta, mod2, sin2

	function SWEP:GetViewModelPosition(pos, ang)
		EA = EyeAngles()
		FT = fFrameTime()
		
		delta = Angle(EA.p, EA.y, 0) - self.OldDelta
			
		self.OldDelta = Angle(EA.p, EA.y, 0)
		self.AngleDelta = LerpAngle(math.Clamp(FT * 3, 0, 1), self.AngleDelta, delta)
		self.AngleDelta.y = math.Clamp(self.AngleDelta.y, -15, 15)
	
		CT = CurTime()
		vel = Length(GetVelocity(self.Owner))
		ws = self.Owner:GetWalkSpeed()
		mod2 = 1
		if self.dt.Aiming then
			mod2 = 0.2
			TargetPos, TargetAng = self.AimPos * 1, self.AimAng * 1
		else
			TargetPos, TargetAng = Vec0 * 1, Vec0 * 1
		end
		TargetPos = TargetPos + self.Adjust
		
		if vel < 10 or not self.Owner:OnGround() then
			if not self.dt.Aiming then
				cos1, sin1 = math.cos(CT), math.sin(CT)
				tan = math.atan(cos1 * sin1, cos1 * sin1)
				
				TargetAng.x = TargetAng.x + tan * 1.15
				TargetAng.y = TargetAng.y + cos1 * 0.4
				TargetAng.z = TargetAng.z + tan
				
				TargetPos.y = TargetPos.y + tan * 0.2 * mod2
			end
		elseif vel > 10 and vel < ws * 1.2 then
			mod = math.Clamp(vel / ws, 0, 1)
			cos1, sin1 = math.cos(CT * 7), math.sin(CT * 7) * mod
			tan = math.atan(cos1 * sin1, cos1 * sin1) * mod
			
			TargetAng.x = TargetAng.x + tan * 0.5 * self.ViewModelMovementScale * mod2
			TargetAng.y = TargetAng.y + cos1 * 0.5 * self.ViewModelMovementScale * mod2
			TargetAng.z = TargetAng.z + cos1 * 2 * self.ViewModelMovementScale * mod2
			TargetPos.x = TargetPos.x - sin1 * 0.5 * self.ViewModelMovementScale * mod2
			TargetPos.y = TargetPos.y + tan * self.ViewModelMovementScale * mod2
			TargetPos.z = TargetPos.z + tan * 0.85 * self.ViewModelMovementScale * mod2
		elseif vel > ws * 1.2 then
			rs = self.Owner:GetRunSpeed()
			mod = math.Clamp(vel / rs, 0, 1)
			cos1, sin1 = math.cos(CT * 10), math.sin(CT * 10) * mod
			tan = math.atan(cos1 * sin1, cos1 * sin1) * mod
			
			TargetAng.x = TargetAng.x + tan * 2 * self.ViewModelMovementScale
			TargetAng.y = TargetAng.y - cos1 * 3 * self.ViewModelMovementScale
			TargetAng.z = TargetAng.z + cos1 * 3 * self.ViewModelMovementScale
			TargetPos.x = TargetPos.x - sin1 * 1.2 * self.ViewModelMovementScale
			TargetPos.y = TargetPos.y + tan * 4 * self.ViewModelMovementScale
			TargetPos.z = TargetPos.z + tan * 1.2 * self.ViewModelMovementScale
		end
		
		FT = FrameTime()
		
		self.BlendPos = LerpVector(FT * 3, self.BlendPos, TargetPos)
		self.BlendAng = LerpVector(FT * 3, self.BlendAng, TargetAng)

		RotateAroundAxis(ang, Right(ang), self.BlendAng.x + self.AngleDelta.p * mod2)
		
		if not self.ViewModelFlip then
			RotateAroundAxis(ang, Up(ang), self.BlendAng.y + self.AngleDelta.y * 0.5 * mod2)
			RotateAroundAxis(ang, Forward(ang), self.BlendAng.z + self.AngleDelta.y * 0.5 * mod2)
		else
			RotateAroundAxis(ang, Up(ang), self.BlendAng.y - self.AngleDelta.y * 0.5 * mod2)
			RotateAroundAxis(ang, Forward(ang), self.BlendAng.z - self.AngleDelta.y * 0.5 * mod2)
		end
		
		sin2 = math.sin(CT * 1.5)
		/*
		RotateAroundAxis(ang, Right(ang), math.cos(CT * 1.5) * blur * 0.1)
		RotateAroundAxis(ang, Right(ang), sin2 * blur * 0.2)
		RotateAroundAxis(ang, Right(ang), sin2 * blur * 0.2)
		*/
		if not self.ViewModelFlip then
			pos = pos + (self.BlendPos.x + self.AngleDelta.y * 0.1 * mod2) * Right(ang)
		else
			pos = pos + (self.BlendPos.x - self.AngleDelta.y * 0.1 * mod2) * Right(ang)
		end
		
		pos = pos + (self.BlendPos.y - self.FireMove) * Forward(ang)
		pos = pos + self.AdjustPos.x * Right(ang) + self.AdjustPos.y * Forward(ang) + self.AdjustPos.z * Up(ang)
		pos = pos + (self.BlendPos.z - self.AngleDelta.p * 0.1) * Up(ang)
		
		self.FireMove = Lerp(FT * 4, self.FireMove, 0)
		
		return pos, ang
	end
	
	
	local ply, wep
	
	local function GetRecoil()
		ply = LocalPlayer()
		
		if not ply:Alive() then
			return
		end
		
		wep = ply:GetActiveWeapon()
		
		if IsValid(wep) and wep.RazborkaWeapon then
			CT = CurTime()
			wep.SpreadWait = CT + wep.SpreadCooldown
			
			wep.AddSpread = math.Clamp(wep.AddSpread + wep.SpreadPerShot, 0, wep.MaxSpreadInc)
			wep.AddSpreadSpeed = math.Clamp(wep.AddSpreadSpeed - 0.2, 0, 1)
			wep.FireMove = 1
		end
	end
	
	usermessage.Hook("RazborkaRecoil", GetRecoil)
	
	local function AddSpreadPls()
		ply = LocalPlayer()
		
		if not ply:Alive() then
			return
		end
		
		wep = ply:GetActiveWeapon()
		
		if IsValid(wep) and wep.RazborkaWeapon then
			wep.SpreadWait = CurTime() + 0.2
			wep.AddSpread = math.Clamp(0.2, 0, wep.MaxSpreadInc)
			wep.AddSpreadSpeed = math.Clamp(wep.AddSpreadSpeed - 0.5, 0, 1)
		end
	end
	
	usermessage.Hook("AddSpreadPls", AddSpreadPls)

	function SWEP:BeLight( pos )
		local dlight = DynamicLight(self:EntIndex())
			
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 170
		dlight.b = 0
		dlight.Brightness = 2
		dlight.Size = 128
		dlight.Decay = 512
		dlight.DieTime = CurTime() + 0.02
	end

	function SWEP:WorldMuzzleFlash()
		if !self.delayWorldMuzzle or self.delayWorldMuzzle < CurTime() then
			local at = self:LookupAttachment( "muzzle" )
			local atpos = self:GetAttachment( at )
			local e = EffectData()
			e:SetOrigin( atpos.Pos )
			e:SetNormal( atpos.Ang:Forward() * 1 )
			e:SetScale( self.muzScale/2 or .1 )
			util.Effect( "muzzleflosh" , e)
			self:BeLight( atpos.Pos )
			/*
			local pos, ang = self.Owner:GetBonePosition( self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			local e = EffectData()
			e:SetStart( Vector( 0, 0, 0 ) )
			e:SetNormal( atpos.Ang:Up() )
			e:SetOrigin( pos + ang:Forward()*self.thirdEjectAdjust.y + ang:Up()*self.thirdEjectAdjust.z + ang:Right()*self.thirdEjectAdjust.x )
			e:SetRadius( self.Shell or 1 )
			e:SetScale( (self.ShellSize or 1)*.8 )
			util.Effect( "cusshell" , e)
			*/
			self.delayWorldMuzzle = CurTime() + 0.01
		end
	end

	function SWEP:ViewMuzzleFlash()
		if !self.Owner:ShouldDrawLocalPlayer() then
			local vm = self.Owner:GetViewModel()
			if !IsValid(vm) then return end
			local at = vm:LookupAttachment( "1" )
			local atpos = vm:GetAttachment( at )
			local e = EffectData()
			e:SetOrigin( atpos.Pos )
			e:SetNormal( atpos.Ang:Forward() * 1 )
			e:SetScale( self.muzScale or .2 )
			util.Effect( "muzzleflosh" , e)
			self:BeLight( atpos.Pos )
		end
	end

	function SWEP:ShellEject()
		if !self.Owner:ShouldDrawLocalPlayer() then
			local e = EffectData()
			e:SetStart( self.ShellAngle or Vector( 0, 0, 0 ) )
			e:SetRadius( self.Shell or 1 )
			e:SetEntity( self )
			e:SetScale( self.ShellSize or 1 )
			e:SetAttachment("2")
			util.Effect( "cusshell" , e)
		end
	end

	function SWEP:FireAnimationEvent(pos,ang,event)
		if event==6001 then
			-- muzzle
			self:ViewMuzzleFlash()
			return (event==6001)
		end
		if event==5001 then
			-- muzzle
			self:ViewMuzzleFlash()
			return (event==5001)
		end
		if event==5003 then
			-- muzzle
			self:WorldMuzzleFlash()
			return (event==5003)
		end
		if event==20 then
			-- shell
			self:ShellEject()
			return (event==20)
		end
		if event==21 then
			-- shell
			self:ShellEject()
			return (event==21)
		end
	end	

end