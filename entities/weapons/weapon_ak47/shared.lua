if (SERVER) then
	AddCSLuaFile("shared.lua")

elseif (CLIENT) then
	SWEP.PrintName 			= "AK-47"
	SWEP.IconLetter 		= "b"

	killicon.AddFont("weapon_sh_ak47", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.MuzzleAttachment		= "1"
SWEP.ShellEjectAttachment	= "2"
SWEP.Base 					= "weapon_sh_base"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_ak47.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_AK47.Single")
SWEP.Primary.Damage 		= 25
SWEP.Primary.Recoil 		= 0.6
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.006
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 			= 0.1
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "ar2"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.RMod					= 1
SWEP.RKick					= 10
SWEP.RRise					= -0.004
SWEP.IronSightsPos 			= Vector (6.0776, 0.1, 2.0964)
SWEP.IronSightsAng 			= Vector (2.46, -0.0459, 0)
SWEP.BoltBone				= "AK47_Bolt"
SWEP.Heavy					= true

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.AK47_Parent",
	pos = Vector(-0.1, 3, 19.5),
	angle = Angle(-89, 0, 90),
	size = 0.8--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/rds.mdl",
	bone = "v_weapon.AK47_Parent",
	pos = Vector(0.035, 4.3, 1.8),
	angle = Angle(-90, 0, 90),
	size = 0.55--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos = Vector (6.0776, 0.1, 2.0964),
	AuxIronSightsAng = Vector (-0.65, 0, 0),
	RRise = 0.001,
	RSlide = 0,
	skin = 0,
	bodygroup = {}
	},
	["m145"] = {
	type = "Model",
	model = "models/weapons/m145.mdl",
	bone = "v_weapon.AK47_Parent",
	pos = Vector(0.035, 5.85, 1),
	angle = Angle(-0, 0, 0),
	size = 0.48--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos = Vector (6.095, 0.1, 2.0964),
	AuxIronSightsAng = Vector (-1.38, 0.1, 0),
	RRise = 0.002,
	RSlide = 0.0004,
	skin = 0,
	bodygroup = {}
	},
	["scope"] = {
	type = "Model",
	model = "models/weapons/scope.mdl",
	bone = "v_weapon.AK47_Parent",
	pos = Vector(0.035, 6, 12),
	angle = Angle(90, 0, 90),
	size = 0.15--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos = Vector (6, 0.1, 2.3),
	AuxIronSightsAng = Vector (-1, 0, 0),
	RRise = 1,
	RSlide = 0.0004,
	skin = 0,
	bodygroup = {}
	}
}

SWEP.Rails = {
	["rail"] = {
	type = "Model",
	model = "models/weapons/akmount.mdl",
	bone = "v_weapon.AK47_Parent",
	pos = Vector(-0.49, 2.61, 6),
	angle = Angle(-90, 0, 90),
	size = 0.2--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}


