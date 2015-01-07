local defaultCloth = "Casual Cloth"
local sheetItems = {
	[1] = {	-- for CITIZENSHEETS[1]
		{"Firefighter Uniform", "A LAFD Firefighter Uniform.", 1},
		{defaultCloth, "A Blue Chekcered Shirt with Jeans.", 2},
		{"Well Uniform", "A Well kept Blue Uniform", 3},
		{"Nurse Uniform", "A Cyan Nurse Uniform", 4},
		{"Nurse Uniform", "A Purple Blue Nurse Uniform", 5},
		{defaultCloth, "A Black Suits", 6},
		{defaultCloth, "A Dark Blue Jacket with Jeans", 7},
		{defaultCloth, "A Bright Red and White Shirt with Gray-Brown Pants", 8},
		{defaultCloth, "A Black Hood T-Shirt that 'Misfits' on the front with Gray-Brown Pants", 9},
		{defaultCloth, "A Bright-Gray T-Shirt that has 3 Green Stripes with Jeans", 10},
		{defaultCloth, "A Bright Red Hood T-Shirt with Gray-Brown Pants", 12},
		{defaultCloth, "A Black Jacket on White T-Shirt with Dark Gray Pants", 11},
		{defaultCloth, "A White Shirt that blood spit on with Jeans", 13},
		{defaultCloth, "A Green Stripe Shirt with Bright-Brown Pants.", 14},
		{defaultCloth, "A Dark Brown Leather Jacket on Gray T-Shirt with Dark Gray Pants.", 15},
		{defaultCloth, "A Red Chekcered Shirt with Jeans.", 16},
		{defaultCloth, "A Blue Training Uniform with Gray Pants.", 17},
		{defaultCloth, "A Black Jacket with Jeans.", 18},
		{defaultCloth, "A Engineer Work Uniform with Bright-Gray Pants.", 19},
		{defaultCloth, "A Mountain Climbing Jacket with Jeans.", 20},
		{defaultCloth, "A Jean-Style Shirt with bit-Worn Jeans.", 21},
		{defaultCloth, "A Padding Jacket with Blue Pants.", 22},
		{defaultCloth, "A Jacket on Shirt with Pants.", 23},
		{defaultCloth, "A Jacket on Shirt with Pants.", 24},
		{defaultCloth, "A Blue Striped Shit with Jeans.", 25},
		{defaultCloth, "A White Shirt with Pants.", 26},
		{"Orange Uniform", "An Orange Uniform.", 27},
		{"Security Uniform", "A Uniform that Security wears.", 28},
		{"Military Uniform", "A Uniform that Soldier wears.", 29},
		{"Monk Uniform", "A Uniform that monk wears.", 30},
	},

	[2] = {	-- for CITIZENSHEETS[2]
		{"Nurse Uniform", "A Cyan Nurse Uniform", 1},
		{"Nurse Uniform", "A Purple Blue Nurse Uniform", 2},
		{defaultCloth, "A Shirt with Dark Blue Jeans.", 3},
		{defaultCloth, "An Comfortable Outfit with Dark Blue Pants.", 4},
		{defaultCloth, "A Shirt with Black Pants.", 5},
		{defaultCloth, "A Bright Shirt with Black Pants.", 6},
		{defaultCloth, "A Colored Shirt with Blue Jeans.", 7},
		{defaultCloth, "A Bright Shirt with Black Jeans.", 8},
		{defaultCloth, "A Police Uniform.", 9},
		{defaultCloth, "A Light Blue Jersey with Light Brown Pants.", 10},
		{defaultCloth, "A Green Shirt with Blue Jeans.", 11},
		{defaultCloth, "A White Bunny Shirt with Black Jeans.", 12},
		{defaultCloth, "A White Kitty Shirt with Light Blue Jeans", 13},
		{defaultCloth, "A Red Sweater with Black Jeans", 14},
		{defaultCloth, "A Violet Shirt with Blue Jeans", 15},
		{defaultCloth, "A Clean looking Jacket with Gray Jeans.", 16},
		{defaultCloth, "A Leather Jacket with Blue Pants.", 17},
		{defaultCloth, "A Black Suits", 18},
	}
}

local categoryName = {
	[1] = "Male Clothes",
	[2] = "Female Clothes"
}

local businessClass = {
	CLASS_DEALER,
	CLASS_BLACKDEALER,
}

function PLUGIN:PluginLoaded()
	for cat, data in ipairs(sheetItems) do
		for k, v in ipairs(data) do
			local ITEM = nut.item.register("acloth_"..cat..v[3], "base_atcloth", nil, nil, true)
			ITEM.name = v[1]
			ITEM.desc = v[2]
			ITEM.sheet = {cat, v[3]} -- sheetdata [1]<male> index [2]<fancy>
			ITEM.price = v[4] or 100
			ITEM.isCloth = true
			ITEM.category = categoryName[cat] or "Clothes"

			for _, idx in ipairs(businessClass) do
				local classData = nut.class.list[idx]

				if (classData and classData.business) then
					classData.business["acloth_"..cat..v[3]] = 1
				end	
			end
		end
	end
end