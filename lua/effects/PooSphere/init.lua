EFFECT.Mat = "effects/blood_core"

function EFFECT:Init( data )

	self.Start = data:GetStart()
	self.Normal = data:GetNormal()
	self.Offset = self.Start + ( self.Normal * 2 )
	
	local emitter = ParticleEmitter( self.Start )
	
	for i = 1, math.random( 3, 11 ) do
	
		local poop = emitter:Add( self.Mat, self.Offset )
		
		if ( emitter ) then
		
			poop:SetStartAlpha( math.random( 180, 255 ) )
			poop:SetEndAlpha( math.random( 30, 60 ) )
			poop:SetVelocity( VectorRand() * 50 )
			poop:SetLifeTime( 0 )
			poop:SetDieTime( math.Rand( 1, 1.5 ) )
			poop:SetStartSize( math.Rand( 25, 75 ) )
			poop:SetEndSize( math.Rand( 5, 25 ) )
		
		end
	
	end
	
	emitter:Finish()
	
end

function EFFECT:Think()

	// dies immediately
	return false

end

function EFFECT:Render()

	// this effect is only for particle spawning
	
end