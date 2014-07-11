local GM = GM
--print("Planet Class") 
--Class Stuff
Planet = {}
Planet.__index = Planet
if SERVER then print("Planet.lua - Server") end

--Is this entity in the planet?
function Planet:IsIn( ent ) 
		if (ent.Cell.x >= self.Cells[1].x and ent.Cell.x <= self.Cells[table.GetLastKey(self.Cells)].x) then 
			-- In the X
			if (ent.Cell.y >= self.Cells[1].y and ent.Cell.y <= self.Cells[table.GetLastKey(self.Cells)].y) then 
				return true
			end
		end
		return false
end

local function VecToString(vec ) 
	return (tostring(vec.x).." "..tostring(vec.y).." "..tostring(vec.z))
end

function Planet:Teleport( ent )
	--print( tostring (ent ) )
	MapRepeat.SetCell( ent, VecToString( self.Cells[1] ) )
end

function Planet:Exit( ent )
	ent.planet = nil --or ""
	print("Set Planet to Nil!")
	ent.Environment = Space
	
	--TODO: Set the position based on their location in the Planet
	--For now; We're going to randomise their location...
	local s = math.Rand(-math.pi, math.pi) --Or should it be to 0-2pi? 
	local t = math.Rand(-math.pi, math.pi)
	
	plyPos = Vector(
		self.radius * math.cos(s) * math.sin(t) + self.pos.x + 10 , 
		self.radius * math.sin(s) * math.sin(t) + self.pos.y + 10,
		self.radius * math.cos(t) + self.pos.z + 10 )
	print("Teleporting the player to: "..tostring(plyPos))
	print("Set Cell:"..type(self.Cell))
	ent:SetPos(plyPos)
	return MapRepeat.PosToCell(plyPos)
end

function Planet.Create(name, radius, cells, pos) 
	local plnt = {}
	setmetatable(plnt, Planet)
	plnt.__index = Planet.index
	plnt.name = name
	plnt.Cells = cells
	plnt.Width = 4; -- X Direction
	plnt.Height = 2; -- Y Direction
	plnt.pos = pos
	plnt.radius = radius
	plnt.Cell = MapRepeat.PosToCell(pos) 
	return plnt
end
