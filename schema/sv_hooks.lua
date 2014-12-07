function SCHEMA:InitializedSchema()
	-- Initialize Salary Timer.
	timer.Create("nutSalary", nut.config.get("wageInterval", 180), 0, function()
		for k, v in ipairs(player.GetAll()) do
			local char = v:getChar()

			if (char) then
				local charFaction = char:getFaction()
				local faction = nut.faction.indices[charFaction]

				if (faction.salary) then
					if (hook.Run("CanPlayerReceiveSalary", v) == false) then
						return false
					end

					char.player:notify(L("salaryReceived", v, nut.currency.get(faction.salary)))

					char:giveMoney(faction.salary) -- just test.
				end
			end
		end
	end)
end

function SCHEMA:CanPlayerInteractItem(client, action, item)
	if (action == "drop" or action == "take") then
		return
	end

	local itemTable
	if (type(item) == "Entity") then
		if (IsValid(item)) then
			itemTable = nut.item.instances[item.nutItemID]
		end
	else
		itemTable = nut.item.instances[item]
	end

	if (itemTable and itemTable.isWeapon) then
		local reqattribs = WEAPON_REQSKILLS[itemTable.uniqueID]
		
		if (reqattribs) then
			for k, v in pairs(reqattribs) do
				local attrib = client:getChar():getAttrib(k, 0)
				if (attrib < v) then
					client:notify(Format("You have to train %s to use this Item. (%s/%s)", nut.attribs.list[k].name, attrib, v))
					return false
				end
			end
		end
	end
end

function SCHEMA:CanPlayerReceiveSalary(client)
	local char = client:getChar()
	if (!char.player:Alive()) then
		return false, char.player:notify(L("salaryRejected", client))	
	end
end

function SCHEMA:CanPlayerHandcuff(client, target)
	local clientChar = client:getChar()
	local targetChar = target:getChar()

	if (targetChar:isHandcuffed() or clientChar:isHandcuffed()) then
		return false
	end
end

function SCHEMA:PlayerSpawn(client)
	local char = client:getChar()

	if (char and char:isHandcuffed()) then
		print("player is handcuffed!")
		print("give player handcuff SWEP.")
		client:Give("weapon_handcuffs")
	end
end

nut.char.hookVar("name", "NameChangeNotify", function(char, oldVar, newVar)
	// Maybe Name Based stuffs?
end)