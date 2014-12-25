nut.perk = nut.perk or {}
nut.perk.list = nut.perk.list or {}
nut.perk.progress = nut.perk.progress or {}
/*
	nut.perk.progress = {
		[charID] = {
			["PERKID"] = {
				acquired = true/false,
				progress = {
					
				}
			}
		}
	}
*/

local charMeta = FindMetaTable("Character")

-- Register classes from a directory.
function nut.perk.loadFromDir(directory)
	-- Search the directory for .lua files.
	for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		-- Get the name without the "sh_" prefix and ".lua" suffix.
		local niceName = v:sub(4, -5)

		-- Set up a global table so the file has access to the class table.
		PERK = {uniqueID = niceName}
			-- Define some default variables.
			PERK.name = "Unknown"
			PERK.desc = "No description available."
			PERK.icon = ""
			PERK.getDesc = function(PERK) return PERK.desc end
			--PERK.getProgressText

			-- Include the file so data can be modified.
			nut.util.include(directory.."/"..v, "shared")

			-- Add the class to the list of classes.
			nut.perk.list[niceName] = PERK
		-- Remove the global variable to prevent conflict.
		PERK = nil
	end
end

function charMeta:hasPerk(perk)
	local perks = self:getPerks()

	for k, v in ipairs(perks) do
		if (k == perk) then
			return true
		end
	end

	return false
end

function charMeta:getProgress(perkID)
	local id = self:getID()

	return nut.perk.progress[id][perkID].progress
end

function charMeta:setProgress(perkID, progress)
	local id = self:getID()
	local client = self:getPlayer()

	nut.perk.progress[id][perkID].progress = progress
	netstream.Start(client, "perkSync", id, perkID, progress)
end

function charMeta:addPerk()
	local id = self:getID()
end

function charMeta:removePerk()
	local id = self:getID()
end

function charMeta:savePerks()
	local id = self:getID()

	self:setData("perks", nut.perk.progress[id], true)
end

function charMeta:loadPerks()

end

if (SERVER) then
else
	netstream.Hook("perkSync", function(id, perkID, progress)
		nut.perk.progress[id] = nut.perk.progress[id] or {}
		nut.perk.progress[id][perkID] = nut.perk.progress[id][perkID] or {
			acquired = false,
			progress = {}
		}

		nut.perk.progress[id][perkID].progress = progress
	end)
end