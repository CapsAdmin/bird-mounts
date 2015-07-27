
AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )

include( 'shared.lua' )


function ENT:SpawnFunction( ply, tr )

	local ent = ents.Create( "poop_bomb" )
	ent:SetPos( tr.HitPos )
	ent:SetOwner( ply )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:Initialize()
	
	self.Entity:SetModel( "models/spitball_large.mdl" )
	self.Entity:PhysicsInit( SOLID_BBOX )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_BBOX )
	self.Entity:SetColor( math.random( 200, 255 ), math.random( 200, 255 ), math.random( 200, 255 ), math.random( 200, 255 ) )
	self.Entity:DrawShadow( true )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ( ValidEntity( phys ) ) then
	
		phys:Wake()
	
	end
		
end

function ENT:PhysicsCollide( data, physobj )
	
	local pos = self:GetPos()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+Vector(0,0,-90)
	local trace = util.TraceLine(tracedata)
	if trace.HitWorld then
		util.Decal("PaintSplatPink",trace.HitPos+trace.HitNormal,trace.HitPos-trace.HitNormal)
	end

	local splash = Sound("physics/flesh/flesh_bloody_impact_hard1.wav")
	
	self:EmitSound(splash,math.random(100,120),math.random(90,110))
	
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect("poopbomb", effectdata)
	
	for i=1,math.random(40,60) do
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector(0,0,20))
		effectdata:SetAngle( (VectorRand() * 1):Angle() )
		util.Effect( "pootrail", effectdata )
	end
	
	for i=1,math.random(1,6) do
		local tracedata = {}
		tracedata.start = self:GetPos()+Vector(0,0,90)
		tracedata.endpos = self:GetPos()+Vector(math.random(-150,150),math.random(-150,150),-90)
		local trace = util.TraceLine(tracedata)
		if trace.Hit then
			local effectdata = EffectData()
			effectdata:SetStart(trace.HitPos)
			effectdata:SetNormal(trace.Normal)
			util.Effect( "poosphere", effectdata )
		end
	end
		
	self:Fire("kill",1,0.01)
	
end

function ENT:Think()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect("poopbomb", effectdata)
	
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() + Vector(0,0,20))
	effectdata:SetAngle( (VectorRand() * 10):Angle() )
	util.Effect( "pootrail", effectdata )
end

function ENT:OnRemove()
	util.BlastDamage(self, self, self:GetPos(), 300, 100)
end