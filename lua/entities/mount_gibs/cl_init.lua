include( "shared.lua" )

function ENT:Initialize()
	self.emitter = ParticleEmitter( self:GetPos(), true )
	self.emitter2 = ParticleEmitter( self:GetPos() )
end

function ENT:Think()
	local color = self:GetNWVector("Color")
	local SIZE = 5
	local particle = self.emitter:Add( "particles/feather", self:GetPos() + (VectorRand() * SIZE)  ) 
	particle:SetVelocity( VectorRand() * SIZE * 30 )
	particle:SetDieTime( 1 )
	particle:SetStartAlpha( 255 )
	particle:SetStartSize( math.Rand( 10, 20 ) )
	particle:SetEndSize( math.Rand( 10, 20 ) )
	particle:SetGravity( Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), -300 ) )
	particle:SetAngles( VectorRand():Angle() )
	particle:SetAngleVelocity( VectorRand() * 150 )
	particle:SetColor(color.x,color.y,color.z)
	particle:SetCollide(true)

	local particle = self.emitter2:Add( "effects/blood2", self:GetPos() + (VectorRand() * SIZE)  ) 
	particle:SetVelocity( VectorRand() * SIZE * 100 )
	particle:SetDieTime( 0.3 )
	particle:SetAirResistance( 1000 )
	particle:SetStartAlpha( 255 )
	particle:SetStartSize( math.Rand( 10, 20 ) )
	particle:SetEndSize( math.Rand( 10, 20 ) )
	particle:SetGravity( Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), -300 ) )
	particle:SetAngles( VectorRand():Angle() )
	particle:SetColor( 220, 20, 30 )
	particle:SetCollide(true)
	return true
end