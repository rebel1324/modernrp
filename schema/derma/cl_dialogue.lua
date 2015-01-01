local PANEL = {}
	local w, h
	function PANEL:Init()
		if (nut.gui.dialogue and nut.gui.dialogue:IsVisible()) then
			nut.gui.dialogue:Close()
		end

		w, h = math.max(ScrW()/3, 600), math.max(ScrH()/4, 200)
		print(w, h)
		self:SetSize(w, h)
		self:SetPos(ScrW()/2 - w/2, ScrH()/2 + h/2)
		self:MakePopup()

		self.text = self:Add("DLabel")
		self.text:Dock(TOP)
		--self.text:SetWrap(true)
		self.text:SetText("지나가던 사탄이 말하기를, 너는 정말 많은 죄를 지은 것 같구나.")
		self.text:SetTall(h/3)
		self.text:SetFont("nutSmallFont")
		self.text:SetContentAlignment(3+2)
		self.text:DockMargin(5, 5, 5, 5)

		self.sels = self:Add("DPanelList")
		self.sels:Dock(FILL)
		self.sels:DockMargin(5, 5, 5, 5)
		self.sels:EnableVerticalScrollbar()

		for i = 1, 10 do
			local btn = vgui.Create("DButton")
			btn:SetText("What the fuck")
			self.sels:AddItem(btn)
		end

		nut.gui.dialogue = self
	end

	function PANEL:setDialogue(dlgKey, nodeKey)

	end

	function PANEL:OnRemove()
		nut.gui.dialogue = nil
	end
vgui.Register("nutDialogue", PANEL, "DFrame")