if (SERVER) then
	SWEP.Weight				= 10
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName      = "Cleave"
	SWEP.Author    = "Black Tea"
	SWEP.Instructions 	= "Left Click to Swing."
	SWEP.ShowWorldModel		= false
	
	SWEP.ViewModelBoneMods = {
		["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(.1, .1, .1), pos = Vector(300, -300, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["weapon"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(-0.226, 0.6, 0.826), angle = Angle(-90, 90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["weapon"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.23, 1.384, 2.328), angle = Angle(90, 0, 0), size = Vector(0.791, 0.791, 0.791), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end


SWEP.Base = "bt_melee"
SWEP.Category			= "Black Tea"
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
SWEP.UseHands = true
SWEP.Slot				= 1							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Automatic		= true
SWEP.Primary.Damage			= 80
SWEP.Primary.Reach			= 50
SWEP.Primary.Angle			= -.3
SWEP.Primary.Spread			= .2

SWEP.ReOriginPos = Vector(3, -4, 12.267)
SWEP.ReOriginAng = Vector(-15.22, 12, 60.638)
SWEP.LowerAngles = Angle( -10, 12, 0 )-- nut

SWEP.SwingPos = Vector(3.7, -16, 10.314)
SWEP.SwingAng = Vector(11.85, 0, 70)
SWEP.DisoriginPos = Vector(-16.143, 20.26, 4.015)
SWEP.DisoriginAng = Vector(-90, 50.165, 60.354)

function SWEP:Impact( trcTrace )
	self.Owner:EmitSound( Format( "physics/metal/metal_solid_impact_bullet%d.wav", 3 ), 80, math.random( 100, 101 )  )
end

