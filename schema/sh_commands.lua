nut.command.add("handcuff", {
	syntax = "",
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local target = trace.Entity

		if (target and target:IsValid() and target:IsPlayer()) then
			if (hook.Run("CanPlayerHandcuff", client, target) != false) then
				local inv = client:getChar():getInventory()
				local item = inv:hasItem("handcuffs")
				if (inv and item) then
					target:getChar():setHandcuffed(true)

					inv:remove(item.id) -- remove handcuffs after use.
				end
			end
		end
	end
})