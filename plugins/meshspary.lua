PLUGIN.name = "Mesh Spray"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "A Mesh Spray for Nutscript 1.1"
local PLUGIN = PLUGIN
nut.decal = nut.decal or {}
nut.decal.list = nut.decal.list or {}
nut.decal.types = {}

local wireframe = Material( "models/wireframe" )
DEFAULT_SIZE = Vector( 1, 1, 1 ) * 64
function nut.decal.register(matName, size)
	local index = #nut.decal.types
	local customMat

	if (CLIENT) then
		local decalName = "CUSTOM_SPRAY" .. index .. math.Round(RealTime())
		customMat = CreateMaterial(decalName, "vertexlitgeneric",
		    {
		        ["$basetexture"] = matName,
		        ["$vertexcolor"] = 1,
		        ["$translucent"] = 1,
		    }
		)
	end

	nut.decal.types[index + 1] = {
		material = customMat,
		size = size or DEFAULT_SIZE,
	}
end

nut.decal.register("decals/decalgraffiti057a_cs")
nut.decal.register("decals/decalgraffiti059a")
nut.decal.register("decals/decal_posters003a")

if (SERVER) then
	function nut.decal.add(position, angles, decalType, noAdjust, lifeTime)
		decalType = decalType or 1
		print(decalType)

		if (decalType) then
			local decalInfo = nut.decal.types[decalType]
			local decalSize = decalInfo.size

			if (!noAdjust) then
				angles:RotateAroundAxis(angles:Up(), 180)
				angles:RotateAroundAxis(angles:Forward(), 0)
				position = position + angles:Right() * 1 + angles:Up() * -decalSize[1] / 2 + angles:Right() * -decalSize[2] / 2 
			end

			local decalData = {
				pos = position,
				ang = angles,
				decalType = decalType,
				lifeTime = lifeTime or nil,
			}

			table.insert(nut.decal.list, decalData)
			netstream.Start(player.GetAll(), "decalSync", decalData)
		end
	end
else
	netstream.Hook("decalSyncAll", function(decalData)
		nut.decal.list = decalData
	end)

	netstream.Hook("decalSync", function(decalData)
		table.insert(nut.decal.list, decalData)
	end)
	
	-- Create Rectangle Mesh
	local function rectMesh()
		local verts = {}
		local pos, ang = Vector(), Angle()
		local d1, d2, d3 = ang:Up(), ang:Right(), ang:Forward()*10

		-- Mesh works. 
		mesh.Begin(RECTMESH, MATERIAL_TRIANGLES, 2)

			table.insert(verts, {pos = pos + d1 * 0 + d2 * 1, u = 1, v = 1, normal = d1})
			table.insert(verts, {pos = pos + d1 * 0 + d2 * 0, u = 0, v = 1, normal = d1})
			table.insert(verts, {pos = pos + d1 * 1 + d2 * 0, u = 0, v = 0, normal = d1})

			table.insert(verts, {pos = pos + d1 * 1 + d2 * 0, u = 0, v = 0, normal = d1})
			table.insert(verts, {pos = pos + d1 * 1 + d2 * 1, u = 1, v = 0, normal = d1})
			table.insert(verts, {pos = pos + d1 * 0 + d2 * 1, u = 1, v = 1, normal = d1})

			for index = 1, #verts do
				local vt = verts[index]
			
				mesh.Position(vt.pos)
				mesh.Normal(vt.normal)
				mesh.Color(255, 255, 255, 255)
				
				-- Texture UV
				mesh.TexCoord( 0, vt.u,	vt.v )
				-- Lightmap UV
				mesh.TexCoord( 1, vt.u,	vt.v )
				
				mesh.AdvanceVertex()
			end

		mesh.End()
		--RECTMESH:BuildFromTriangles( verts )
	end

	-- You only create Mesh Once.
	if (RECTMESH) then
		RECTMESH:Destroy()
		RECTMESH = nil
	end

	-- Give a hint, It's Lightmapped Generic!
	--RECTMESH = Mesh(Material("decals/decalgraffiti057a_cs"))
	RECTMESH = Mesh()
	rectMesh()

	local position = Vector(0, 0, 1) * 250

	hook.Add("PreDrawTranslucentRenderables", "aa", function()
		for k, v in ipairs(nut.decal.list) do
			local decalInfo = nut.decal.types[v.decalType]

			if (decalInfo and RECTMESH) then
				local matrix = Matrix();
				matrix:Translate(v.pos);
				matrix:Rotate(v.ang);
				matrix:Scale(decalInfo.size);
			 

				cam.PushModelMatrix(matrix)
					render.ComputeLighting(v.pos,v.ang:Forward() )
					render.SetMaterial(decalInfo.material or wireframe)
					render.SetLightmapTexture(decalInfo.material:GetTexture("$basetexture"))

					RECTMESH:Draw()
				cam.PopModelMatrix()
			end
		end
	end)
end

nut.command.add("decaladd", {
	adminOnly = true,
	syntax = "[number decalType] [number scale]",
	onRun = function(client, arguments)
		-- Get the position and angles of the text.
		print(client, client:GetEyeTraceNoCursor())
		local trace = client:GetEyeTraceNoCursor()
		local angles = trace.HitNormal:Angle()
		local position = trace.HitPos + angles:Forward()
		local decalType = tonumber(arguments[1])
		
		-- Add the text.
		nut.decal.add(position, angles, isnumber(decalType) and decalType or 1)

		-- Tell the player the text was added.
		return L("decaldAdded", client)
	end
})

nut.command.add("decalremove", {
	adminOnly = true,
	syntax = "[number radius]",
	onRun = function(client, arguments)
		-- Get the origin to remove text.
		local trace = client:GetEyeTraceNoCursor()
		local position = trace.HitPos + trace.HitNormal*2
		-- Remove the text(s) and get the amount removed.
		local amount = PLUGIN:removeDecal(position, tonumber(arguments[1]))

		-- Tell the player how many texts got removed.
		return L("decalRemoved", client, amount)
	end
})