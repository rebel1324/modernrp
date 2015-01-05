local PLUGIN = PLUGIN
PLUGIN.name = "Books"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "The Books that you can read."

if (CLIENT) then
	local PANEL = {}

	function PANEL:Init()
		self:SetSize(400, 500)
		self:MakePopup()
		self:Center()

		self.HTML = self:Add("DHTML")
		self.HTML:Dock(FILL)
		self.HTML.Paint = function(this, w, h)
			draw.SimpleText("Loading", "ChatFont", w/2, h/2, color_white, 1, 1)
		end
	end

	function PANEL:SetHTML(content)
		self.HTML:SetHTML(content)
	end

	vgui.Register("bookFrame", PANEL, "DFrame")

	netstream.Hook("readBook", function(itemID)
		local itemTable = nut.item.list[itemID]

		if (itemTable and itemTable.content) then
			local bookFrame = vgui.Create("bookFrame")
			bookFrame:SetTitle(itemTable.name)

			if (itemTable.isURL == true) then
				bookFrame:OpenURL(itemTable.content)
			else
				bookFrame:SetHTML(itemTable.content)
			end
		end
	end)
end