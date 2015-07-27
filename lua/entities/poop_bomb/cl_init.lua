
include( 'shared.lua' )

ENT.Mat = "effects/blood_core"

function ENT:Initialize()

	language.Add( "poop_bomb", "Poop" )

	//sound
	self.Sound = CreateSound( self.Entity, "NPC_Antlion.PoisonBall" )
	self.Sound:Play()
	
end
function ENT:Draw()
	self:SetModelScale( Vector(5,5,self:GetVelocity().z / 100) )
	self:DrawModel()
end

function ENT:Think()

	if ( ValidEntity( LocalPlayer() ) ) then
	
		local ply = LocalPlayer()
		local dir = ( ply:GetPos() - self.Entity:GetPos() ):Normalize()
		
		local rec = ply:GetPos():Dot( dir )
		local trans = -rec
				
		local pitch = 100 * ( ( 1 - rec / 13049 ) / ( 1 + trans / 13049 ) )
		pitch = math.Clamp( pitch, 50, 250 )

		self.Sound:ChangePitch( pitch, 0.1 )

	end

end

function ENT:OnRemove()

	self.Sound:FadeOut( 0.1 )
	
end
