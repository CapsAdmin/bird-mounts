ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Mount Base"
ENT.Author = "CapsAdmin"
ENT.Information = "A base for the bird mounts."
ENT.Category = "CapsAdmin"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )   
    self.AutomaticFrameAdvance = bUsingAnim
end

if CLIENT then
	--local PigeonMount
	function ENT:Initialize()
		self:SetRenderBounds(Vector(-500,-500,-500),Vector(500,500,500))
		self:SetModelScale(Vector(10,10,10))
	end
		
	local SmoothPosition = Vector(0,0,0)
	hook.Remove("CalcView", "MountCalcView")
	hook.Add("CalcView", "MountCalcView", 
	function(Player, Position, Angles, FOV)
		local r,g,b,a = LocalPlayer():GetColor()
		if Player:GetNWBool("Thirdperson") then
			local Vehicle = Player:GetNWEntity("MountEntity")
			local Offset = (Vehicle:GetForward() * -200) + (Vehicle:GetUp() * 150)
			SmoothPosition = SmoothPosition + ((Position + Offset) - SmoothPosition) / 30
			Angles = (Vehicle:GetPos() - SmoothPosition):Angle()
			LocalPlayer():SetColor(Color(r,g,b,0))
			return GAMEMODE:CalcView(Player, SmoothPosition, Angles, FOV)
		else
			LocalPlayer():SetColor(Color(r,g,b,a))
		end
	end)

end

hook.Add( "Move", "MountMove", 

function( Player )
	--Debug(Player ,Player:GetNWBool("MountIn"))
	if Player:GetNWBool("InMount")  then
		return true 
	end 
end)