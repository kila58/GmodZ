if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType			= "pistol"
elseif (CLIENT) then
	SWEP.PrintName 			= "GLOCK 18"
	SWEP.IconLetter 		= "c"

	killicon.AddFont("weapon_sh_glock18", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end


SWEP.Base 					= "weapon_sh_base_pistol"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_glock18.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_Glock.Single")
SWEP.Primary.Damage 		= 17
SWEP.Primary.NumShots 		= 1
SWEP.Primary.ClipSize 		= 19
SWEP.Primary.Delay 			= 0.05
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "pistol"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.FireSelect				= 1
SWEP.RRise					= 0.005
SWEP.IronSightsPos = Vector (4.3305, 0.1, 2.7697)
SWEP.IronSightsAng = Vector (0.6171, -0.0077, 0)
SWEP.DistantSound			= "glock.mp3"
SWEP.BoltBone				= "Glock_Slide"
SWEP.Subsonic				= true
SWEP.SlideLockPos			= Vector(1.2,-0.35,0.05)
SWEP.DotVis					= -0.9

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.Glock_Parent",
	pos = Vector(-4, 3.55, -0.632),
	angle = Angle(2, 15.6, 90),
	size = 0.7,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/mrds.mdl",
	bone = "v_weapon.Glock_Slide",
	pos = Vector(0.5, -1.05, -3.2),
	angle = Angle(0,0,77),
	AuxIronSightsPos = Vector (4.34, 0.1, 2.65),
	AuxIronSightsAng = Vector (0.7171, -0.0077, 0),
	size = 0.115,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
