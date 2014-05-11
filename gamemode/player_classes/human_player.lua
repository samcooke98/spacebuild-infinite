AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )
--Human Race Class
local PLAYER = {}

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400

-- Set a Race specific colour, this will be used as an identifier
PLAYER.RaceColor			= Color(20,120,225,200)
PLAYER.PlayerColor          = Vector( 20/255, 120/255, 225/255 )
PLAYER.WeaponColor          = Vector( "0.30 1.80 2.10" )

-- Specify variable to store Race name
PLAYER.RaceName				= "Human"
PLAYER.Model				= "male01"

player_manager.RegisterClass( "player_sb_human", PLAYER, "player_sb_base" )
