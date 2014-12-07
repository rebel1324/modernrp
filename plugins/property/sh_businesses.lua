local function registerBusiness(uniqueName, data)
	data.share = 50 -- <NUMBER> SHARE
	data.owner = nil -- <NUMBER> id
	data.expire = 0 -- <NUMBER> CURTIME
	data.motd = "Diligent Workers will get good pays"

	PLUGIN.businessInfo[uniqueName] = data
end

local BUSINESS = {}
BUSINESS.uniqueID = "garbage"
BUSINESS.name = "Garbage Process"
BUSINESS.desc = "A Garbage Process.\nYou can do shit and fuck and fuck tons"
BUSINESS.profit = 100
BUSINESS.price = BUSINESS.profit * 100
BUSINESS.hooks = {}
local hooks = BUSINESS.hooks
BUSINESS.events = {}
local events = BUSINESS.events

function events:canTakeJob(client, businessTable)
	return true
end

function events:onJobTake(client, businessTable)

end

function events:onJobFailed(client, businessTable)

end

function events:onJobSuccess(client, businessTable)

end

registerBusiness(BUSINESS.uniqueID, BUSINESS)
if (CLIENT) then
	urltex.GetMaterialFromURL("http://i.imgur.com/RciEVjV.png", function(mat, tex)
		BUSINESS.image = mat
	end, nil, nil, 512, nil)
end

BUSINESS = {}
BUSINESS.uniqueID = "delivery"
BUSINESS.name = "Quick Delivery"
BUSINESS.desc = "A Quick Delivery Businesses.\nYou can earn the money by shipping the posts to certain area."
BUSINESS.profit = 100
BUSINESS.price = BUSINESS.profit * 100
BUSINESS.hooks = {}
local hooks = BUSINESS.hooks
BUSINESS.events = {}
local events = BUSINESS.events

function events:canTakeJob(client, businessTable)
	return true
end

function events:onJobTake(client, businessTable)

end

function events:onJobFailed(client, businessTable)

end

function events:onJobSuccess(client, businessTable)

end

registerBusiness(BUSINESS.uniqueID, BUSINESS)
if (CLIENT) then
	urltex.GetMaterialFromURL("https://ssl.gstatic.com/codesite/ph/images/defaultlogo.png", function(mat, tex)
		BUSINESS.image = mat
	end, nil, nil, 512, nil)
end