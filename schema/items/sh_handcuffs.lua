ITEM.name = "Handcuffs"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A Handcuffs that can hold people's hands"

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = "Use",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() -- We don't need cursors.
		local target = trace.Entity

		if (target and target:IsValid() and target:IsPlayer()) then
			if (hook.Run("CanPlayerHandcuff", client, target) != false) then
				target:getChar():setHandcuffed(true)

				return true
			end
		end

		return false
	end,
}
