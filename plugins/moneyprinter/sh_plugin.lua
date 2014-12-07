local PLUGIN = PLUGIN
PLUGIN.name = "Money Printer"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "lol moneyprinter"

function PLUGIN:CanGenerateMoney()
	-- return false if it's disabled.
	return true
end

function PLUGIN:OnGenerateMoney(money)
	-- return money itself.
	return money
end

function PLUGIN:OnMoneyPrinterSpawned(printer, item)
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