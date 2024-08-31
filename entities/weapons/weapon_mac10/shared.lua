if (SERVER) then
	AddCSLuaFile("shared.lua")

elseif (CLIENT) then
	SWEP.PrintName 			= "MAC 11 .380"
	SWEP.IconLetter 		= "l"

	killicon.AddFont("weapon_sh_mac10-380", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.Base 					= "weapon_sh_base_pistol"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel 			= "models/weapons/w_smg_mac10.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_MAC10.Single")
SWEP.Primary.Recoil 		= 0.25
SWEP.Primary.Damage 		= 15
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.006
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 			= 0.050
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "smg1"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.FireSelect				= 1
SWEP.FreeFloatHair			= false
SWEP.ModelRunAnglePreset	= 2
SWEP.RMod 					= 1
SWEP.RRise					= 0.00
SWEP.RSlide					= 0.0135
SWEP.Mac10					= true
SWEP.Subsonic				= true
SWEP.IronSightsPos = Vector (6.97, 0.1, 2.9021)
SWEP.IronSightsAng = Vector (0.75, 5.3, 7.6)
SWEP.HoldType				= "smg"
SWEP.DistantSound			= "mac.mp3"
SWEP.Pistol					= false

SWEP.Riser = {
	["rail"] = {
		type = "Model",
		model = "models/props_interiors/vendingmachinesoda01a.mdl",
		bone = "v_weapon.MAC10_Parent",
		pos = Vector(-0.07, 3.55, -3.38),
		angle = Angle(0, 0, 90),
		size = 0.016--[[Vector(0.123, 0.123, 0.123)]],
		color = Color(30, 30, 30, 255),
		surpresslightning = false,
		material = "models/debug/debugwhite",
		skin = 0,
		bodygroup = {}
		}
	}

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.MAC10_Parent",
	pos = Vector(-0.15, 3, 3.8),
	angle = Angle(-90,0,90),
	size = 0.75,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	},
	["rds"] = {
	type = "Model",
	model = "models/weapons/mrds.mdl",
	bone = "v_weapon.MAC10_Parent",
	pos = Vector(2.82, 2.3, -3.3),
	angle = Angle(90,90,0),
	AuxIronSightsPos = Vector (6.97, 0.1, 2.9021),
	AuxIronSightsAng = Vector (-1.1, 5.3, 7.6),
	RRise = 0.003,
	size = 0.115,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
