ENT.Type = "anim"
ENT.Base = "mount_base"
ENT.PrintName = "Seagull Mount"
ENT.Spawnable = true

ENT.Information = "A seagull mount."
ENT.Category = "CapsAdmin"

ENT.MountPainSound = "ambient/creatures/seagull_pain"
ENT.AmmountOfPainSounds = 3
ENT.PitchMaxPain = 50
ENT.PitchMinPain = 40

ENT.MountSound = "ambient/creatures/seagull_idle"
ENT.AmmountOfSounds = 3
ENT.PitchMax = 50
ENT.PitchMin = 40

ENT.MountType = "mount_seagull"
ENT.MountModel = "models/seagull.mdl"
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