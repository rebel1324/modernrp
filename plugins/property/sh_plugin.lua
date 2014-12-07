local PLUGIN = PLUGIN
PLUGIN.name = "Business Property"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You can own some automatic business and manage them to earn more mone"
PLUGIN.businessInfo = {}
nut.property = {}

nut.util.include("cl_vgui.lua")
nut.util.include("sh_urltex.lua") -- CREDIT GOES TO CAPSADMIN
nut.util.include("sh_businesses.lua")
nut.util.include("sh_playermeta.lua")

if (SERVER) then
	netstream.Hook("prpAssign", function(client, entity, business)
		if (entity and entity:IsValid()) then
			entity:setNetVar("property", business)
		end
	end)

	netstream.Hook("prpSet", function(client, flagpoint, business, share)
		if (flagpoint.touched[client]) then

		end
	end)

	netstream.Hook("prpMOTD", function(client, flagpoint, business, message)
		if (flagpoint.touched[client]) then

		end
	end)

	netstream.Hook("prpBuy", function(client, flagpoint, business)
		local businessTable = nut.property.getBusiness(business)

		if (flagpoint.touched[client]) then

		end
	end)	

	netstream.Hook("prpAccept", function(client, flagpoint, business)
		local businessTable = nut.property.getBusiness(business)

		if (flagpoint.touched[client]) then
			if (hook.Run("CanPlayerTakeJob", client, businessTable) == false) then
				return 
			end
			
			if (businessTable.events:canTakeJob(client, businessTable)) then
				client:setNetVar("curjob", business)
				businessTable.events:onJobTake(client, businessTable)
			end
		end
	end)

	netstream.Hook("prpGiveup", function(client, flagpoint, business)
		local job = client:getNetVar("curjob")

		if (flagpoint.touched[client]) then
			if (job) then
				if (job == business) then
					local businessTable = nut.property.getBusiness(business)

					client:setNetVar("curjob", nil)
					businessTable.events:onJobFailed(client, businessTable)
				end
			end
		end
	end)

	function PLUGIN:CanPlayerTakeJob(client, businessTable)
		local job = client:getNetVar("curjob")

		return (!job or job == "")
	end

	function PLUGIN:Think()
		for k, v in pairs(self.businessInfo) do
			if (v.owner and v.expire and v.expire < CurTime()) then
				v.owner:notify("Your business contract is expired.")
				v.owner = nil
				v.expire = nil
			end
		end
	end

	function PLUGIN:LoadData()
		local savedTable = self:getData() or {}

		for k, v in ipairs(savedTable) do
			local flagpoint = ents.Create("nut_flagpoint")
			flagpoint:SetPos(v.pos)
			flagpoint:SetAngles(v.ang)
			flagpoint:Spawn()
			flagpoint:Activate()
		end
	end
	
	function PLUGIN:SaveData()
		local savedTable = {}

		for k, v in ipairs(ents.GetAll()) do
			if (v:GetClass() == "nut_flagpoint") then
				table.insert(savedTable, {pos = v:GetPos(), ang = v:GetAngles(), assginment = v:getNetVar("property", "none")})
			end
		end

		self:setData(savedTable)
	end

	function PLUGIN:InitializedSchema()
		-- Initialize all business hooks.
		for class, data in pairs(self.businessInfo) do
			if (data.hooks) then
				for k, v in pairs(data.hooks) do
					hook.Add(k, "Property_".. class .. k, v)
				end
			end
		end
	end

	function PLUGIN:PlayerLoadedChar(client, character, currentChar)
		local job = client:getNetVar("curjob")

		if (job) then
			local businessTable = nut.property.getBusiness(job)

			businessTable.events:onJobFailed(client, businessTable)
			client:setNetVar("curjob", nil)
		end

		for k, v in pairs(self.businessInfo) do
			if (v.owner and v.owner == character.id) then
				v.owner = nil
			end
		end
	end
	
	function PLUGIN:PlayerDisconnected(client)
		local character = client:getChar()

		for k, v in pairs(self.businessInfo) do
			if (v.owner and v.owner == character.id) then
				v.owner = nil
			end
		end
	end
else
	netstream.Hook("prpMenu", function(entity)
		surface.PlaySound("buttons/button1.wav")
		if (propertyMenu and propertyMenu:IsVisible()) then
			propertyMenu:Remove()	
			propertyMenu = nil
		end

		propertyMenu = vgui.Create("nutPropertyMenu")
		propertyMenu.point = entity
		local bInfo = entity:getNetVar("property", "none")
		propertyMenu.bInfo = nut.property.getBusiness(bInfo)
		propertyMenu:loadInfo()
	end)

	netstream.Hook("prpAssign", function(entity)
		surface.PlaySound("buttons/button2.wav")
		if (assignMenu and assignMenu:IsVisible()) then
			assignMenu:Remove()	
			assignMenu = nil
		end

		assignMenu = vgui.Create("nutPropertyAssign")
		assignMenu.point = entity
	end)
end

function nut.property.getAll()
	return PLUGIN.businessInfo
end

function nut.property.getBusiness(id)
	return PLUGIN.businessInfo[id]
end