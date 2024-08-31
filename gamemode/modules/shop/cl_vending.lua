
local PANEL = {}
local PANEL_W = 400;
local PANEL_H = 100;

function OpenVendingMachine()

	if sellFrame then sellFrame:Remove() end
	if !LocalPlayer():InInnerSafezone() then return end

	sellFrame = vgui.Create( "DPanel" )
	sellFrame:SetSize( ScrW(), 600 )
	sellFrame:Center()
	sellFrame:MakePopup()
	function sellFrame:Paint()

		surface.SetDrawColor( 10, 10, 10, 200 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	end

	local closeBtn = vgui.Create( "DButton", sellFrame )
	closeBtn:SetText( "Close Vending Machine" )
	closeBtn:SetSize( 150, 30 )
	closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	closeBtn.OnCursorEntered = function()
		closeBtn:SetTextColor( Color( 80, 200, 255, 255 ))
	end
	closeBtn.OnCursorExited = function()
		closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	end
	closeBtn.DoClick = function()

		sellFrame:Remove()

	end
	closeBtn.Paint = function()

		surface.SetDrawColor( 70, 70, 70, 255 )
		surface.DrawRect( 0, 0, closeBtn:GetWide(), closeBtn:GetTall())

		surface.SetDrawColor( 10, 10, 10, 255 )
		surface.DrawOutlinedRect( 0, 0, closeBtn:GetWide(), closeBtn:GetTall())

	end
	closeBtn:Center()
	closeBtn.y = sellFrame:GetTall() - 50


	local sellList = vgui.Create( "DPanelList", sellFrame )
	sellList:SetSize( PANEL_W, 500 )
	sellList:Center()
	sellList:EnableVerticalScrollbar( true )
	sellList.y = sellList.y - 30

	for k,v in pairs(BUNDLES) do

		local item = vgui.Create( "vending_item" )
		item:SetSize( PANEL_W, PANEL_H )
		item.bundleId = k
		item:SetBundleImage()

		sellList:AddItem( item )

	end

end
usermessage.Hook( "ply_open_vending", OpenVendingMachine );

function PANEL:Init()

	self.bundleId = 0;
	self.img = nil;
	self.buy = vgui.Create( "DButton", self )
	self.buy:SetSize( 100, 30 )
	self.buy:SetText( "Buy Bundle" )
	self.buy:SetPos( PANEL_W - 125, PANEL_H - 40 )

	self.buy.OnMousePressed = function()

		if LocalPlayer():InInnerSafezone() then
			net.Start("buy_bundle")
				net.WriteFloat( math.Round(self.bundleId) )
			net.SendToServer()
		end

	end

end

function PANEL:SetBundleImage()

	if self.bundleId == 0 then return end

	self.img = vgui.Create( "DModelPanel", self )
	self.img:SetModel( items[BundleItem( self.bundleId )].model )
	self.img:SetSize( 98, PANEL_H - 24 )
	self.img:SetCamPos( Vector( 12, 12, 5 ) )
	self.img:SetLookAt( Vector( 0, 0, 0 ) )
	self.img:SetPos( 1, 24 )

end

function PANEL:Paint()

	surface.SetDrawColor( Color( 40, 40, 40, 255 ) )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	if self.bundleId != 0 then
		surface.SetDrawColor( Color( 30, 30, 30, 255 ) )
		surface.DrawRect( 0, 0, self:GetWide(), 24 )
		surface.DrawRect( 1, self:GetTall() / 2 - 49, 98, 98 )

		draw.SimpleText( items[BundleItem( self.bundleId )].name, "ChatFont", 10, 12, Color( 255, 255, 255, 255 ), 0, 1 )
		draw.SimpleText( "x" .. BundleCount( self.bundleId ), "HUDInfo", 80, self:GetTall() - 21, Color( 130, 130, 130, 100 ), 0, 1 )

		local prColor = Color( 255, 255, 255, 255 )

		if Money < BundlePrice( self.bundleId ) then
			prColor = Color( 70, 70, 70, 255 )
		end

		draw.SimpleText( BundlePrice( self.bundleId ) .. " $", "HUDInfo", self:GetWide() - 10, 10, prColor, TEXT_ALIGN_RIGHT, 0 )

	end

	surface.SetDrawColor( Color( 255, 255, 255, 20 ) )
	surface.DrawLine( 0, 0, self:GetWide() - 1, 0 )
	surface.DrawLine( 0, 0, 0, self:GetTall() )

	surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
	surface.DrawLine( 1, self:GetTall() - 1, self:GetWide(), self:GetTall() - 1 )
	surface.DrawLine( self:GetWide() - 1, 0, self:GetWide() - 1, self:GetTall() - 1 )

end

vgui.Register( "vending_item", PANEL )
