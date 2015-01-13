local PANEL = {}
	function PANEL:Init()
		if (IsValid(nut.gui.vendor)) then
			nut.gui.vendor:Remove()
		end

		nut.gui.vendor = self

		self:SetSize(ScrW() * 0.5, 680)
		self:MakePopup()
		self:Center()

		self.stash = self:Add("nutStashItemList")
		self.stash:Dock(LEFT)
		self.stash:SetWide(self:GetWide() * 0.5 - 7)
		self.stash:SetDrawBackground(true)
		self.stash:DockMargin(0, 0, 5, 0)
		self.stash.action:SetText(L"stashOut")

		self.inv = self:Add("nutStashItemList")
		self.inv:Dock(RIGHT)
		self.inv:SetWide(self:GetWide() * 0.5 - 7)
		self.inv:SetDrawBackground(true)
		self.inv.title:SetText(LocalPlayer():Name())
		self.inv.action:SetText(L"stashIn")

		self.tally = {}

		for k, v in pairs(LocalPlayer():getChar():getInv():getItems()) do
			if (v.base == "base_bags") then
				continue
			end

			self.tally[v.uniqueID] = (self.tally[v.uniqueID] or 0) + 1
		end

		self.stash.action.DoClick = function()
			if (self.entity) then
				local selectedItem = nut.gui.vendor.activeItem

				if (IsValid(selectedItem) and !selectedItem.isstash) then
					-- transfer items.
					--netstream.Start("ventorItemTrade", self.entity, selectedItem.uniqueID)
				end
			end
		end

		self.inv.action.DoClick = function()
			if (self.entity) then
				local selectedItem = nut.gui.vendor.activeItem

				if (IsValid(selectedItem) and selectedItem.isstash) then
					--netstream.Start("ventorItemTrade", self.entity, selectedItem.uniqueID, true)
				end
			end
		end
	end

	function PANEL:setVendor(entity, items, money, stocks)
	end

	function PANEL:OnRemove()
		--netstream.Start("vendorExit")
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

		self.itemPanels = {}
	end

	function PANEL:addItem(uniqueID, count, isinv)
		local itemTable = nut.item.list[uniqueID]

		if (!itemTable) then
			return
		end

		local oldPanel = self.itemPanels[uniqueID]

		if (IsValid(oldPanel)) then
			count = count or (oldPanel.count + 1)

			oldPanel.count = count
			oldPanel.name:SetText(itemTable.name..(count and " ("..count..")" or ""))

			return oldPanel
		elseif (isinv) then
			count = count or 1
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
		panel.count = count

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

		local items = nut.gui.vendor.items
		local price = items[uniqueID] and items[uniqueID][1] or itemTable.price or 0
		local price2 = math.Round(price * 0.5)

		panel.overlay:SetToolTip(L("itemPriceInfo", nut.currency.get(price), nut.currency.get(price2)))
		self.itemPanels[uniqueID] = panel

		return panel
	end
vgui.Register("nutStashItemList", PANEL, "DPanel")