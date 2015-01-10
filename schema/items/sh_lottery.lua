ITEM.name = "Lottery Ticket"
ITEM.desc = "A Lottey Ticket"
ITEM.model = "models/props_junk/garbage_carboard002a.mdl"
ITEM.price = 200

ITEM.functions._use = { 
	name = "Check",
	tip = "checkTip",
	icon = "icon16/coins.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local money = hook.Run("LotteryEvent", client, item) or item.price

		client:notify("Get Rekt " .. money)
		char:giveMoney(money)

		return true
	end,
	onCanRun = function(item)
		return (!item.entity or !IsValid(item.entity))
	end
}