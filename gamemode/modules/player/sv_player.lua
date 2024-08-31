function GM:PlayerAuthed( ply )

	ply.authed = true;
	ply:Initialize();
	ply:RetrieveStats();
	ply:InformMoney()

	-- Simple Timers for hunger and stuff. Will be changed.
	timer.Create( ply:UniqueID() .. "thirsthunger" , 15, 0, function()
		if ply:Alive() and !ply:InInnerSafezone() then
			ply:SetThirst( ply:Thirst() - math.Rand(1, 2) )
			ply:SetHunger( ply:Hunger() - math.Rand(1, 2) )
		end
	end )

	timer.Create( ply:UniqueID() .. "stamina", 0.5, 0, function()

		if IsValid( ply ) and ply:Alive() and ply.stamNextChange < CurTime() then
			ply:SetStamina( ply.stamina + 4 )
		end

	end)

end

function GM:SetupMove( ply, mv )

	// Check for stamina.
	if ply:KeyDown( IN_SPEED ) then
		ply:SetStamina( ply.stamina - 0.15 )
		if ply.stamina <= 0 and ply:GetRunSpeed() != ply:GetWalkSpeed() then
			ply:SetRunSpeed( ply.baseWalkSpeed )
		elseif ply.stamina > 0 and ply:GetRunSpeed() == ply:GetWalkSpeed() then
			ply:SetRunSpeed( ply.baseRunSpeed )
		end
	end

end

function GM:PlayerDisconnected( ply )
	--kill if they have a timer
	if ply.KillTimer and ply.KillTimer > CurTime() then
		ply:Kill()
	end
	-- Save the inventory
	ply:SaveInventory()

	-- Delete the inventory
	DeleteInventory( ply.inventory )

end

-- Flashlight check function.
function GM:PlayerSwitchFlashlight(ply, SwitchOn)

	-- Check if the player has the flashlight item.
	if ply.itemVars and ply.itemVars["flashlight"] then
		return SwitchOn or true
	end

end

function GM:EntityRemoved( ent )

	if ent:IsPlayer() then
		print( ent:Nick() .. " has been removed." )
		timer.Remove( ent:UniqueID() .. "thirsthunger" );
		timer.Remove( ent:UniqueID() .. "wakemobs" );
	end

end

function GM:ShowHelp( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "ply_open_bank", ply ) -- Sending a message to the client.
    umsg.End()
end

function GM:ShowSpare2( ply ) -- This hook is called everytime F1 is pressed.
    umsg.Start( "ply_thirdperson", ply ) -- Sending a message to the client.
    umsg.End()
end

