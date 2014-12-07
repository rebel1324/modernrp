WEAPON_REQSKILLS = {}
local function addRequire(itemID, reqAttribs)
	WEAPON_REQSKILLS[itemID] =  reqAttribs
end

addRequire("357", {gunskill = 7})
addRequire("ar2", {gunskill = 10})
addRequire("smg1", {gunskill = 5})
addRequire("pistol", {gunskill = 1})

nut.config.add("wageInterval", 180, "The delay of player get salary from the server.", nil, {
	data = {min = 10, max = 3600},
	category = "server"
})