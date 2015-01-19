if ( SERVER ) then
	AddCSLuaFile()
end

if ( CLIENT ) then
	SWEP.PrintName			= ".45 HK USP Silenced"			
	SWEP.Author				= "Black Tea"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
end

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_nutcs_base"
SWEP.Category			= "NutScript 1.1 Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp_silencer.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.011
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 0.18
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellType = 0
SWEP.ShellAng = Angle(-0, -100, 0)
SWEP.WShellAng = -SWEP.ShellAng 
SWEP.muzAdjust = Angle(0, 90, 0)
SWEP.originMod = Vector(-2, -8, 0)
SWEP.MuzSize = .1
SWEP.WMuzSize = .1
SWEP.spreadData = {
	rcvrRecoilRate = .2,
	incrRecoilRate = 1,
	maxRecoil = 5,

	rcvrSpreadRate = .05,
	incrSpreadRate = 2,
	maxSpread = 5,
	minSpread = 2,
}

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW_SILENCED) 
	self:SetNextPrimaryFire(CurTime() + (self.DeployTime or 1))
	return true
end

function SWEP:Reload()
	self:SetIronsight(false)
	self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + self:GetPrimaryDelay())
	self.Weapon:SetNextPrimaryFire(CurTime() + self:GetPrimaryDelay())


	if ( !self:CanPrimaryAttack() ) then return end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
	
	if (!IsFirstTimePredicted()) then
		return
	end

	self.Weapon:EmitSound( self.Primary.Sound )
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	self:TakePrimaryAmmo( 1 )
end
