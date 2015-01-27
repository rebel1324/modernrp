-- Salary Timer Payload
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

				char.player:notify(L("reserveSalary", v, nut.currency.get(faction.salary)))

				char:addReserve(faction.salary)
			end
		end
	end
end

-- Bank Interest Timer Payload
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

				char.player:notify(L("reserveIncome", v, nut.currency.get(profit)))
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
					client:notify(L("requireAttrib", client, L(nut.attribs.list[k].name, client), attrib, v))

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
		char.lostMoney = math.Round(char:getReserve() * (nut.config.get("dpBank", 10) / 100))
		if (char.lostMoney > 10) then
			char:takeReserve(char.lostMoney)
		end
	end
end

-- This hook returns if the printer can generate the money.
function SCHEMA:CanGenerateMoney(printer)
	-- return false if it's disabled.
	return true
end

-- This hook returns the amount of money that money printer generates.
function SCHEMA:OnGenerateMoney(printer, money)
	-- return money itself.
	return money
end

-- This hook will be run when printer is spawned.
function SCHEMA:OnMoneyPrinterSpawned(printer, item)
	if (printer and printer:IsValid()) then
		local uniqueID = item.uniqueID

 		-- for display purpsoe?
		printer:setNetVar("id", uniqueID)
		
		-- adjust printing amount.
		printer.amount = item.amount

		-- set printer's health.
		printer:setHealth(item.health)

		-- set pritner's money printing interval
		-- default initial interval is fixed to 30.
		-- you can change it by changing hardcoded number in nut_moneyprinter.
		-- actually that initial delay doesn't matter.
		printer:setInterval(item.printSpeed)
	end
end

-- Don't let them spray thier fucking spray without spraycan
function SCHEMA:PlayerSpray(client)
	return (client:getChar():getInv():hasItem("spraycan")) or false
end

-- On character is created, Give him some money and items. 
function SCHEMA:OnCharCreated(client, id)
	local char = nut.char.loaded[id]

	if (char) then
		local inv = char:getInv()

		if (inv) then
			inv:add("healvial")
		end

		char:giveMoney(nut.config.get("startMoney", 0))
	end
end

-- Give Class Loadout.
function SCHEMA:PostPlayerLoadout(client)
	local char = client:getChar()

	if (char) then
		local class = nut.class.list[char:getClass()]

		if (class and class.loadout) then
			for k, v in pairs(class.loadout) do
				local weapon = client:Give(k)

				if (isnumber(v)) then
					client:GiveAmmo(v or 0, weapon:GetPrimaryAmmoType())
				end
			end
		end
	end
end

-- Save Data.
local saveEnts = {
	["nut_atm"] = true,
}
function SCHEMA:SaveData()
	local savedEntities = {}

	for k, v in ipairs(ents.GetAll()) do
		local class = v:GetClass():lower()

		if (saveEnts[class]) then
			table.insert(savedEntities, {
				class = class, 
				pos = v:GetPos(),
				ang = v:GetAngles(),
			})
		end
	end

	-- Save Map Entities
	self:setData(savedEntities)

	-- Save schema variables.
	--self:setData(schemaData, true, true)
end

-- Load Data.
function SCHEMA:LoadData()
	-- Load Map Entities
	local savedEntities = self:getData() or {}
	
	for k, v in ipairs(savedEntities) do
		local ent = ents.Create(v.class)
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:Spawn()
		ent:Activate()
	end

	-- Load Schema Variables.
	-- self:loadData(true, true)
end

-- This hook will be run when player spawned the vehicle with vehicle item. (NEEDS VEHICLE PLUGIN)
function SCHEMA:OnPlayerSpawnedVehicle(vehicle, item, client)
	-- for fast dev
	item = nut.item.list[item.uniqueID]

	if (item.policeCar) then
		vehicle:setNetVar("policeCar", item.uniqueID)
	end
end

netstream.Hook("carLightToggle", function(client)
	local vehicle = client:GetVehicle()

	if (vehicle and IsValid(vehicle)) then
		if (vehicle:getNetVar("policeCar")) then
			local light = vehicle:getNetVar("lightOn", false)
			
			vehicle:setNetVar("lightOn", !light)
			vehicle:EmitSound("buttons/lightswitch2.wav")
		end
	end
end)

/*
	Modifying the lottery chance requires bit knowledge of Programming.
	Before modifying the rate of lottery, you just keep that in your mind.
	With .01 change of difficultyFactor, The Return rate could be increased for like 400%.

	The result: http://i.imgur.com/tPqoF0r.png
	The Simulation was ran 1,000,000 times.
	700,000 failure made and 300,000 profits were made in that simulation.
	The Rate of Return is 93% with graph x^.155.

	You can examine the probability simulation code in here: http://pastebin.com/VA4WXCQT
	If you can't manage this code, You can replace it to your own code.
*/

local difficultyFactor = .155
local lotteryPrize = {
	2048,
	512,
	128,
	64,
	16,
	2,
	1,
	0,
	0,
}

function SCHEMA:LotteryEvent(client, item)
	local value = math.random()^difficultyFactor
	value = value * #lotteryPrize
	value = math.ceil(value)

	return (item.price or 100) * lotteryPrize[value]
end