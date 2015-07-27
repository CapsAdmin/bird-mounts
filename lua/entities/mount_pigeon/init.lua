AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction( Player, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos
	local ent = ents.Create( self.MountType )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end