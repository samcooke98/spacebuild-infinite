GM.Name 	= "Spacebuild Infinite"
GM.Author 	= "Samuel Cooke"
GM.Email 	= "Don't" 


--			--
-- Includes --
--			--
include("/player_classes/base_player.lua")
include("/player_classes/human_player.lua")

include("sh_planetmanager.lua")




--Functions
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_sb_human" )
	--print("A player has spawned");
	
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )

	ply:UnSpectate()
	--Call the player loadout hook
	hook.Call( "PlayerLoadout", GAMEMODE, ply )

	--Set player model with the hook
	hook.Call( "PlayerSetModel", GAMEMODE, ply )
	
	ply:SetupHands();
end

local noPhysgunEnts = {
	"func_brush", "sbi_planet"
}

function GM:PhysgunPickup( ply, ent) 
	if (ent:GetClass() == "player" and not ply:IsAdmin()) then
		return false;
	end
	for k,v in pairs(noPhysgunEnts) do
		if ( ent:GetClass() == v) then
			return false
		end
	end
	return true
end

