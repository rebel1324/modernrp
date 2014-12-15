local PANEL = {}
	function PANEL:Init()
		if (IsValid(nut.gui.vendor)) then
			nut.gui.vendor:Remove()
		end

		nut.gui.vendor = self

		self:SetSize(ScrW() * 0.5, 680)
		self:MakePopup()
		self:Center()

		self.selling = self:Add("nutVendorItemList")
		self.selling:Dock(LEFT)
		self.selling:SetWide(self:GetWide() * 0.5 - 7)
		self.selling:SetDrawBackground(true)
		self.selling:DockMargin(0, 0, 5, 0)
		self.selling.action:SetText(L"buy")

		self.buying = self:Add("nutVendorItemList")
		self.buying:Dock(RIGHT)
		self.buying:SetWide(self:GetWide() * 0.5 - 7)
		self.buying:SetDrawBackground(true)
		self.buying.title:SetText(LocalPlayer():Name())
		self.buying.action:SetText(L"sell")

		self.tally = {}

		for k, v in pairs(LocalPlayer():getChar():getInv():getItems()) do
			if (v.base == "base_bags") then
				continue
			end

			self.tally[v.uniqueID] = (self.tally[v.uniqueID] or 0) + 1
		end

		self.selling.action.DoClick = function()
			if (self.entity) then
				local selectedItem = nut.gui.vendor.activeItem
				netstream.Start("ventorItemTrade", self.entity, selectedItem.uniqueID, false)
			end
		end

		self.buying.action.DoClick = function()
			if (self.entity) then
				local selectedItem = nut.gui.vendor.activeItem
				netstream.Start("ventorItemTrade", self.entity, selectedItem.uniqueID, true)
			end
		end
	end

	function PANEL:setVendor(entity, items, rates, money, stocks)
		entity = entity or self.entity
		items = items or self.items or {}
		rates = rates or self.rates or {1, 1}
		money = money or self.rates or 0
		stocks = stocks or self.stocks or {}

		self.selling.items:Clear()
		self.buying.items:Clear()

		if (IsValid(entity)) then
			self.selling.title:SetText(entity:getNetVar("name"))
			self:SetTitle(entity:getNetVar("name"))

			local count = 0

			for k, v in SortedPairs(self.tally) do
				local mode = items[k] and items[k][2]

				if (!mode or mode == VENDOR_SELL) then
					continue
				end
				
				self.buying:addItem(k, v)
				count = count + 1
			end

			if (count == 0) then
				local fault = self.buying.items:Add("DLabel")
				fault:SetText(L"vendorNoSellItems")
				fault:SetContentAlignment(5)
				fault:Dock(FILL)
				fault:SetFont("nutChatFont")
			end

			count = 0

			for k, v in SortedPairs(items) do
				if (items[k] and items[k][2] and items[k][2] > 0) then
					local amount = stocks and stocks[k] and stocks[k][1] or nil

					self.selling:addItem(k, amount)
					count = count + 1
				end
			end

			if (count == 0) then
				local fault = self.selling.items:Add("DLabel")
				fault:SetText(L"vendorNoBuyItems")
				fault:SetContentAlignment(5)
				fault:Dock(FILL)
				fault:SetFont("nutChatFont")
			end

			self.entity = entity
			self.items = items
			self.rates = rates
			self.money = money
			self.stocks = stocks
		end
	end
vgui.Register("nutStash", PANEL, "DFrame")

PANEL = {}
	function PANEL:Init()
		self.title = self:Add("DLabel")
		self.title:SetTextColor(color_white)
		self.title:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.title:Dock(TOP)
		self.title:SetFont("nutBigFont")
		self.title:SizeToContentsY()
		self.title:SetContentAlignment(7)
		self.title:SetTextInset(10, 5)
		self.title.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, w, h)
		end
		self.title:SetTall(self.title:GetTall() + 10)

		self.items = self:Add("DScrollPanel")
		self.items:Dock(FILL)
		self.items:SetDrawBackground(true)
		self.items:DockMargin(5, 5, 5, 5)

		self.action = self:Add("DButton")
		self.action:Dock(BOTTOM)
		self.action:SetTall(32)
		self.action:SetFont("nutMediumFont")
		self.action:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	end

	function PANEL:addItem(uniqueID, count)
		local itemTable = nut.item.list[uniqueID]

		if (!itemTable) then
			return
		end

		local color_dark = Color(0, 0, 0, 80)

		local panel = self.items:Add("DPanel")
		panel:SetTall(36)
		panel:Dock(TOP)
		panel:DockMargin(5, 5, 5, 0)
		panel.Paint = function(this, w, h)
			surface.SetDrawColor(nut.gui.vendor.activeItem == this and nut.config.get("color") or color_dark)
			surface.DrawRect(0, 0, w, h)
		end
		panel.uniqueID = itemTable.uniqueID

		panel.icon = panel:Add("SpawnIcon")
		panel.icon:SetPos(2, 2)
		panel.icon:SetSize(32, 32)
		panel.icon:SetModel(itemTable.model, itemTable.skin)

		panel.name = panel:Add("DLabel")
		panel.name:DockMargin(40, 2, 2, 2)
		panel.name:Dock(FILL)
		panel.name:SetFont("nutChatFont")
		panel.name:SetTextColor(color_white)
		panel.name:SetText(itemTable.name..(count and " ("..count..")" or ""))
		panel.name:SetExpensiveShadow(1, Color(0, 0, 0, 150))

		panel.overlay = panel:Add("DButton")
		panel.overlay:SetPos(0, 0)
		panel.overlay:SetSize(ScrW() * 0.25, 36)
		panel.overlay:SetText("")
		panel.overlay.Paint = function() end
		panel.overlay.DoClick = function(this)
			nut.gui.vendor.activeItem = panel
		end
	end

	function PANEL:OnRemove()
		netstream.Start("vendorExit")
	end
vgui.Register("nutStashList", PANEL, "DPanel")