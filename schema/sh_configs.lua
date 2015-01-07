WEAPON_REQSKILLS = {}
ITEM_FORALL = {}

-- Add Item on Public Business (No Restriction on Business.)
local function addPublicItem(itemID, mul)
	ITEM_FORALL[itemID] = (mul or 1)
end

-- Add Item Stat Requirements.
local function addRequire(itemID, reqAttribs)
	WEAPON_REQSKILLS[itemID] =  reqAttribs
end

-- Adding Weapon Requirements.
addRequire("357", {gunskill = 7})
addRequire("ar2", {gunskill = 10})
addRequire("smg1", {gunskill = 5})
addRequire("pistol", {gunskill = 1})

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

nut.config.add("dpBankFee", 5, "The Bank Transfer Fee (x% of Transfer Money).", nil, {
	data = {min = 0, max = 100},
	category = "schema"
})