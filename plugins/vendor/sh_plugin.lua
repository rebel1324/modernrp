local PLUGIN = PLUGIN
PLUGIN.name = "Vendor"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Sell and Buy stuffs from the Server's NPC"
PLUGIN.npcTable = {}

TRADE_BUYONLY = 1
TRADE_SELLONLY = 2
TRADE_BUYANDSELL = 3

nut.util.include("cl_vgui.lua")

-- NPC slowly regenerates money and deplete money.
DEFAULTVENDOR = {	
	name = "John Doe",
	desc = "John Dough??",
	model = "huehueue model",
	money = 500,
	w = 8,
	h = 6,
	inventory = { -- only for save.
		[1] = {
			["smg1"] = 1,
			["ar2"] = 0,
			["pistol"] = 1,
			["357"] = 1,
			["crowbar"] = 1,
		},
		[2] = {
			["357ammo"] = 2,
			["ar2ammo"] = 2,
			["smg1ammo"] = 2,
			["shotgunammo"] = 2,
			["rocketammo"] = 2,
			["pistolammo"] = 2,
		}
	},
	configs = {
		limitedMoney = false,
		stockUserItem = true, -- stacks sold user items in vendor's inventory.
		noStock = true, -- has infinity amount of items.
		tradeFlag = TRADE_BUYANDSELL,
	}
}

if (SERVER) then
	function PLUGIN:SaveData()
	end

	function PLUGIN:LoadData()
		-- load NPCS
		-- load NPC Inventories
		-- npc:loadConfig(data)
	end
end

function PLUGIN:CanPlayerSellItem(char, vendor, request)
	-- does player has enough money?
	-- nut item list request.id .price
	if (false) then
		return false
	end

	-- does player has matching flag?
	if (item.flags and char:hasFlags(item.flags)) then
		return false
	end

	-- does vendor has enough items?
	if (false) then
		return false
	end

	-- You can return custom selling price by returning any number value.
end

function PLUGIN:CanPlayerBuyItem(char, vendor, request, id)
	local item = nut.item.list[id]

	-- You can manipulate purchased items with this hook.
	-- does not requires any kind of return.

	-- ex) item:setData("shopItem", true)
	-- then every purchased item will be marked as Shop Item.
	return item.price or 10
end

function PLUGIN:OnPlayerBuyItem(char, vendor, request, item)
	local client = char.player

	client:EmitSound("ambient/levels/labs/coinslot1.wav")
end

netstream.Hook("vendorAct", function(client, vendor, isSell, id)
	if (!vendor or !client or !client:IsValid() or !vendor:IsValid()) then
		return false
	end

	local char = client:getChar()
	local inv = char:getInv()

	if (isSell) then -- selling request accepts inventory id.
		if (id and nut.item.lists[id]) then
			local sellingItem, price = hook.Run("CanPlayerSellItem", char, vendor, request)

			
			if (sellingItem) then
				price = (price or sellingItem.price or 0)

				if (vendor.limitedMoney) then
					if (vendor:getNetVar("money") < price) then
						return false
					end
				end

				vendor:takeMoney(price)
				char:addMoney(price)

				if (vendor.configs.stockUserItem) then

				else
					
				end
			else
				print("[Nutscript] Client tried to sell invalid item!")
			end
		end
	else -- buying request accepts uniqueID of the item.
		local price = hook.Run("CanPlayerBuyItem", char, vendor, id)

		if (price == false) then
			return false
		end

		price = (price or 0)

		inv:add(id, 1, data)
		char:takeMoney(price)
		vendor:addMoney(price)

		hook.Run("OnPlayerBuyItem", char, vendor, request, item)
	end
end)