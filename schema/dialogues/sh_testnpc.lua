/*
	EXAMPLE NODE:
	nodes = {
		STARTS CONVERSATION ON "start"
		["_start"] = {
			PRIMARY: clientText = "Hello."
			PRIMARY: npcText = "May I help you?"
			OPTIONAL: canAccess = function()
				return true
			end
			PRIMARY: next = {
				"checkIn",
				"askRooms",
				"byebye"
			}
		}

		["byebye"] = {
			clientText
		}
	}
*/

DIALOGUE.name = "Ghost Hotel Owner"

local function roomDialogue(dlgData)
	return Format("We have %s rooms", dlgData.rooms)
end

local function testCheck(client)
	if (CLIENT) then
		return true
	else
		return false
	end
end

DIALOGUE:setNode("_start", "No Thanks.", "May I help you?", {"checkIn", "byebye"})
DIALOGUE:setNode("checkIn", "I need a room", roomDialogue, {"checkIn", "byebye"}, testCheck)
DIALOGUE:setNode("accept", "I'll pay it", "Thanks for using our hotel.", {"byebye"})
DIALOGUE:setNode("byebye", "I have to go.", "k then.")

if (SERVER) then
	local dialogeNode = DIALOGUE:getNode("checkIn")
	function dialogeNode:serverCallback(client)
		local roomNumbers = math.random(1, 10)

		return {
			rooms = roomNumbers,
		}
	end
end