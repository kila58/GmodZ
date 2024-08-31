
local PANEL = {}
PANEL.Players = {}

function PANEL:Init()
	self:SetPos(ScrW()/2-((1*66)/2),80)
end

function PANEL:Paint()
	surface.SetDrawColor(50,50,50)
	surface.DrawRect(0,0,#self.Players*66,78)
end

function PANEL:Think()

	self:SetPos(ScrW()/2-((#self.Players*66)/2),0)
	local aT = {}
	for k,v in pairs(player.GetAll()) do
		if(LocalPlayer():GetNWInt("SquadGroup",1) == v:GetNWInt("SquadGroup",0)) then
			table.insert(aT,v)
		end
	end
	self:SetSize(#aT*66,78)
	for k=1,8 do
		if(aT[k] == nil) then
			if(self.Players[k] != nil) then
				self.Players[k]:Remove()
				self.Players[k] = nil
			end
		elseif(self.Players[k] == nil) then
			self.Players[k] = vgui.Create("vHUDIcon",self)
			self.Players[k]:SetPos((k-1)*66+1,0)
			self.Players[k]:SetSize(64,78)
			self.Players[k].Player = aT[k]
			self.Players[k]:Update()
		elseif(self.Players[k].Player != aT[k] && aT[k] != nil) then
			if(self.Players[k] != nil && ValidPanel(self.Players[k])) then
				self.Players[k].Player = aT[k]
				self.Players[k]:Update()
			else
				self.Players[k] = nil
			end
		end
	end

	if(LocalPlayer():GetNWInt("SquadGroup",0) == 0) then
		self:Remove()
		self = nil
	end
end

derma.DefineControl("vHUDSquad","vHUDSquad",PANEL,"DPanel")

local ICON = {}
ICON.Slot = 1
ICON.Player = nil

ICON.Avatar = nil
function ICON:Init()
	self:SetTooltip("Free slot")
	self:SetText("")
end

function ICON:Update()

	if(self.Avatar != nil) then
		self.Avatar:Remove()
	end
	if(IsValid(self.Player)) then
		self.Avatar = vgui.Create("AvatarImage",self)
		self.Avatar:SetPos(5,5)
		self.Avatar:SetSize(64-10,64-10)
		self.Avatar:SetPlayer(self.Player,64)
	end
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

derma.DefineControl("vHUDIcon","vHUDIcon",ICON,"DPanel")
