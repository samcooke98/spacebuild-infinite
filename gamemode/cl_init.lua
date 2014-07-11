include( "shared.lua" )
--print("CL_init!")

include("/classes/Planet.lua")


--local disabled = true
local disabled = false
function GM:PreDrawSkyBox( )
	print("hmmm")
	render.MaterialOverride(Material("spawnicons/models/beer/wiremod/gate_e2.png", "noclamp smooth" ))
end

hook.Add("CellRender", "Planet Rendering", function()
	--
	--Is the player in a planet?
	if disabled then return end
	local plyPlanet = nil
	for k,v in pairs(GAMEMODE.planets) do
		--PrintTable(GAMEMODE.planets[k])
		if (GAMEMODE.planets[k]:IsIn(LocalPlayer())) then
			plyPlanet = GAMEMODE.planets[k]
		end
	end
	
	if (plyPlanet == nil) then 
		--print("false")
		return false
	else
		
	
		for k,v in pairs(plyPlanet.Cells) do 
			MapRepeat.DrawCellAbs(v)
		end
		--Get Neighbouring Cells
		nearbyCells = {}
		
		local cell = LocalPlayer().Cell
		
		
		
		--[[
		
		|-----------------------|
		|	7 		3 		5	| 
		|-----------------------|
		|	2		C		1	|
		|-----------------------|
		|	8 		4		6	| 
		|-----------------------|		
		]]--
		nearbyCells[1] = Vector(cell.x + 1, cell.y + 0, cell.z )
		nearbyCells[2] = Vector(cell.x - 1, cell.y - 0, cell.z )
		
		nearbyCells[3] = Vector(cell.x + 0, cell.y + 1, cell.z )
		nearbyCells[4] = Vector(cell.x - 0, cell.y - 1, cell.z )
		
		nearbyCells[5] = Vector(cell.x + 1, cell.y + 1, cell.z )
		nearbyCells[6] = Vector(cell.x + 1, cell.y - 1, cell.z )
		
		nearbyCells[7] = Vector(cell.x - 1, cell.y + 1, cell.z )
		nearbyCells[8] = Vector(cell.x - 1, cell.y - 1, cell.z )		
		
		--Figure out which ones are good
		plyPlanet.Height = 2
		plyPlanet.Width = 4
		local newX = 0
		local newY =0
		for k,v in pairs(nearbyCells) do 
			if v ~= nil then
				if not (v:WithinAABox(plyPlanet.Cells[1], table.GetLastValue(plyPlanet.Cells))) then
					newX = v.x
					newY = v.y
					if ( v.y > cell.y and cell.x == v.x) then
						--Key 3
						MapRepeat.DrawCellAbsSE(Vector(	v.x						, v.y - plyPlanet.Height, v.z ), AbsToRel(v) )
					
					elseif (v.y < cell.y and cell.x == v.x) then 
						--Key 4
						MapRepeat.DrawCellAbsSE(Vector(	v.x						, v.y + plyPlanet.Height, v.z ), AbsToRel(v) )
					
					elseif (v.x > cell.x and cell.y == v.y) then
						--Key 1 
						MapRepeat.DrawCellAbsSE(Vector(	v.x - plyPlanet.Width	, v.y, v.z ), AbsToRel(v) )
					
					elseif (v.x < cell.x and cell.y == v.y) then
						--Key 2
						MapRepeat.DrawCellAbsSE(Vector(v.x + plyPlanet.Width	, v.y, v.z), AbsToRel(v))
					
					
					--Start of Corner Picese
					elseif (v.x > cell.x and v.y > cell.y) then 
						--Key: 5
						local newX = v.x
						local newY = v.y
						if (v.x <= plyPlanet.Cells[1].x  and v.x >= table.GetLastValue(plyPlanet.Cells).x) or (v.x >= plyPlanet.Cells[1].x  and v.x <= table.GetLastValue(plyPlanet.Cells).x) then
							--X is in the planet
							newX = v.x
						else --X isn't in the planet
							newX = v.x - plyPlanet.Width 
						end
						if (v.y <= plyPlanet.Cells[1].y  and v.y >= table.GetLastValue(plyPlanet.Cells).y) or (v.y >= plyPlanet.Cells[1].y  and v.y <= table.GetLastValue(plyPlanet.Cells).y) then
							--X is in the planet
							newY = v.y
						else --X isn't in the planet
							newY = v.y - plyPlanet.Height 
						end
						MapRepeat.DrawCellAbsSE(Vector(newX, newY, v.z), AbsToRel(v))	
					
					elseif (v.x > cell.x and v.y < cell.y) then 
						--Key: 6
						if (v.x <= plyPlanet.Cells[1].x  and v.x >= table.GetLastValue(plyPlanet.Cells).x) or (v.x >= plyPlanet.Cells[1].x  and v.x <= table.GetLastValue(plyPlanet.Cells).x) then
							--X is in the planet
							newX = v.x
						else --X isn't in the planet
							newX = v.x - plyPlanet.Width 
						end
						if (v.y <= plyPlanet.Cells[1].y  and v.y >= table.GetLastValue(plyPlanet.Cells).y) or (v.y >= plyPlanet.Cells[1].y  and v.y <= table.GetLastValue(plyPlanet.Cells).y) then
							--X is in the planet
							newY = v.y
						else --X isn't in the planet
							newY = v.y + plyPlanet.Height 
						end
						
						MapRepeat.DrawCellAbsSE(Vector(	newX, newY, v.z), AbsToRel(v))
					
					elseif (v.x < cell.x and v.y < cell.y) then 
						--Key; 8 
						if (v.x <= plyPlanet.Cells[1].x  and v.x >= table.GetLastValue(plyPlanet.Cells).x) or (v.x >= plyPlanet.Cells[1].x  and v.x <= table.GetLastValue(plyPlanet.Cells).x) then
							--X is in the planet
							newX = v.x
						else --X isn't in the planet
							newX = v.x + plyPlanet.Width 
						end
						if (v.y <= plyPlanet.Cells[1].y  and v.y >= table.GetLastValue(plyPlanet.Cells).y) or (v.y >= plyPlanet.Cells[1].y  and v.y <= table.GetLastValue(plyPlanet.Cells).y) then
							--X is in the planet
							newY = v.y
						else --X isn't in the planet
							newY = v.y + plyPlanet.Height 
						end
						MapRepeat.DrawCellAbsSE(Vector(newX	, newY, v.z), AbsToRel(v))
					
					elseif (v.x < cell.x and v.y > cell.y) then
						--Key: 7
						if (v.x <= plyPlanet.Cells[1].x  and v.x >= table.GetLastValue(plyPlanet.Cells).x) or (v.x >= plyPlanet.Cells[1].x  and v.x <= table.GetLastValue(plyPlanet.Cells).x) then
							--X is in the planet
							newX = v.x
						else --X isn't in the planet
							newX = v.x + plyPlanet.Width 
						end
						if (v.y <= plyPlanet.Cells[1].y  and v.y >= table.GetLastValue(plyPlanet.Cells).y) or (v.y >= plyPlanet.Cells[1].y  and v.y <= table.GetLastValue(plyPlanet.Cells).y) then
							--X is in the planet
							newY = v.y
						else --X isn't in the planet
							newY = v.y - plyPlanet.Height 
						end
						MapRepeat.DrawCellAbsSE(Vector(newX	, newY, v.z), AbsToRel(v))
					else
						
					end
				else
					--print("V: "..tostring(v).." is in the planet!") 
					MapRepeat.DrawCellAbs(v)
				end
			end
		end
	end
	return true
end)





--Gravity Hull
GravHull = {}
local GH = GravHull

include( "/gravityhull/cl_main.lua" )

include( "/gravityhull/sh_codetools.lua" )
include( "/gravityhull/sh_entityoverrides.lua" )
include( "/gravityhull/sh_playeroverrides.lua" )



--Map Repeat
MapRepeat = {}
include( "/maprepeat/cl_main.lua" )
include( "/maprepeat/sh_main.lua" )




--HUD Stuff
noDraw = {
"CHudHealth", 
"CHudBattery", 
"CHudAmmo", 
"CHudSecondaryAmmo"
}

function GM:HUDShouldDraw( element )
	for _,v in pairs(noDraw) do 
		if (v == element) then return false end
	end
	return true
end


function GM:HUDWeaponPickedUp( weap )
	--We should do some call wireframe shit with the weapon here. 
	-- But later
end