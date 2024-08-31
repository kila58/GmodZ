



if SERVER then
	
	AddCSLuaFile()
	
	local maxLogs = 2500
	local logs = {}
	hook.Add("EntityTakeDamage", "gmodz_inform", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() then return end
		
		local attacker = dmginfo:GetAttacker()
		local damage = dmginfo:GetDamage()
		local inflictor = dmginfo:GetInflictor()
		local health = target:Health()-damage
		
		local msg = Format("[%s] DAMAGE: '%s'(%s)[%d HP] took '%d' damage from ", os.date("%X"), target:Name(), target:SteamID(), health, damage)
		
		if IsValid(attacker) then
			if attacker:IsPlayer() then
				if IsValid(inflictor) then
					msg = msg..Format("player '%s'(%s) with weapon '%s' and inflictor '%s'", attacker:Name(), attacker:SteamID(), tostring(attacker:GetActiveWeapon()), tostring(inflictor))
				else
					msg = msg..Format("player '%s'(%s) with weapon '%s' and an unknown inflictor.", attacker:Name(), attacker:SteamID(), tostring(attacker:GetActiveWeapon()))
				end
				table.insert(logs, 1, {msg, target:GetShootPos(), attacker:GetShootPos()})
			else
				msg = msg..Format("entity '%s'.", tostring(attacker))
				
				table.insert(logs, 1, {msg, target:GetShootPos(), attacker:GetPos()})
			end
		else
			if dmginfo:IsFallDamage() then
				msg = msg.."a fall."
			else
				msg = msg.."an unknown source."
			end
			table.insert(logs, 1, {msg, target:GetShootPos(), target:GetShootPos()})
		end
		
		print(msg)
		
		logs[maxLogs+1] = nil
		
	end)
	
	util.AddNetworkString("gmodz_inform")
	
	concommand.Add("dmglog", function(ply, _, args)
		if not ply:IsAdmin() and not ply:IsUserGroup("moderator") then return end
		
		local num = tonumber(args[1] or "") or 300
		num = math.min(math.min(num, maxLogs), #logs)
		
		net.Start("gmodz_inform")
			net.WriteUInt(num, 32)
			for i=num, 1, -1 do
				local log = logs[i]
				if not log then num = i break end
				net.WriteString(log[1])
				net.WriteVector(log[2])
				net.WriteVector(log[3])
			end
		net.Send(ply)
	end)
else
	
	local logs
	local logSelect
	
	net.Receive("gmodz_inform", function()
		logs = {}
		local num = net.ReadUInt(32)
		for i=1, num do
			logs[i] = {net.ReadString(), net.ReadVector(), net.ReadVector()}
			print(i, logs[i][1])
		end
	end)
	
	concommand.Add("dmglog_view", function(_, _, args)
		logSelect = tonumber(args[1] or "")
	end)
	
	concommand.Add("dmglog_current", function(_, _, args)
		if not logs then print("There are no logs to view. Use 'dmglog' first.") end
		for i=1, #logs do
			print(i, logs[i][1])
		end
	end)
	
	local function drawLine(a, b)
		a = a:ToScreen()
		b = b:ToScreen()
		
		if not a.visible or not b.visible then return end
		
		surface.DrawLine(a.x, a.y, b.x, b.y)
	end
	
	local function drawMark(pos)
		local s = 15
		drawLine(pos-Vector(s, 0, 0), pos+Vector(s, 0, 0))
		drawLine(pos-Vector(0, s, 0), pos+Vector(0, s, 0))
		drawLine(pos-Vector(0, 0, s), pos+Vector(0, 0, s))
	end
	
	hook.Add("HUDPaint", "gmodz_inform", function()
		if not logs or not logSelect then return end
		
		local log = logs[logSelect]
		
		if not log then return end
		
		local to = log[2]:ToScreen()
		local from = log[3]:ToScreen()
		
		if not from.visible or not to.visible then return end
		
		surface.SetDrawColor(255, 0, 255, 255)
		surface.DrawLine(from.x, from.y, to.x, to.y)
		
		surface.SetDrawColor(255, 0, 0, 255)
		drawMark(log[3])
		
		surface.SetDrawColor(0, 255, 0, 255)
		drawMark(log[2])
		
	end)
end



