GM.planets = {} -- This is a table of every planet that is currently created.
local GM = GM or GAMEMODE

if SERVER then 
PlanetManager = {}

	function PlanetManager.RegisterPlanet( name, args, ... ) 
		GM.planets[name] = Planet.Create(name, args, ...)
		return GM.planets[name]
	end

		--TODO: Send to the client
	function PlanetManager.SendPlanets( client ) 
		net.Start( "SendPlanets" )
			--print("Transmitting Planets")
			----printTable(GM.planets)
			net.WriteTable(GM.planets)
		net.Send( client ) 

	end
	
	function PlanetManager.FindPlanetByCell( oldCell )
		for k,newCell in pairs(GM.planets) do 
			if( oldCell:WithinAABox(table.GetFirstValue(newCell.Cells), table.GetLastValue(newCell.Cells) +Vector(0,0,1) ) ) then 
				print("Found a planet!")	
				return newCell
			end
		end
	end
	
	hook.Add("PlayerInitialSpawn", "Send Planet Information to the Client", function( ply ) 
		PlanetManager.SendPlanets( ply )
	end) 
	
	hook.Add("PlayerSetCell", "Planet Managing", function(ent, newCell, oldCell) 
		if (oldCell == nil) then 
			return
		end 
		oldCell = ent.Cells[1]
		newCell = util.StringToType(newCell, "Vector")
		oldCell = util.StringToType(oldCell, "Vector")

		--Find out what planet the player is in
		local planet = ent.planet
		if (newCell.z > oldCell.z and planet ~= nil) then 
			print("Making player exit planet, Calling Now")
			return planet:Exit( ent )
		end
		
		if planet == nil then return end
			
		if not (newCell:WithinAABox(table.GetFirstValue(planet.Cells), table.GetLastValue(planet.Cells))) then
			print("Line 51")
			print("NewCell = "..tostring(newCell.z))
			print("OldCell = "..tostring(oldCell.z))
			print("Is Greater than? "..tostring((tonumber(newCell.z) > tonumber(oldCell.z))))
		
			
			if ( newCell.x < oldCell.x and newCell.y == oldCell.y ) then
				return Vector(newCell.x + planet.Width, newCell.y, newCell.z)
			elseif ( newCell.y > oldCell.y and oldCell.x == newCell.x) then
				return (Vector(newCell.x, newCell.y - planet.Height, newCell.z ) )
			elseif (newCell.y < oldCell.y and oldCell.x == newCell.x) then 
				return (Vector(newCell.x, newCell.y + planet.Height, newCell.z ) )
			elseif (newCell.x > oldCell.x and oldCell.y == newCell.y) then
				return (Vector(newCell.x - planet.Width, newCell.y, newCell.z ) )
			else		
				
				
			end
		
						
		else
			planet:Exit(ent)
			return
		end
	end)
end




if CLIENT then 

	net.Receive( "SendPlanets", function( length, client )
		--print("Recieved Planets.. Processing!") 
			GM.planets = net.ReadTable()
			for k,newCell in pairs(GM.planets) do 
				setmetatable( newCell, Planet )
			end
		--print("Done!") 
		--printTable(GM.planets)
	end)

end