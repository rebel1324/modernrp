local iconsize = 32 + 16
local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
	self:SetTitle("Property Assign")
	self:SetSize(500, 300)
	self:Center()
	self:MakePopup()

	local noticeBar = self:Add("nutNoticeBar")
	noticeBar:Dock(TOP)
	noticeBar:setText("This Property is not assigned!")

	self.list = self:Add("PanelList")
	self.list:Dock(FILL)
	self.list:DockMargin(0, 5, 0, 0)
	self.list:SetSpacing(5)
	self.list:SetPadding(5)
	self.list:EnableVerticalScrollbar()

	self:loadBusinesses()
end

function PANEL:loadBusinesses()
	for class, data in pairs(PLUGIN.businessInfo) do
		local panel = self.list:Add("DButton")
		panel:SetText(data.name)
		panel:SetFont("ChatFont")
		panel:SetTextColor(color_white)
		panel:SetTall(40)
		panel.DoClick = function(this)
			surface.PlaySound("buttons/blip1.wav")
			netstream.Start("prpAssign", self.point, class)
			self:Close()
		end
		self.list:AddItem(panel)
	end
end

vgui.Register("nutPropertyAssign", PANEL, "DFrame")

PANEL = {}

function PANEL:Init()
	self:SetTitle("Property Information")
	self:SetSize(400, 350)
	self:Center()
	self:MakePopup()

	local noticeBar = self:Add("nutNoticeBar")
	noticeBar:Dock(TOP)
	noticeBar:setText("Job is available!")
end

local margin = 4
function PANEL:loadInfo()
	/*
	self.info = self:Add("DPanel")
	self.info:Dock(TOP)
	self.info:DockMargin(0, 5, 0, 0)
	self.info:SetTall(128)
	*/

	local label = self:Add("DLabel")
	label:SetText(self.bInfo.name)
	label:Dock(TOP)
	label:SetContentAlignment(5)
	label:SetTextColor(color_white)
	label:SetFont("DermaLarge")
	label:DockMargin(5, 10, 5, 0)
	label:SetTall(50)

	local label = self:Add("DLabel")
	label:SetText("Owner: none")
	label:Dock(TOP)
	label:SetContentAlignment(5)
	label:SetTextColor(color_white)
	label:SetFont("ChatFont")
	label:DockMargin(5, 0, 5, 0)

	local label = self:Add("DLabel")
	label:SetText(self.bInfo.desc)
	label:Dock(TOP)
	label:SetTextColor(color_white)
	label:SetFont("ChatFont")
	label:DockMargin(5, 10, 5, 0)
	label:SetTall(50)
	label:SetWrap(true)

	local job = LocalPlayer():getNetVar("job")
	local button = self:Add("DButton")
	button:SetText((job == self.bInfo.uniqueID) "Give up Task" or "Accept Job")
	button:Dock(TOP)
	button:SetTextColor(color_white)
	button:DockMargin(2, 10, 2, 0)
	button:SetTall(25)
	button.DoClick = function()
		netstream.Start("prpAccept", client, self.point, self.bInfo.uniqueID)
		self:Close()
	end

	local button = self:Add("DButton")
	button:SetText("Purchase Business")
	button:Dock(TOP)
	button:SetTextColor(color_white)
	button:DockMargin(2, 5, 2, 0)
	button:SetTall(25)
	button.DoClick = function()
		netstream.Start("prpBuy", client, self.point, self.bInfo.uniqueID)
	end


	local button = self:Add("DButton")
	button:SetText("Adjust Profit Share")
	button:Dock(TOP)
	button:SetTextColor(color_white)
	button:DockMargin(2, 5, 2, 0)
	button:SetTall(25)

	local button = self:Add("DButton")
	button:SetText("Set MOTD")
	button:Dock(TOP)
	button:SetTextColor(color_white)
	button:DockMargin(2, 5, 2, 0)
	button:SetTall(25)
end

vgui.Register("nutPropertyMenu", PANEL, "DFrame")