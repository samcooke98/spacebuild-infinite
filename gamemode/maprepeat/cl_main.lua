MapRepeat.CelledEnts = MapRepeat.CelledEnts or {}
MapRepeat.Hooks = {}

--This function installs all the hooks, cause Llama's cool like that :) - Sam 
function MapRepeat.AddHook(a,b,c)
	MapRepeat.Hooks[a] = MapRepeat.Hooks[a] or {}
	MapRepeat.Hooks[a][b] = c
end

function MapRepeat.InstallHooks()
	for a,t in pairs(MapRepeat.Hooks) do
		for b,c in pairs(t) do
			--print("Hook: "..a..". Unique ID: "..b);
			hook.Add(a,b,c)
		end
	end
end

--Clientside Setup 
usermessage.Hook("maprepeat_install",function(um)
	MapRepeat.InstallHooks()
end)
usermessage.Hook("maprepeat_uninstall",function(um)
	MapRepeat = nil
end)
usermessage.Hook("maprepeat_num",function(um)
	local k = um:ReadString()
	MapRepeat.Sync[k] = um:ReadFloat()
end)


usermessage.Hook("maprepeat_rgen",function(um)
	--print("Map Repeat RGen");
	local k = um:ReadShort()
	if IsValid(Entity(k)) then k = Entity(k) end
	local rg = {}
	local sz = um:ReadShort()
	rg.r = um:ReadShort()
	local i
	for i=1,sz do
		rg[i] = {}
		rg[i][1] = um:ReadString()
		rg[i][2] = um:ReadString()
		rg[i][3] = um:ReadString()
	end
	MapRepeat.RGen[k] = rg
end)

usermessage.Hook("maprepeat_cell",function(um)
	if !MapRepeat then return end
	local e = um:ReadShort()
	if IsValid(Entity(e)) then e = Entity(e) end
	local c = um:ReadString()
	--print(tostring(e) .. "->CELL: " .. c)
	if type(MapRepeat.CelledEnts[e]) == 'string' then
		MapRepeat.Cells[MapRepeat.CelledEnts[e]][e] = nil
	end
	MapRepeat.Cells[c] = MapRepeat.Cells[c] or {}
	MapRepeat.Cells[c][e] = true
	MapRepeat.CelledEnts[e] = true
end)

--Clientside of Setting Cell
usermessage.Hook("maprepeat_setcell",function(um)
	if !MapRepeat then return end
	local e = um:ReadShort()
	if IsValid(Entity(e)) then e = Entity(e) end
	local c = um:ReadString()
	if type(MapRepeat.CelledEnts[e]) == 'string' then
		MapRepeat.Cells[MapRepeat.CelledEnts[e]][e] = nil
		if IsEntity(e) then
			MapRepeat.Cells[MapRepeat.CelledEnts[e]][e:EntIndex()] = nil
		end
	end
	if (IsEntity(e)) then e.Cell = c end
	MapRepeat.Cells[c] = MapRepeat.Cells[c] or {}
	MapRepeat.Cells[c][e] = true
	MapRepeat.CelledEnts[e] = c
	if e == LocalPlayer() then
		--print("Cell to Array in localplayer()")
		local ct = MapRepeat.CellToArray(c)
		e.Cell = Vector(ct[1],ct[2],ct[3])
		e.CellStr = c
	end
end)

--- Draw a cell.
-- This function draws a cell, defined by the parameter. The vector supplied should be relative 
-- to the cell the player is currently in. 
-- @param vec The Cell Vector to be drawn, relative to the current Cell. 
function MapRepeat.DrawCellVec(vec)
	MapRepeat.DrawCell(vec.x, vec.y, vec.z ) 
end

--- Draw a cell.
-- This function draws a cell, defined by the parameter. The vector supplied is an absolute vector of the cell.
-- @param vec The Cell Vector to be draw, absolute to the cell coordinate system. 
function MapRepeat.DrawCellAbs(vec)
	local currentCell = LocalPlayer().Cell
	----print(type(currentCell))
	--print("Current Cell"..tostring(currentCell))
	relative = Vector(vec.x - currentCell.x, vec.y - currentCell.y, vec.z - currentCell.z)
	--print("Relative"..tostring(relative))
	MapRepeat.DrawCellVec(relative)
end
--CELLWhereToDraw

function AbsToRel( AbsCell ) 
	local currentCell = LocalPlayer().Cell
	relative = Vector(AbsCell.x - currentCell.x, AbsCell.y - currentCell.y, AbsCell.z - currentCell.z)
	return relative
end
debugTable = {}
i = 1
function MapRepeat.DrawCellAbsSE( cellToDraw, cellWhereToDraw ) 
	if (i == 16) then i = 1 end  
	debugTable[i] = { cellToDraw, cellWhereToDraw }
	i = i +1 
	
	
	local currentCell = LocalPlayer().Cell
	----print(type(currentCell))
	----print("Current Cell"..tostring(currentCell))
	relative = Vector(cellToDraw.x - currentCell.x, cellToDraw.y - currentCell.y, cellToDraw.z - currentCell.z)
	--print("Relative"..tostring(relative))
	--print("Where: " ..tostring(cellWhereToDraw))
	MapRepeat.DrawCellAt(relative, cellWhereToDraw)
end
function MapRepeat.DrawCellAt( cellToDraw, cellWhereToDraw ) 
	local x = cellToDraw.x
	local y = cellToDraw.y
	local z = cellToDraw.z
	
	local s = MapRepeat.Sync
	local l,r,t,b,u,d = s.left, s.right, s.top, s.bottom, s.up, s.down
	local w = (r or 0) - (l or 0)
	local h = (b or 0) - (t or 0)
	local v = (u or 0) - (d or 0)
	if s.tilemap == 1 then
		local e = Entity(0)
		e:SetRenderOrigin(Vector(x*w,y*h,z*v))
		e:DrawModel()
		--e:SetRenderOrigin(vector_origin)
	end
	local pl = LocalPlayer()
	if !pl.Cell then 
		pl.Cell = Vector(0,0,0) 
		pl.CellStr = "0 0 0"
	end
	cam.Start3D(RealEyePos()-Vector( cellWhereToDraw.x * w, cellWhereToDraw.y * h, cellWhereToDraw.z * v ),RenderAngles())
		local c = (x+pl.Cell.x)..' '..(y+pl.Cell.y)..' '..(z+pl.Cell.z)--[[
		--print("Cell:"..c)
		--print("Real Eye Pos:"..tostring(RealEyePos()))
		--print("Eye Pos:"..tostring(EyePos()))
		]]--
		--print("Eye pos - Vec = "..tostring(RealEyePos()-Vector( cellWhereToDraw.x * w, cellWhereToDraw.y * h, cellWhereToDraw.z * v )))
		if !(MapRepeat.Cells[c] and MapRepeat.Cells[c].gen) then
			MapRepeat.GenCell(c)
		end
		for k,v in pairs(MapRepeat.Cells[c]) do
			if tonumber(k) and IsValid(Entity(tonumber(k))) then
				MapRepeat.Cells[c][Entity(tonumber(k))] = v
			end
			if k == NULL then
				MapRepeat.Cells[c][k] = nil
			end
		end
		for k,v in pairs(MapRepeat.Cells[c]) do
			if tonumber(k) == 'number' and IsValid(Entity(tonumber(k))) then
				MapRepeat.Cells[c][k] = nil
				k = Entity(k)
			end
			if type(k) == 'Entity' and IsValid(k) and v then
				----print("Drawing: "..tostring(k));
				(k.Draw or k.DrawModel)(k)
				if k.MRNoDraw then
					k:SetNoDraw(false)
					k.MRNoDraw = false
				end
			end
		end
		--render.DrawWireframeSphere(Vector(0,0,0), 100, 100, [255,255,255,255])
	cam.End3D()
end

function MapRepeat.DrawCell(x,y,z)
	-- Are X,Y,Z relative to the original cell 
	----print("Drawing Cell @ "..x.." "..y.." "..z.."\n");
	local s = MapRepeat.Sync
	local l,r,t,b,u,d = s.left, s.right, s.top, s.bottom, s.up, s.down
	local w = (r or 0) - (l or 0)
	local h = (b or 0) - (t or 0)
	local v = (u or 0) - (d or 0)
	if s.tilemap == 1 then
		local e = Entity(0)
		e:SetRenderOrigin(Vector(x*w,y*h,z*v))
		e:DrawModel()
		--e:SetRenderOrigin(vector_origin)
	end
	local pl = LocalPlayer()
	if !pl.Cell then 
		pl.Cell = Vector(0,0,0) 
		pl.CellStr = "0 0 0"
	end
	cam.Start3D(RealEyePos()-Vector(x*w,y*h,z*v),RenderAngles())
		render.PopCustomClipPlane()
		
		local c = (x+pl.Cell.x)..' '..(y+pl.Cell.y)..' '..(z+pl.Cell.z)--[[
		--print("Cell:"..c)
		--print("Real Eye Pos:"..tostring(RealEyePos()))
		--print("Eye Pos:"..tostring(EyePos()))
		--print("Eye pos - Vec = "..tostring(RealEyePos()-Vector(x*w,y*h,z*v)))]]--
		--print("2nd Eye pos - Vec = "..tostring(RealEyePos()-Vector(x*w,y*h,z*v)))
		if !(MapRepeat.Cells[c] and MapRepeat.Cells[c].gen) then
			MapRepeat.GenCell(c)
		end
		for k,v in pairs(MapRepeat.Cells[c]) do
			if tonumber(k) and IsValid(Entity(tonumber(k))) then
				MapRepeat.Cells[c][Entity(tonumber(k))] = v
			end
			if k == NULL then
				MapRepeat.Cells[c][k] = nil
			end
		end
		for k,v in pairs(MapRepeat.Cells[c]) do
			if tonumber(k) == 'number' and IsValid(Entity(tonumber(k))) then
				MapRepeat.Cells[c][k] = nil
				k = Entity(k)
			end
			if type(k) == 'Entity' and IsValid(k) and v then
				----print("Drawing: "..tostring(k));
				(k.Draw or k.DrawModel)(k)
				if k.MRNoDraw then
					k:SetNoDraw(false)
					k.MRNoDraw = false
				end
			end
		end
		--render.DrawWireframeSphere(Vector(0,0,0), 100, 100, [255,255,255,255])
	cam.End3D()
end


local ignored_ents = {}
ignored_ents["viewmodel"] = true
ignored_ents["class CLuaEffect"] = true
MapRepeat.AddHook("RenderScene","SL_MRScene",function()
	
	local pl = LocalPlayer()
	if !pl.Cell then 
		--print("0 0 0 Spot");
		pl.Cell = Vector(0,0,0) 
		pl.CellStr = "0 0 0"
	end
	if !(MapRepeat.Cells[pl.CellStr] and MapRepeat.Cells[pl.CellStr].gen) then
		--print("GenCell Called")
		MapRepeat.GenCell(pl.CellStr)
	end
	for _,e in pairs(ents.GetAll()) do
		if !ignored_ents[e:GetClass()] and (e:GetOwner() != LocalPlayer() or e:GetClass() != "physgun_beam") then
			if !(MapRepeat.CelledEnts[e] or MapRepeat.CelledEnts[e:EntIndex()] or MapRepeat.RGen[e] or MapRepeat.RGen[e:EntIndex()]) then
				MapRepeat.Cells["0 0 0"][e] = true
				MapRepeat.CelledEnts[e] = "0 0 0"
			elseif MapRepeat.CelledEnts[e:EntIndex()] then
				local old = MapRepeat.CelledEnts[e:EntIndex()]
				MapRepeat.CelledEnts[e:EntIndex()] = nil
				MapRepeat.CelledEnts[e] = old
			end
			if MapRepeat.CelledEnts[e] or MapRepeat.RGen[e] or MapRepeat.RGen[e:EntIndex()] then
				if !(MapRepeat.Cells[pl.CellStr][e] or MapRepeat.Cells[pl.CellStr][e:EntIndex()]) then
					e:SetNoDraw(true)
					e.MRNoDraw = true
				elseif e.MRNoDraw then
					e:SetNoDraw(false)
					e.MRNoDraw = false
				end
			end
		end
	end
end)

--- This hooks allows for custom rendering of the infinite map's cells. 
-- @name CellRender
-- @class hook 
-- @return Boolean. If true, InfinteMaps will not render anything and instead rely on you to during this hook.  
--[[
hook.Add("CellRender", "Testing", function()
	MapRepeat.DrawCellAbsSE(Vector(0,0,-1), Vector(0,0,1) )
	
	return true
end)]]--

MapRepeat.AddHook("PostDrawOpaqueRenderables","SL_MRDraw",function()
	if (hook.Call("CellRender") or false) ~= true then 
		local s = MapRepeat.Sync
		--[[ This here is deprecated, as the sync table does not contain a cube function. I suspect this as something to do with infinitely repeating maps where each cell is the same!
		if (tonumber(s.cube) or 0) > 0 then
			--print("HERE!")
			for x = -s.cube,s.cube do
				for y = -s.cube,s.cube do
					for z = -s.cube,s.cube do
						if !(x == 0 && y == 0 && z == 0) then
							--print("HERE! Line 169")
							MapRepeat.DrawCell(x,y,z)
						end
					end
				end
			end
			return
		end
		]]--
		
		local l,r,t,b,u,d = s.left, s.right, s.top, s.bottom, s.up, s.down
		--sides
		if l then MapRepeat.DrawCell(-1,0,0) end
		if r then MapRepeat.DrawCell(1,0,0) end
		if t then MapRepeat.DrawCell(0,-1,0) end
		if b then MapRepeat.DrawCell(0,1,0) end
		if u then MapRepeat.DrawCell(0,0,1) end
		if d then MapRepeat.DrawCell(0,0,-1) end
		--2D corners (XY)
		if l and t then MapRepeat.DrawCell(-1,-1,0) end
		if r and t then MapRepeat.DrawCell(1,-1,0) end
		if l and b then MapRepeat.DrawCell(-1,1,0) end
		if r and b then MapRepeat.DrawCell(1,1,0) end
		--2D corners (XZ)
		if l and d then MapRepeat.DrawCell(-1,0,-1) end
		if r and d then MapRepeat.DrawCell(1,0,-1) end
		if l and u then MapRepeat.DrawCell(-1,0,1) end
		if r and u then MapRepeat.DrawCell(1,0,1) end
		--2D corners (YZ)
		if l and d then MapRepeat.DrawCell(0,-1,-1) end
		if r and d then MapRepeat.DrawCell(0,1,-1) end
		if l and u then MapRepeat.DrawCell(0,-1,1) end
		if r and u then MapRepeat.DrawCell(0,1,1) end
		--3D corners (+Z)
		if l and t and u then MapRepeat.DrawCell(-1,-1,1) end
		if r and t and u then MapRepeat.DrawCell(1,-1,1) end
		if l and b and u then MapRepeat.DrawCell(-1,1,1) end
		if r and b and u then MapRepeat.DrawCell(1,1,1) end
		--3D corners (-Z)
		if l and t and d then MapRepeat.DrawCell(-1,-1,-1) end
		if r and t and d then MapRepeat.DrawCell(1,-1,-1) end
		if l and b and d then MapRepeat.DrawCell(-1,1,-1) end
		if r and b and d then MapRepeat.DrawCell(1,1,-1) end
	else
		----print("Developer has decided to overwrite the default drawing!")
	end
end)

--[[ TODO: Figure out why this is commented out. 
MapRepeat.AddHook("ShouldCollide","SL_MRCollideCL",function(e1,e2)
	--print(tostring(e1).." & "..tostring(e2))
	if GravHull.SHIPCONTENTS[LocalPlayer()] then return end
    if e1 == LocalPlayer() then
		if !(MapRepeat.Cells[e1.CellStr or "0 0 0"]) then return true end
        if !(MapRepeat.Cells[e1.CellStr or "0 0 0"][e2] or MapRepeat.Cells[e1.CellStr or "0 0 0"][e2:EntIndex()]) then return false end
    elseif e2 == LocalPlayer() then
		if !(MapRepeat.Cells[e2.CellStr or "0 0 0"]) then return true end
        if !(MapRepeat.Cells[e2.CellStr or "0 0 0"][e1] or MapRepeat.Cells[e2.CellStr or "0 0 0"][e1:EntIndex()]) then return false end
    end 
end)]]--

--Physgun Control. 
MapRepeat.AddHook("PhysgunPickup","SL_MRPickup",function(pl,e)
	if !(MapRepeat.Cells[pl.CellStr or "0 0 0"][e] or MapRepeat.Cells[pl.CellStr or "0 0 0"][e:EntIndex()]) then return false end
	if MapRepeat.CelledEnts[e] == true then return false end
end)

-- I presume these are some helper functions that Llama uses. 
local VEC = FindMetaTable("Vector")
if !VEC.RealToScreen then VEC.RealToScreen = VEC.ToScreen end
function VEC:ToScreen()
	if !MapRepeat then return self:RealToScreen() end
	local cell,pos = MapRepeat.PosToCell(self)
	return pos:RealToScreen()
end
if !RealEyePos then RealEyePos = EyePos end
function EyePos()
	if !MapRepeat then return RealEyePos() end
	return MapRepeat.CellToPos(RealEyePos(),LocalPlayer().CellStr)
end