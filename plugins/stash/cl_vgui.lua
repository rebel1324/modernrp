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
	if (IsValid(nut.gui.stash)) then
		nut.gui.stash:Remove()
	end
	
	nut.gui.stash = self
end

function PANEL:setData(stashData)
	self.inv = stashData
	self.invw, self.invh = 10, 10

	self.curPage = 1
	self.maxPage = 1

	self:SetSize(iconsize, iconsize)
	self:setGridSize(self.invw, self.invh)

	self:loadItems(self.inv)
end

function PANEL:prevPage()
	if (self.curPage == 1) then
		return
	end

	self.curPage = self.curPage - 1
	self:clearItems()
end

function PANEL:nextPage()
	if (self.curPage == self.maxPage) then
		return
	end

	self.curPage = self.curPage + 1
	self:clearItems()
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

					menu:AddOption("Take", function()
						--netstream.Start("vendorAct", self.vendor, false, data.id)
					end):SetImage(itemTable.icon or "icon16/cart_add.png")

					menu:Open()
				end
				itemTable.client = nil
			end
		end
		panel.PaintOver = function(this, w, h)
			local itemTable = nut.item.list[data.id]
			
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

vgui.Register("nutStashInventory", PANEL, "EditablePanel")



PANEL = {}

function PANEL:Init()
	if (IsValid(nut.gui.stashinv)) then
		nut.gui.stashinv:Remove()
	end
	
	nut.gui.stashinv = self

	self:SetSize(iconsize, iconsize)
	self:setGridSize(nut.config.get("invW"), nut.config.get("invH"))

	self.panels = {}

	local created = {}

	if (LocalPlayer():getChar() and LocalPlayer():getChar():getInv().slots) then
		for x, items in pairs(LocalPlayer():getChar():getInv().slots) do
			for y, data in pairs(items) do
				if (!data.id) then continue end

				local item = nut.item.instances[data.id]

				if (item and !IsValid(self.panels[item.id])) then
					local icon = self:addIcon(item.model or "models/props_junk/popcan01a.mdl", x, y, item.width, item.height)

					if (IsValid(icon)) then
						icon:SetToolTip("Item #"..item.id.."\n"..L("itemInfo", item.name, (type(item.desc) == "function" and item.desc(item) or item.desc)))

						self.panels[item.id] = icon
					end
				end
			end
		end
	end
end
	
function PANEL:setGridSize(w, h)
	self.gridW = w
	self.gridH = h
	
	self:SetSize(w * iconsize + 8, h * iconsize + 8)
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

function PANEL:addIcon(model, x, y, w, h)
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
		panel.OnMousePressed = function(this, code)
			if (this.doRightClick) then
				this:doRightClick()
			end
		end
		panel.doRightClick = function(this)
			local itemTable = LocalPlayer():getChar():getInv():getItemAt(panel.gridX, panel.gridY)
			
			if (itemTable) then
				itemTable.client = LocalPlayer()
				local cooked = itemTable:getData("cooked", 0)

				local menu = DermaMenu()

				menu:AddOption("Store", function()
					--netstream.Start("cookFood", itemTable:getID())
				end):SetImage(itemTable.icon or "icon16/brick.png")

				menu:Open()

				itemTable.client = nil
			end
		end
		panel.PaintOver = function(this, w, h)
			local itemTable = LocalPlayer():getChar():getInv():getItemAt(this.gridX, this.gridY)
			local cooked = itemTable:getData("cooked", 0)

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

vgui.Register("nutStashPlayer", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:SetTitle("Stash Menu")
end

function PANEL:loadStash(stashInv)
	local panel = self:Add("Panel")
	panel:Dock(FILL)

	self.stash = stashInv
	self.inv = panel:Add("nutStashInventory")
	self.inv:setData(stashInv)
	self.inv:Dock(TOP)
	self.inv:DockMargin(0, 0, 0, 0)

	self.switchButton = panel:Add("DButton")
	self.switchButton:Dock(TOP)
	self.switchButton:DockMargin(0, 3, 0, 5)
	self.switchButton:SetTall(30)
	self.switchButton:SetFont("nutChatFont")
	self.switchButton:SetTextColor(color_white)
	self.switchButton:SetText("Switch to Inventory")
	self.switchButton.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		panel:Remove()
		self:loadInventory()
	end

	self.pagePanel = panel:Add("DPanel")
	self.pagePanel:Dock(TOP)
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

	local drawPanel = self.pagePanel:Add("Panel")
	drawPanel:Dock(FILL)
	drawPanel.Paint = function(this, w, h)
		draw.SimpleText("Page ".. self.inv.curPage .."/".. self.inv.maxPage, "nutChatFont", w/2, h/2, color_white, 1, 1)
	end

	local x, y = self.inv:GetSize()
	self:SetSize(x, y + 114)
	self:Center()
	self:MakePopup()
end

function PANEL:loadInventory()
	local panel = self:Add("Panel")
	panel:Dock(FILL)

	self.inv = panel:Add("nutStashPlayer")
	self.inv:Dock(TOP)
	self.inv:DockMargin(0, 0, 0, 0)

	self.switchButton = panel:Add("DButton")
	self.switchButton:Dock(TOP)
	self.switchButton:DockMargin(0, -5, 0, 0)
	self.switchButton:SetTall(30)
	self.switchButton:SetFont("nutChatFont")
	self.switchButton:SetTextColor(color_white)
	self.switchButton:SetText("Switch to Stash")
	self.switchButton.DoClick = function()
		surface.PlaySound("buttons/lightswitch2.wav")
		panel:Remove()
		self:loadStash(self.stash)
	end

	local x, y = self.inv:GetSize()
	self:SetSize(x, y + 60)
	self:Center()
	self:MakePopup()
end


vgui.Register("nutStashFrame", PANEL, "DFrame")