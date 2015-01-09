-- This hook returns whether player can use bank or not.
function SCHEMA:CanUseBank(client, atmEntity)
	return true
end

-- This hook returns whether character is recognised or not.
function SCHEMA:IsCharRecognised(char, id)
	local character = nut.char.loaded[id]
	local client = character:getPlayer()
	
	if (client and character) then
		local faction = nut.faction.indices[client:Team()]

		if (faction and faction.isPublic) then
			return true
		end
	end
end

-- Restrict Business.
function SCHEMA:CanPlayerUseBusiness(client, id)
	local item = nut.item.list[id]
	local char = client:getChar()

	if (char) then
		local class = nut.class.list[char:getClass()]

		if (class and class.business and class.business[id]) then
			return true
		end
	end

	return (false)
end

local flesh = {
	[MAT_FLESH] = 1,
	[MAT_ALIENFLESH] = 0,
	[MAT_BLOODYFLESH] = 1,
	[70] = 1,
}
function SCHEMA:EntityFireBullets(ent, bulletTable)
	local oldCallback = bulletTable.Callback

	bulletTable.Callback = function(client, trace, dmgInfo)
		if (oldCallback) then
			oldCallback(client, trace, dmgInfo)
		end
		
		if (trace) then
			if (flesh[trace.MatType]) then
				local e = EffectData()
				e:SetScale(math.Rand(1.3, 1.65))
				e:SetOrigin(trace.HitPos + VectorRand() * 1)
				util.Effect("btBlood", e)
			else
				local e = EffectData()
				e:SetOrigin(trace.HitPos)
				e:SetNormal(trace.HitNormal)
				e:SetScale(math.Rand(.4, .5))
				util.Effect( "btImpact", e )
			end
		end
	end

	return true
end