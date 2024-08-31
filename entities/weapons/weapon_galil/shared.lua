if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
elseif (CLIENT) then
	SWEP.PrintName 		= "GALIL SAR"
	SWEP.IconLetter 		= "v"
	SWEP.ViewModelFlip	= false

	killicon.AddFont("weapon_sh_galil", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end


SWEP.Base 					= "weapon_sh_base"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_rc_galil.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_galil.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_Galil.Single")
SWEP.Primary.Recoil 		= 0.4
SWEP.Primary.Damage 		= 22
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.003
SWEP.Primary.ClipSize 		= 35
SWEP.Primary.Delay 			= 0.085
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "ar2"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.RMod					= 1
SWEP.RRise					= 0.0
SWEP.IronSightsPos 			= Vector(-5.15,0.1,2.37)
SWEP.IronSightsAng 			= Vector(-0.3,0,0)
SWEP.ModelRunAnglePreset	= 1
SWEP.DistantSound			= "galil.mp3"
SWEP.BoltBone				= "bolt"

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.galil",
	pos = Vector(0.1, -0.12, 17.7),
	angle = Angle(-90, 0, 270),
	size = 0.79--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/rds.mdl",
	bone = "v_weapon.galil",
	pos = Vector(0.02, -0.95, 3),
	angle = Angle(-90, 0, -90),
	size = 0.55--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos = Vector(-5.15,0.1,1.6),
	AuxIronSightsAng = Vector(-0,0,0),
	RRise = 0.001,
	RSlide = 0,
	skin = 0,
	bodygroup = {}
	},
	["m145"] = {
	type = "Model",
	model = "models/weapons/m145.mdl",
	bone = "v_weapon.galil",
	pos = Vector(0.03, -2.45, 2),
	angle = Angle(0, -180, 0),
	size = 0.48--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos = Vector(-5.15,0.1,1.6),
	AuxIronSightsAng = Vector(-0.36,-0.02,0),
	RRise = 0.002,
	RSlide = 0,
	skin = 0,
	bodygroup = {}
	},
	["scope"] = {
	type = "Model",
	model = "models/weapons/scope.mdl",
	bone = "v_weapon.galil",
	pos = Vector(0.03, -2.65, 14.1),
	angle = Angle(90, -180, 90),
	size = 0.155--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos = Vector(-5.15,0.1,1.6),
	AuxIronSightsAng = Vector(-0.36,-0.02,0),
	RRise = 0.002,
	RSlide = 0,
	skin = 0,
	bodygroup = {}
	}
}

SWEP.Rails = {
	["rail"] = {
	type = "Model",
	model = "models/weapons/akmount.mdl",
	bone = "v_weapon.galil",
	pos = Vector(0.55, 0.75, 8),
	angle = Angle(-90, 0, -90),
	size = 0.2--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
