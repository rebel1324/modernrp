-- This hook initializes the salary timers for players.
function SCHEMA:SalaryPayload()
	for k, v in ipairs(player.GetAll()) do
		local char = v:getChar()

		-- If faction has default salary, give them the salary.
		if (char) then
			local charFaction = char:getFaction()
			local faction = nut.faction.indices[charFaction]

			if (faction.salary) then
				if (hook.Run("CanPlayerReceiveSalary", v) == false) then
					return false
				end

				char.player:notify(L("reserveIncreased", v, nut.currency.get(faction.salary)))

				char:addReserve(faction.salary)
			end
		end
	end
end

function SCHEMA:BankIncomePayload()
	for k, v in ipairs(player.GetAll()) do
		local char = v:getChar()

		-- If faction has default salary, give them the salary.
		if (char) then
			local charFaction = char:getFaction()
			local faction = nut.faction.indices[charFaction]

			if (faction.salary) then
				if (hook.Run("CanPlayerGetBankIncome", v) == false) then
					return false
				end

				local profit = math.Round(char:getReserve() * (math.abs(nut.config.get("incomeRate", 1) / 100)))

				char.player:notify(L("reserveIncreased", v, nut.currency.get(profit)))
				char:addReserve(profit)
			end
		end
	end
end

function SCHEMA:InitializedSchema()
	-- Initialize Salary Timer.
	timer.Create("nutSalary", nut.config.get("wageInterval", 180), 0, SCHEMA.SalaryPayload)

	timer.Create("nutBankIncome", nut.config.get("incomeInterval", 180), 0, SCHEMA.BankIncomePayload)
end

-- This hook restricts oneself from using a weapon that configured by the sh_config.lua file.
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

-- This hook returns whether player can receive the salary or not.
function SCHEMA:CanPlayerReceiveSalary(client)
	local char = client:getChar()
	if (!char.player:Alive()) then
		return false, char.player:notify(L("salaryRejected", client))	
	end
end

-- This hook notices you the death penalty that you've got by the server.
function SCHEMA:PlayerSpawn(client)
	local char = client:getChar()

	if (char) then
		if (client.deadChar and client.deadChar == char:getID() and char.lostMoney and char.lostMoney > 10) then
			client:notify(L("hospitalPrice", client, nut.currency.get(char.lostMoney)))
		end
			
		client.deadChar = nil
	end
end

-- This hook enforces death penalty for dead players.
function SCHEMA:PlayerDeath(client)
	local char = client:getChar()

	if (char) then
		client.deadChar = char:getID()
		char.lostMoney = math.Round(char:getReserve()*.1)
		if (char.lostMoney > 10) then
			char:takeReserve(char.lostMoney)
		end
	end
end