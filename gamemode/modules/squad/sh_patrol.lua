
local LetAutoJoin = false

SQUADGroups = SQUADGroups or {}
SQUADGroups.Users = SQUADGroups.Users or {}


net.Receive("NoSendLuaPlz",function()
	local ply = net.ReadEntity()
	local txt = net.ReadString()
	local tC = team.GetColor(ply:Team())
	chat.AddText(Color(80,150,255),"(SQUAD) ",tC,sql.SQLStr(ply:Nick()..": ",true),Color(235,235,235),sql.SQLStr(txt,true))
end)

local PLY = FindMetaTable("Player")

function PLY:SetupDataTables()

	self:NetworkVar( "Float", 0, "ok" )

end

if SERVER then

util.AddNetworkString("SquadCreateGroup")
util.AddNetworkString("SquadLeaveGroup")

util.AddNetworkString("AskToJoin")

util.AddNetworkString("Answer")

util.AddNetworkString("SquadInviteGroup")
util.AddNetworkString("SquadInviteGroupTClient")
util.AddNetworkString("SquadInviteGroupTServer")

util.AddNetworkString("InviteRequest") --Is sent when invited, includes information like inviters name

util.AddNetworkString("SquadUpdateSettings")

util.AddNetworkString("SquadGroupUpdate")

util.AddNetworkString("SquadRemove")
util.AddNetworkString("CreateSquadMenu")

util.AddNetworkString("SquadFreezeCam")
util.AddNetworkString("SquadDrawScreen")

util.AddNetworkString("SquadUpdateHired")
util.AddNetworkString("NoSendLuaPlz")

SQUADGroups.AG = SQUADGroups.AG or 0

function SQUADGroups:Update()
	net.Start("SquadGroupUpdate")
	net.WriteTable(SQUADGroups.Users)
	net.Broadcast()
end

hook.Add( "PlayerSay", "playersaywebsite", function( ply, text, public )
	if ( text == "!squad" ) then
		ply:ConCommand( "menu" );
		return (false)
	end
end );

hook.Add( "PlayerSay", "SquadMessage", function( ply, text, _ )
	if ( string.sub( text, 1, 1 ) == ">" && ply:GetNWInt("SquadGroup",0) != 0) then--if ( the first 4 letters are /all continue
		local sT = string.sub( text, 2 ) --add [Global] infront of the players text ) then display
		for k,v in pairs(player.GetAll()) do
			if(v:GetNWInt("SquadGroup",0) == ply:GetNWInt("SquadGroup",1)) then
				local tC = team.GetColor(ply:Team())
				net.Start("NoSendLuaPlz")
				net.WriteEntity(ply)
				net.WriteString(sT)
				net.Send(v)
			end
		end
		return ""
	end
end )

hook.Add("PlayerInitialSpawn","GiveASquad",function(ply)
	local nm = {}
	if(LetAutoJoin) then
		local at = {}
		for k,v in pairs(player.GetAll()) do
			if(v:GetNWInt("SquadGroup",0) != 0) then
				if(at[v:GetNWInt("SquadGroup",0)] == nil) then
					at[v:GetNWInt("SquadGroup",0)] = 0
				end
				at[v:GetNWInt("SquadGroup",0)] = at[v:GetNWInt("SquadGroup",0)] + 1
				nm[v:GetNWInt("SquadGroup",0)] = v:GetNWString("SquadGroupName")
			end
		end
		table.sort(at)
		for k,v in pairs(at) do
			if(v < 8) then
				ply:SetNWInt("SquadGroup",k)
				ply:SetNWString("SquadGroupName",nm[k])
				SQUADGroups:Update()
				break;
			end
		end
	end

end)

net.Receive("SquadDrawScreen",function(l,ply)
	local pl = net.ReadEntity()
	if(ply:GetNWEntity("ObserverPlayer",nil) != pl) then
		ply:SetNWEntity("ObserverPlayer",pl)
	else
		ply:SetNWEntity("ObserverPlayer",ply)
	end
end)

net.Receive("SquadFreezeCam",function(l,ply)
	local ent = net.ReadEntity()

	ply:SpectateEntity(ent)
	ply.LPos = ply:GetPos()
	ply.LAngle = ply:EyeAngles()
	ply:DrawViewModel(false)
	ply:Spectate(OBS_MODE_FREEZECAM)
	timer.Simple(1.5,function()
		ply:DrawViewModel(true)
		ply:UnSpectate()
		ply:Spawn()
		ply:SetEyeAngles(ply.LAngle)
		ply:SetPos(ply.LPos)
	end)
end)

net.Receive("SquadCreateGroup",function(l,ply)
	SQUADGroups.AG = SQUADGroups.AG + 1
	ply:SetNWInt("SquadGroup",SQUADGroups.AG)
	ply:SetNWString("SquadGroupName",net.ReadString())
	SQUADGroups.Users[SQUADGroups.AG] = {ply}
	timer.Simple(0.5,function()
		SQUADGroups:Update()
	end)
end)

net.Receive("SquadLeaveGroup",function(l,ply)
	if(SQUADGroups.Users[ply:GetNWInt("SquadGroup")] != nil) then
		table.RemoveByValue(SQUADGroups.Users[ply:GetNWInt("SquadGroup")],ply)
	end
	ply:SetNWInt("SquadGroup",0)
	timer.Simple(0.5,function()
		SQUADGroups:Update()
	end)
end)

net.Receive("SquadRemove",function(l,a)
	local ply = net.ReadEntity()
	if(SQUADGroups.Users[ply:GetNWInt("SquadGroup")] != nil) then
		table.RemoveByValue(SQUADGroups.Users[ply:GetNWInt("SquadGroup")],ply)
	end
	ply:SetNWInt("SquadGroup",0)
	timer.Simple(0.5,function()
		SQUADGroups:Update()
	end)
end)

net.Receive("SquadInviteGroup",function(l,ply)
	local playerz = ply
	local nnt = net.ReadEntity()
	local pT = {}
	local pN = 1

	if(nnt:GetNWInt("SquadGroup",0) == playerz:GetNWInt("SquadGroup")) then return end

	if timer.Exists("InviteTimer") then return end
	timer.Create( "InviteTimer", 30, 1, function()  print("test") end )

	net.Start("InviteRequest")
	net.WriteEntity(playerz)
	net.Send(nnt)

	net.Receive("Answer",function()
		if (net.ReadBit() == 1) then
			for k,v in pairs(player.GetAll()) do
				if(playerz:GetNWInt("SquadGroup") == v:GetNWInt("SquadGroup")) then
					if(playerz != v) then
						pN = pN + 1
					end
					table.insert(pT,v)
				end
			end
			if(pN < 8) then
				if(true) then
					nnt:SetNWInt("SquadGroup",playerz:GetNWInt("SquadGroup"))
					nnt:SetNWString("SquadGroupName",playerz:GetNWString("SquadGroupName"))
					table.insert(SQUADGroups.Users[playerz:GetNWInt("SquadGroup")],plyayerz)
					SQUADGroups:Update()
				end
			end
		else
			return
		end
	end)
end)

net.Receive("SquadInviteGroupTServer",function(l,ply)
	ply:SetNWInt("SquadGroup",net.ReadFloat())
	table.insert(SQUADGroups.Users[ply:GetNWInt("SquadGroup")],ply)
	SQUADGroups:Update()
end)

net.Receive("SquadUpdateSettings",function(l,ply)
	local tbl = net.ReadTable()
	if(tbl[1]) then
		ply:SetNWInt("CanWatch",1)
	else
		ply:SetNWInt("CanWatch",0)
	end
end)

net.Receive("SquadUpdateHired",function(l,ply)
	local t = net.ReadTable()
	if(t[1]) then
		ply:SetNWInt("CanBeHired",1)
	else
		ply:SetNWInt("CanBeHired",0)
	end
end)

end

if CLIENT then

net.Receive("InviteRequest",function()
	local nnt = net.ReadEntity()
	Derma_Query("You have been invited to a squad by " .. nnt:Nick() .. ", do you accept?","Invite","Yes",function()
		net.Start("Answer")
		net.WriteBit(true)
		net.SendToServer()
	end,"No",function()
		net.Start("Answer")
		net.WriteBit(false)
		net.SendToServer()
	end)
end)

hook.Add( "HUDPaint", "Names", function()
	local lt = {}
	if(LocalPlayer():GetNWInt("SquadGroup",0) != 0) then
		for k,v in pairs(player.GetAll()) do
			if(v:GetNWInt("SquadGroup",0) == LocalPlayer():GetNWInt("SquadGroup")) then
				local ltpos = ( v:EyePos() ):ToScreen()

				if IsValid(v) and v:IsPlayer() and (v ~= LocalPlayer()) then
					draw.SimpleTextOutlined( "^", "Default", ltpos.x, ltpos.y + 7, Color(0,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255)  )
				end
			end
		end
	end
end)

end
