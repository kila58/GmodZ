
local ICON = {}
ICON.Slot = 1
ICON.Player = nil

ICON.Avatar = nil
local Parent = nil

function ICON:Init()

	self:SetTooltip("Free slot")
	self:SetText("")
	Parent = self:GetParent()

end

function ICON:Update()

	Parent = self:GetParent()

	if(self.Avatar != nil) then
		self.Avatar:Remove()
	end
	if(IsValid(self.Player)) then
		self.Avatar = vgui.Create("AvatarImage",self)
		self.Avatar:SetPos(5,5)
		self.Avatar:SetSize(64-10,64-10)
		self.Avatar:SetPlayer(self.Player,64)
		self.BAvatar = vgui.Create("DButton",self)
		self.BAvatar:SetPos(5,5)
		self.BAvatar:SetSize(54,54)
		self.BAvatar:SetText("")
		self.BAvatar.Paint = function() end
		self.BAvatar.DoClick = function() if IsValid(self.Player) && self.Player != LocalPlayer() then self:DropMenu() end end
	end
end

function ICON:DoClick()
	if IsValid(self.Player) && self.Player != LocalPlayer() then
		self:DropMenu()
	end
end

local Menu = nil

function ICON:DropMenu()
	if(Menu != nil) then
		Menu:Remove()
	end

	Menu = DermaMenu()
	Menu:SetPos(gui.MousePos())
	Menu:MakePopup()
	local btnWithIconA = Menu:AddOption( "Kick player" )
	btnWithIconA:SetIcon( "icon16/cancel.png" )
	btnWithIconA.OnMousePressed = function()
		net.Start("SquadRemove")
		net.WriteEntity(self.Player)
		net.SendToServer()
		Menu:Remove()
		self.Player = nil
		self.BAvatar:Remove()
		self.Avatar:Remove()
		Parent:UpdateData()
	end
	if(self.Player:GetNWInt("CanWatch",1) == 1) then
		Menu:AddSpacer()
		local btnWithIconA = Menu:AddOption( "Show/Hide view" )
		btnWithIconA:SetIcon( "icon16/monitor.png" )
		btnWithIconA.OnMousePressed = function()
			net.Start("SquadDrawScreen")
			net.WriteEntity(self.Player)
			net.SendToServer()
			Menu:Remove()
		end
		Menu:AddSpacer()
	end
end

function ICON:UpdateStatus()

end

function ICON:Health()
	if(self.Player:Health() >= 70) then
		return Color(10,150,10)
	elseif(self.Player:Health() >= 40) then
		return Color(150,150,10)
	else
		return Color(150,10,10)
	end
end

function ICON:Think()
	if(self.Player == nil && self.Avatar != nil) then
		self.Avatar:Remove()
		self.BAvatar:Remove()
		self.Player = nil
	end
end

function ICON:Paint(w,h)
	surface.SetDrawColor(35,35,35)
	surface.DrawRect(0,0,w,64)

	surface.DrawRect(0,h-12,w,14)

	if(!IsValid(self.Player)) then
		surface.SetDrawColor(150,10,10)
		else
		surface.SetDrawColor(10,150,10)
	end

	surface.DrawRect(2,2,w-4,64-4)
	surface.SetDrawColor(35,35,35)
	surface.DrawRect(4,4,w-8,64-8)

	if(IsValid(self.Player)) then
		self:SetTooltip(self.Player:Nick() or "Free slot")
		surface.SetDrawColor(self:Health())
		surface.DrawRect(2,66,math.Clamp((w-4)*self.Player:Health()/100,0,w-4),10)
		surface.SetDrawColor(Color(255,255,255,10))
		surface.DrawRect(2,66,math.Clamp((w-4)*self.Player:Health()/100,0,w-4),5)

		surface.SetDrawColor(35,35,35)
		surface.DrawRect(8,66,1,10)
		surface.DrawRect(14,66,1,10)
		surface.DrawRect(20,66,1,10)
		surface.DrawRect(26,66,1,10)
		surface.DrawRect(32,66,1,10)
		surface.DrawRect(38,66,1,10)
		surface.DrawRect(44,66,1,10)
		surface.DrawRect(50,66,1,10)
		surface.DrawRect(56,66,1,10)
	end

end

derma.DefineControl("VPatrolIcon","VPatrolIcon",ICON,"DButton")

local BUTTON = {}
BUTTON.Text = 1
BUTTON.Enabled = false

function BUTTON:Init()
	self:SetText("")
end

function BUTTON:Paint(w,h)

	if(!self:IsHovered() or !self.Enabled) then
		surface.SetDrawColor(50,50,50)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(65,65,65)
		surface.DrawRect(2,2,w-4,h-4)
		surface.SetDrawColor(50,50,50)
		surface.DrawRect(3,3,w-6,h-6)
		surface.SetDrawColor(60,60,60)
		surface.DrawRect(5,5,w-10,6)
	else
		surface.SetDrawColor(50,50,50)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(80,86,243))
		surface.DrawRect(2,2,w-4,h-4)
		surface.SetDrawColor(Color(40,66,200))
		surface.DrawRect(3,3,w-6,h-6)
		surface.SetDrawColor(Color(50,86,255))
		surface.DrawRect(5,5,w-10,6)
	end

	if(self.Enabled) then
		draw.SimpleText(self.Text,"DermaMicroSquad",w/2+2,h/2+2,Color(50,50,50,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(self.Text,"DermaMicroSquad",w/2,h/2,Color(255,255,255,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(self.Text,"DermaMicroSquad",w/2+2,h/2+2,Color(50,50,50,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(self.Text,"DermaMicroSquad",w/2,h/2,Color(150,150,150,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

end

derma.DefineControl("VPatrolButton","VPatrolButton",BUTTON,"DButton")
