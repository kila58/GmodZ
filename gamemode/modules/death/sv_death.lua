util.AddNetworkString("SendKillTimer")

function GM:PlayerDeathThink( ply )

	-- Only respawn if authed and respawn time is over.
	if ply.authed and ply.respawnTime < CurTime() then
		ply:Spawn()
	elseif ply.respawnTime < CurTime() then
		ply:Spawn()
	end

end

function GM:PlayerDeath( ply, killer )
	Pos = ply:GetPos()

	-- put back 'used' ammo before dropping
	for ammo_gmod, ammo_item in pairs(items.ammoTranslations) do
		local count = ply:GetAmmoCount(ammo_gmod)
		if count > 0 then
			ply:AddItem(ammo_item, count)
		end
	end
	
	ply:DropInventory()
	ply:RemoveAllAmmo();
	ply:ResetStats()
	ply:RetrieveStats()
	ply.respawnTime = CurTime() + 10
	--ply:ChatPrint( "You died at " ..tostring(Pos).. ", Player " .. killer:GetName() .. " killed you." )

	ply.KillTimer = nil
	net.Start("SendKillTimer")
		net.WriteUInt(0,32)
	net.Send(ply)
	if IsValid(killer) and killer:IsPlayer() and killer ~= ply then
	--Print to the player who killed him and where he died
		ply:ChatPrint( "You died at " ..tostring(ply:GetPos()).. ", Player " .. killer:GetName() .. " killed you." )
		killer.KillTimer = CurTime() + 300
		net.Start("SendKillTimer")
		net.WriteUInt(killer.KillTimer,32)
		net.Send(killer)
		ply:SetWalkSpeed( 140 );
		ply:SetRunSpeed( 210 );
	end

end

local function checkgod()
	for k,v in pairs(player.GetAll()) do
		if v:HasGodMode() then
			v:SetColor( Color(255,255,255,200) )
			v:SetRenderMode( RENDERMODE_TRANSALPHA )
		else
			v:SetColor( Color(255,255,255,255) )
			v:SetMaterial( "" )
		end
	end
end

local function CheckKillTimer()
	for k,v in pairs(player.GetAll()) do
		if v.KillTimer and v.KillTimer > CurTime() and v:InInnerSafezone() then
			v:Kill()
			local vPoint = v:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart( vPoint )
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 1 )
			util.Effect( "HelicopterMegaBomb", effectdata )
		end
	end
end
timer.Create("CheckKillTimer",1,0,CheckKillTimer)
timer.Create("CheckGod",.1,0,checkgod)

function GM:EntityTakeDamage(ent,dmg)
	if IsValid(ent) and ent:IsPlayer() then
		if ent:InInnerSafezone() then
			dmg:ScaleDamage(0)
			return
		end
		if ent:InOuterSafezone() and ent:HasGodMode() then
			dmg:ScaleDamage(0)
			return
		end
		local attacker = dmg:GetAttacker()
		if ent ~= attacker and ent:IsPlayer() and IsValid(attacker) and attacker:IsPlayer() and dmg:GetDamage() > 1 then
		local newTimer = CurTime()+180
		if not attacker.KillTimer or newTimer > attacker.KillTimer then
			attacker.KillTimer = newTimer
			net.Start("SendKillTimer")
				net.WriteUInt(attacker.KillTimer,32)
			net.Send(attacker)
		end
			if attacker:InInnerSafezone() then
				dmg:ScaleDamage(0)
				return
			end
			if attacker:InOuterSafezone() and ent:HasGodMode() or attacker:HasGodMode() then
				dmg:ScaleDamage(0)
				return
			end
		end
	end
end