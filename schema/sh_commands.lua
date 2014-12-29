nut.command.add("bankdeposit", {
	syntax = "<amount>",
	onRun = function(client, arguments)
		local atmEntity
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:isBank()) then
				atmEntity = v
				break
			end
		end

		if (IsValid(atmEntity)) then
			local amount = table.concat(arguments, "")
			local char = client:getChar()
			amount = math.Round(tonumber(amount))

			if (amount and amount > 0 and char) then
				if (char:hasMoney(amount)) then
					char:addReserve(amount)
					char:takeMoney(amount)
					client:notify(L("depositMoney", client))
				else
					client:notify(L("cantAfford", client))
				end
			else
				client:notify(L("provideValidNumber", client))
			end
		end
	end
})

nut.command.add("bankwithdraw", {
	syntax = "<amount>",
	onRun = function(client, arguments)
		local atmEntity
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:isBank()) then
				atmEntity = v
				break
			end
		end

		if (IsValid(atmEntity)) then
			local amount = table.concat(arguments, "")
			local char = client:getChar()
			amount = math.Round(tonumber(amount))

			if (amount and amount > 0 and char) then
				if (char:hasReserve(amount)) then
					char:takeReserve(amount)
					char:giveMoney(amount)
					client:notify(L("withdrawMoney", client))
				else
					client:notify(L("cantAfford", client))
				end
			else
				client:notify(L("provideValidNumber", client))
			end
		end
	end
})

nut.command.add("banktransfer", {
	syntax = "<amount>",
	onRun = function(client, arguments)
		local atmEntity
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:isBank()) then
				atmEntity = v
				break
			end
		end

		if (IsValid(atmEntity)) then
			local amount = table.concat(arguments, "")
			local char = client:getChar()
			amount = math.Round(tonumber(amount))

			if (amount and amount > 0 and char) then
				if (char:hasReserve(amount)) then
					-- Fee 5%
				end
			else
				client:notify(L("provideValidNumber", client))
			end
		end
	end
})

nut.command.add("banklongtransfer", {
	syntax = "<amount>",
	onRun = function(client, arguments)
		local atmEntity
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), 128)) do
			if (v:isBank()) then
				atmEntity = v
				break
			end
		end

		if (IsValid(atmEntity)) then
			local amount = table.concat(arguments, "")
			local char = client:getChar()
			amount = math.Round(tonumber(amount))

			if (amount and amount > 0 and char) then
				if (char:hasReserve(amount)) then
					-- Fee 10%
				end
			else
				client:notify(L("provideValidNumber", client))
			end
		end
	end
})