if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "pistol"
elseif (CLIENT) then
	SWEP.PrintName 		= "USP .45"
	SWEP.IconLetter 	= "a"
	SWEP.CSMuzzleFlashes	= false
	SWEP.ViewModelFOV		= 60

	killicon.AddFont("weapon_sh_usp", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.MuzzleAttachment		= "1"
SWEP.Base 					= "weapon_sh_base_pistol"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_usp.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_USP.Single")
SWEP.SuppressedSound		= Sound("weapons/suppressed_usp.wav")
SWEP.Primary.Recoil 		= 0.7
SWEP.Primary.Damage 		= 16
SWEP.Primary.NumShots 		= 1
SWEP.Primary.ClipSize 		= 15
SWEP.Primary.Delay 			= 0.1
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "pistol"
SWEP.IronSightsPos 			= Vector (4.48, 0.1, 2.75)
SWEP.IronSightsAng 			= Vector (-0.35, -0.07, 0)
--SWEP.ViewModelBonescales 	= {["v_weapon"] = Vector(0.01, 0.01, 0.01)}
SWEP.DistantSound			= nil
SWEP.BoltBone				= "USP_Slide"
SWEP.SlideLockPos			= Vector(0,0,-1.1)
SWEP.Subsonic				= true
SWEP.DotVis					= -1

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.USP_Switch",
	pos = Vector(-0.13, 0.8, 7.1),
	angle = Angle(-90, -90, 0),
	size = 0.75,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/mrds.mdl",
	bone = "v_weapon.USP_Slide",
	pos = Vector(2.485, -1.15, -1),
	angle = Angle(90,90,0),
	AuxIronSightsPos = Vector (4.48, 0.1, 2.63),
	AuxIronSightsAng = Vector (-0.15, -0.07, 0),
	size = 0.10,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}

