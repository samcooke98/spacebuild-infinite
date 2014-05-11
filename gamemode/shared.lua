GM.Name 	= "Spacebuild Infinite"
GM.Author 	= "Samuel Cooke"
GM.Email 	= "Don't" 


--			--
-- Includes --
--			--
include("/player_classes/base_player.lua")
include("/player_classes/human_player.lua")

--Functions
function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_sb_human" )
	print("A player has spawned");
	
	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )

	ply:UnSpectate()
	--Call the player loadout hook
	hook.Call( "PlayerLoadout", GAMEMODE, ply )

	--Set player model with the hook
	hook.Call( "PlayerSetModel", GAMEMODE, ply )
	
	ply:SetupHands();
end

function GM:PhysgunPickup( ply, ent) 
	if (ent:GetClass() == "func_brush" or (ent:GetClass() == "player" and not ply:IsAdmin())) then
		return false;
	else
		return true; -- Not complete yet
	end
end