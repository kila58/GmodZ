-- Chat system
local gKeys = {}
gKeys["/"] = {}
gKeys["/"]["ooc"] = function( ply, text, tc, isDead, space )

	local groupcolor = Color(0, 0, 0)
	local grouptag = "[]"

	local realtime = CurTime()
	local time = realtime - 0.1
	local r = math.abs( math.sin( time * 2 ) * 255 )
	local g = math.abs( math.sin( time * 2 + 2 ) * 255 )
	local b = math.abs( math.sin( time * 2 + 4 ) * 255 )

	if ply:GetUserGroup() == "superadmin" then
		groupcolor = Color(math.random(1, 255), math.random(1, 255), math.random(1, 255))
		grouptag = "[SA] "
	elseif ply:GetUserGroup() == "vip_admin" then
		groupcolor = Color(247, 247, 0)
		grouptag = "[VIPA] "
	elseif ply:GetUserGroup() == "admin" then
		groupcolor = Color(0, 43, 255)
		grouptag = "[A] "
	elseif ply:GetUserGroup() == "vip_moderator" then
		groupcolor = Color(247, 247, 0)
		grouptag = "[VIPM] "
	elseif ply:GetUserGroup() == "moderator" then
		groupcolor = Color(0, 255, 0)
		grouptag = "[M] "
	elseif ply:GetUserGroup() == "vip" then
		groupcolor = Color(247, 247, 0)
		grouptag = "[VIP] "
	elseif ply:GetUserGroup() == "vip_tempmod" then
		groupcolor = Color(247, 247, 0)
		grouptag = "[VIPTEMP] "
	elseif ply:GetUserGroup() == "tempmod" then
		groupcolor = Color(255, 0, 0)
		grouptag = "[TEMP] "
	elseif ply:GetUserGroup() == "user" then
		groupcolor = Color( 100, 100, 100 )
		grouptag = "[USER] "
	elseif ply:SteamID() == "STEAM_0:0:15291647" then
		groupcolor = Color( 255, 153, 255 )
		grouptag = "[Jarl~<3] "
	end

	chat.AddText( 	Color( 100, 100, 100 ),
				"[OOC] ",
				groupcolor,
				grouptag,
				Color( 180, 180, 180 ),
				ply:Nick() .. ": ",
				Color( 230, 230, 230 ),
				string.sub( text, space + 1 ) )
end
gKeys["/"]["g"] = gKeys["/"]["ooc"]
gKeys["/"]["y"] = gKeys["/"]["ooc"]
gKeys["/"]["/"] = gKeys["/"]["ooc"]

gKeys["!"] = {}
gKeys["!"]["ooc"] = function( ply, text, tc, isDead, space )

	if ply:IsAdmin() then
		chat.AddText( 	Color( 100, 100, 100 ),
					"[OOC] ",
					Color( 230, 50, 50 ),
					"[A] ",
					Color( 180, 180, 180 ),
					ply:Nick() .. ": ",
					Color( 230, 230, 230 ),
					string.sub( text, space + 1 ) )
	else
		chat.AddText( 	Color( 100, 100, 100 ),
					"[OOC] ",
					Color( 180, 180, 180 ),
					ply:Nick() .. ": ",
					Color( 230, 230, 230 ),
					string.sub( text, space + 1 ) )
	end

end
gKeys["!"]["g"] = gKeys["!"]["ooc"]
gKeys["!"]["y"] = gKeys["!"]["ooc"]

-- The actual function that changes color and stuff.
function GM:OnPlayerChat( ply, text, tc, isDead )

	local sign = string.sub( text, 1, 1 )
	local cmd

	-- If the sign is in the table, do something with it.
	if gKeys[sign] then

		local firstSpace = string.find( text, " " )
		if firstSpace then

			cmd = string.sub( text, 2, firstSpace - 1 )
			if gKeys[sign][cmd] then
				gKeys[sign][cmd]( ply, text, tc, isDead, firstSpace );
				return true
			end

		end

	end

	-- Normal text.
	chat.AddText( 	Color( 200, 150, 0 ),
					ply:Nick() .. ": ",
					Color( 255, 255, 255 ),
					text )
	return true

end