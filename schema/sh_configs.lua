WEAPON_REQSKILLS = {}
local function addRequire(itemID, reqAttribs)
	WEAPON_REQSKILLS[itemID] =  reqAttribs
end

-- Adding Weapon Requirements.
addRequire("357", {gunskill = 7})
addRequire("ar2", {gunskill = 10})
addRequire("smg1", {gunskill = 5})
addRequire("pistol", {gunskill = 1})

-- Adding Schema Specific Configs.
nut.config.add("wageInterval", 180, "The delay of player get salary from the server.", nil, {
	data = {min = 10, max = 3600},
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