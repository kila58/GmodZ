if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "pistol"
elseif (CLIENT) then
	SWEP.PrintName 		= "SIG-SAUER P228"
	SWEP.IconLetter 	= "y"

	killicon.AddFont("weapon_sh_p228", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.EjectDelay				= 0.05
SWEP.Base 					= "weapon_sh_base_pistol"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_p228.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_P228.Single")
SWEP.Primary.Damage 		= 21
SWEP.Primary.NumShots 		= 1
SWEP.Primary.ClipSize 		= 12
SWEP.Primary.Delay 			= 0.05
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "pistol"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.IronSightsPos 			= Vector (4.7648, -0.1, 2.9876)
SWEP.IronSightsAng 			= Vector (-0.6967, 0.0241, -0.0391)
SWEP.DistantSound			= "p228.mp3"
SWEP.BoltBone				= "p228_Slide"
SWEP.SlideLockPos			= Vector(-1.2,0,0)
SWEP.Subsonic				= true
SWEP.DotVis					= -1.4

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.P228_Parent",
	pos = Vector(0.02, 2.9, 4.35),
	angle = Angle(-90,0,90),
	size = 0.7,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/mrds.mdl",
	bone = "v_weapon.P228_Slide",
	pos = Vector(2.86, -1.55, 0),
	angle = Angle(90,0,90),
	AuxIronSightsPos = Vector (4.7648, -0.1, 2.9876),
	AuxIronSightsAng = Vector (-1.5, 0.0241, -0.0391),
	size = 0.11,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
