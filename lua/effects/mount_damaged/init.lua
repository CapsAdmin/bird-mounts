-- Chicken pain effect
-- By Teta_Bonita, modified by capsadmin
local effectData
function EFFECT:Init( data )
	effectData = data
	local Pos = data:GetOrigin()
	local Entity = data:GetEntity()
	if not ValidEntity(Entity) then return end
	local FeatherAmmount = data:GetScale()
	local color
	self.DamagePos = (effectData:GetOrigin() - Entity:GetPos())
	self.BloodTimer = 255
	
	
	if Entity:GetClass() == "mount_pigeon" then
		color = Color(160, 155, 115)
	elseif Entity:GetClass() == "mount_crow" then
		color = Color(20,20,20)
	elseif Entity:GetClass() == "mount_seagull" then
		color = Color(200,200,200)
	end
	self.emitter2D = ParticleEmitter( Pos, false )
	local emitter3D = ParticleEmitter( Pos, true )

	-- Emit feathers
	for i = 1,FeatherAmmount do
		
		local norm = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -0.3, 1 ) ):GetNormalized()
		local size = math.Rand( 10, 20 )
		
		local particle = emitter3D:Add( "particles/feather", Pos + norm * 3 )
		particle:SetDieTime( math.Rand( 2, 2.5 ) )
		particle:SetVelocity( norm * math.Rand( 150, 300 ) )
		particle:SetAirResistance( 400 )
		particle:SetGravity( Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), -300 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.1 )
		particle:SetAngles( VectorRand():Angle() )
		particle:SetAngleVelocity( VectorRand() * 150 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( size )
		particle:SetEndSize( size )
		particle:SetColor( color.r, color.g, color.b )
	
	end
	
end


function EFFECT:Think()
	if not self.BloodTimer then return end
	self.BloodTimer = self.BloodTimer - 0.5
	local Entity = effectData:GetEntity()
	if not ValidEntity(Entity) then return end
	local size = math.Rand( 1, 5 )
	local particle = self.emitter2D:Add( "effects/blood2", Entity:GetPos() + self.DamagePos  )
	particle:SetDieTime( math.Rand( 2, 2.5 ) )
	particle:SetVelocity( VectorRand() * math.Rand( 15, 30 ) )
	particle:SetGravity( Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), -300 ) )
	particle:SetCollide( true )
	particle:SetBounce( 0.1 )
	particle:SetAngles(Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)))
	particle:SetStartAlpha( self.BloodTimer )
	particle:SetStartSize( size )
	particle:SetEndSize( size )
	particle:SetColor( 220, 20, 30 )
	if self.BloodTimer < 1 then self.emitter2D:Finish() return false else return true end 
	return false
end


function EFFECT:Render()

end

