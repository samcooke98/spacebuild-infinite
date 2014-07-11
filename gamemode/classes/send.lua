local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"class.lua",
	"Planet.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end