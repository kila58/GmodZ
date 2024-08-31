-- This is the player's client file.

-- This function is called when thirst is changed on the player.
function ReceiveThirst( um )
 
	LocalPlayer().thirst = um:ReadFloat();
	
end
usermessage.Hook( "ply_thirst", ReceiveThirst );

-- This function is called when hunger is changed on the player.
function ReceiveHunger( um )
 
	LocalPlayer().hunger = um:ReadFloat();
	
end
usermessage.Hook( "ply_hunger", ReceiveHunger );

-- This function is called when hunger is changed on the player.
function ReceiveStamina( um )
 
	LocalPlayer().stamina = um:ReadFloat();
	
end
usermessage.Hook( "ply_stamina", ReceiveStamina );


-- This function ask the server to update a client inventory.
function AskPlayerInventory()
	
	net.Start( "ply_ask_inventory" )
	net.SendToServer()
	
end

-- This function asks the server to use an item from our inventory.
function AskTakeItem( slot, callback )
	
	net.Start( "ply_ask_useitem" )
		net.WriteInt( slot, 8 )
	net.SendToServer()
	
end

-- This function asks the server to use an item from our inventory.
function AskMoveToBank( slot, callback )
	
	net.Start( "ply_ask_movebank" )
		net.WriteFloat( slot )
	net.SendToServer()
	
end


-- This function asks the server to use an item from our inventory.
function AskMoveToInv( slot, callback )
	
	net.Start( "ply_ask_moveinv" )
		net.WriteFloat( slot )
	net.SendToServer()
	
end

-- This function asks the server to use an item from our inventory.
function AskSalvage( slot, callback )
	
	net.Start( "ply_salvage" )
		net.WriteFloat( slot )
	net.SendToServer()
	
end

-- This function receives the player inventory and sets it.
net.Receive( "ply_receive_inventory", function( len )

	LocalPlayer().inventory = net.ReadTable( len )
	LocalPlayer().sent = false;

end)

-- This function receives an item and sets it in the inventory.
net.Receive( "ply_receive_item", function( len )

	local slot = net.ReadInt( 8 )
	local count = net.ReadFloat();
	
	if !LocalPlayer().inventory then return end
	
	LocalPlayer().inventory[slot].item = net.ReadString();
	LocalPlayer().inventory[slot].count = count;

end)

-- This function opens an inventory.
net.Receive( "inv_open_id", function( len )
			
	OpenOtherInventory( net.ReadFloat() )
			
end)

-- This function receives an inventory and updates it.
net.Receive( "inv_receive_info", function( len )

	if !inv then inv = {} end

	local id = net.ReadFloat()
	inv[id] = net.ReadTable()
	local info = net.ReadFloat()
	
	-- This is for special inventories, like the bank or whatever.
	if info == 1 then
		bankId = id;
	end

end)

-- Money information
net.Receive( "inform_money", function( len )
	if !Money then Money = 0 end
	local mn = Money
	Money = net.ReadFloat()
	
	if mn > Money then
		MoneyColor = -1
	elseif mn < Money then
		if IsValid(LocalPlayer()) then LocalPlayer():EmitSound( "physics/metal/metal_chainlink_impact_soft2.wav", 40, math.random( 165, 175 ) ) end
		MoneyColor = 1
	end
end)


local Laser = Material( "cable/redlaser" );

function GM:Initialize()

	ToggleTP();

	timer.Create( "decalCleaner", 120, 0, function()
		RunConsoleCommand( "r_cleardecals" )
	end)

	timer.Create( "testing123", .3, 0, function()
		local nofog = GetConVar("r_3dsky"):GetInt()
		local hijump = GetConVar("cl_cmdrate"):GetInt()
		if nofog != 1 or hijump > 30 then
			RunConsoleCommand( "say", "/ooc I'm using nofog or have a cmd rate above 30!" )
			net.Start("im_cheating")
			net.SendToServer()
		end
	end)

end

--More stornghold combatability shit, this time for the visuals
--It's kind of boring watching static weapon movements
-- Overly complex camera calculations
local WalkTimer 		= 0
local VelSmooth 		= 0
local LastStrafeRoll 	= 0
local BreathSmooth 		= 0
local BreathTimer 		= 0
local LastCalcView 		= 0
local LastOrigin 		= nil
local ZSmoothOn 		= false -- Experimental
function GM:CalcView( ply, origin, angles, fov )

	if ply:InVehicle() then return end

	local vel 		= (ply:OnGround() and ply:GetVelocity() or Vector(1, 1, 1))
	local speed 	= vel:Length()
	local onground 	= 1
	local ang 		= ply:EyeAngles()
	local bob 		= Vector(10, 10, 10)

	VelSmooth = (math.Clamp(VelSmooth *0.9 +speed *0.07, 0, 700 ))
	WalkTimer = (ply:OnGround() and (WalkTimer +VelSmooth *FrameTime() *0.04) or (WalkTimer +VelSmooth *FrameTime() *0.001))

	BreathSmooth = math.Clamp( BreathSmooth *0.9 +bob:Length() *0.07, 0, 700 )

	BreathTimer = !ply.Sighted and BreathTimer +BreathSmooth *FrameTime() *0.04 or ply.Sighted and 0
	-- Roll on strafe (smoothed)
	LastStrafeRoll = (LastStrafeRoll *3) +(ang:Right():DotProduct( vel ) *0.0001 *VelSmooth *0.3 )
	LastStrafeRoll = LastStrafeRoll *0.18 -- Change this
	angles.roll = angles.roll +LastStrafeRoll

	if ply:GetGroundEntity() != NULL then
		angles.roll 	= angles.roll +math.sin( BreathTimer *0 ) *BreathSmooth *0.00000003 *BreathSmooth
		angles.pitch 	= angles.pitch +math.cos( BreathTimer *3.5 ) *BreathSmooth *0.001 *ply:GetFOV() *0.006 *BreathSmooth
		angles.yaw 		= angles.yaw +math.cos( BreathTimer *5 ) *BreathSmooth *0.0005 *ply:GetFOV() *0.006 *BreathSmooth
	end

	local shakespeed, shakespeed2, violencescale, violencescale2

	if running then
		shakespeed 		= 1.5
		shakespeed2 	= 6
		violencescale 	= 0.01
		violencescale2 	= 0.1
	else
		shakespeed 		= 1.2
		shakespeed2 	= 2.2
		violencescale 	= 0.5
		violencescale2 	= 0.2
	end

	if ply:GetGroundEntity() ~= NULL then
		angles.roll 	= angles.roll +math.sin( WalkTimer *shakespeed ) *VelSmooth *(0.00003 *violencescale2) *VelSmooth
		angles.pitch 	= angles.pitch +math.cos( WalkTimer *shakespeed2 ) *VelSmooth *(0.000012 *violencescale) *VelSmooth
		angles.yaw 	 	= angles.yaw +math.cos( WalkTimer *shakespeed ) *VelSmooth *(0.000003 *violencescale) *VelSmooth
	end
	if !ply.DashDelta then ply.DashDelta = 0 end
	if ply.DashDelta == nil then return end
	local RUNPOS 	= math.Clamp( ply:GetAimVector().z *30, -30, 50 )*ply.DashDelta
	local NEGRUNPOS = math.Clamp( ply:GetAimVector().z *-30, -30, 20 )*ply.DashDelta

	local ret 		= self.BaseClass:CalcView( ply, origin, angles, fov )
	local running 	= ply:KeyDown( IN_SPEED ) and ply:KeyDown( bit.bor(IN_FORWARD,IN_BACK,IN_MOVELEFT,IN_MOVERIGHT) )
	local scale 	= (running and 3 or 1) *0.01
	local wep 		= ply:GetActiveWeapon()

	return ret
end

function GM:CalcViewModelView( Weapon, ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng )

	local ply = LocalPlayer()

	if ( !IsValid( Weapon ) ) then return end

	if ply.DashDelta == nil then return end

	if ply:InVehicle() then return end

	local vm_origin, vm_angles = EyePos, EyeAng

	-- Controls the position of all viewmodels
	local func = Weapon.GetViewModelPosition
	if ( func ) then
		local pos, ang = func( Weapon, EyePos*1, EyeAng*1 )
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	-- Controls the position of individual viewmodels
	func = Weapon.CalcViewModelView
	if ( func ) then
		local pos, ang = func( Weapon, ViewModel, OldEyePos*1, OldEyeAng*1, EyePos*1, EyeAng*1 )
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	local vel 		= (ply:OnGround() and ply:GetVelocity() or Vector(1, 1, 1))
	local speed 	= vel:Length()
	local onground 	= 1
	local ang 		= ply:EyeAngles()
	local bob 		= Vector(10, 10, 10)
		local running 	= ply:KeyDown( IN_SPEED ) and ply:KeyDown( bit.bor(IN_FORWARD,IN_BACK,IN_MOVELEFT,IN_MOVERIGHT) )
	local scale 	= (running and 3 or 1) *0.01
	local wep 		= ply:GetActiveWeapon()

	WalkTimer = (ply:OnGround() and (WalkTimer +VelSmooth *FrameTime() *0.001) or (WalkTimer +VelSmooth *FrameTime() *0.001))
	VelSmooth = (math.Clamp(VelSmooth *0.9 +speed *0.07, 0, 700 ))
	local RUNPOS 	= math.Clamp( ply:GetAimVector().z *30, -30, 50 )*ply.DashDelta
	local NEGRUNPOS = math.Clamp( ply:GetAimVector().z *-30, -30, 20 )*ply.DashDelta
	if vm_angles then
		vm_angles.roll 	= vm_angles.roll +math.sin( BreathTimer *0 ) *BreathSmooth *0.00000003 *BreathSmooth
		vm_angles.pitch = vm_angles.pitch +math.cos( BreathTimer *3.5 ) *BreathSmooth *-0.001 *ply:GetFOV() *0.006 *BreathSmooth
		vm_angles.yaw = vm_angles.yaw +math.cos( BreathTimer *5 ) *BreathSmooth *0.0005 *ply:GetFOV() *0.006 *BreathSmooth
		if IsValid( wep ) and wep.ModelRunAnglePreset == 1 then
			vm_angles.roll 	= vm_angles.roll +math.sin( WalkTimer *2.2 ) *0.02 *VelSmooth*ply.DashDelta -NEGRUNPOS
			vm_angles.pitch = vm_angles.pitch +math.cos( WalkTimer *1 ) *0.006 *VelSmooth*ply.DashDelta
			vm_angles.yaw 	= vm_angles.yaw +math.cos( WalkTimer *.99 ) *0.05 *VelSmooth*ply.DashDelta
		elseif IsValid( wep ) and wep.ModelRunAnglePreset == 0  then
			vm_angles.roll 	= vm_angles.roll +math.sin( WalkTimer *2.2 ) *0.02 *VelSmooth*ply.DashDelta -RUNPOS
			vm_angles.pitch = vm_angles.pitch +math.cos( WalkTimer *1 ) *0.006 *VelSmooth*ply.DashDelta
			vm_angles.yaw 	= vm_angles.yaw +math.cos( WalkTimer *.99 ) *0.05 *VelSmooth*ply.DashDelta
		elseif IsValid( wep ) and wep.ModelRunAnglePreset == 2 then
			vm_angles.roll 	= vm_angles.roll +math.sin( WalkTimer *2.2 ) *0.02 *VelSmooth*ply.DashDelta -RUNPOS
			vm_angles.pitch = vm_angles.pitch +math.cos( WalkTimer *1 ) *0.006 *VelSmooth*ply.DashDelta
			vm_angles.yaw 	= vm_angles.yaw +math.cos( WalkTimer *.99 ) *0.05 *VelSmooth*ply.DashDelta
		end
	end

	if vm_origin then
		local left = ply:GetRight() *-1
		local up = ang:Up()

		--Tool
		if IsValid( wep ) and wep.ModelRunAnglePreset == 5 and not running then
			vm_origin = vm_origin +(math.sin( WalkTimer *1.8 ) *VelSmooth *0.0025) *left +((math.cos( WalkTimer *3.6 ) *VelSmooth *1) *0.001) *up
		end

		if IsValid( wep ) and wep.ModelRunAnglePreset == 5 and running then
			vm_origin = vm_origin +(math.sin( WalkTimer *1 ) *VelSmooth *0.005) *left +((math.cos( WalkTimer *2 ) *VelSmooth *0.001)) *up
		end

		--Weapons
		if wep.ModelRunAnglePreset ~= 5 and not running and not ply:KeyDown( IN_ATTACK2 ) --fucking hell whyyyyyy --why what?
		or ply:KeyDown( IN_USE ) and ply:KeyDown( IN_ATTACK2 ) and wep.ModelRunAnglePreset ~= 5 and not running and not ply.Sighted then
			vm_origin = vm_origin +(math.sin( WalkTimer *1.8 ) *VelSmooth *0.0025) *left +((math.cos( WalkTimer *3.6 ) *VelSmooth *1) *0.001) *up
		end

		if wep.ModelRunAnglePreset ~= 5 and not running and ply.Sighted then
			vm_origin = vm_origin +(math.sin( WalkTimer *1.8 ) *VelSmooth *0.0002) *left +((math.cos( WalkTimer *3.6 ) *VelSmooth *1) *0.0001) *up
		end

		if wep.ModelRunAnglePreset ~= 5 and running and IsValid( wep ) and wep.ModelRunAnglePreset == 3 then
			vm_origin = vm_origin +(math.sin( WalkTimer *1 ) *VelSmooth *0.005) *left +((math.cos( WalkTimer *2 ) *VelSmooth *0.001)) *up
		end
	end
	
	return vm_origin, vm_angles

end

function GM:SpawnMenuOpen()
	return LocalPlayer():IsSuperAdmin()
end

function GM:ContextMenuOpen()
	return LocalPlayer():IsSuperAdmin()
end

function GM:PreDrawTranslucentRenderables()

	DrawItemInfo( LocalPlayer() );

end

function GM:Think()

	local pl = LocalPlayer()

	if !pl.fadePercent then pl.fadePercent = 0 end

	if pl:GetVelocity() != Vector( 0, 0, 0 ) then
		pl.fadePercent = 0
	elseif pl.fadePercent < 0.9 then
		pl.fadePercent = pl.fadePercent + FrameTime() / 5;
	end

	if !pl.inventory and !pl.sent then
		AskPlayerInventory()
		pl.sent = true
	end

	DisposeRagdolls( pl );

end

-- Hide unused stuff here.
local function HideThings( name )
	if !IsValid(LocalPlayer()) then return end
	if(name == "CHudHealth") or (name == "CHudBattery") or (name == "CHudAmmo") or ((name == "CHudCrosshair") and ThirdPerson ) or (!LocalPlayer():Alive() and (name == "CHudDamageIndicator" )) then
             return false
        end
        -- We don't return anything here otherwise it will overwrite all other
        -- HUDShouldDraw hooks.
end
hook.Add( "HUDShouldDraw", "HideThings", HideThings )

-- This function disposes of ragdolls.
function DisposeRagdolls( ply )

	for _,v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
		if !v.removeTime then
			v.removeTime = 255;
			v:SetRenderMode( RENDERMODE_TRANSALPHA )
		end

		if v.removeTime > 0 then
			v.removeTime = v.removeTime - FrameTime() * 30
			v:SetColor( Color( 255, 255, 255, v.removeTime ));
		else
			v:Remove()
		end
	end

end

-- Fog functions!
// Add World Fog
hook.Add( "SetupWorldFog", "SetupFog", function()

	render.FogMode( 1 )
	render.FogStart( -500 )
	render.FogEnd( 4000  )
	render.FogMaxDensity( 1 )

	render.FogColor( 68, 62, 50	)

	return true

end)

// Add Skybox Fog
hook.Add( "SetupSkyboxFog", "SetupFog", function( skyboxscale )

	render.FogMode( 1 )
	render.FogStart( -500 * skyboxscale )
	render.FogEnd( 4000 * skyboxscale  )
	render.FogMaxDensity( 1 )

	render.FogColor( 68, 62, 50	)

	return true

end)
