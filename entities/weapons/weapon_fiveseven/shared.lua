if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType			= "pistol"
elseif (CLIENT) then
	SWEP.PrintName 			= "FN FIVE-SEVEN"
	SWEP.IconLetter 		= "u"

	killicon.AddFont("weapon_sh_five-seven", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.EjectDelay				= 0.05
SWEP.Base 					= "weapon_sh_base_pistol"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_fiveseven.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_FiveSeven.Single")
SWEP.Primary.Damage 		= 10
SWEP.Primary.NumShots 		= 1
SWEP.Primary.ClipSize 		= 20
SWEP.Primary.Delay 			= 0.05
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "pistol"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.IronSightsPos 			= Vector (4.5282, 0.1, 3.35)
SWEP.IronSightsAng 			= Vector (-0.5139, -0.0182, 0)
SWEP.DistantSound			= "fiveseven.mp3"
SWEP.BoltBone				= "FIVESEVEN_SLIDE"
SWEP.GunBone				= "FIVESEVEN_PARENT"
SWEP.SlideLockPos			= Vector(-1.3,0,0)
SWEP.DotVis					= -0.75

SWEP.VElements = {
	["suppressor"] = {
	type = "Model",
	model = "models/weapons/suppressor.mdl",
	bone = "v_weapon.fiveseven_Parent",
	pos = Vector(-0.04, 2.3, 7.5),
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
	bone = "v_weapon.FIVESEVEN_SLIDE",
	pos = Vector(2.815, 0.25,-1.53),
	angle = Angle(0,90,0),
	AuxIronSightsPos = Vector (4.5282, 0.1, 3.2),
	AuxIronSightsAng = Vector (-0.4139, -0.0182, 0),
	size = 0.11,
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	skin = 0,
	bodygroup = {}
	}
}
