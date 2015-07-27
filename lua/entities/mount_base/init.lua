AddCSLuaFile("shared.lua")
include("shared.lua")

resource.AddFile("materials/particles/feather.vmt")
resource.AddFile("materials/particles/feather.vtf")

CreateConVar("birdmounts_health", 300)

--[[ function Debug(Text)
PrintMessage(HUD_PRINTCONSOLE, tostring(Text))
end ]]

function ENT:Initialize()
	self.SmoothArrive = 3
	self.PlayTakeOff = true
	self.PlayLanding = true
	self.SmoothForward = 0
	self.IsOnOrBeforeGround = 1
	self.SmoothZ = 0
	self.Crashed = false
	self.Thirdperson = true
	self.Accel = 0
	self.AntiPoopSpam = 0
	self.AntiThirdPersonSpam = 0
	self.TimeEntered = 0
	
	
	self:PhysicsInitBox(Vector(-70,-30,0),Vector(50,30,70))
	self:SetModel( self.MountModel )
	self:SetMoveType( MOVETYPE_VPHYSICS	)
	self:StartMotionController()
	
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(10000)
		phys:SetMaterial("flesh")
	end
	
	self.FlapSound = CreateSound(self, "ambient/wind/windgust_strong.wav")
	self.WindSound = CreateSound(self, "vehicles/fast_windloop1.wav")
	self.FlapSound:Play()
	self.WindSound:Play()
	
	self.ThirdPersonCam = ents.Create("prop_dynamic")
	self.ThirdPersonCam:SetModel("models/dav0r/camera.mdl")
	self.ThirdPersonCam:SetPos(self:GetPos() + Vector(0,0,self.ChairOffset))
	self.ThirdPersonCam:SetAngles(self:GetAngles())
	self.ThirdPersonCam:Spawn()
	self.ThirdPersonCam:SetColor(0,0,0,0)
	self.ThirdPersonCam:SetParent(self)
	
	self.HitBox = ents.Create("prop_physics")
	self.HitBox:SetModel("models/props_wasteland/kitchen_fridge001a.mdl")
	self.HitBox:SetPos(self:GetPos() + Vector(0,0,50) + self:GetForward() * - 70)
	self.HitBox:SetAngles(self:GetAngles() + Angle(0,90,90))
	self.HitBox:Spawn()
	constraint.Weld(self, self.HitBox)
	constraint.NoCollide(self, self.HitBox)
	self.HitBox:GetPhysicsObject():SetMass(1)
	self.HitBox:CallOnRemove("MountHitBox", function() self:Remove() end)
	self.HitBox.IsHitBoxMount = true
	self.HitBox.Owner = self
	self.HitBox:GetPhysicsObject():SetMaterial("flesh")
	self.HitBox:SetHealth(GetConVar("birdmounts_health"):GetInt())
	self.HitBox:SetColor(0,0,0,0)
	self.AutomaticFrameAdvance = true
end

function ENT:SpawnFunction( Player, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos
	local ent = ents.Create( self.MountType )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:MountIsOnGround()
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = trace.start + Vector( 0, 0, -2 )
	trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceEntity( trace, self.Entity )
	return tr.HitWorld
end

function ENT:InBeforeGround()
	local trace = {}
	trace.start = self:GetPos() + Vector(0,0,-10)
	trace.endpos = trace.start + Vector( 0, 0, -200 )
	trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceEntity( trace, self.Entity )
	local DownVelocity = util.tobool(math.Clamp(self:GetVelocity().z * -1, 0, 1))
	if DownVelocity and tr.HitWorld then return true end
end

function ENT:OnEnter(Player)
	if not self.In then
		self.Pilot = Player
		self.In = true
		Player:SetOwner(self.HitBox)
		Player:SetMoveType(MOVETYPE_NOCLIP)
		Player:SetAngles(self:GetAngles())
		Player:SetPos(self:GetPos() + Vector(0,0,self.ChairOffset))
		Player:SetNWBool("InMount", true)
		Player:SetNWEntity("MountEntity", self)
		Player:SetParent(self)
		constraint.NoCollide(Player, self)
	elseif self.In then
		self:OnExit()
	end
end

function ENT:Think()
	if math.random(0,500) == 1 then 
		local RandomSound = math.random(1,self.AmmountOfSounds)
		local RandomPitch = math.random(self.PitchMin, self.PitchMax)
		self:EmitSound(self.MountSound .. RandomSound .. ".wav", 100, RandomPitch)
	end
	
	for Index, Entity in pairs(ents.FindInSphere(self:GetPos(), 150)) do
		if Entity:IsPlayer() and Entity:KeyDown(IN_USE) and CurTime() > self.TimeEntered then
			self:OnEnter(Entity)
			self.TimeEntered = CurTime() + 0.2
		end
	end
	
	if ValidEntity(self.Pilot) then
		
		local Bomb = self.Pilot:KeyDown(IN_JUMP)
		
		if Bomb and (CurTime() > self.AntiPoopSpam) then
			self.AntiPoopSpam = CurTime() + 2
			local poop = ents.Create("poop_bomb")
			poop:SetPos(self:GetPos())
			poop:SetVelocity(self:GetVelocity())
			poop:Spawn()
		end
		
		local KeyReleased = self.Pilot:KeyDown(IN_DUCK)
		if KeyReleased and self.Thirdperson and self.AntiThirdPersonSpam <= CurTime() then
			self.Pilot:SetNWBool("Thirdperson", false)
			self.Pilot:SetViewEntity(NULL)
			self.Thirdperson = false
			self.AntiThirdPersonSpam = CurTime() + 0.3
		elseif KeyReleased and not self.Thirdperson and self.AntiThirdPersonSpam <= CurTime() then
			self.Pilot:SetNWBool("Thirdperson", true)
			self.Pilot:SetViewEntity(self.ThirdPersonCam)
			self.Thirdperson = true
			self.AntiThirdPersonSpam = CurTime() + 0.3
		end
		if not ValidEntity(self.Pilot:GetParent()) or not self.Pilot:Alive() then
			self:OnExit()
		end
	end

	
	self:GetPhysicsObject():Wake()
	local Speed = (self:GetVelocity():Length() / 100)
	if self:MountIsOnGround() then
		self.PlayTakeOff = true
		self.FlapSound:ChangeVolume(0)
		self.WindSound:ChangePitch(70)
		self.WindSound:ChangeVolume(self:GetVelocity():Length() / 2000)
		if Speed > 3 then
			self:ResetSequence(self:LookupSequence(self.Run))
			self:SetPlaybackRate(Speed/5)
		end
		if Speed < 3 then 
			self:ResetSequence(self:LookupSequence(self.Walk))
			self:SetPlaybackRate(Speed)
		end
	end
	
	if Speed < 0.1 then
		self:ResetSequence(self:LookupSequence(self.Idle))
		self:SetPlaybackRate(0.5)
		self.FlapSound:ChangeVolume(0)
		self.WindSound:ChangeVolume(0)
	end
	
	local velocity = self:GetVelocity()
	local maxspeed = 700
	local vertvelocity = Vector( 0, 0, velocity.z ):Length()
	local speed = math.Clamp( vertvelocity, 0, 500 )
	local flapspeed = speed * 0.5 / maxspeed
	local WorldWingPosition, WorldWingAngles = self:GetBonePosition(self:LookupBone("crow.phalanges2_l"))
	local WingPosition = (self:WorldToLocal(WorldWingPosition).z * -1 + 11)
	self.SmoothZ = self.SmoothZ + (WingPosition - self.SmoothZ) / 5
	local RoundedZ = math.Round(self.SmoothZ*10)
	
	if not self:MountIsOnGround() then
		if self.PlayTakeOff then 
			self:SetSequence(self:LookupSequence(self.TakeOff))
			self:SetPlaybackRate(flapspeed*5)
			self.PlayTakeOff = false
			self.PlayLanding = false
		end
		
		if self.PlayLanding and self:InBeforeGround() then
			self:SetSequence(self:LookupSequence(self.Landing))
			self:SetPlaybackRate(flapspeed)
			self.PlayLanding = false
		end
		self.FlapSound:ChangePitch(math.Clamp(RoundedZ,50, 100))
		self.FlapSound:ChangeVolume(math.Clamp(RoundedZ/80, 0, 1))
		self.WindSound:ChangePitch(70)
		self.WindSound:ChangeVolume(self:GetVelocity():Length() / 2000)
		timer.Simple(self:SequenceDuration(),
		function()
			if not ValidEntity(self) then return end
			self:ResetSequence(self:LookupSequence(self.Fly))
			self:SetPlaybackRate(flapspeed)
			self.PlayLanding = true
		end)
	end
	self:NextThink(CurTime())
	return true
end



function ENT:PhysicsSimulate( phys, deltatime )
	if self.In and self.Pilot and not self.Crashed then
		
		self.CrashedTimer = true
		local ForwardSpeed
		if self:MountIsOnGround() then 
			local Sprint = self.Pilot:KeyDown(IN_SPEED)
			local Forward = self.Pilot:KeyDown(IN_FORWARD)

			if Forward and Sprint then
				ForwardSpeed = 500
			elseif Forward then
				ForwardSpeed = 100
			else 
				ForwardSpeed = 0
			end
			
		else
			ForwardSpeed = 1000
		end
		
		if not self:MountIsOnGround() then
			local Sprint = self.Pilot:KeyDown(IN_SPEED)
			if Sprint then 
				ForwardSpeed = 2000
			end
		end
		
		
		if self:InBeforeGround() and not self:MountIsOnGround() then
			self.IsOnOrBeforeGround = 3
		else
			self.IsOnOrBeforeGround = 1
		end
		
		
		self.SmoothForward = self.SmoothForward + (ForwardSpeed - self.SmoothForward) / 50
		phys:Wake()
		self.SmoothArrive = self.SmoothArrive + (self.IsOnOrBeforeGround - self.SmoothArrive) / 50
		
		local move = {}
		move.secondstoarrive = self.SmoothArrive
		move.pos = self:GetPos() + self:GetForward() * self.SmoothForward
		move.maxangular= 5000
		move.maxangulardamp= 10000
		move.maxspeed = 1000000
		move.maxspeeddamp = 10000
		move.dampfactor= 0.8
		move.teleportdistance = 5000
		local ang = self.Pilot:GetAimVector():Angle()
		ang.r = math.Clamp((self:MountIsOnGround() and 0 or math.NormalizeAngle( ang.y - phys:GetAngles().y ) * -1), -30, 30)
		move.angle = Angle(ang.p, ang.y, ang.r)
		move.deltatime = deltatime
		phys:ComputeShadowControl(move)
	else		
		local linear = Vector( 0, 0, 0 )
		local angular = Vector( 0, 0, 0 )
		local velocity = phys:GetVelocity()
		local angles = phys:GetAngles()
		local rollang = 180*((angles.r-180)>0 and 1 or -1)-(angles.r-180)
		local angulardamping = phys:GetAngleVelocity() * -1.6
		local friction = velocity * -0.6
		friction.z = 0

		
		local targetYaw = velocity:Length() > 120 and velocity:Angle().y or angles.y
		local angularYaw = math.Clamp( math.NormalizeAngle( targetYaw - angles.y ), -45, 45 ) * 2

		angular = angular + Vector(
		(rollang)*deltatime*3200,
		(angles.p)*deltatime*-3200,
		angularYaw*deltatime*6400)

		angular = angular + Vector(
		(rollang)*deltatime*3200,
		(angles.p)*deltatime*-3200,
		0)
		local gravitydamping = Vector( 0, 0, ( velocity.z * velocity:Length() * -0.00006  ) )
		linear = linear + gravitydamping * deltatime * 1000
		angular = angular + angulardamping * deltatime * 750

		return angular, linear, SIM_GLOBAL_ACCELERATION
	end
end

function ENT:PhysicsCollide(Data, PhysObject)
	if (Data.Speed > 300 and Data.DeltaTime > 0.9 ) and self.In and self.Pilot then
		self.Crashed = true
		timer.Simple(0.5, function() self.Crashed = false end)
	end
end

function ENT:OnRemove()
	self.FlapSound:Stop()
	self.WindSound:Stop()
	if ValidEntity(self.HitBox) then self.HitBox:Remove() end
	self:OnExit()
end

function ENT:OnExit()
	if self.In then
		self.In = false
		self.Pilot:SetOwner(nil)
		self.Pilot:SetMoveType(MOVETYPE_WALK)
		self.Pilot:SetParent()
		self.Pilot:SetNWBool("InMount", false)
		self.Pilot:SetNWBool("Thirdperson", false)
		self.Pilot:SetViewEntity(self.Pilot)
		self.Pilot:SetEyeAngles(Angle(self.Pilot:EyeAngles().p,self.Pilot:EyeAngles().y,0))
		self.Pilot:SetVelocity(self:GetVelocity())
		self.Pilot:SetPos(self:GetPos() + self:GetRight() * 50)
		timer.Simple(1, function() if ValidEntity(self) then constraint.RemoveConstraints(self) end end)
		self.Pilot = nil
	end
end

hook.Add("EntityTakeDamage", "MountDamage",

function(Entity, Inflictor, Attacker, Ammount, DamageInfo)
	if Entity.IsHitBoxMount then
		local RandomSound = math.random(1,Entity.Owner.AmmountOfPainSounds)
		local RandomPitch = math.random(Entity.Owner.PitchMinPain, Entity.Owner.PitchMaxPain)
		Entity:EmitSound(Entity.Owner.MountPainSound .. RandomSound .. ".wav", 100, RandomPitch)
		local effectData = EffectData()
		effectData:SetOrigin(DamageInfo:GetDamagePosition())
		effectData:SetEntity(Entity.Owner)
		effectData:SetScale(5)
		util.Effect("mount_damaged", effectData)
		Entity:SetHealth(Entity:Health() - Ammount)
		if Entity:Health() < 1 then 
			local effectData = EffectData()
			effectData:SetOrigin(Entity:GetPos())
			effectData:SetEntity(Entity.Owner)
			effectData:SetScale(100)
			util.Effect("mount_damaged", effectData)
			for i=1, math.random(1,3) do
				local gibs = ents.Create("mount_gibs")
				gibs:SetPos(Entity:GetPos())
				gibs:SetVelocity(Entity:GetVelocity())
				gibs:Spawn()
				gibs:Activate()
				if Entity.Owner:GetClass() == "mount_pigeon" then
					color = Vector(160, 155, 115)
				elseif Entity.Owner:GetClass() == "mount_crow" then
					color = Vector(20,20,20)
				elseif Entity.Owner:GetClass() == "mount_seagull" then
					color = Vector(200,200,200)
				end
				gibs:SetNWVector("Color", color)
			end
			timer.Simple(0.5, function() if ValidEntity(Entity) then Entity:Remove() end end)
		end
	end
end)