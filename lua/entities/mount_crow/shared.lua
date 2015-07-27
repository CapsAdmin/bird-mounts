ENT.Type = "anim"
ENT.Base = "mount_base"
ENT.PrintName = "Crow Mount"
ENT.Spawnable = true

ENT.Information = "A crow mount."
ENT.Category = "CapsAdmin"

ENT.MountPainSound = "npc/crow/pain"
ENT.AmmountOfPainSounds = 2
ENT.PitchMaxPain = 50
ENT.PitchMinPain = 40

ENT.MountSound = "npc/crow/idle"
ENT.AmmountOfSounds = 4
ENT.PitchMax = 50
ENT.PitchMin = 30

ENT.MountType = "mount_crow"
ENT.MountModel = "models/crow.mdl"
ENT.ChairOffset = 30

--Sequence names for easy modifications to other models
ENT.Idle = "idle01"
ENT.TakeOff = "takeoff"
ENT.Landing = "land"
ENT.Fly = "fly"
ENT.Run = "run"
ENT.Walk = "walk"

if CLIENT then
	language.Add(ENT.MountType, ENT.PrintName)
end