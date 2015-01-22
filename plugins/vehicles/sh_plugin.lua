local PLUGIN = PLUGIN
PLUGIN.name = "Vehicle: Remastered"
PLUGIN.author = "Black Tea"
PLUGIN.desc = [[Vehicle Item Plugin with pretty good compatibility.
\nFollowing vehicle mods are supported:
\nDefault Source Vehicles, SCARS]]

-- Vehicle Plugin Development is pending until Chessnut Fix the Vehicle Problem.
-- This is how initialize Language in Single File.
local langkey = "english"
do
	local langTable = {
		vehicleDesc = "You changed your vehicle's desc to %s.",
		vehicleExists = "You already have at least one vehicle outside.",
		vehicleStored = "You stored your vehicles into your virtual garage.",
		notSky = "You need to be outside to bring your vehicle out.",
		vehicleSpawned = "You spawned your vehicle on the world.",
		vehicleCloser = "You need to be closer to your vehicle.",
		vehicleStoredDestroyed = "Your vehicle is destoryed or removed. But stored successfully.",
		vehicleGasFilled = "The vehicle now filled to %d%%.",
		vehicleGasLook = "You must look at the vehicle that you can fill the gas.",
	}

	table.Merge(nut.lang.stored[langkey], langTable)
end

if (SERVER) then
	-- If player disconnects from the server, remove all the vehicles on the server.
	function PLUGIN:PlayerDisconnected(client)
		local char = client:getChar()

		-- If disconnecting player's character is valid.
		if (char) then
			local vehicle = char:getVar("curVehicle")

			-- If the vehicle is spawned and player is disconnected, deplete gas.
			for k, v in ipairs(char:getInv():getItems()) do
				if (v.vehicleData) then
					if (v:getData("spawned")) then
						v:setData("spawned", nil)
						v:setData("gas", 0)
					end
				end
			end

			-- and remove vehicle safe.
			if (vehicle and IsValid(vehicle)) then
				vehicle:Remove()
			end
		end
	end

	-- If player changes the char, remove all the vehicles on the server.
	function PLUGIN:PlayerLoadedChar(client, curChar, prevChar)
		-- If player is changing the char and the character ID is differs from the current char ID.
		if (prevChar and curChar:getID() != prevChar:getID()) then
			local vehicle = curChar:getVar("curVehicle")

			-- If the vehicle is spawned and player is disconnected, deplete gas.
			for k, v in ipairs(curChar:getInv():getItems()) do
				if (v.vehicleData) then
					if (v:getData("spawned")) then
						v:setData("spawned", nil)
						v:setData("gas",  0)
					end
				end
			end

			-- and remove vehicle safe.
			if (vehicle and IsValid(vehicle)) then
				vehicle:Remove()
			end
		end
	end

	-- Kick all passengers in Generic Vehicles.
	local function kickPassengersGeneric(vehicle)
		if (vehicle.seats) then
			for k, v in ipairs(vehicle.seats) do
				if (v and IsValid(v)) then
					local driver = v:GetDriver()

					if (driver and IsValid(driver)) then
						driver:ExitVehicle()
					end
				end
			end
		end
	end

	-- Kick all passengers in SCAR
	local function kickPassengersSCAR(vehicle)
		if (vehicle.Seats) then
			for k, v in ipairs(vehicle.Seats) do
				if (k == 1) then
					continue 
				end

				if (v and IsValid(v)) then
					local driver = v:GetDriver()

					if (driver and IsValid(driver)) then
						driver:ExitVehicle()
					end
				end
			end
		end
	end
	
	-- Check function for SCAR vehicle.
	local function scarFuel(vehicle)
		return (!vehicle.ranOut)
	end

	-- Common function for filling the gas out.
	local function fillGas(vehicle, amount)
		vehicle:setNetVar("gas", math.min(vehicle:getNetVar("gas") + amount, vehicle.maxGas))
	end

	-- Spawn the vehicle with certain format.
	function NutSpawnVehicle(pos, ang, spawnInfo)
		local vehicleEnt

		if (spawnInfo.type == TYPE_GENERIC) then
			--Spawn function for the generic source vehicles
			vehicleEnt = ents.Create("prop_vehicle_jeep")			
			vehicleEnt:SetModel(spawnInfo.model)
			vehicleEnt:SetKeyValue("vehiclescript", spawnInfo.script) 
			vehicleEnt:SetPos(pos)
			vehicleEnt:Spawn()
			vehicleEnt:SetRenderMode(1)
			vehicleEnt:SetColor(spawnInfo.color or color_white)
			
			if (spawnInfo.seatInfo) then
				vehicleEnt.seats = {}

				for k, v in ipairs(seatInfo) do
					local pos, ang = LocalToWorld(vehicleEnt:GetPos(), vehicleEnt:GetAngles(), v.pos, v.ang)
					local seatEnt = ents.Create("prop_vehicle_jeep")
					seatEnt:SetModel(v.model)
					seatEnt:SetKeyValue("vehiclescript", v.script or "scripts/vehicles/prisoner_pod.txt") 
					seatEnt:SetPos(pos)
					seatEnt:SetAngles(ang)
					seatEnt:Spawn()
					seatEnt:SetParent(vehicleEnt)
					if (v.visible) then
						seatEnt:SetNoDraw(true)
					end
					
					seats[k] = seatEnt
				end
			end

			vehicleEnt.kickPassengers = kickPassengersGeneric
		elseif (spawnInfo.type == TYPE_SCAR) then
			-- Spawn function for SCARs
			vehicleEnt = ents.Create(spawnInfo.class)
			if (!IsValid(vehicleEnt)) then
				print("Scar entity does not exists.")

				return
			end

			vehicleEnt:SetPos(pos)
			vehicleEnt:Spawn()
			vehicleEnt.hasFuel = scarFuel

			-- Scar is just an entity. So it requires some touches.
			if (vehicleEnt.Seats) then
				local mainSeat = vehicleEnt.Seats[1]

				if (mainSeat and IsValid(mainSeat)) then
					vehicleEnt.scarDriverSeat = mainSeat
					mainSeat.actualVehicle = vehicleEnt
				end
			end

			vehicleEnt.kickPassengers = kickPassengersSCAR
		else
			-- If the type is not provided, cancel the spawn function
			print("Tried call NutSpawnVehicle without vehicleType.")

			return
		end

		-- Set vehicle's name and physical description
		vehicleEnt:setNetVar("carName", spawnInfo.name)
		vehicleEnt:setNetVar("carPhysDesc", spawnInfo.physDesc)
		vehicleEnt.maxGas = spawnInfo.maxGas
		vehicleEnt.spawnedVehicle = true
		vehicleEnt.fillGas = fillGas

		return vehicleEnt
	end

	-- A function for gas
	local function gasCalc()
		for k, v in ipairs(ents.GetAll()) do
			local class = v:GetClass():lower()

			-- vehicle or driveable vehicle.
			if (v:IsVehicle() and v.spawnedVehicle) then
				local gas = v:getNetVar("gas")

				if (gas and IsValid(v:GetDriver())) then

					if (gas <= 0) then
						-- If gas is ran out, Turn off the vehicle.
						if (v.IsScar) then
							-- SCARs
							v.ranOut = true
							v:TurnOffCar()
						else
							-- Generic Vehicles
							v:Fire("TurnOff")
							v.ranOut = true
						end
					else
						v:setNetVar("gas", math.max(gas - 1, 0))

						-- If gas filled, Make it run again.
						if (v.IsScar) then
							-- SCARs
							if (v.ranOut) then
								v.ranOut = false
								v:TurnOnCar()
							end
						else
							-- Generic Vehicles
							if (v.ranOut) then
								v:Fire("TurnOn")
								v.ranOut = false
							end
						end
					end
				end
			end
		end
	end

	-- Calculate fuel.
	timer.Create("ServerFuelEffects", 1, 0, function()
		local succ, err = pcall(gasCalc)	
		
		-- To make timer not get removed for the error.
		if (!succ) then
			print("VEHICLE: ")
			print(err)
		end
	end)

	function SCHEMA:PlayerLeaveVehicle(client, vehicle)
		if (vehicle.spawnedVehicle or vehicle.actualVehicle) then
			if (vehicle.actualVehicle and IsValid(vehicle.actualVehicle)) then
				vehicle = vehicle.actualVehicle	
			end

			local owner = vehicle:getNetVar("owner")
			local charID = client:getChar():getID()

			if (owner and charID and owner == charID) then
				vehicle:kickPassengers()
			end
		end
	end
else
	-- Draw vehicle's name and physical description
	function SCHEMA:ShouldDrawEntityInfo(vehicle)
		if (vehicle:IsVehicle()) then
			return true
		end
	end
	
	function SCHEMA:DrawEntityInfo(vehicle, alpha)
		if (vehicle:IsVehicle() and vehicle:getNetVar("carName")) then
			local vh = LocalPlayer():GetVehicle()
			if (!vh or !IsValid(vh)) then
				local position = vehicle:LocalToWorld(vehicle:OBBCenter()):ToScreen()
				local x, y = position.x, position.y
				
				nut.util.drawText(vehicle:getNetVar("carName", "gay car"), x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
				nut.util.drawText(vehicle:getNetVar("carPhysDesc", "faggy car"), x, y + 16, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
			end
		end	
	end
end

-- A Command for changing the vehicle's physical description.
nut.command.add("vehicledesc", {
	syntax = "<string text>",
	onRun = function(client, arguments)
		if (!arguments[1]) then
			return L("invalidArg", client, 1)
		end

		local phyDesc = table.concat(arguments, " ")
		local trace = client:GetEyeTraceNoCursor()

		local ent = trace.Entity
		if (ent and IsValid(ent)) then
			local char = client:getChar()

			if (ent:getNetVar("owner", 0) == char:getID()) then
				ent:setNetVar("carPhysDesc", phyDesc)
				client:notify(L("vehicleDesc", client, phyDesc))
			end
		end
	end
})