if (SERVER) then
	AddCSLuaFile("shared.lua")

elseif (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.PrintName 			= "STEYR TMP"
	SWEP.IconLetter 		= "d"

	killicon.AddFont("weapon_sh_tmp", "CSKillIcons", SWEP.IconLetter, Color(200, 200, 200, 255))
end

SWEP.HoldType				= "smg"
SWEP.MuzzleEffect			= "silenced"
SWEP.ShellEffect			= "rg_shelleject"
SWEP.MuzzleAttachment		= "1"
SWEP.ShellEjectAttachment	= "2"
SWEP.Base 					= "weapon_sh_base_pistol"
SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true
SWEP.ViewModel 				= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel 			= "models/weapons/w_smg_tmp.mdl"
SWEP.Primary.Sound 			= Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil 		= 0.25
SWEP.Primary.Damage 		= 10
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.008
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 			= 0.07
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "smg1"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.ModelRunAnglePreset	= 2
SWEP.FireSelect				= 1
SWEP.RMod					= 1
SWEP.RRise					= -0.001
SWEP.SlideLocks				= 0
SWEP.SMG					= true
SWEP.IronSightsPos = Vector (5.234, 0.1, 2.5)
SWEP.IronSightsAng = Vector (0.5531, -0.0248, 0)
SWEP.DistantSound			= nil
--SWEP.DotVis					= -1.1
SWEP.Pistol					= false

SWEP.VElements = {
	["rds"] = {
	type = "Model",
	model = "models/weapons/mrds.mdl",
	bone = "v_weapon.TMP_Parent",
	pos = Vector(2.94, 1.65, -3.4),
	angle = Angle(90,90,0),
	AuxIronSightsPos = Vector (5.234, 0.1, 2.5),
	AuxIronSightsAng = Vector (-0.2, -0.0248, 0),
	size = 0.115,
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
		bone = "v_weapon.TMP_Parent",
		pos = Vector(0.017, 3.45, -1.65),
		angle = Angle(-90, 0, 90),
		size = 0.515--[[Vector(0.123, 0.123, 0.123)]],
		color = Color(230, 230, 242, 255),
		surpresslightning = false,
		skin = 0,
		bodygroup = {}
	},
	["rail2"] = {
		type = "Model",
		model = "models/weapons/rail.mdl",
		bone = "v_weapon.TMP_Parent",
		pos = Vector(0.017, 3.45, 0.62),
		angle = Angle(-90, 0, 90),
		size = 0.515--[[Vector(0.123, 0.123, 0.123)]],
		color = Color(230, 230, 242, 255),
		surpresslightning = false,
		skin = 0,
		bodygroup = {}
	}
}





