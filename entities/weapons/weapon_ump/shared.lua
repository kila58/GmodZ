if (SERVER) then
	AddCSLuaFile("shared.lua")

elseif (CLIENT) then
	SWEP.PrintName 			= "HK UMP-45"
	SWEP.IconLetter 		= "q"
	SWEP.ViewModelFOV		= 55

	killicon.AddFont("weapon_sh_ump_45", "CSKillIcons", SWEP.IconLetter,Color(200, 200, 200, 255))
end

SWEP.ShellEffect			= "rg_shelleject"
SWEP.Base 					= "weapon_sh_base"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel 			= "models/weapons/w_smg_ump45.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_UMP45.Single")
SWEP.SuppressedSound		= Sound("weapons/suppressed_ump.wav")
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 18
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.004
SWEP.Primary.ClipSize 		= 25
SWEP.Primary.Delay 			= 0.092
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "smg1"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.RMod					= 1
SWEP.RKick					= 10
SWEP.RRise					= 0.0015
SWEP.RSlide					= 0.001
SWEP.IronSightsPos = Vector (7.3298, 0.1, 3.3176)
SWEP.IronSightsAng = Vector (-1.361, 0.3, 1.5171)
SWEP.SMG					= true
SWEP.DistantSound			= "ump.mp3"
SWEP.Subsonic				= true

SWEP.VElements = {
	["suppressor"] = {
		type = "Model",
		model = "models/weapons/suppressor.mdl",
		bone = "v_weapon.ump45_Parent",
		pos = Vector(0.08, 4.5, 12.5),
		angle = Angle(-90, -90, 0),
		size = 0.8,
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		skin = 0,
		bodygroup = {}
	},
	["m145"] = {
		type = "Model",
		model = "models/weapons/m145.mdl",
		bone = "v_weapon.ump45_Parent",
		pos = Vector(0.3, 7.1, 0.6),
		angle = Angle(0, 2, 0),
		size = 0.5,
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		--material = "models/props_combine/metal_combinebridge001",
		AuxIronSightsPos = Vector (7.31, 0, 2.105),
		AuxIronSightsAng = Vector (-0.75, 0.15, 2.1),
		RRise = 0.001,
		RSlide = 0,
		skin = 0,
		bodygroup = {}
	},
	["rds"] = {
		type = "Model",
		model = "models/weapons/rds.mdl",
		bone = "v_weapon.ump45_Parent",
		pos = Vector(0.27, 5.44, 2),
		angle = Angle(-90, 0, 88),
		size = 0.58,
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		--material = "models/props_combine/metal_combinebridge001",
		skin = 0,
		bodygroup = {},
		AuxIronSightsPos = Vector (7.37, 0, 2.45),
		AuxIronSightsAng = Vector (-1.3, 0.3, 1.5171)
	},
	["scope"] = {
		type = "Model",
		model = "models/weapons/scope.mdl",
		bone = "v_weapon.ump45_Parent",
		pos = Vector(0.3, 7.3, 13.5),
		angle = Angle(90, 2, 90),
		size = 0.156,
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		--material = "models/props_combine/metal_combinebridge001",
		AuxIronSightsPos = Vector (7.31, 0, 2.305),
		AuxIronSightsAng = Vector (-0.36, 0.1, 2),
		RRise = 0.001,
		RSlide = 0,
		skin = 0,
		bodygroup = {}
	}
}

SWEP.Rails = {
	["rail"] = {
		type = "Model",
		model = "models/weapons/rail.mdl",
		bone = "v_weapon.ump45_Parent",
		pos = Vector(0.3, 6, 1.2),
		angle = Angle(-90, 0, 90),
		size = 0.65--[[Vector(0.123, 0.123, 0.123)]],
		color = Color(150, 150, 150, 255),
		surpresslightning = false,
		--material = "models/props_combine/metal_combinebridge001",
		skin = 0,
		bodygroup = {}
		},
	["rail2"] = {
		type = "Model",
		model = "models/weapons/rail.mdl",
		bone = "v_weapon.ump45_Parent",
		pos = Vector(0.3, 6, 3),
		angle = Angle(-90, 0, 90),
		size = 0.65--[[Vector(0.123, 0.123, 0.123)]],
		color = Color(150, 150, 150, 255),
		surpresslightning = false,
		--material = "models/props_combine/metal_combinebridge001",
		skin = 0,
		bodygroup = {}
		}
	}
