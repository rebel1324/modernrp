local PLUGIN = PLUGIN
PLUGIN.name = "Group"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You can make the groups."

-- make it like lib.
local charMeta = FindMetaTable("Character")
nut.group = nut.group or {}
nut.group.list = nut.group.list or {}

GROUP_OWNER = 0
GROUP_ADMIN = 1
GROUP_NORMAL = 2

local langkey = "english"
do
	local langTable = {
		groupCreated = "You created group %s.",
		groupDeleted = "You dismissed group %s.",
		groupPermission = "You need more permission in group to do this action.",
		groupFail = "Failed to create group",
		groupExists = "You're already assinged on group.",
		groupInvalid = "Group is not valid",
		groupHUDLeader = "You're already assinged on group.",
		groupHUD = "He is memeber of '%s'.",
	}

	table.Merge(nut.lang.stored[langkey], langTable)
end

if (SERVER) then
	function PLUGIN:SaveData()
		nut.group.saveAll()
	end
	
	function nut.group.save(groupID)
		local save = nut.group.list[groupID]
		return nut.data.set("groups/" .. groupID, save, false, true)
	end
	
	function nut.group.saveAll()
		for k, v in pairs(nut.group.list) do
			nut.group.save(k)
		end
	end

	function nut.group.load(groupID)
		local save = nut.group.list[groupID]
		return nut.data.get("groups/" .. groupID, save, false, true)
	end

	function nut.group.create(char, name)
		if (char) then
			local id = char:getID()
			nut.group.list[id] = {
				name = name,
				desc = "This is group.",
				password = "",
				isPrivate = false,
				members = {
					[id] = GROUP_OWNER,
				}
			}

			nut.group.syncGroup(id, nut.group.list[id])
			hook.Add("OnGroupCreated", id)
			return id
		end

		return false
	end

	function nut.group.delete(groupID)
		if (nut.group.list[groupID]) then
			nut.group.list[groupID] = nil

			nut.group.syncGroup(groupID, nil)
			hook.Add("OnGroupDissmissed", groupID)
			return true
		end

		return false
	end

	function charMeta:createGroup(name)
		local client = self:getPlayer()
		local group = nut.group.list[self:getGroup()]

		if (!group) then
			local groupID = nut.group.create(self, name)

			if (groupID) then
				self:setData("groupID", groupID)
				group = nut.group.list[groupID]
				client:notify(L("groupCreated", client, group.name))

				return true
			else
				client:notify(L("groupFail", client))
			end
		else
			client:notify(L("groupExists", client))
		end

		return false
	end

	do
		function charMeta:dismissGroup()
			local client = self:getPlayer()
			local groupID = self:getGroup()
			local group = nut.group.list[groupID]

			if (group) then
				local members = nut.group.getMembers(groupID)
				local ranks = members[self:getID()]
				
				if (ranks and ranks == GROUP_OWNER) then
					client:notify(L("groupDeleted", client, group.name))

					for k, v in ipairs(nut.group.getAliveMembers(id)) do
						self:setData("groupID", nil, nil, player.GetAll())
					end

					nut.group.delete(groupID)
					return true
				else
					client:notify(L("groupPermission", client))
				end
			else
				client:notify(L("groupInvalid", client))
			end

			return false
		end
		
		function charMeta:kickGroup(kickerCharID, groupID)
			local groupID = nut.group.list[groupID]

			if (group) then
				local members = nut.group.getMembers(id)
				local kickerRank = (kickerCharID == 0 and 0 or members[kickerCharID])
				local charRank = members[self:getID()]

				if (kickerRank < charRank) then
					self:SetData("groupID", nil, nil, player.GetAll())
					return true
				end
			end

			return false
		end

		function charMeta:inviteGroup(inviterCharID, groupID)
			local groupID = nut.group.list[groupID]

			if (group) then
				-- varies on group setting.
			end
		end

		function charMeta:joinGroup(groupID)
			local group = nut.group.list[groupID]

			if (group) then
				self:setData("groupID", groupID, nil, player.GetAll())
				return true
			end

			return false
		end
	end

	function nut.group.syncGroup(groupID)
		groupTable = nut.group.list[groupID]

		if (groupTable) then
			groupTable = table.Copy(groupTable)
			groupTable.password = nil
		end

		netstream.Start(player.GetAll(), "nutGroupSync", groupID, groupTable)
	end

	function nut.group.syncAll(client)
		for k, v in pairs(nut.group.list) do
			netstream.Start(client, "nutGroupSync", k, v)
		end
	end

	function PLUGIN:PlayerLoadedChar(client, charID, prevID)
		local char = client:getChar()
		local groupID = char:getGroup()
		local groupTable = nut.group.list[groupID]

		if (!groupTable) then
			local groupInfo = nut.group.load(groupID)

			if (groupInfo) then
				nut.group.list[groupID] = groupInfo
			else
				if (groupID != 0) then
					char:setData("groupID", nil)
				end
			end
		end

		nut.group.syncAll(client)
	end

	function PLUGIN:PlayerDisconnected(client)
		local char = client:getChar()

		if (char) then
			local groupID = char:getGroup()
			local aliveMembers = nut.group.getAliveMembers()

			if (table.Count(aliveMembers) <= 0) then
				nut.group.save(groupID)
				nut.group.list[groupID] = nil
			end
		end
	end
else
	netstream.Hook("nutGroupSync", function(id, groupTable)
		nut.group.list[id] = groupTable
	end)

	local tx, ty 
	function PLUGIN:DrawCharInfo(character, x, y, alpha)
		local groupID = character:getGroup()
		local group = nut.group.list[groupID] 

		if (group) then
			tx, ty = nut.util.drawText(L("groupHUD", group.name), x, y, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
			y = y + ty
		end

		return x, y
	end
end

function charMeta:getGroup()
	return self:getData("groupID", 0)
end

function nut.group.getMembers(id)
	return (nut.group.list[id] and (nut.group.list[id].members or {}) or {})
end

function nut.group.getAliveMembers(id)
	local groupMembers = nut.group.getMembers(id)
	local aliveMembers = {}
	local char, charID

	for k, v in ipairs(player.GetAll()) do
		char = v:getChar()
		
		if (char) then
			charID = char:getID()
			if (groupMembers[charID]) then
				table.insert(aliveMembers, charID)
			end
		end
	end

	return aliveMembers
end

do
	nut.command.add("groupcreate", {
		syntax = "<string name>",
		onRun = function(client, arguments)
			local char = client:getChar()

			if (char and hook.Run("CanCharCreateGroup", char) != false) then
				local groupName = table.concat(arguments, " ")

				if (groupName != "" and groupName:utf8len() > 3) then
					char:createGroup(groupName)
				end
			end
		end
	})

	nut.command.add("groupdismiss", {
		syntax = "",
		onRun = function(client, arguments)
			local char = client:getChar()

			if (char and hook.Run("CanCharCreateGroup", char) != false) then				
				char:dismissGroup()
			end
		end
	})

	nut.command.add("groupinvite", {
		syntax = "<name>",
		onRun = function(client, arguments)
			local target = nut.command.findPlayer(client, arguments[1])

			if (IsValid(target) and target:getChar()) then
				local char = client:getChar()
				local groupID = char:getGroup()
				local tChar = target:getChar()
				print(groupID)
				print(tChar:joinGroup(groupID))
				client:notify(L("groupInvited", client))
			end
		end
	})
end