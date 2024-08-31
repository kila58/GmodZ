--[[
	GM13 Changes

	surface.CreateFont now uses font data
	Cleaned Code
]]

if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight 			= 5
elseif CLIENT then
	SWEP.DrawAmmo			= true		
	SWEP.DrawCrosshair		= false		
	SWEP.ViewModelFOV		= 60			
	SWEP.ViewModelFlip		= true
	SWEP.Slot 				= 1

	local font_data = {
		["CSKillIcons"] = {
			font 	= "csd",
			size 	= ScreenScale(60),
			weight 	= 500
		},
		["CSSelectIcons"] = {
			font 	= "csd",
			size 	= ScreenScale(60),
			weight 	= 500
		},
		["Firemode"] = {
			font 	= "HalfLife2",
			size 	= ScrW() / 60,
			weight 	= 500
		},
	}

	-- This is the font that's used to draw the death icons
	surface.CreateFont( "CSKillIcons", 		font_data.CSKillIcons )
	-- This is the font that's used to draw the select icons
	surface.CreateFont( "CSSelectIcons", 	font_data.CSSelectIcons )
	-- This is the font that's used to draw the firemod icons
	surface.CreateFont( "Firemode", 		font_data.Firemode )
end

SWEP.HoldType				= "revolver"
SWEP.Base					= "weapon_sh_base"
SWEP.MuzzleEffect			= "pistol" 
SWEP.ShellEffect			= "rg_shelleject" 
SWEP.MuzzleAttachment		= "1" 
SWEP.ShellEjectAttachment	= "2"
SWEP.EjectDelay				= 0
SWEP.DrawWeaponInfoBox  	= true
SWEP.Contact 				= ""
SWEP.Purpose 				= ""
SWEP.Instructions 			= ""
SWEP.Spawnable 				= false
SWEP.AdminSpawnable 		= false
SWEP.Weight 				= 5
SWEP.AutoSwitchTo 			= false
SWEP.AutoSwitchFrom 		= false
SWEP.Primary.Sound 			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 0
SWEP.Primary.NumShots 		= 0
SWEP.Primary.Cone 			= 0.01
SWEP.Primary.ClipSize 		= 0
SWEP.Primary.Delay 			= 0
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "pistol"
SWEP.Secondary.ClipSize 	= 0
SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.SlideLocks				= 1
SWEP.FireSelect				= 0
SWEP.Look					= 1
SWEP.CycleSpeed				= 1
SWEP.IronCycleSpeed			= 2
SWEP.RMod					= 1
SWEP.RKick					= 10
SWEP.RRise					= 0
SWEP.ModelRunAnglePreset	= 3
SWEP.Pistol					= true
SWEP.Zoom					= 75
SWEP.Attach					= "ValveBiped.Bip01_R_Thigh"
SWEP.AttachVector			= Vector(-6,3,-3)
SWEP.AttachAngle			= Angle(0,0,90)