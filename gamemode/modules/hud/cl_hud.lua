local KillTimer = 0

local function RecvKillTimer()
	KillTimer = net.ReadUInt(32)
end
net.Receive("SendKillTimer",RecvKillTimer)

-- This is the where we draw the hud information.
function GM:HUDPaint()

	blackdeath( LocalPlayer() );

	if !LocalPlayer():Alive() then return end

	DrawInfoBars( LocalPlayer() );
	DrawHPImage( LocalPlayer() );
	DrawAmmoInfo( LocalPlayer() );
	Compass( LocalPlayer() );
	-- Draw names.
	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ))

	DrawMoney( LocalPlayer() );
	DrawNames( LocalPlayer() );
	DrawGradientBars();

	if KillTimer > CurTime() then
	surface.SetDrawColor(50,50,50,200)
	surface.DrawRect(5,5,200,25)
	draw.SimpleText("SZ Timer: "..string.ToMinutesSeconds(KillTimer - CurTime()),"ChatFont",105,17.5,color_white,1,1)
	end

end

-- Thanks StronkHold
function Compass()
	local colComp = Color(
		255,
		255,
		255,
		255
	)
	local Speed = 1
	local TickDist = 1
	local Hight = 0.992
	local Width = 0.500000
	local EyeAngle = LocalPlayer():EyeAngles().yaw*Speed
	local Alpha = 1-math.abs((EyeAngle)/180)
	local addline, addline2, encircle, longtick = 0,0,0,0
	local Degrees = math.Round(180-(EyeAngle/Speed))
	local Center = Degrees > 99 and 10 or Degrees > 9 and 6 or 3
	draw.SimpleText("^","DebugFixed",ScrW()*Width-3,ScrH()*(Hight),Color( colComp.r, colComp.g, colComp.b, 255 ))
	draw.SimpleText(Degrees,"DebugFixed",ScrW()*Width-Center,ScrH()*Hight+5,Color( colComp.r, colComp.g, colComp.b, 255 ))
	surface.SetDrawColor( colComp.r, colComp.g, colComp.b, 255 *Alpha )--255, 255, 255, 255*Alpha )
	draw.SimpleText("S","DebugFixed",(EyeAngle-4)+ScrW()*Width,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
	surface.DrawLine(EyeAngle+ScrW()*Width, ScrH()*Hight, EyeAngle+ScrW()*Width, ScrH()*(Hight-0.01))

	for i=1, 36*Speed do
		addline = math.Round(addline + 10/(Speed/TickDist))
		encircle = EyeAngle + addline*Speed
		Alpha = 1-math.abs((encircle)/(180))

		if addline == 90 or addline == 180 or addline == 270 then
			longtick = 0.01
			if addline == 90 then
				draw.SimpleText("E","DebugFixed",(EyeAngle-4)+ScrW()*Width+addline*Speed,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
			elseif addline == 180 then
				draw.SimpleText("N","DebugFixed",(EyeAngle-4)+ScrW()*Width+addline*Speed,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
			elseif addline == 270 then
				draw.SimpleText("W","DebugFixed",(EyeAngle-4)+ScrW()*Width+addline*Speed,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
			end
		else
			longtick = 0.005
		end

		surface.SetDrawColor( colComp.r, colComp.g, colComp.b, 255 *Alpha )--255, 255, 255, 255*Alpha )
		surface.DrawLine(EyeAngle+ScrW()*Width+addline*Speed, ScrH()*Hight, EyeAngle+ScrW()*Width+addline*Speed, ScrH()*(Hight-longtick))
	end

	for i=1, 36*Speed do
		addline2 = math.Round(addline2 - 10/(Speed/TickDist))
		encircle = EyeAngle + addline2*Speed
		Alpha = 1-math.abs((encircle)/(180))

		if addline2 == -90 or addline2 == -180 or addline2 == -270 then
			longtick = 0.01
			if addline2 == -90 then
				draw.SimpleText("W","DebugFixed",(EyeAngle-4)+ScrW()*Width+addline2*Speed,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
			elseif addline2 == -180 then
				draw.SimpleText("N","DebugFixed",(EyeAngle-4)+ScrW()*Width+addline2*Speed,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
			elseif addline2 == -270 then
				draw.SimpleText("E","DebugFixed",(EyeAngle-4)+ScrW()*Width+addline2*Speed,ScrH()*(Hight-0.024),Color( colComp.r, colComp.g, colComp.b, 255*Alpha ))
			end
		else
			longtick = 0.005
		end

		surface.SetDrawColor( colComp.r, colComp.g, colComp.b, 255 *Alpha )--255, 255, 255, 255*Alpha )
		surface.DrawLine(EyeAngle+ScrW()*Width+addline2*Speed, ScrH()*Hight, EyeAngle+ScrW()*Width+addline2*Speed, ScrH()*(Hight-longtick))
	end
end

function blackdeath( ply )
	if !ply:Alive() then
		surface.SetDrawColor( Color( 0,0,0))
		draw.NoTexture()
		surface.DrawRect( 0,0,ScrW(),ScrH())
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( ScrW() / 2.1, ScrH() / 2 )
		surface.DrawText( "You Are Dead." )
	end
end

-- Draw the healthbar
local hp_bg = Material( "icons/bg_hp_sil.png" )
local hp_in = Material( "icons/in_hp_sil.png" )
function DrawHPImage( ply )

	if !ply:Health() then return end

	local w = 94
	local h = 242
	local padding = 36
	local percent = ply:Health() / 100
	local y = ScrH() - (padding * 3) - (infoBarH * 3)
	local color = Color( 140, 50, 50, 255 )

	// Background image.
	render.SetMaterial( hp_bg )
	render.DrawQuadEasy( Vector( padding + w/2, ScrH() - h/2,0),    --position of the rect
        Vector(0,0,-1),        --direction to face in
        w, h,              --size of the rect
        Color( 10, 10, 10, 200 ),  --color
        -90                     --rotate 90 degrees
    )

	// Second background image
	render.SetMaterial( hp_in )
	render.DrawQuadEasy( Vector( padding + w/2, ScrH() - h/2,0),    --position of the rect
        Vector(0,0,-1),        --direction to face in
        w, h,              --size of the rect
        Color( 40, 10, 10, 240 ),  --color
        -90                     --rotate 90 degrees
    )

	// Draw the actual HP
	render.SetScissorRect( 0, ScrH() - (h * percent), padding + w, ScrH(), true )
	render.SetMaterial( hp_in )
	render.DrawQuadEasy( Vector( padding + w/2, ScrH() - h/2,0),    --position of the rect
        Vector(0,0,-1),        --direction to face in
        w, h,              --size of the rect
        color,  --color
        -90                     --rotate 90 degrees
    )
	render.SetScissorRect( 0, ScrH() - h + 20, padding + w, ScrH(), false )

	// Draw HP number.
	if ply:Health() > 0 then
		draw.SimpleTextOutlined( ply:Health(), "ChatFont", padding + w/2 - 4, ScrH() - h/2 - 26, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ))
	end

end

-- Wut
local ammo_bg = Material( "icons/bg_bullet.png" )
function DrawAmmoInfo( ply )

	local wep = ply:GetActiveWeapon()

	if wep:IsValid() then

		local clip = wep:Clip1();
		if clip and clip >= 0 then

			local padding = 10
			local w = 200
			local h = 100

			surface.SetMaterial( ammo_bg )
			surface.SetDrawColor( 10, 10, 10, 240 )
			surface.DrawTexturedRect( ScrW() - padding - w, ScrH() - padding - h, w, h )

			draw.SimpleText( wep:Clip1() or 0, "HUDInfo", ScrW() - padding - w/1.6, ScrH() - padding - h/2 + 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, 1 )
			draw.SimpleText( " x " .. ply:GetAmmoCount( wep:GetPrimaryAmmoType() ) , "HUDInfoSmall", ScrW() - padding - w/1.6, ScrH() - padding - h/2 + 3, Color(150, 50, 50, 255), TEXT_ALIGN_LEFT, 1 )
		end

	end

end

-- This is the health, thirst and hunger bar.
function DrawInfoBars( ply )

	local padding = 20
	local w = 12
	local h = 190
	local bgc = Color( 10, 10, 10, 200 )
	local inc = Color( 30, 30, 30, 200 )
	local color = Color( 50, 50, 120, 255 )

	-- Draw thirst if player has any.
	if ply.thirst then

		local percent = ply.thirst / 100
		local y = math.Round( h * percent )

		surface.SetDrawColor( bgc )
		surface.DrawRect( padding - 2, ScrH() - padding - h - 2, w + 4, h + 4 )

		surface.SetDrawColor( inc )
		surface.DrawRect( padding, ScrH() - padding - h, w, h )

		surface.SetDrawColor( color )
		surface.DrawRect( padding, ScrH() - padding - y, w, y )

	end

	-- Draw thirst if player has any.
	if ply.hunger then

		color = Color( 120, 120, 50, 255 )
		local offset = 114
		local percent = ply.hunger / 100
		local y = math.Round( h * percent )

		surface.SetDrawColor( bgc )
		surface.DrawRect( offset + padding - 2, ScrH() - padding - h - 2, w + 4, h + 4 )

		surface.SetDrawColor( inc )
		surface.DrawRect( offset + padding, ScrH() - padding - h, w, h )

		surface.SetDrawColor( color )
		surface.DrawRect( offset + padding, ScrH() - padding - y, w, y )

	end

	-- Draw player stam.
	if ply.stamina then

		local percent = ply.stamina / 100
		local offset = 160
		local y = math.Round( 150 * percent )

		surface.SetDrawColor( infoBarColors.bg )
		surface.DrawRect( offset - 2, ScrH() - 152 - padding, 14, 154 )

		surface.SetDrawColor( infoBarColors.stamina )
		surface.DrawRect( offset, ScrH() - y - padding, 10, y )

	end

end

-- This function draws the info on items.
function DrawItemInfo( ply )

	local itemTable = ents.FindInSphere( ply:GetPos(), 170 );

	-- For each, loop through them.
	for k,v in pairs( itemTable ) do

		-- If it's an item. Draw something to tell the player.
		if v:GetClass() == "gmodz_item" then

			-- Retrieve the information of this item.
			if !v.askedInfo then
				v.askedInfo = true;
				AskItemInfo( v )
			end

			if v.id == "none" then return end

			local infoH = 18 - math.cos(CurTime() * 2) * 2
			local offset = Vector( 0, 0, infoH )
			local ang = LocalPlayer():EyeAngles()
			local pos = v:GetPos() + offset + ang:Up()

			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			if v.id != "none" then

				local w,h = surface.GetTextSize( items[v.id].name )

				if !w or !h then
					w = 40
					h = 10
				end

				w = (w + 12)
				h = (h + 4)

				cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.2 )

					surface.SetDrawColor( Color( 100, 100, 100, 50 ))
					surface.DrawRect( -w/2 - 2, -2, w + 4, h + 4 )

					surface.SetDrawColor( Color( 40, 40, 40, 255 ))
					surface.DrawRect( -w/2, 0, w, h )

					draw.DrawText( items[v.id].name, "HudHintTextLarge", 0, 2, Color( 50, 255, 50, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				cam.End3D2D()

			end

		elseif v:GetClass() == "gmodz_inv" then


			local w,h = surface.GetTextSize( "Backpack" )
			w = (w + 12)
			h = (h + 4)

			local offset = Vector( 1, 10, 24 )
			local ang = LocalPlayer():EyeAngles()
			local pos = v:GetPos() + offset + ang:Up()

			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			cam.Start3D2D( pos, Angle( 0, 0, 0 ), 0.3 )

				surface.SetDrawColor( Color( 100, 100, 100, 50 ))
				surface.DrawRect( -w/2 - 2, -2, w + 4, h + 6 )

				surface.SetDrawColor( Color( 40, 40, 40, 255 ))
				surface.DrawRect( -w/2, 0, w, h + 2 )

				draw.DrawText( "Inventory", "HudHintTextLarge", 0, 2, Color( 255, 255, 50, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			cam.End3D2D()

		end
	end
end

-- Draw the names above players and NPCs
function DrawNames( ply )

	for k,v in pairs(player.GetAll()) do

		--if v:Crouching() then return end

		if (ply:GetPos() - v:GetPos()):LengthSqr() < 700000 and v != ply and (v:GetMoveType() != MOVETYPE_NOCLIP) then

			local trace = {}

			trace.start = ply:GetPos() + Vector(0, 0, 70)
			trace.endpos = v:GetPos() + Vector(0, 0, 70)
			trace.filter = { ply, v }
			trace.mask = MASK_SHOT

			local tr = util.TraceLine( trace )
			if tr.Hit then
				continue
			end

			local sPos = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
			local sPosunid = (v:GetPos() + Vector(0, 0, 95)):ToScreen()
			local color = infoBarColors.health

			if v:Health() > 70 then
				color = infoBarColors.healthGood
			elseif v:Health() > 40 then
				color = infoBarColors.healthOk
			end

			if ply:IsAdmin() then
				draw.SimpleText("UNID: "..v:UniqueID().."", "Trebuchet18", sPosunid.x, sPosunid.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			draw.SimpleText("".. v:Nick() ..": ".. v:GetUserGroup(), "Trebuchet18", sPos.x, sPos.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end

end

-- This function draws money on the game.
function DrawMoney( ply )

	if !Money then return end
	local text = "Cash: $" .. Money .. ""
	w = 120 + 20
	h = 30 + 10

	if !MoneyColor then MoneyColor = 0 end

	local col = Color( 255, 255, 255, 255 )
	if MoneyColor < 0 then
		col = Color( 255, 255 + 255 * MoneyColor, 255 + 255 * MoneyColor, 255 )
	elseif MoneyColor > 0 then
		col = Color( 255 - 255 * MoneyColor, 255, 255 - 255 * MoneyColor, 255 )
	end
	MoneyColor = math.Approach( MoneyColor, 0, FrameTime() * 1.5 )

	surface.SetMaterial( ammo_bg )
	surface.SetDrawColor( Color( 10, 10, 10, 240 ) )
	surface.DrawTexturedRect( ScrW()/2 - w/2, ScrH() - h - 16 - 10, w, h )
	draw.SimpleText( text, "ChatFont", ScrW() / 2, ScrH() - h/2 - 16 - 10, col, 1, 1 )

end

local gradient = surface.GetTextureID( "gui/gradient" )
function DrawGradientBars()

	surface.SetDrawColor( 10, 10, 10, 150 )
	surface.SetTexture( gradient )
	surface.DrawTexturedRectRotated( ScrW() / 2, 40, 80, ScrW(), -90)
	surface.DrawTexturedRectRotated( ScrW() / 2, ScrH() - 40, 80, ScrW(), 90)
	surface.DrawTexturedRectRotated( 40, ScrH() / 2, 80, ScrW(), 0)
	surface.DrawTexturedRectRotated( ScrW() - 40, ScrH() / 2, 80, ScrW(), 180)

end