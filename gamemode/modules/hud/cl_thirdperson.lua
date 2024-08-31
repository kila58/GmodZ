--
-- Thirdperson file. Awww yea
--

function MyCalcView(ply, pos, angles, fov)

	if !ply.lastCamPos then ply.lastCamPos = pos end

	pos = pos - (angles:Right() * -25 ) - (angles:Forward()* 70)

	local lerpFactor = FrameTime() * 20
	if lerpFactor > 1 then lerpFactor = 1 end

	//realPos = LerpVector( lerpFactor, ply.lastCamPos, pos )
	trPos = ply:EyePos()

	local tr = {}
	tr.start = trPos
	tr.endpos = pos
	tr.filter = { LocalPlayer() }
	tr.mask = MASK_SHOT

	// Trace to check if we hit something on the way.
	local trace = util.TraceLine( tr )
	if trace.Hit then
		pos = trace.HitPos + (angles:Forward() * 10)
	end

	realPos = LerpVector( lerpFactor, ply.lastCamPos, pos )

	local aim = ply:GetEyeTrace()
	local camPos = aim.HitPos - realPos
	local camAngle = camPos:Angle()

    local view = {}
    view.origin = realPos
    view.angles = Angle( camAngle.p, angles.y, 0 )
    view.fov = fov

	ply.lastCamPos = realPos

    return view
end

-- This function draws the third person crosshair (Sight Line).
local chMat = Material( "sprites/splodesprite" )
function DrawTPCrosshair( ply )

	if ply == LocalPlayer() then
		local aim = util.TraceLine(util.GetPlayerTrace( ply ))
		local pos = ply:GetShootPos()

		if IsValid( ply:GetActiveWeapon() ) then
			if ply:GetActiveWeapon():GetBonePosition(1) then
				//pos = ply:GetActiveWeapon():GetBonePosition(1)
			end
		end

		render.SetMaterial(Material("sprites/bluelaser1"))

		// Color
		local col = Color( 50, 50, 50, 100)
		if aim.Hit and ( aim.Entity:IsPlayer() or aim.Entity:IsNPC() ) then
			col = Color( 255, 50, 50, 100 )
		end

		render.DrawBeam( pos + (ply:EyeAngles():Forward() * 45 ) , aim.HitPos, 2, 0, 12.5, col )
	end

end

// Draw the 3D hud for thirdperson mode.
function TPHud()

	local ply = LocalPlayer()
	local pos, ang = ply:GetBonePosition(2)

	pos = pos - ( ang:Right() * -6 )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )

	cam.Start3D2D( pos, ang, 0.1 )

		local offsetY = -100
		local offsetX = -10
		local width = 100

		-- HP Bar
		-- Draw health if player has any.
		if ply:Health() then

			local percent = ply:Health() / 100

			surface.SetDrawColor( infoBarColors.bg )
			surface.DrawRect( offsetX -width / 2, offsetY, width, 15 )

			if percent > 0.7 then
				surface.SetDrawColor( infoBarColors.healthGood )
			elseif percent > 0.3 then
				surface.SetDrawColor( infoBarColors.healthOk )
			else
				surface.SetDrawColor( infoBarColors.health )
			end

			surface.DrawRect( offsetX - width / 2, offsetY, width * percent, 15 )
			draw.SimpleText( ply:Health(), "ChatFont", offsetX , offsetY + 7, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Health", "Default", offsetX - 44, offsetY - 8, Color( 150, 150, 150, 255 * ( ply.fadePercent or 1 ) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		offsetY = -78

		-- Thirst bar.
		if ply.thirst then

			local percent = ply.thirst / 100

			surface.SetDrawColor( infoBarColors.bg )
			surface.DrawRect( offsetX  -width / 2, offsetY + 6, width, 10 )

			surface.SetDrawColor( infoBarColors.thirst )
			surface.DrawRect( offsetX  - width / 2, offsetY + 6, width * percent, 10 )

			draw.SimpleText( "Thirst", "Default", offsetX - 44, offsetY , Color( 150, 150, 150, 255 * ( ply.fadePercent or 1 ) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		-- Hunger bar
		if ply.hunger then

			local percent = ply.hunger / 100

			surface.SetDrawColor( infoBarColors.bg )
			surface.DrawRect( offsetX -width / 2, offsetY + 28, width, 10 )

			surface.SetDrawColor( infoBarColors.hunger )
			surface.DrawRect( offsetX - width / 2, offsetY + 28, width * percent, 10 )

			draw.SimpleText( "Hunger", "Default", offsetX - 44, offsetY + 22, Color( 150, 150, 150, 255 * ( ply.fadePercent or 1 ) ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		end

		-- Stamina bar
		if ply.stamina then

			local percent = ply.stamina / 100

			surface.SetDrawColor( infoBarColors.bg )
			surface.DrawRect( 50, offsetY + 40, 5, -64 )

			surface.SetDrawColor( infoBarColors.stamina )
			surface.DrawRect( 50, offsetY + 40, 5, percent * -64 )

		end

	cam.End3D2D()

end

// Add a console command to toggle the thirperson view.
function ToggleTP()

	// Toggle or not ThirdPerson
	if ThirdPerson then
		hook.Remove( "CalcView", "CalcTP" )
		hook.Remove( "PrePlayerDraw", "DrawTP" )
		hook.Remove( "ShouldDrawLocalPlayer", "DrawLocal" )
		hook.Remove( "PostPlayerDraw", "TPHud" )

		ThirdPerson = false
	else
		hook.Add( "CalcView", "CalcTP", MyCalcView)
		hook.Add( "PrePlayerDraw", "DrawTP", DrawTPCrosshair )
		hook.Add( "PostPlayerDraw", "TPHud", TPHud )

		-- Draw the local player.
		hook.Add("ShouldDrawLocalPlayer", "DrawLocal", function(ply)
			return true
		end)

		ThirdPerson = true
	end

end
concommand.Add( "gmodz_thirdperson", ToggleTP )
usermessage.Hook( "ply_thirdperson", ToggleTP )
