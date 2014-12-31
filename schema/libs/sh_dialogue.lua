nut.dialogue = nut.dialogue or {}
nut.dialogue.list = nut.dialogue.list or {}

local playerMeta = FindMetaTable("Player")

/*
	HOW DIALOGUE WORKS
	CLINET -> SERVER : REQUEST CONVERSATION
	SERVER -> CLIENT : MAKE CONVERSATION SESSION
	REPEAT
		CLINET -> SERVER : MAKE DECISIONS
		SERVER -> CLIENT : SEND DATA AND GET NEXT CONVERSATION
	END
	CLIENT -> SERVER : TERMINATE CONVERSATION AND ENDS CONVERSATION
*/

-- Register dialogues from a directory.
function nut.dialogue.loadFromDir(directory)
	-- Search the directory for .lua files.
	for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		-- Get the name without the "sh_" prefix and ".lua" suffix.
		local niceName = v:sub(4, -5)
		-- Determine a numeric identifier for this dialogue.
		local index = #nut.dialogue.list + 1

		-- Set up a global table so the file has access to the dialogue table.
		DIALOGUE = {index = index, uniqueID = niceName}
			-- Define some default variables.
			DIALOGUE.canAccess = function() return true end
			DIALOGUE.nodes = {}
			function DIALOGUE:setNode(key, clientText, npcText, nextDialoges, canDisplay)
				if (!key) then
					return
				end

				self.nodes[key] = {
					clientText = clientText or "NOT ASSIGNED",
					npcText = npcText or "NOT ASSIGNED",
					nextNodes = nextDialoges,
					canDisplay = canDisplay or function() return true end
				}
			end

			function DIALOGUE:getNode(key)
				return (self.nodes[key])
			end

			function DIALOGUE:getNextNode(key)
				if (self.nodes[key]) then
					return (self.nodes[key].nextNodes)
				end

				return nil
			end

			-- For future use with plugins.
			if (PLUGIN) then
				DIALOGUE.plugin = PLUGIN.uniqueID
			end

			-- Include the file so data can be modified.
			nut.util.include(directory.."/"..v, "shared")

			-- Add the dialogue to the list of classes.
			nut.dialogue.list[niceName] = DIALOGUE

			-- Check the dialogue is valid or not.
			if (!DIALOGUE:getNode("_start")) then
				print("Dialogue " .. niceName .. " does not have start node.")
				DIALOGUE = nil
				continue
			end

			local hasEnd = false
			do 
				for k, v in pairs(DIALOGUE.nodes) do
					if (!DIALOGUE:getNextNode(k)) then
						hasEnd = true
						break
					end
				end
			end
			
			if (hasEnd == false) then
				print("Dialogue " .. niceName .. " does not have end node.")
				DIALOGUE = nil
				continue
			end
		-- Remove the global variable to prevent conflict.
		DIALOGUE = nil
	end
end

if (SERVER) then
	netstream.Hook("dlgData", function(client, key, value)
		local dlgObject = nut.dialogue.list[client.curDlg]

		if (dlgObject) then
			local dlgNode = dlgObject:getNode(key)
			local dlgNextKey = dlgObject:getNextNode(key)
			local dlgNextNode = dlgObject:getNode(dlgNextKey)

			if (dlgNode and dlgObject.canAccess(client) and dlgNextNode.canAccess(client)) then
				if (dlgNextNode) then
					local dlgData = {}

					if (dlgNextNode.serverCallback) then
						dlgData = dlgNode:serverCallback(client)
					end

					netstream.Hook(client, "dlgResult", dlgNextKey, dlgData)
					return
				else

					client:endDialogue()
					netstream.Hook(client, "dlgResult", false)
					return
				end
			end
		end

		client:endDialogue()
		netstream.Hook(client, "dlgResult", false)
	end)
else
	netstream.Hook("dlgResult", function(key, dlgData)
		if (!key) then
			-- haltDialogue
			return
		end
		
	end)
end

do
	if (SERVER) then
		function playerMeta:startDialogue(key)
			local dlgObject = nut.dialogue.list[key]

			if (dlgObject) then
				self.curDlg = key

				-- send dialogue window
				hook.Run("OnStartDialogue", self, key)
			end
		end

		function playerMeta:endDialogue()
			if (self.curDlg) then
				hook.Run("OnEndDialouge", self, self.curDlg)
				self.curDlg = nil
			end
		end
	end
end