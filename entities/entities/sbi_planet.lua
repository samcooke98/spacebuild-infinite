AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

local GM = GAMEMODE

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Radius") 
	self:NetworkVar( "Float", 1, "LongSteps") 
	self:NetworkVar( "Float", 2, "LatSteps") 
end

function ENT:KeyValue( key, value )
	if key == "Radius" then
		self:SetRadius( value ) 
	elseif key == "longSteps" then
		self:SetLongSteps( value ) 
	elseif key == "latSteps" then
		self:SetLatSteps( value ) 
	elseif key == "PlanetCell1" then
		print("Key:"..key)
		self.cell1 = util.StringToType( value, "Vector" )
	elseif key == "PlanetCell2" then 
		self.cell2 = util.StringToType( value, "Vector" )
	elseif key == "Name" then
		self.name = value
	else
	end
end

function ENT:InitializePlanet() 
	if SERVER then 
		local cells = {}
		--Calculate Cells;
		for i = self.cell1.x, self.cell2.x do 
			for j = self.cell1.y, self.cell2.y do 
				table.insert(cells, Vector(i, j, self.cell1.z))
			end
		end
		print("Cells:")
		PrintTable(cells)

		self.planet = PlanetManager.RegisterPlanet( self.name or "Test", self.Radius, cells, self:GetPos() ) 
		self.planet2 = PlanetManager.RegisterPlanet( self.name or "Test2", self.Radius, cells, self:GetPos() )
		print("planet created!")
	end
	
	--self.planet = Planet.create("Test") 
end

function ENT:Initialize()
	self.Radius = self:GetRadius()
	self.longSteps = self:GetLongSteps()
	self.latSteps = self:GetLatSteps()
	
	if CLIENT then self:SetRenderBounds(  Vector(-self.Radius,-self.Radius,-self.Radius), Vector(self.Radius,self.Radius,self.Radius) ) end
	if SERVER then 
		self:SetMoveType( MOVETYPE_NONE ) -- We don't want these planets to move
		self:SetSolid( SOLID_CUSTOM ) -- We want people to be able to pass through it...

		self:PhysicsInitSphere( self.Radius ) -- Create a standard physics sphere
		self:SetCollisionBounds( Vector(-self.Radius, -self.Radius, -self.Radius ), Vector( self.Radius, self.Radius, self.Radius ) ) 
		self:GetPhysicsObject():EnableMotion( false ) -- DON'T MOVE!
		self:DrawShadow( false ) -- That would be bad.

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			print(phys:IsMoveable())
		end
		self:GetPhysicsObject():EnableMotion( false ) -- DON'T MOVE!

		
	end
	self:InitializePlanet()
end

function ENT:StartTouch( touch )
	self.planet:Teleport(touch)
	touch.planet = self.planet
end

if CLIENT then 
	function ENT:Draw()
		render.SetMaterial( Material("editor/wireframe") )
		
		--render.SetColorMaterial()
		render.SetMaterial( Material("bynari/moon") )
		render.DrawSphere(self:GetPos(), self.Radius, self.longSteps, self.latSteps, Color(255,255,255,255))
	end
	
end

function ENT:CanTool()
	return false -- So the ent cannot be tooled ( parent, rope etc )
end

function ENT:GravGunPunt()
	return false -- So the player can't move the planet
end

function ENT:GravGunPickupAllowed()
	return false -- So the player can't pick the planet up and run off with it.
end