
-- This opens up the bank interface.
local BankIconW = 150
local BankIconH = 150
local BankPad = 20

function OpenBank()

	if !bankId then return end
	if bankFrame then bankFrame:Remove() end

	bankFrame = vgui.Create("DPanel");
	bankFrame:SetSize( ScrW(), 600 );
	bankFrame:Center();
	function bankFrame:Paint()

		surface.SetDrawColor( 10, 10, 10, 250 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	end
	bankFrame:MakePopup();

	-- Closing button.
	local closeBtn = vgui.Create( "DButton", bankFrame )
	closeBtn:SetPos( bankFrame:GetWide() - 120, bankFrame:GetTall() - 45 )
	closeBtn:SetText( "Close Bank" )
	closeBtn:SetSize( 100, 30 )
	closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	closeBtn.OnCursorEntered = function()
		closeBtn:SetTextColor( Color( 80, 200, 255, 255 ))
	end
	closeBtn.OnCursorExited = function()
		closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	end
	closeBtn.DoClick = function()

		bankFrame:Remove()

	end
	closeBtn.Paint = function()

		surface.SetDrawColor( 70, 70, 70, 255 )
		surface.DrawRect( 0, 0, closeBtn:GetWide(), closeBtn:GetTall())

		surface.SetDrawColor( 10, 10, 10, 255 )
		surface.DrawOutlinedRect( 0, 0, closeBtn:GetWide(), closeBtn:GetTall())

	end

	local bankItemList = vgui.Create( "DPanelList", bankFrame )
	bankItemList:EnableHorizontal( true )

	// Check for items in the bank.
	for k,v in pairs(inv[bankId]) do

		if type(v) == "table" then

			local icon = vgui.Create( "item_frame", bankItemList )
			icon:SetSize( BankIconW, BankIconH )
			icon:SetItemFromSlot( bankId, k )
			icon:SetupImage();

			bankItemList:AddItem( icon )

		end

	end

	bankItemList:SetSize( BankIconW * 5 + BankPad * 5, BankIconH * 3.5 + BankPad * 3 )
	bankItemList:Center()

end
usermessage.Hook( "ply_open_bank", OpenBank );

-- ITEM PANEL, WILL BE USED FOR OTHER STUFF BUT NOW ITS THE BANK.

local PANEL = {}

function PANEL:Init()

	self.slot = 0
	self.item = "none"
	self.count = 0
	self.parent = "none"
	self.img = nil

end

function PANEL:SetItemFromSlot( id, slot )

	if !id or !slot or !inv[id] then return end

	self.slot = slot;
	self.item = inv[id][slot].item
	self.count = inv[id][slot].count

end

function PANEL:SetupImage()

	if self.item == "none" then return end

	self.img = vgui.Create( "DModelPanel", self )
	self.img:SetModel( items[self.item].model )
	self.img:SetSize( 128, 128 )
	self.img:SetCamPos( Vector( 12, 12, 5 ) )
	self.img:SetLookAt( Vector( 0, 0, 0 ) )
	self.img:Center()
	self.img.y = 30
	self.img.OnMousePressed = function()

		self:OnMousePressed();

	end

end

function PANEL:Clean()

	self.slot = 0;
	self.item = "none";
	self.count = 0;

	if self.img then self.img:Remove() end

end

function PANEL:Paint()

	local w = self:GetWide();
	local h = self:GetTall();

	surface.SetDrawColor( 20, 20, 20, 255 )
	surface.DrawRect( 2, 2, w - 4, h - 4 )

	surface.SetDrawColor( 70, 70, 70, 255 )
	surface.DrawOutlinedRect( 2, 2, w - 4, h - 4 )

	if self.item != "none" then
		draw.SimpleText( items[self.item].name, "ChatFont", 12, 15, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	if self.count > 0 then
		draw.SimpleText( "x" .. self.count, "ChatFont", self:GetWide() - 12, self:GetTall() - 20, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end

end

function PANEL:OnMousePressed()

	if LocalPlayer():InInnerSafezone() && self.item != "none" then

		local menu = DermaMenu( self )

		menu:AddOption( "Move to Inventory", function()
			AskMoveToInv( self.slot )
			self:Clean();
		end)

		menu:Open();

	end

end

vgui.Register( "item_frame", PANEL )
