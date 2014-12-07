ENT.Type = "anim"
ENT.PrintName = "Note"
ENT.Author = "Black Tea"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.Category = "NutScript"
ENT.RenderGroup 		= RENDERGROUP_BOTH

if (SERVER) then
	function ENT:Initialize()
	end

	function ENT:OnRemove()
	end

	function ENT:Use(activator)
		if (self.id and WRITINGDATA[self.id]) then
			netstream.Start(activator, "receiveNote", self.id, WRITINGDATA[self.id], self:canWrite(activator))
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:getOwner()
	return self:getNetVar("ownerChar")
end

function ENT:canWrite(client)
	if (client) then
		return (client:IsAdmin() or client:getChar().id == self:getOwner())
	end
end