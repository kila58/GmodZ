-- This is the menus! --
-- This function opens the player's inventory.

function OpenInventory()

	local ply = LocalPlayer();

	ply.invPanel = vgui.Create( "DPanel" )

	if !ply.invPanel then return end

	ply.invPanel:SetSize( ScrW(), ScrH() )
	ply.invPanel:Center()
	ply.invPanel:MakePopup()
	ply.invPanel.Paint = function()

		surface.SetDrawColor( Color( 0, 0, 0, 120 ))
		surface.DrawRect( 0, 0, ply.invPanel:GetWide(), ply.invPanel:GetTall() )

	end

	local deco = vgui.Create( "DPanel", ply.invPanel )
	deco:SetSize( ScrW(), 500 )
	deco:SetPos( 0, 60 )
	deco.Paint = function()

		surface.SetDrawColor( Color( 0, 0, 0, 200 ))
		surface.DrawRect( 0, 0, deco:GetWide(), deco:GetTall() )

	end

	local invLabel = vgui.Create( "DLabel", ply.invPanel )
	invLabel:SetText( "You don't have any inventory at the moment." )
	invLabel:SetFont( "HudHintTextLarge" );
	invLabel:SetPos( 110, 70 )
	invLabel:SetSize( 300, 20 )

	-- If we have an inventory, show it.
	if ply.inventory then
		invLabel:SetText( ply:Nick() .. "'s inventory." )

		local itemW = 140
		local itemH = 100
		local itemPadding = 1
		local itemPerRow = 5

		if #ply.inventory > 20 then
			itemPerRow = 8
		end

		-- Calculations, don't touch.
		local itemPanelW = itemPerRow * ( itemW + itemPadding ) + itemPadding
		local itemPanelH = math.ceil( #ply.inventory / itemPerRow ) * ( itemH + itemPadding ) + itemPadding

		-- Resize if there is an inventory.
		//ply.invPanel:SetSize( itemPanelW + 40, itemPanelH + 100 )
		ply.invPanel:Center()

		local invWrapper = vgui.Create( "DPanel", ply.invPanel )
		invWrapper:SetSize( itemPanelW, itemPanelH )
		invWrapper:SetPos( 100, 100 );
		//invWrapper:Center();
		invWrapper.Paint = function()

			surface.SetDrawColor( Color( 50, 50, 50, 255 ))
			surface.DrawRect( 0, 0, invWrapper:GetWide(), invWrapper:GetTall() )

		end

		-- For each item, draw an icon.
		for k,v in pairs(ply.inventory ) do

			if k != "weapon" and k != "melee" then

				local x = ( k-1 ) % itemPerRow
				local y = math.floor( (k - 1) / itemPerRow )

				-- Holder panel.
				local itemHolder = vgui.Create( "DPanel", invWrapper )
				itemHolder:SetSize( itemW, itemH )
				itemHolder:SetPos( x * ( itemW + itemPadding ) + itemPadding, y * ( itemH + itemPadding ) + itemPadding )
				itemHolder.Paint = function()

					-- Draw a little something if we "hover".
					surface.SetDrawColor( Color( 30, 30, 30, 255 ))
					surface.DrawRect( 0, 0, itemHolder:GetWide(), itemHolder:GetTall() )

				end

				if v.item != "none" then

					-- This will draw our 3D image.
					local itemImage = vgui.Create( "DModelPanel", itemHolder )
					itemImage:SetModel( items[v.item].model )
					itemImage:SetSize( itemW, itemH - 20 )
					itemImage:SetPos( 0, 0 )
					itemImage:SetCamPos( Vector( 12, 12, 5 ) )
					itemImage:SetLookAt( Vector( 0, 0, 0 ) )

					-- This is the button.
					local itemBtn = vgui.Create( "DButton", itemHolder )
					itemBtn:SetPos( 0, 0 )
					itemBtn:SetSize( itemW, itemH )
					itemBtn:SetText( "" )
					itemBtn.DoClick = function()

						-- Do actions on success.
						local menu = DermaMenu(itemBtn)

						-- Add an option to the menu.
						local txt = "Use"
						if items[v.item].category == "weapons" then
							txt = "Equip/Holster"
						end

						menu:AddOption( txt, function()
							net.Start("AskUseItem")
									net.WriteUInt(k,16)
								net.SendToServer()
								if (items[v.item].removeOnUse and v.count == 1) or items[v.item].isAmmo then
									itemImage:Remove()
									itemBtn:Remove()
								elseif items[v.item].removeOnUse and v.count > 1 then
									v.count = v.count - 1
								end
						end )

						----------------
						menu:AddSpacer()
						----------------

						menu:AddOption( "Drop All", function()
							-- Ask to drop.
							Derma_Query("Are you sure you want to drop "..v.count.." unit(s) of "..items[v.item].name.."?","Confirmation","Yes",function()
								net.Start("AskDropItem")
									net.WriteUInt(k,16)
									net.WriteUInt(v.count,32)
								net.SendToServer()
								itemImage:Remove()
								itemBtn:Remove()
							end,"No")
						end )

						menu:AddOption( "Drop Amount...", function()

							DropItemAmount( v, k )

						end)

						if LocalPlayer():InInnerSafezone() then

							if items[v.item].salvage then
								----------------
								menu:AddSpacer()
								----------------

								menu:AddOption( "Salvage one item for " .. items[v.item].points .. "$ (Safezone - Permanent)", function()
									AskSalvage( k );
									if v.count > 1 then
										v.count = v.count - 1;
									else
										itemImage:Remove();
										itemBtn:Remove();
									end
								end)
							end

							----------------
							menu:AddSpacer()
							----------------

							menu:AddOption( "Move to Bank", function()
								AskMoveToBank( k );
								itemImage:Remove();
								itemBtn:Remove();
							end)

						end

						-- Open the menu.
						menu:Open()

					end

					itemBtn.DoRightClick = itemBtn.DoClick

					itemBtn.Paint = function()

						if v.item == "none" then return end

						if items[v.item].category == "weapons" then
							surface.SetDrawColor( Color( 50, 55, 60, 255 ) )
						else
							surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
						end

						surface.DrawRect( 0, itemBtn:GetTall() - 20, itemBtn:GetWide(), 20 )

						draw.SimpleText( items[v.item].name, "HudHintTextLarge", 4, itemBtn:GetTall() - 10, Color( 150, 150, 150, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						draw.SimpleText( v.count, "Trebuchet24", itemBtn:GetWide() - 8, 12, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

					end
				end
			end

		end
	end

end
hook.Add( "OnSpawnMenuOpen", "OpenInventory_", OpenInventory )
hook.Add( "OnSpawnMenuClose", "CloseInventory_", function()

	if LocalPlayer().invPanel then
		LocalPlayer().invPanel:Remove()
	end

end )


-- This function opens a given ID inventory...
function OpenOtherInventory( id )

	if !inv then return end
	if !inv[id] then return end

	local otherPanel = vgui.Create( "DPanel" )
	otherPanel:MakePopup()
	otherPanel.Paint = function ()

		surface.SetDrawColor( Color( 0, 0, 0, 200 ))
		surface.DrawRect( 0, 0, otherPanel:GetWide(), otherPanel:GetTall() )

	end

	if inv[id] then

		local itemW = 140
		local itemH = 100
		local itemPadding = 1
		local itemPerRow = 5

		if #inv[id] > 20 then
			itemPerRow = 8
		end

		-- Calculations, don't touch.
		local itemPanelW = itemPerRow * ( itemW + itemPadding ) + itemPadding
		local itemPanelH = math.ceil( #inv[id] / itemPerRow ) * ( itemH + itemPadding ) + itemPadding

		-- Resize if there is an inventory.
		otherPanel:SetSize( ScrW(), itemPanelH + 100 )
		otherPanel:Center()

		local invWrapper = vgui.Create( "DPanel", otherPanel )
		invWrapper:SetSize( itemPanelW, itemPanelH )
		invWrapper:SetPos( 100, 100 );
		invWrapper:Center();
		invWrapper.Paint = function()

			surface.SetDrawColor( Color( 50, 50, 50, 255 ))
			surface.DrawRect( 0, 0, invWrapper:GetWide(), invWrapper:GetTall() )

		end

		-- For each item, draw an icon.
		for k,v in pairs(inv[id]) do

			if k != "weapon" and k != "melee" then

				local x = ( k-1 ) % itemPerRow
				local y = math.floor( (k - 1) / itemPerRow )

				-- Holder panel.
				local itemHolder = vgui.Create( "DPanel", invWrapper )
				itemHolder:SetSize( itemW, itemH )
				itemHolder:SetPos( x * ( itemW + itemPadding ) + itemPadding, y * ( itemH + itemPadding ) + itemPadding )
				itemHolder.Paint = function()

					-- Draw a little something if we "hover".
					surface.SetDrawColor( Color( 30, 30, 30, 255 ))
					surface.DrawRect( 0, 0, itemHolder:GetWide(), itemHolder:GetTall() )

				end

				if v.item != "none" then

					-- This will draw our 3D image.
					local itemImage = vgui.Create( "DModelPanel", itemHolder )
					itemImage:SetModel( items[v.item].model )
					itemImage:SetSize( itemW, itemH - 20 )
					itemImage:SetPos( 0, 0 )
					itemImage:SetCamPos( Vector( 12, 12, 5 ) )
					itemImage:SetLookAt( Vector( 0, 0, 0 ) )

					-- This is the button.
					local itemBtn = vgui.Create( "DButton", itemHolder )
					itemBtn:SetPos( 0, 0 )
					itemBtn:SetSize( itemW, itemH )
					itemBtn:SetText( "" )
					itemBtn.DoClick = function()
						net.Start("AskPickupItemInv")
							net.WriteUInt(id,16)
							net.WriteUInt(k,16)
						net.SendToServer()
						itemBtn:Remove()
						itemImage:Remove()
					end
					itemBtn.Paint = function()

						surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
						surface.DrawRect( 0, itemBtn:GetTall() - 20, itemBtn:GetWide(), 20 )

						draw.SimpleText( items[v.item].name, "HudHintTextLarge", 4, itemBtn:GetTall() - 10, Color( 150, 150, 150, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

						if !(items[v.item].isPrimary or items[v.item].isSecondary or items[v.item].isMelee) then
							draw.SimpleText( v.count, "Trebuchet24", itemBtn:GetWide() - 8, 12, Color( 200, 200, 200, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						end

					end
				end
			end

		end
	end

	-- Closing button.
	local closeBtn = vgui.Create( "DButton", otherPanel )
	closeBtn:SetPos( otherPanel:GetWide() - 120, otherPanel:GetTall() - 45 )
	closeBtn:SetText( "Close Inventory" )
	closeBtn:SetSize( 100, 30 )
	closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	closeBtn.OnCursorEntered = function()
		closeBtn:SetTextColor( Color( 80, 200, 255, 255 ))
	end
	closeBtn.OnCursorExited = function()
		closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	end
	closeBtn.DoClick = function()

		otherPanel:Remove()

	end
	closeBtn.Paint = function()

		surface.SetDrawColor( 70, 70, 70, 255 )
		surface.DrawRect( 0, 0, closeBtn:GetWide(), closeBtn:GetTall())

		surface.SetDrawColor( 10, 10, 10, 255 )
		surface.DrawOutlinedRect( 0, 0, closeBtn:GetWide(), closeBtn:GetTall())

	end

end

-- This asks the user how many of the item he wants to drop.
function DropItemAmount( id, key, callback )

	if !id then return end

	local dropPanel = vgui.Create( "DFrame" )
	dropPanel:MakePopup()
	dropPanel:SetSize( 300, 200 )
	dropPanel.Paint = function()

		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, dropPanel:GetWide(), dropPanel:GetTall() )

	end
	dropPanel:Center()

	local label = vgui.Create("DLabel", dropPanel)
	label:SetFont( "ChatFont" )
	label:SetText( "Drop " .. items[id.item].name )
	label:SizeToContents()
	label:Center()
	label.y = 20;

	local itemImage = vgui.Create( "DModelPanel", dropPanel )
	itemImage:SetModel( items[id.item].model )
	itemImage:SetSize( 128, 128 )
	itemImage:SetCamPos( Vector( 12, 12, 5 ) )
	itemImage:SetLookAt( Vector( 0, 0, 0 ) )
	itemImage:Center()
	itemImage.x = dropPanel:GetWide() - 148

	local txtInput = vgui.Create( "DTextEntry", dropPanel )
	txtInput:SetSize( 100, 30 )
	txtInput:SetText( "1" )
	txtInput:Center()
	txtInput:SetEditable( true )
	txtInput.x = 30

	-- Dropping button
	local dropBtn = vgui.Create( "DButton", dropPanel )
	dropBtn:SetPos( 40 , dropPanel:GetTall() - 40 )
	dropBtn:SetText( "Drop Item(s)" )
	dropBtn:SetSize( 100, 30 )
	dropBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	dropBtn.OnCursorEntered = function()
		dropBtn:SetTextColor( Color( 80, 200, 255, 255 ))
	end
	dropBtn.OnCursorExited = function()
		dropBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	end
	dropBtn.DoClick = function()

		local nb = tonumber(txtInput:GetValue())

		-- If there is something
		if nb then
			local ic = math.Round(math.Clamp(nb, 0, 200 ))

			Derma_Query("Are you sure you want to drop "..ic.." unit(s) of "..items[id.item].name.."?","Confirmation","Yes",function()
				net.Start("AskDropItem")
					net.WriteUInt(key,16)
					net.WriteUInt(ic,32)
				net.SendToServer()
				if (items[id.item].removeOnUse and ic == 1) or items[id.item].isAmmo then
				elseif items[id.item].removeOnUse and ic > 1 then
					id.count = ic - 1
				end
			end,"No")
		end

		if callback then callback() end
		dropPanel:Remove()

	end
	dropBtn.Paint = function()

		surface.SetDrawColor( 70, 70, 70, 255 )
		surface.DrawRect( 0, 0, dropBtn:GetWide(), dropBtn:GetTall())

		surface.SetDrawColor( 10, 10, 10, 255 )
		surface.DrawOutlinedRect( 0, 0, dropBtn:GetWide(), dropBtn:GetTall())

	end

	-- Closing button.
	local closeBtn = vgui.Create( "DButton", dropPanel )
	closeBtn:SetPos( dropPanel:GetWide() - 140, dropPanel:GetTall() - 40 )
	closeBtn:SetText( "Cancel" )
	closeBtn:SetSize( 100, 30 )
	closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	closeBtn.OnCursorEntered = function()
		closeBtn:SetTextColor( Color( 80, 200, 255, 255 ))
	end
	closeBtn.OnCursorExited = function()
		closeBtn:SetTextColor( Color( 255, 255, 255, 255 ))
	end
	closeBtn.DoClick = function()

		dropPanel:Remove()

	end
	closeBtn.Paint = dropBtn.Paint

end
