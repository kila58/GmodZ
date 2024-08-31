-- Chat check for Can Player See?
local cKeys = {}
cKeys["/"] = {}
cKeys["/"]["ooc"] = function( str, tm, pto, pfrom )
	return true
end
cKeys["/"]["g"] = cKeys["/"]["ooc"]
cKeys["/"]["y"] = cKeys["/"]["ooc"]
cKeys["/"]["/"] = cKeys["/"]["ooc"]

-- Function to check if chat is fine.
function GM:PlayerCanSeePlayersChat( str, tm, pto, pfrom )

	local sign = string.sub( str, 1, 1 )
	local cmd

	-- If the sign is in the table, do something with it.
	if cKeys[sign] then
		local firstSpace = string.find( str, " " )
		if firstSpace then

			cmd = string.sub( str, 2, firstSpace - 1 )
			if cKeys[sign][cmd] then
				return cKeys[sign][cmd]( str, tm, pto, pfrom );
			end

		end
	end

	-- If we're too far don't send chat.
	if ((pto:GetPos() - pfrom:GetPos()):LengthSqr() < 2000000) then
		return true
	else
		return false
	end

end

--My simplistic squad voice system
--Now that the gamemode relies on the addon
--I might as well implement it into the gamemode.
local hearsquad = true

function GM:ShowTeam( ply )
	hearsquad = !hearsquad

	if hearsquad == true then
		ply:ChatPrint("Squad Voice Chat Enabled")
	else
		ply:ChatPrint("Squad Voice Chat Disabled")
	end
end

-- Check if a player can receive voice.
function GM:PlayerCanHearPlayersVoice( pto, pfrom )

	-- If we're too far don't send voice.
	if ((pto:GetPos() - pfrom:GetPos()):LengthSqr() < 2000000) then
		return true
	elseif (pfrom:GetNWInt("SquadGroup") == pto:GetNWInt("SquadGroup")) and (pfrom:GetNWInt("SquadGroup") != 0) and (hearsquad == true) then
		return true
	else
		return false
	end

end

-- Chat system
local pKeys = {}
pKeys["!"] = {}
pKeys["!"]["ooc"] = function( ply, text, public, space )

	if !ply.autoOOC then
		ply.autoOOC = true
		ply:ChatPrint( "Automatic OOC enabled.")
	else
		ply.autoOOC = false
		ply:ChatPrint( "Automatic OOC disabled.")
	end

	return "/ooc " .. string.sub( text, space + 1 )

end
pKeys["!"]["g"] = pKeys["!"]["ooc"]
pKeys["!"]["y"] = pKeys["!"]["ooc"]

-- PlayerSay
function PlySay( ply, text, public )

    local sign = string.sub( text, 1, 1 )
	local cmd

	-- If the sign is in the table, do something with it.
	if pKeys[sign] then
		local firstSpace = string.find( text, " " )
		if firstSpace then

			cmd = string.sub( text, 2, firstSpace - 1 )

			if pKeys[sign][cmd] then
				return pKeys[sign][cmd]( ply, text, public, firstSpace );
			end

		end
	-- If we are on auto ooc, do something.
	elseif ply.autoOOC then
		return "/ooc " .. text
	end

end
hook.Add( "PlayerSay", "PlySay", PlySay );