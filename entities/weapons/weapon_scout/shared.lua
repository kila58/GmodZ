if (SERVER) then
	AddCSLuaFile("shared.lua")

elseif (CLIENT) then
	SWEP.PrintName 			= "STEYR SCOUT SNIPER"
	SWEP.ViewModelFOV		= 60
	SWEP.IconLetter 		= "n"

	killicon.AddFont("weapon_sh_scout", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.MuzzleAttachment		= "1"
SWEP.Base					= "weapon_sh_scoutbase"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_rc_scout.mdl"
SWEP.WorldModel 			= "models/weapons/w_snip_scout.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_SCOUT.Single")
SWEP.Primary.Damage 		= 65
SWEP.Primary.Recoil 		= 1
SWEP.Primary.NumShots 		= 1
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 			= 1.2
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "SniperRound"
SWEP.IronSightZoom			= 30
SWEP.UseScope				= false
SWEP.FireSelect 			= 0
SWEP.Sniper					= false
SWEP.RMod					= 1
SWEP.RKick					= 5
SWEP.DistantSound			= "scout.mp3"
SWEP.IronSightsPos 			= Vector (4.95, 0, 2.09)
SWEP.IronSightsAng 			= Vector (-0.33, 0, 0)
SWEP.IronPos				= Vector(-0.02, 3.08, 5.1)
SWEP.IronAng				= Angle(0, 0, 90)
SWEP.IronFrontPos			= Vector(0, 0, 1.5)

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.scout_Parent",
	pos = Vector(-0.057, 2.6, 15.1),
	angle = Angle(-89.7, 0, 90),
	size = 0.715,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/rds.mdl",
	bone = "v_weapon.scout_Parent",
	pos = Vector(-0.02, 2.5, 5),
	angle = Angle(-90, 0, 90),
	size = 0.54,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos 	= Vector (4.99, 0, 2),
	AuxIronSightsAng 	= Vector (0, 0, 0),
	skin = 0,
	bodygroup = {}
	},
	["m145"] = {
	type = "Model",
	model = "models/weapons/m145.mdl",
	bone = "v_weapon.scout_Parent",
	pos = Vector(-0.02, 4, 5.5),
	angle = Angle(0, 0, 0),
	size = 0.46,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos 	= Vector (4.99, 0, 1.91),
	AuxIronSightsAng 	= Vector (0, 0, 0),
	RRise = 0,
	RSlide = 0,
	skin = 0,
	bodygroup = {}
	},
	["scope"] = {
	type = "Model",
	model = "models/weapons/scope.mdl",
	bone = "v_weapon.scout_Parent",
	pos = Vector(-0.02, 4.15, 16.5),
	angle = Angle(90, 0, 90),
	size = 0.150--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	AuxIronSightsPos 	= Vector (4.99, 0, 1.91),
	AuxIronSightsAng 	= Vector (0, 0, 0),
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
	bone = "v_weapon.scout_Parent",
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
	bone = "v_weapon.scout_Parent",
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
	bone = "v_weapon.scout_Parent",
	pos = Vector(-0.02, 3, 4.5),
	angle = Angle(-90, 0, 90),
	size = 0.585--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rail2"] = {
	type = "Model",
	model = "models/weapons/rail.mdl",
	bone = "v_weapon.scout_Parent",
	pos = Vector(-0.02, 3, 7.4),
	angle = Angle(-90, 0, 90),
	size = 0.585--[[Vector(0.123, 0.123, 0.123)]],
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
