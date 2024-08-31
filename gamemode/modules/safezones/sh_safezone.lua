------------------------------

--		Safezone Script		--

------------------------------

IsGod = false



local Ply = FindMetaTable("Player")



local outer = {

	Vector( 4111, -8289),

	Vector(-2205, -8289),

	Vector(-2205, -20000),

	Vector( 4111, -20000),

}

local bunker = {
	Vector(-1833, -13061),

	Vector(-1832, -13306),

	Vector(-1476, -13059),

	Vector(-1477, -13308),

}

local house1 = {

	Vector(-2032, -11024),

	Vector(-2032, -11502),

	Vector(-1422, -11507),

	Vector(-1422, -11024),

}

local house2 = {

	Vector(-2030, -12534),

	Vector(-1783, -12534),

	Vector(-1783, -12788),

	Vector(-1292, -12788),

	Vector(-1292, -12662),

	Vector(- 779, -12662),

	Vector(- 779, -12170),

	Vector(-1292, -12170),

	Vector(-1292, -12043),

	Vector(-1783, -12043),

	Vector(-1783, -12301),

	Vector(-2030, -12301),

}

local inner = {

	Vector( 1735, -11477),

	Vector(  893, -10617),

	Vector(   78, -10617),

	Vector(- 580, -11424),

	Vector(- 580, -12107),

	Vector(  220, -12841),

	Vector(  966, -12841),

	Vector( 1735, -12119),

}



local function pointInsidePolygon(poly, x, y)

	local len = #poly

	local inside = false

	for i=1, len do

		local pa = poly[i]

		local pb = poly[i%len + 1]



		if (pa.y > y) ~= (pb.y > y) and (x < (pb.x-pa.x) * (y-pa.y) / (pb.y-pa.y) + pa.x) then

			inside = not inside

		end

	end

	return inside

end



function Ply:InInnerSafezone()

	local pos = self:GetPos()

	local x, y = pos.x, pos.y

	return pointInsidePolygon(inner, x, y)

end

function Ply:InOuterSafezone()

	local pos = self:GetPos()

	local x, y = pos.x, pos.y

	return pointInsidePolygon(outer, x, y) and not pointInsidePolygon(house1, x, y) and not pointInsidePolygon(house2, x, y) and not pointInsidePolygon(bunker, x, y)

end



if CLIENT then

	-- Super useful get position utility your welcome

	concommand.Add("copypos", function(ply)

		local pos = ply:GetPos()

		SetClipboardText(Format("Vector(%d, %d, %d)", math.Round(pos.x), math.Round(pos.y), math.Round(pos.z)))

	end)

	concommand.Add("copyang", function(ply)

		local ang = ply:GetAngles()

		SetClipboardText(Format("Angle(%d, %d, %d)", math.Round(ang.p), math.Round(ang.y), math.Round(ang.r)))

	end)

end



if SERVER then

	util.AddNetworkString("GodMode")

	-- Apply god mode to those in inner safezone and revoke from those outside outer safezone.

	local nextThink

	hook.Add("Think", "SafeZone", function()

		if nextThink and CurTime() < nextThink then return end

		nextThink = CurTime() + 0.1



		for _,ply in pairs(player.GetAll()) do

			if ply.KillTimer and CurTime() < ply.KillTimer then

				ply:GodDisable()

			else

				if ply:InInnerSafezone() then ply:GodEnable() end

				if not ply:InOuterSafezone() then ply:GodDisable() end

			end

			net.Start("GodMode")

			if ply:HasGodMode() then

				net.WriteString("yesgod")

			else

				net.WriteString("nogod")

			end

			net.Send(ply)

		end

	end)

end



-- Safezone notice.

if CLIENT then

	local HasGod = ""

	net.Receive("GodMode", function()
		HasGod = net.ReadString()
	end)

	local function drawPolygon(tbl)

		local len = #tbl



		for i=1, len do

			local pa = tbl[i]

			local pb = tbl[i%len + 1]



			pa.z = -620

			pb.z = -620

			pa = pa:ToScreen()

			pb = pb:ToScreen()



			if pa.visible and pb.visible then

				surface.DrawLine(pa.x, pa.y, pb.x, pb.y)

			end

		end

	end

	hook.Add( "HUDPaint", "Safezone", function()



		local pl = LocalPlayer()



		local x = ScrW() * 0.5

		local y = ScrH() * 0.1

		-- In the outer safezone and godded. (admins in sit have god mode)

		if pl:InOuterSafezone() and (HasGod == "yesgod") --[[and pl:HasGodMode()]] then



			surface.SetFont("ChatFont")



			local text = "You are in the safezone, you can't deal damage and you can't be hurt by players."

			local w,h = surface.GetTextSize( text )

			w = w + 40

			h = h + 20



			draw.RoundedBox( 6,  x - w/2, y, w, h, Color( 0, 0, 0, 100 ) )

			draw.SimpleText( text, "ChatFont", x, y + h/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end



		-- Can only access bank in the inner safezone

		if pl:InInnerSafezone() and (HasGod == "yesgod")--[[pl:HasGodMode()]] then



			local text = "You can press F1 to open your bank."

			local w,h = surface.GetTextSize( text )

			surface.SetFont("ChatFont")

			w = w + 40

			h = h + 20



			draw.RoundedBox( 6, x - w/2, y + 40, w, h, Color( 0, 0, 0, 100 ) )

			draw.SimpleText( text, "ChatFont", x, y + h/2 + 40, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )



		end





		-- Debug draw the boundaries
	--[[
		surface.SetDrawColor(255, 0, 0, 255)

		drawPolygon(outer)

		drawPolygon(house1)

		drawPolygon(bunker)

		drawPolygon(house2)



		surface.SetDrawColor(0, 255, 0, 255)

		drawPolygon(inner)
		]]





	end)
end
