AddCSLuaFile()

if CLIENT then

surface.CreateFont( "DerMaFont", {
	font = "Arial",
	size = 28,
	weight = 500
} )

surface.CreateFont( "DermaSquad", {
	font = "Tahoma",
	size = 24,
	weight = 500
} )

surface.CreateFont( "DermaMicroSquad", {
	font = "Calibri",
	size = 18,
	weight = 500
} )


local COLORS = {}
COLORS["Dark"] = Color(55,55,55)
COLORS["SDark"] = Color(70,70,70)
COLORS["LDark"] = Color(95,95,95)
COLORS["Gray"] = Color(100,100,100)
COLORS["Bright"] = Color(200,200,200,25)
COLORS["Shadow"] = Color(50,50,50,25)
COLORS["Red"] = Color(231,76,60)
COLORS["Blue"] = Color(60,76,231)

local function menu()
	--future if statement

		local window = vgui.Create("DFrame")

		window:SetSize(560, 250) -- set the frame size
		window:SetTitle("")
		window:ShowCloseButton(false)
		window:MakePopup()
		window:SetDraggable(true)
		window:Center()

		local w,h = window:GetSize()

		window.bClose = vgui.Create( "DButton" )
		window.bClose:SetParent(window)
		window.bClose:SetText( "" )
		window.bClose.DoClick = function ( button ) window:Close() end
		window.bClose.Paint = function( panel, w, h )
			surface.SetDrawColor(COLORS["SDark"])
			surface.DrawRect(0,0,24,24)
			draw.SimpleText("X","DerMaFont",3.5,-2,Color(255,255,255,100))
		end
		window.bClose:SetPos(w-28,4)
		window.bClose:SetSize(32,24)
		window.bClose:SetTooltip("Close this")

		window.Paint = function()

			surface.SetDrawColor(COLORS["Dark"])
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(COLORS["LDark"])
			surface.DrawRect(1,2,w-2,1)
			surface.DrawRect(1,h-1,w-2,1)

			surface.DrawRect(1,2,1,h-4)
			surface.DrawRect(w-2,2,1,h-4)

			surface.SetDrawColor(COLORS["Gray"])
			surface.DrawRect(4,4,w-8,24)

			draw.SimpleText("Your squad","DermaSquad",24+64+8,38,Color(255,255,255,100),TEXT_ALIGN_CENTER)
			draw.SimpleText("Your squad","DermaSquad",24+64+8+364,38,Color(255,255,255,100),TEXT_ALIGN_CENTER)

			draw.SimpleText("Options","DermaSquad",194+172/2,38,Color(255,255,255,100),TEXT_ALIGN_CENTER)

		end

		window.Patrol = {}
		window.Patrol[1] = vgui.Create("VPatrolIcon")
		window.Patrol[1]:SetParent(window)
		window.Patrol[1]:SetPos(24,72)
		window.Patrol[1]:SetSize(64,78)

		window.Patrol[2] = vgui.Create("VPatrolIcon")
		window.Patrol[2]:SetParent(window)
		window.Patrol[2]:SetPos(24,160)
		window.Patrol[2]:SetSize(64,78)

		window.Patrol[3] = vgui.Create("VPatrolIcon")
		window.Patrol[3]:SetParent(window)
		window.Patrol[3]:SetPos(24+64+16,72)
		window.Patrol[3]:SetSize(64,78)

		window.Patrol[4] = vgui.Create("VPatrolIcon")
		window.Patrol[4]:SetParent(window)
		window.Patrol[4]:SetPos(24+64+16,160)
		window.Patrol[4]:SetSize(64,78)

		window.Patrol[5] = vgui.Create("VPatrolIcon")
		window.Patrol[5]:SetParent(window)
		window.Patrol[5]:SetPos(24+365,72)
		window.Patrol[5]:SetSize(64,78)

		window.Patrol[6] = vgui.Create("VPatrolIcon")
		window.Patrol[6]:SetParent(window)
		window.Patrol[6]:SetPos(24+365,160)
		window.Patrol[6]:SetSize(64,78)

		window.Patrol[7] = vgui.Create("VPatrolIcon")
		window.Patrol[7]:SetParent(window)
		window.Patrol[7]:SetPos(24+64+16+365,72)
		window.Patrol[7]:SetSize(64,78)

		window.Patrol[8] = vgui.Create("VPatrolIcon")
		window.Patrol[8]:SetParent(window)
		window.Patrol[8]:SetPos(24+64+16+365,160)
		window.Patrol[8]:SetSize(64,78)

		window.Buttons = {}
		window.Buttons[1] = vgui.Create("VPatrolButton")
		window.Buttons[1]:SetParent(window)
		window.Buttons[1]:SetPos(194,72)
		window.Buttons[1]:SetSize(172,24)
		window.Buttons[1].Text = "Create Squad"
		window.Buttons[1].DoClick = function()
			if(window.Buttons[1].Enabled) then
				net.Start("SquadCreateGroup")
				net.SendToServer()
			end
		end
		window.Buttons[1]:SetTooltip("Create a squad and invite people")

		--[[window.Buttons[2] = vgui.Create("VPatrolButton")
		window.Buttons[2]:SetParent(window)
		window.Buttons[2]:SetPos(194,72+24)
		window.Buttons[2]:SetSize(172,24)
		window.Buttons[2].Text = "Invite someone"
		window.Buttons[2]:SetTooltip("Invite people to be part of your squad")
		window.Buttons[2].DoClick = function()
			if(window.Buttons[2].Enabled) then
				local Menu = DermaMenu()
				Menu:SetPos(gui.MousePos())
				Menu:MakePopup()
				local nG = 0
				for k,v in pairs(player.GetAll()) do
					if(v != LocalPlayer() && v:GetNWInt("SquadGroup",0) == 0 && v:GetNWInt("CanBeHired",0) == 0) then
						local btnWithIconA = Menu:AddOption( v:Nick() )
						btnWithIconA:SetIcon( "icon16/add.png" )
						btnWithIconA.OnMousePressed = function()
							net.Start("SquadInviteGroup")
							net.WriteEntity(v)
							net.SendToServer()
							Menu:Remove()
						end
					end
				end
			end
		end]]--

		window.Buttons[2] = vgui.Create("VPatrolButton")
		window.Buttons[2]:SetParent(window)
		window.Buttons[2]:SetPos(194,72+24)
		window.Buttons[2]:SetSize(172,24)
		window.Buttons[2].Text = "Invite someone"
		window.Buttons[2]:SetTooltip("Invite people to be part of your squad")
		window.Buttons[2].DoClick = function()
			if(window.Buttons[2].Enabled) then
				local Menu = DermaMenu()
				Menu:SetPos(gui.MousePos())
				Menu:MakePopup()
				local nG = 0
				for k,v in pairs(player.GetAll()) do
					if(v != LocalPlayer() && v:GetNWInt("SquadGroup",0) == 0 && v:GetNWInt("CanBeHired",0) == 0) then
						local btnWithIconA = Menu:AddOption( v:Nick() )
						btnWithIconA:SetIcon( "icon16/add.png" )
						btnWithIconA.OnMousePressed = function()
							net.Start("SquadInviteGroup")
							net.WriteEntity(v)
							net.SendToServer()
							Menu:Remove()
						end
					end
				end
			end
		end

		window.Buttons[3] = vgui.Create("VPatrolButton")
		window.Buttons[3]:SetParent(window)
		window.Buttons[3]:SetPos(194,72+48)
		window.Buttons[3]:SetSize(172,24)
		window.Buttons[3].Text = "Leave the Squad"
		window.Buttons[3]:SetTooltip("Leave current squad")
		window.Buttons[3].DoClick = function()
			if(window.Buttons[3].Enabled) then
				window.Patrol[1].Player = nil
				window.Patrol[1]:Remove()
				window.Patrol[1] = vgui.Create("VPatrolIcon")
				window.Patrol[1]:SetParent(window)
				window.Patrol[1]:SetPos(24,72)
				window.Patrol[1]:SetSize(64,78)
				net.Start("SquadLeaveGroup")
				net.SendToServer()
			end
		end

		window.screen = vgui.Create( "DCheckBoxLabel")
		window.screen:SetParent(window)
		window.screen:SetPos( 194, 160 )
		window.screen:SetText( "Allow squad to see your view" )
		window.screen:SetTooltip("Squad members will have the option\nto watch your screen")
		window.screen:SetValue( LocalPlayer():GetNWInt("CanWatch",1) )
		window.screen:SizeToContents()
		window.screen.OnChange = function()
			net.Start("SquadUpdateSettings")
			net.WriteTable({window.screen:GetChecked()})
			net.SendToServer()
		end

		window.hired = vgui.Create( "DCheckBoxLabel")
		window.hired:SetParent(window)
		window.hired:SetPos( 194, 160+16 )
		window.hired:SetText( "Disable Invites" )
		window.hired:SetTooltip("Other player's won't be able to send you invitations to their squads")
		if(LocalPlayer():GetNWInt("CanBeHired",0) == 0) then
			window.hired:SetValue( 0 )
		else
			window.hired:SetValue( 1 )
		end
		window.hired:SizeToContents()
		window.hired.OnChange = function()
			net.Start("SquadUpdateHired")
			net.WriteTable({window.hired:GetChecked()})
			net.SendToServer()
		end

		window.voice = vgui.Create( "DLabel")
		window.voice:SetParent(window)
		window.voice:SetPos( 194, 160 + 54 )
		window.voice:SetText( "F2 toggles squad voice chat." )
		window.voice:SizeToContents()


		local nThink = 0

		window.UpdateData = function()
			local lt = {}
			for k=1,8 do
				window.Patrol[k].Player = nil
				if(window.Patrol[k].Avatar != nil) then
					window.Patrol[k].Avatar:Remove()
					window.Patrol[k].BAvatar:Remove()
				end
			end
		end

		window.Think = function()
			if(LocalPlayer():GetNWInt("SquadGroup",0) == 0) then
				window.Buttons[1].Enabled = true
				window.Buttons[2].Enabled = false
				window.Buttons[3].Enabled = false
			else
				window.Buttons[1].Enabled = false
				window.Buttons[2].Enabled = true
				window.Buttons[3].Enabled = true
			end

			if(nThink < CurTime()) then
				local lt = {}
				if(LocalPlayer():GetNWInt("SquadGroup") != 0) then
					for k,v in pairs(player.GetAll()) do
						if(LocalPlayer():GetNWInt("SquadGroup") == v:GetNWInt("SquadGroup",0)) then
							table.insert(lt,v)
						end
					end
					for k,v in pairs(lt) do
						if(window.Patrol[k].Player != v) then
							window.Patrol[k].Player = v
							window.Patrol[k]:Update()
						end
					end
				end
			end
		end

		net.Receive("SquadGroupUpdate",function()
			local tbl = net.ReadTable()
			if(SQUADGroups.Users) then
				if(window != nil && isfunction(window.UpdateData)) then
					window:UpdateData()
				end
			end
		end)
	--future end
end
concommand.Add("menu", menu)

local function drawPlyEyes(ply)
	local v = {}
	v.origin = ply:EyePos() + ply:GetAimVector()*16
	v.angles = ply:EyeAngles()
	v.x = ScrW()-ScrW()/6-20
	v.y = 28
	v.w = ScrW()/6-8
	v.h = ScrH()/6-8
	v.fov  = 90
	v.aspectratio = ScrW()/ScrH()
	render.RenderView( v )
end
--The orginal used if statements, thats dumb so I fixed it with a better method
local function HealthColor(f)
	local health = f:Health()
	local Red = 255 - (health*2.55);
	local Green = health*2.55;
	return Color(Red,Green,10)
end

if(avContainer != nil) then
	avContainer:Remove()
end
local nT = {}
local avContainer = nil

local function checkIdem(a,b)
	local c = 0
	local d = 0
	for k,v in pairs(a) do
		c = c + v:EntIndex()
	end
	for k,v in pairs(b) do
		d = d + v:EntIndex()
	end
	return c == d
end

local aCheck = 0

hook.Add("HUDPaint","DrawScreensSquad",function()
	if(LocalPlayer():GetNWInt("SquadGroup",0) != 0 && IsValid(LocalPlayer():GetNWEntity("ObserverPlayer")) && LocalPlayer():GetNWEntity("ObserverPlayer"):GetNWInt("SquadGroup",0) == LocalPlayer():GetNWInt("SquadGroup",0) && LocalPlayer():GetNWEntity("ObserverPlayer") != LocalPlayer() && LocalPlayer():GetNWEntity("ObserverPlayer"):GetNWInt("CanWatch",1) == 1) then
		surface.SetDrawColor(50,50,50)
		surface.DrawRect(ScrW()-ScrW()/6-24,24,ScrW()/6,ScrH()/6)
		surface.DrawRect(ScrW()-ScrW()/6-24,24+ScrH()/6 + 8,ScrW()/6,48)

		surface.SetDrawColor(100,100,100,100)

		surface.DrawRect(ScrW()-ScrW()/6-23,24+ScrH()/6 + 9,ScrW()/6-2,1)
		surface.DrawRect(ScrW()-ScrW()/6-23,24+ScrH()/6 + 9,1,46)
		surface.DrawRect(ScrW()-ScrW()/6-26+ScrW()/6,24+ScrH()/6 + 9,1,46)
		surface.DrawRect(ScrW()-ScrW()/6-23,24+ScrH()/6 + 9+45,ScrW()/6-2,1)

		draw.SimpleText(LocalPlayer():GetNWEntity("ObserverPlayer"):Nick(),"DermaSquad",ScrW()-ScrW()/12-24,24+ScrH()/6 + 13,Color(255,255,255,100),TEXT_ALIGN_CENTER)

		surface.SetDrawColor(Color(25,25,25))
		surface.DrawRect(ScrW()-ScrW()/6-21,24+ScrH()/6 + 40,ScrW()/6-6,12)

		local clr = HealthColor(LocalPlayer():GetNWEntity("ObserverPlayer"))
		surface.SetDrawColor(clr)

		surface.DrawRect(ScrW()-ScrW()/6-21,24+ScrH()/6 + 40,math.Clamp((LocalPlayer():GetNWEntity("ObserverPlayer"):Health()/100)*ScrW()/6,0,ScrW()/6-6),12)

		surface.SetDrawColor(Color(255,255,255,15))
		surface.DrawRect(ScrW()-ScrW()/6-21,24+ScrH()/6 + 40,math.Clamp((LocalPlayer():GetNWEntity("ObserverPlayer"):Health()/100)*ScrW()/6,0,ScrW()/6-6),6)

	end

	if(LocalPlayer():GetNWInt("SquadGroup",0) != 0) then

		local lT = {}
		for k,v in pairs(player.GetAll()) do
			if(LocalPlayer():GetNWInt("SquadGroup",1) == v:GetNWInt("SquadGroup",0)) then
				table.insert(lT,v)
			end
		end

		if(avContainer == nil) then
			if(avContainer != nil) then
				avContainer:Remove()
			end
			avContainer = vgui.Create("vHUDSquad")
			avContainer.OnRemove = function()
				avContainer = nil
			end
		end
	end
end)

hook.Add("PostRender","DrawCrosshair",function()
	if(LocalPlayer():GetNWInt("SquadGroup",0) != 0 && IsValid(LocalPlayer():GetNWEntity("ObserverPlayer")) && LocalPlayer():GetNWEntity("ObserverPlayer"):GetNWInt("SquadGroup",0) == LocalPlayer():GetNWInt("SquadGroup",0) && LocalPlayer():GetNWEntity("ObserverPlayer") != LocalPlayer() && LocalPlayer():GetNWEntity("ObserverPlayer"):GetNWInt("CanWatch",1) == 1) then
		drawPlyEyes(LocalPlayer():GetNWEntity("ObserverPlayer"))
	end
end)

end
