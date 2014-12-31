
function SCHEMA:BuildHelpMenu(tabs)
	tabs["schema"] = function(node)
		local body = ""

		for title, text in SortedPairs(self.helps) do
			body = body.."<h2>"..title.."</h2>"..text.."<br /><br />"
		end

		return body
	end
end