AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

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
	end
end

function ENT:Initialize()
	print("SB Infinite Planet detected")
	print("Planet Initialising! v2")
	print("Radius: "..self:GetRadius())
	self.Radius = self:GetRadius()
	self.longSteps = self:GetLongSteps()
	self.latSteps = self:GetLatSteps()
	
	self.latSteps = 10
	self.longSteps = 10
	
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
end

function ENT:StartTouch( ent )
	ent:SetPos(Vector(0,0,0))
end




if CLIENT then 
	function ENT:Draw()
		render.SetMaterial( Material("editor/wireframe") )
		
		--render.SetColorMaterial()
		render.SetMaterial( Material("editor/wireframe") )
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