
--Include files here
include("shared.lua")




--Add Clientside files here
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )



--Gravity Hull 
GravHull = {}
local GH = GravHull
print("Initialising Gravity Hull")
include( "/gravityhull/sv_main.lua" )
include( "/gravityhull/sv_overrides.lua" )

include( "/gravityhull/sh_codetools.lua" )
include( "/gravityhull/sh_entityoverrides.lua" )
include( "/gravityhull/sh_playeroverrides.lua" )

AddCSLuaFile( "/gravityhull/sh_codetools.lua" )
AddCSLuaFile( "/gravityhull/sh_entityoverrides.lua" )
AddCSLuaFile( "/gravityhull/sh_playeroverrides.lua" )

AddCSLuaFile( "/gravityhull/cl_main.lua" )

--Map Repeat
MapRepeat = {}

include("/maprepeat/sv_main.lua")
include("/maprepeat/sh_main.lua")

AddCSLuaFile( "/maprepeat/sh_main.lua" )
AddCSLuaFile( "/maprepeat/cl_main.lua" )