
local PANEL = {}
local PANEL_W = 400;
local PANEL_H = 100;

local ply = LocalPlayer()

function OpenVendingMachinez()

	--[[net.Start( "rank" )
	net.SendToServer()

	net.Receive("rank_inform", function(l)
		local viptrue = net.ReadBit()
	end)]]--

	if sellFramevip then sellFramevip:Remove() end
	if !LocalPlayer():InInnerSafezone() then return end
	if (viptrue == 0) then return end

	sellFramevip = vgui.Create( "DPanel" )
	sellFramevip:SetSize( ScrW(), 600 )
	sellFramevip:Center()
	sellFramevip:MakePopup()
	function sellFramevip:Paint()

		surface.SetDrawColor( 10, 10, 10, 200 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	end

	local closeBtnvip = vgui.Create( "DButton", sellFramevip )
	closeBtnvip:SetText( "Close VIP Vending Machine" )
	closeBtnvip:SetSize( 150, 30 )
	closeBtnvip:SetTextColor( Color( 255, 255, 255, 255 ))
	closeBtnvip.OnCursorEntered = function()
		closeBtnvip:SetTextColor( Color( 80, 200, 255, 255 ))
	end
	closeBtnvip.OnCursorExited = function()
		closeBtnvip:SetTextColor( Color( 255, 255, 255, 255 ))
	end
	closeBtnvip.DoClick = function()

		sellFramevip:Remove()

	end
	closeBtnvip.Paint = function()

		surface.SetDrawColor( 70, 70, 70, 255 )
		surface.DrawRect( 0, 0, closeBtnvip:GetWide(), closeBtnvip:GetTall())

		surface.SetDrawColor( 10, 10, 10, 255 )
		surface.DrawOutlinedRect( 0, 0, closeBtnvip:GetWide(), closeBtnvip:GetTall())

	end
	closeBtnvip:Center()
	closeBtnvip.y = sellFramevip:GetTall() - 50


	local sellListvip = vgui.Create( "DPanelList", sellFramevip )
	sellListvip:SetSize( PANEL_W, 500 )
	sellListvip:Center()
	sellListvip:EnableVerticalScrollbar( true )
	sellListvip.y = sellListvip.y - 30

	for k,v in pairs(BUNDLES_VIP) do

		local itemvip = vgui.Create( "vending_item" )
		itemvip:SetSize( PANEL_W, PANEL_H )
		itemvip.bundleId = k
		itemvip:SetBundleImage()

		sellListvip:AddItem( itemvip )

	end

end
usermessage.Hook( "ply_open_vending_vip", OpenVendingMachinez );

local PANELVIP={}

function PANELVIP:Init()

	self.bundleId = 0;
	self.img = nil;
	self.buy = vgui.Create( "DButton", self )
	self.buy:SetSize( 100, 30 )
	self.buy:SetText( "Buy Bundle" )
	self.buy:SetPos( PANEL_W - 125, PANEL_H - 40 )

	self.buy.OnMousePressed = function()
		if !LocalPlayer():InInnerSafezone() and (viptrue == 0) then
			return
		else
			net.Start("buy_bundle_vip")
				net.WriteFloat( math.Round(self.bundleId) )
			net.SendToServer()
		end

	end

end

function PANELVIP:SetBundleImage()

	if self.bundleId == 0 then return end

	self.img = vgui.Create( "DModelPanel", self )
	self.img:SetModel( items[BundleItem_vip( self.bundleId )].model )
	self.img:SetSize( 98, PANEL_H - 24 )
	self.img:SetCamPos( Vector( 12, 12, 5 ) )
	self.img:SetLookAt( Vector( 0, 0, 0 ) )
	self.img:SetPos( 1, 24 )

end

function PANELVIP:Paint()

	surface.SetDrawColor( Color( 40, 40, 40, 255 ) )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	if self.bundleId != 0 then
		surface.SetDrawColor( Color( 30, 30, 30, 255 ) )
		surface.DrawRect( 0, 0, self:GetWide(), 24 )
		surface.DrawRect( 1, self:GetTall() / 2 - 49, 98, 98 )

		draw.SimpleText( items[BundleItem_vip( self.bundleId )].name, "ChatFont", 10, 12, Color( 255, 255, 255, 255 ), 0, 1 )
		draw.SimpleText( "x" .. BundleCount_vip( self.bundleId ), "HUDInfo", 80, self:GetTall() - 21, Color( 130, 130, 130, 100 ), 0, 1 )

		local prColor = Color( 255, 255, 255, 255 )

		if Money < BundlePrice_vip( self.bundleId ) then
			prColor = Color( 70, 70, 70, 255 )
		end

		draw.SimpleText( BundlePrice_vip( self.bundleId ) .. " $", "HUDInfo", self:GetWide() - 10, 10, prColor, TEXT_ALIGN_RIGHT, 0 )

	end

	surface.SetDrawColor( Color( 255, 255, 255, 20 ) )
	surface.DrawLine( 0, 0, self:GetWide() - 1, 0 )
	surface.DrawLine( 0, 0, 0, self:GetTall() )

	surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
	surface.DrawLine( 1, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
	surface.DrawLine( self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall() - 1 )

end

vgui.Register( "vending_item_vip", PANELVIP )
