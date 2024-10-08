
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true

	surface.CreateFont("CSKillIcons", { font="csd", weight="500", size=ScreenScale(30),antialiasing=true,additive=true })
	surface.CreateFont("CSSelectIcons", { font="csd", weight="500", size=ScreenScale(60),antialiasing=true,additive=true })

	SWEP.SprintPosMult		= 0;
	SWEP.SprintAngMult		= 0;

end

SWEP.Author			= "Counter-Strike"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

// Note: This is how it should have worked. The base weapon would set the category
// then all of the children would have inherited that.
// But a lot of SWEPS have based themselves on this base (probably not on purpose)
// So the category name is now defined in all of the child SWEPS.
//SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then
	SWEP.fSprintDelay = CurTime();
end

local RUN_SPEED = 25000;

/*---------------------------------------------------------
---------------------------------------------------------*/
function SWEP:Initialize()

	if ( SERVER ) then
		self:SetNPCMinBurst( 30 )
		self:SetNPCMaxBurst( 30 )
		self:SetNPCFireRate( 0.01 )
	end

	self:SetWeaponHoldType( self.HoldType )
	self.Weapon:SetNetworkedBool( "Ironsights", false )

end


/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self.ZoomedIn = false;
	self:SetIronsights( false )
end


/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if !self.ZoomFOV then
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if ( !self:CanPrimaryAttack() ) then return end

	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )

	// Shoot the bullet
	self.Owner:LagCompensation(true)
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	self.Owner:LagCompensation(false)

	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )

	if ( self.Owner:IsNPC() ) then return end

	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to
	// send the float.
	if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end


end

/*---------------------------------------------------------
   Name: SWEP:CSShootBullet( )
---------------------------------------------------------*/
function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	if self.ZoomedIn and self.Owner:GetVelocity() == Vector( 0, 0, 0 ) then
		cone = 0.005
	end

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	= 4									// Show a tracer on every x bullets
	bullet.Force	= 5									// Amount of force to give to phys objects
	bullet.Damage	= dmg

	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	if ( self.Owner:IsNPC() ) then return end

	// CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then

		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )

	end

end


/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	if !self.IconLetter then return end
	if !self.IconFont then
		self.IconFont = "CSSelectIcons"
	end

	draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	draw.SimpleText( self.IconLetter, self.IconFont, x + 2 + wide/2, y + 2 + tall*0.2, Color( 255, 210, 0, 120 ), TEXT_ALIGN_CENTER )

	// try to fool them into thinking they're playing a Tony Hawks game
	//draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	//draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )

end

local IRONSIGHT_TIME = 0.25

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if self.ZoomedIn then
		pos = pos + ang:Forward() * -50
	end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )

	if ( bIron != self.bLastIron ) then

		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if ( bIron ) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end

	end

	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then

		if ( self.Owner:GetVelocity():LengthSqr() > RUN_SPEED && self.Owner.stamina > 0 && CurTime() > (self:GetNextPrimaryFire() + 1) ) then
			if self.SprintPosMult < 0.98 then
				self.SprintPosMult = Lerp( FrameTime() * 8, self.SprintPosMult, 1 );
			elseif self.SprintPosMult != 1 then
				self.SprintPosMult = 1;
			end

			if self.SprintAngMult < 0.98 then
				self.SprintAngMult = Lerp( FrameTime() * 8, self.SprintAngMult, 1 );
			elseif self.SprintAngMult != 1 then
				self.SprintAngMult = 1;
			end

		else
			self.SprintPosMult = math.Approach(self.SprintPosMult, 0, -FrameTime() * 15 );
			self.SprintAngMult = math.Approach(self.SprintAngMult, 0, -FrameTime() * 15 );
		end

		//ang = ang * 1;
		//ang:RotateAroundAxis( ang:Right(), 1 * -4 )
		//ang:RotateAroundAxis( ang:Up(), 1 * -7 )

		pos = pos - ang:Forward() * self.SprintPosMult * 2;
		pos = pos - ang:Up() * self.SprintPosMult * 1.2;
		pos = pos - ang:Right() * self.SprintPosMult * -1;

		return pos, ang
	end

	if ( !self.IronSightsPos ) then return pos, ang end

	local Mul = 1.0

	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then

		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )

		if (!bIron) then Mul = 1 - Mul end

	end

	local Offset	= self.IronSightsPos

	if ( self.IronSightsAng ) then

		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )

	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang

end


/*---------------------------------------------------------
	SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end

function SWEP:TranslateFOV(oldfov)
	if self.ZoomedIn then
		return self.ZoomFOV
	end
	return oldfov
end

SWEP.NextSecondaryAttack = 0
/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos and !self.ZoomFOV) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end

	if self.IronSightsPos then
		bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
		self:SetIronsights( bIronsights )
	elseif self.ZoomFOV then

		-- Set the FOV
		if self.ZoomedIn then self.ZoomedIn = false
		else self.ZoomedIn = true end

	end

	self.NextSecondaryAttack = CurTime() + 0.3

end
/*---------------------------------------------------------
	onRestore
	Loaded a saved game (or changelevel)
---------------------------------------------------------*/
function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )

end

function SWEP:AdjustMouseSensitivity()
	if self.ZoomedIn then
		return 0.25
	end
end
