if (SERVER) then
	AddCSLuaFile("shared.lua")

elseif (CLIENT) then
	SWEP.PrintName 			= "UTG L96"
	SWEP.ViewModelFOV		= 60
	SWEP.IconLetter 		= "r"

	killicon.AddFont("weapon_sh_awp", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.MuzzleAttachment		= "1"
SWEP.Base 					= "weapon_sh_awpbase"
SWEP.Spawnable 				= false
SWEP.AdminSpawnable 		= false
SWEP.ViewModel 				= "models/weapons/v_rc_awp.mdl"
SWEP.WorldModel 			= "models/weapons/w_snip_awp.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_AWP.Single")
SWEP.Primary.Damage 		= 250
SWEP.Primary.Recoil 		= 2
SWEP.Primary.NumShots 		= 1
SWEP.Primary.ClipSize 		= 5
SWEP.Primary.Delay 			= 1
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "SniperRound"
SWEP.DrawParabolicSights	= false
SWEP.FireSelect				= 0
SWEP.DistantSound			= "awp.mp3"
SWEP.IronSightsPos 			= Vector (5.59, 0.1, 1.8)
SWEP.IronSightsAng 			= Vector (-0.23, 0, 0)
SWEP.IronPos				= Vector(0.06, 4.05, 3.4)
SWEP.IronAng				= Angle(0, 0, 90)
SWEP.IronFrontPos			= Vector(0, 0, 1.5)

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.awm_Parent",
	pos = Vector(-0.08, 3.4, 21),
	angle = Angle(-89.7, 0, 90),
	size = 0.8,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/rds.mdl",
	bone = "v_weapon.awm_Parent",
	pos = Vector(0.03, 3.5, 3.1),
	angle = Angle(-90, 0, 90),
	size = 0.54,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos 	= Vector (5.6, 0.1, 1.8),
	AuxIronSightsAng 	= Vector (-0.5, 0, 0),
	skin = 0,
	bodygroup = {}
	},
	["m145"] = {
	type = "Model",
	model = "models/weapons/m145.mdl",
	bone = "v_weapon.awm_Parent",
	pos = Vector(0.03, 5, 3.5),
	angle = Angle(0, 0, 0),
	size = 0.46,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos 	= Vector (5.6, 0.1, 1.8),
	AuxIronSightsAng 	= Vector (-0.72, 0, 0),
	RRise = 0.0005,
	RSlide = 0,
	skin = 0,
	bodygroup = {}
	},
	["scope"] = {
	type = "Model",
	model = "models/weapons/scope.mdl",
	bone = "v_weapon.awm_Parent",
	pos = Vector(0.035, 5.23, 15),
	angle = Angle(90, 0, 90),
	size = 0.155--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos 	= Vector (5.6, 0.1, 1.8),
	AuxIronSightsAng 	= Vector (-0.72, 0, 0),
	RRise = 0.003,
	RSlide = 0.0004,
	skin = 0,
	bodygroup = {}
	}
}

SWEP.Irons = {
	["rear"] = {
	type = "Model",
	model = "models/weapons/irons.mdl",
	bone = "v_weapon.awm_Parent",
	pos = SWEP.IronPos,
	angle = SWEP.IronAng,
	size = 0.55--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["front"] = {
	type = "Model",
	model = "models/weapons/irons_f.mdl",
	bone = "v_weapon.awm_Parent",
	pos = SWEP.IronPos+SWEP.IronFrontPos,
	angle = SWEP.IronAng,
	size = 0.55--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}

SWEP.Rails = {
	["rail"] = {
	type = "Model",
	model = "models/weapons/rail.mdl",
	bone = "v_weapon.awm_Parent",
	pos = Vector(0.03, 4, 2.75),
	angle = Angle(-90, 0, 90),
	size = 0.585--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(220, 225, 220, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rail2"] = {
	type = "Model",
	model = "models/weapons/rail.mdl",
	bone = "v_weapon.awm_Parent",
	pos = Vector(0.03, 4, 5.4),
	angle = Angle(-90, 0, 90),
	size = 0.585--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(220, 225, 220, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
