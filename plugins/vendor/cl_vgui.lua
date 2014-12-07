local iconsize = 32 + 16
local PANEL = {}

local function generateInventory(uidTable, invw, invh)
	local inventory = {}
	inventory.slots = {}

	local function canItemFit(x, y, a, b, item2)
		local canFit = true

		for x2 = 0, a - 1 do
			for y2 = 0, b - 1 do
				local item = (inventory.slots[x + x2] or {})[y + y2]

				if ((x + x2) > invw or item) then
					if (item2) then
						if (item and item.id == item2.id) then
							continue
						end
					end

					canFit = false
					break
				end
			end

			if (!canFit) then
				break
			end
		end

		return canFit
	end

	local function findEmptySlot(a, b)
		a = a or 1
		b = b or 1

		if (a > invw or b > invh) then
			return
		end

		local canFit = false

		for y = 1, invh - (b - 1) do
			for x = 1, invw - (a - 1) do
				if (canItemFit(x, y, a, b)) then
					return x, y
				end
			end
		end
	end
	
	for k, v in pairs(uidTable) do
		local itemTable = nut.item.list[k]

		if (itemTable) then
			local w, h = itemTable.width, itemTable.height
			local x, y = findEmptySlot(w, h)
			local item = {
				itemTable = itemTable,
				id = k,
				stock = v,
				gridX = 0,
				gridY = 0,
			}

			if (x and y) then
				inventory.slots[x] = inventory.slots[x] or {}
				inventory.slots[x][y] = true

				item.gridX = x
				item.gridY = y

				for x2 = 0, w - 1 do
					for y2 = 0, h - 1 do
						inventory.slots[x + x2] = inventory.slots[x + x2] or {}
						inventory.slots[x + x2][y + y2] = item
					end
				end
			end
		else
			print("cant ft")
		end
	end

	return inventory
end

function PANEL:Init()
	if (IsValid(nut.gui.vendor)) then
		nut.gui.vendor:Remove()
	end
	
	nut.gui.vendor = self
end

function PANEL:setData(vendor)
	local size = vendor:getNetVar("size")
	self.inv = vendor:getNetVar("inv")
	self.curPage = 1
	self.maxPage = table.Count(self.inv)
	self.invw, self.invh = size[1], size[2]
	self.vendor = vendor

	self:SetSize(iconsize, iconsize)
	self:setGridSize(self.invw, self.invh)

	self:loadItems(self.inv[self.curPage])
end

function PANEL:prevPage()
	if (self.curPage == 1) then
		return
	end

	self.curPage = self.curPage - 1
	self:clearItems()
	self:loadItems(self.inv[self.curPage])
end

function PANEL:nextPage()
	if (self.curPage == self.maxPage) then
		return
	end

	self.curPage = self.curPage + 1
	self:clearItems()
	self:loadItems(self.inv[self.curPage])
end

function PANEL:clearItems()
	for k, v in pairs(self.panels) do
		if (v and v:IsVisible()) then
			v:Remove()
			self.panels[k] = nil
		end
	end
end

function PANEL:loadItems(uidTable)
	local inventory = generateInventory(uidTable, self.invw, self.invh)

	if (inventory) then
		self.panels = {}

		for x, items in pairs(inventory.slots) do
			for y, data in pairs(items) do
				if (!data.id) then continue end

				local item = data.itemTable

				if (item and !IsValid(self.panels[data.id])) then
					local icon = self:addIcon(item.model or "models/props_junk/popcan01a.mdl", x, y, item.width, item.height, data)

					if (IsValid(icon)) then
						icon:SetToolTip(L("itemInfo", item.name, (type(item.desc) == "function" and item.desc(item) or item.desc)) .. "\nCurrent Stock: ".. data.stock)

						self.panels[data.id] = icon
					end
				end
			end
		end
	end
end
	
function PANEL:setGridSize(w, h)
	self.gridW = w
	self.gridH = h
	
	self:SetSize(w * iconsize + 8, h * iconsize )
	self:buildSlots()
end

function PANEL:buildSlots()
	self.slots = self.slots or {}
	
	local function PaintSlot(slot, w, h)
		surface.SetDrawColor(0, 0, 0, 50)
		surface.DrawRect(1, 1, w - 2, h - 2)
		
		surface.SetDrawColor(0, 0, 0, 130)
		surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
	end
	
	for k, v in ipairs(self.slots) do
		for k2, v2 in ipairs(v) do
			v2:Remove()
		end
	end
	
	self.slots = {}
	
	for x = 1, self.gridW do
		self.slots[x] = {}
		
		for y = 1, self.gridH do
			local slot = self:Add("DPanel")
			slot.gridX = x
			slot.gridY = y
			slot:SetPos((x - 1) * iconsize - 1, (y - 1) * iconsize - 1)
			slot:SetSize(iconsize, iconsize)
			slot.Paint = PaintSlot
			
			self.slots[x][y] = slot	
		end
	end
end

function PANEL:addIcon(model, x, y, w, h, data)
	w = w or 1
	h = h or 1
	if (self.slots[x] and self.slots[x][y]) then
		local panel = self:Add("nutItemIcon")
		panel:SetSize(w * iconsize, h * iconsize)
		panel:SetZPos(1)
		panel:InvalidateLayout(true)
		panel:SetModel(model)
		panel:SetPos(self.slots[x][y]:GetPos())
		panel.gridX = x
		panel.gridY = y
		panel.gridW = w
		panel.gridH = h
		local itemTable = nut.item.list[data.id]

		if ((itemTable.iconCam and !renderdIcons[itemTable.uniqueID]) or itemTable.forceRender) then
			local iconCam = itemTable.iconCam
			iconCam = {
				cam_pos = iconCam.pos,
				cam_fov = iconCam.fov,
				cam_ang = iconCam.ang,
			}
			renderdIcons[itemTable.uniqueID] = true
			
			panel.Icon:RebuildSpawnIconEx(
				iconCam
			)
		end
		panel.OnMousePressed = function(this, code)
			if (this.doRightClick) then
				this:doRightClick()
			end
		end
		panel.doRightClick = function(this)
			local itemTable = nut.item.list[data.id]
			
			if (itemTable) then
				itemTable.client = LocalPlayer()

				if (false) then
					surface.PlaySound("buttons/button10.wav")
				else
					local menu = DermaMenu()

					menu:AddOption("Purchase", function()
						netstream.Start("vendorAct", self.vendor, false, data.id)
					end):SetImage(itemTable.icon or "icon16/cart_add.png")

					menu:Open()
				end
				itemTable.client = nil
			end
		end
		panel.PaintOver = function(this, w, h)
			local itemTable = nut.item.list[data.id]

			if (data.stock == 0) then
				surface.SetDrawColor(255, 0, 0, 15)
				surface.DrawRect(2, 2, w - 4, h - 4)
			end
			
			if (itemTable and itemTable.paintOver) then
				itemTable.paintOver(this, itemTable, w, h)
			end
		end

		panel.slots = {}

		for i = 0, w - 1 do
			for i2 = 0, h - 1 do
				local slot = self.slots[x + i] and self.slots[x + i][y + i2]

				if (IsValid(slot)) then
					slot.item = panel
					panel.slots[#panel.slots + 1] = slot
				else
					for k, v in ipairs(panel.slots) do
						v.item = nil
					end

					panel:Remove()

					return
				end
			end
		end
		
		return panel
	end
end

vgui.Register("nutVendorInventory", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:SetTitle("Vendor Menu")
end

function PANEL:loadVendor(vendor)
	self.pagePanel = self:Add("DPanel")
	self.pagePanel:Dock(BOTTOM)
	self.pagePanel:SetTall(40)

	self.pageLeft = self.pagePanel:Add("DButton")
	self.pageLeft:SetText("<<")
	self.pageLeft:Dock(LEFT)
	self.pageLeft:SetWide(34)
	self.pageLeft:DockMargin(4, 4, 4, 4)
	self.pageLeft.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		self.inv:prevPage()
	end

	self.pageRight = self.pagePanel:Add("DButton")
	self.pageRight:SetText(">>")
	self.pageRight:Dock(RIGHT)
	self.pageRight:SetWide(34)
	self.pageRight:DockMargin(4, 4, 4, 4)
	self.pageRight.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		self.inv:nextPage()
	end

	self.inv = self:Add("nutVendorInventory")
	self.inv:setData(vendor)
	self.inv:SetPos(0, 20)
	self.inv:Dock(BOTTOM)
	self.inv:DockMargin(0, 5, 0, 0)
	
	self.panel = self:Add("DPanel")
	self.panel:Dock(FILL)

	/*
	self.panela = self:Add("DPanel")
	self.panela:Dock(TOP)
	self.panela:DockMargin(0, 0, 0, 5)
	self.panela:SetTall(25)
	*/

	local drawPanel = self.panel:Add("Panel")
	drawPanel:Dock(FILL)
	drawPanel.Paint = function(this, w, h)
		draw.SimpleText("Vendor: " .. nut.currency.get(
			vendor:getNetVar("money", 0)
		), "nutChatFont", w/2, h/2, color_white, 1, 1)
	end

	local drawPanel = self.pagePanel:Add("Panel")
	drawPanel:Dock(FILL)
	drawPanel.Paint = function(this, w, h)
		draw.SimpleText("Page ".. self.inv.curPage .."/".. self.inv.maxPage, "nutChatFont", w/2, h/2, color_white, 1, 1)
	end

	local x, y = self.inv:GetSize()
	self:SetSize(x, y + 120)
	self:Center()
	self:MakePopup()
end
vgui.Register("nutVendorFrame", PANEL, "DFrame")

netstream.Hook("nutVendorFrame", function(vendor)
	if (vendorMenu and vendorMenu:IsVisible()) then
		vendorMenu:Close()
		vendorMenu = nil
	end

	vendorMenu = vgui.Create("nutVendorFrame")
	vendorMenu:loadVendor(vendor)
end)