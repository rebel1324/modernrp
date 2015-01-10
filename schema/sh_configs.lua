WEAPON_REQSKILLS = {}

-- Add Item Stat Requirements.
local function addRequire(itemID, reqAttribs)
	WEAPON_REQSKILLS[itemID] =  reqAttribs
end

-- Adding Weapon Requirements.
addRequire("ak47", {gunskill = 3})
addRequire("aug", {gunskill = 5})
addRequire("deagle", {gunskill = 5})
addRequire("famas", {gunskill = 3})
addRequire("fiveseven", {gunskill = 2})
addRequire("galil", {gunskill = 3})
addRequire("m4a1", {gunskill = 5})
addRequire("mac10", {gunskill = 3})
addRequire("mp5", {gunskill = 4})
addRequire("p228", {gunskill = 1})
addRequire("p90", {gunskill = 4})
addRequire("sg552", {gunskill = 5})
addRequire("tmp", {gunskill = 3})
addRequire("ump", {gunskill = 3})
addRequire("usp", {gunskill = 2})

-- Adding Schema Specific Configs.
nut.config.add("wageInterval", 180, "The Interval of distrubution of salary money.", 
	function(oldValue, newValue)
		if (timer.Exists("nutSalary")) then
			timer.Adjust("nutSalary", newValue, 0, SCHEMA.SalaryPayload)
		end
	end, {
	data = {min = 10, max = 3600},
	category = "schema"
})

nut.config.add("incomeInterval", 180, "The Interval of player getting income from the bank money.", 
	function(oldValue, newValue)
		if (timer.Exists("nutBankIncome")) then
			timer.Adjust("nutBankIncome", newValue, 0, SCHEMA.BankIncomePayload)
		end
	end, {
	data = {min = 10, max = 3600},
	category = "schema"
})

nut.config.add("incomeRate", 1, "The Percentage Rate of Bank Income.", nil, {
	data = {min = 0, max = 100},
	category = "schema"
})

nut.config.add("dpBank", 10, "The Death Penalty: Hospital Cost (x% of Bank Reserve).", nil, {
	data = {min = 0, max = 100},
	category = "schema"
})

nut.config.add("bankFee", 5, "The Bank Transfer Fee (x% of Transfer Money).", nil, {
	data = {min = 0, max = 100},
	category = "schema"
})

nut.config.add("startMoney", 5, "Start money for new character.", nil, {
	data = {min = 0, max = 1000},
	category = "schema"
})