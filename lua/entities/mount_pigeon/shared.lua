ENT.Type = "anim"
ENT.Base = "mount_base"
ENT.PrintName = "Pigeon Mount"
ENT.Spawnable = true

ENT.Information = "A pigeon mount."
ENT.Category = "CapsAdmin"

ENT.MountPainSound = "npc/crow/pain"
ENT.AmmountOfPainSounds = 2
ENT.PitchMaxPain = 70
ENT.PitchMinPain = 60

ENT.MountSound = "ambient/creatures/pigeon_idle"
ENT.AmmountOfSounds = 4
ENT.PitchMax = 50
ENT.PitchMin = 40

ENT.MountType = "mount_pigeon"
ENT.MountModel = "models/pigeon.mdl"
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