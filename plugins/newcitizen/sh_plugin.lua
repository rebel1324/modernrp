PLUGIN.name = "Advanced Citizen Outfit"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "This plugin allows the server having good amount of customizable citizens."

-- http://steamcommunity.com/sharedfiles/filedetails/?id=320536858
-- workshop Address = 320536858
if SERVER then resource.AddWorkshop(320536858) end

nut.util.include("sh_sheets.lua")
nut.util.include("sh_citizenmodels.lua")
nut.util.include("cl_vgui.lua")
nut.util.include("sh_generateitem.lua")

-- requires material preload to acquire submaterial change.
if (CLIENT) then
	local time = os.time()
	-- preventing vast loading
	for model, modelData in pairs(RESKINDATA) do
		for k, v in ipairs(modelData.facemaps) do
			surface.SetMaterial(Material(v))
		end
	end

	for model, modelData in pairs(CITIZENSHEETS) do
		for k, v in ipairs(modelData) do
			surface.SetMaterial(Material(v))
		end
	end

	function PLUGIN:OnEntityCreated(ragdoll)
		if (ragdoll and ragdoll:IsValid() and ragdoll:GetClass() == "class C_HL2MPRagdoll") then
			local client = ragdoll:GetRagdollOwner()
			self:CreateEntityRagdoll(client, ragdoll)
		end
	end

	-- currently only applies on local player.
	-- should store cloth data on char or player.
	function PLUGIN:CreateEntityRagdoll(client, ragdoll)
		if (client and ragdoll and client:IsValid() and ragdoll:IsValid() and client:getChar()) then
			local mats = client:GetMaterials()
			for k, v in pairs(mats) do
				ragdoll:SetSubMaterial(k - 1, client:GetSubMaterial(k - 1))
			end
		end
	end
end

function changeFacemap(client, value, ragdoll)
	local model = string.lower(client:GetModel())
	local modelData = RESKINDATA[model]

	if (modelData) then
		if (value == 0) then
			client:SetSubMaterial(modelData[2] - 1, "")
		else
			local facemap = modelData.facemaps[value]
			client:SetSubMaterial(modelData[2] - 1, facemap)
		end
	end
end

function recoverCloth(client, target)
	local inv = client:getChar():getInv()

	if (inv and inv.getItems) then
		for k, v in pairs(inv:getItems()) do
			if (v.isCloth and v:getData("equip")) then
				local model = string.lower(client:GetModel())
				local modelData = RESKINDATA[model]

				if (!model) then					
					return false
				end

				if (modelData) then
					if (modelData.sheets == v.sheet[1]) then
						local sheet = CITIZENSHEETS[v.sheet[1]][v.sheet[2]]

						if (!sheet) then
							return false
						end


						(target or client):SetSubMaterial(modelData[1] - 1, sheet)
					else
						return false
					end
				end

				return false
			end
		end
	end
end

function PLUGIN:PlayerSpawn(client)
	local mats = client:GetMaterials()
	
	-- You have to reset entity texture replacement if you don't want texture fuckups.
	for k, v in ipairs(mats) do
		client:SetSubMaterial(k - 1, "")
	end

	timer.Simple(0, function() -- to prevent getmodel failing.
		if (client:getChar()) then
			timer.Simple(0, function()
				local value = client:getChar():getData("charFacemap")

				if (value) then
					changeFacemap(client, value)
				end

				recoverCloth(client)
			end)
		end
	end)
end

netstream.Hook("charFacemap", function(client, value)
	value = math.ceil(value)
	client:getChar():setData("charFacemap", value)

	changeFacemap(client, value)
end)

nut.command.add("charfacemap", {
	onRun = function(client, arguments)
		netstream.Start(client, "charFacemapMenu")
	end
})