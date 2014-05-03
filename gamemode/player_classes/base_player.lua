AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 


PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400

PLAYER.PlayerColor			= Vector( "0.24 0.34 0.41" )	
PLAYER.WeaponColor 			= Vector( "0.30 1.80 2.10" )

PLAYER.Model 				= "corpse"

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	
    self.Player:GiveAmmo( 256,	"Pistol", 		true )
    self.Player:GiveAmmo( 256,	"SMG1", 		true )
    self.Player:GiveAmmo( 5,	"grenade", 		true )
    self.Player:GiveAmmo( 64,	"Buckshot", 	true )
    self.Player:GiveAmmo( 32,	"357", 			true )
    self.Player:GiveAmmo( 32,	"XBowBolt", 	true )
    self.Player:GiveAmmo( 6,	"AR2AltFire", 	true )
    self.Player:GiveAmmo( 100,	"AR2", 			true )

    self.Player:Give( "weapon_crowbar" )
    self.Player:Give( "weapon_pistol" )
    self.Player:Give( "weapon_smg1" )
    self.Player:Give( "weapon_frag" )
    self.Player:Give( "weapon_physcannon" )
    self.Player:Give( "weapon_crossbow" )
    self.Player:Give( "weapon_shotgun" )
    self.Player:Give( "weapon_357" )
    self.Player:Give( "weapon_rpg" )
    self.Player:Give( "weapon_ar2" )

    self.Player:Give( "weapon_physgun" )

    self.Player:SwitchToDefaultWeapon()
end

function PLAYER:Spawn()
	BaseClass.Spawn(self);
	
	self.Player:SetPlayerColor( self.PlayerColor )
	self.Player:SetWeaponColor( self.WeaponColor )
end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

end

function PLAYER:GetHandsModel()
	return { model = "models/weapons/c_arms_citizen.mdl", skin = 1, body = "0000000" }
end

function PLAYER:SetModel()
	
	local modelname = player_manager.TranslatePlayerModel( self.Model )
	util.PrecacheModel( modelname )
	self.Player:SetModel( modelname )
end
--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

end

player_manager.RegisterClass( "player_sb_base", PLAYER, "player_default" )