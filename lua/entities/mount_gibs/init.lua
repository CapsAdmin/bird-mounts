AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/Gibs/Strider_Gib" .. math.random(1,7) .. ".mdl" )
	self:SetMaterial("models/flesh")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType(  MOVETYPE_VPHYSICS )   
    self:SetSolid( SOLID_VPHYSICS )
	--self:SetColor( 0,0,0,0 )
    local PhysObj = self:GetPhysicsObject()
    if PhysObj:IsValid() then
        PhysObj:Wake()
		PhysObj:SetVelocity(VectorRand() * 100)
		PhysObj:AddAngleVelocity(VectorRand() * self:BoundingRadius() * 2)
    end
end
 	
function ENT:PhysicsCollide( data )
	if data.HitEntity:IsWorld() then
		self:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", 100, math.Clamp( math.Clamp( (self:BoundingRadius() * 10), 1, 5000 ) * -1 + 255 + math.random(-5, 5), 50, 255 )  )
		self:Fire("kill",1,0.01)
	end
end
