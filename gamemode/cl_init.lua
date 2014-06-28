include( "shared.lua" )
print("CL_init!")
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