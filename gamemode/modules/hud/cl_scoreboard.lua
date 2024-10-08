
surface.CreateFont( "ScoreboardDefault",
{
	font		= "Helvetica",
	size		= 22,
	weight		= 800
})

surface.CreateFont( "ScoreboardDefaultTitle",
{
	font		= "Helvetica",
	size		= 32,
	weight		= 800
})


--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE =
{
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar		= vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )

		self.Name		= self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:DockMargin( 8, 0, 0, 0 )

		self.Mute		= self:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping		= self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "ScoreboardDefault" )
		self.Ping:SetContentAlignment( 5 )

		self.Deaths		= self:Add( "DLabel" )
		self.Deaths:Dock( RIGHT )
		self.Deaths:SetWidth( 50 )
		self.Deaths:SetFont( "ScoreboardDefault" )
		self.Deaths:SetContentAlignment( 5 )

		self.Kills		= self:Add( "DLabel" )
		self.Kills:Dock( RIGHT )
		self.Kills:SetWidth( 50 )
		self.Kills:SetFont( "ScoreboardDefault" )
		self.Kills:SetContentAlignment( 5 )

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3*2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,

	Setup = function( self, pl )

		self.Player = pl

		local groupcolor = Color(0, 0, 0)
		local grouptag = "[]"

		local realtime = CurTime()
		local time = realtime - 0.1
		local r = math.abs( math.sin( time * 2 ) * 255 )
		local g = math.abs( math.sin( time * 2 + 2 ) * 255 )
		local b = math.abs( math.sin( time * 2 + 4 ) * 255 )

		if pl:GetUserGroup() == "superadmin" then
			groupcolor = Color(r, g, b)
			grouptag = "[SA] "
		elseif pl:GetUserGroup() == "vip_admin" then
			groupcolor = Color(247, 247, 0)
			grouptag = "[VIPA] "
		elseif pl:GetUserGroup() == "admin" then
			groupcolor = Color(0, 43, 255)
			grouptag = "[A] "
		elseif pl:GetUserGroup() == "vip_moderator" then
			groupcolor = Color(247, 247, 0)
			grouptag = "[VIPM] "
		elseif pl:GetUserGroup() == "moderator" then
			groupcolor = Color(0, 255, 0)
			grouptag = "[M] "
		elseif pl:GetUserGroup() == "vip" then
			groupcolor = Color(247, 247, 0)
			grouptag = "[VIP] "
		elseif pl:GetUserGroup() == "vip_tempmod" then
			groupcolor = Color(247, 247, 0)
			grouptag = "[VIPTEMP] "
		elseif pl:GetUserGroup() == "tempmod" then
			groupcolor = Color(255, 0, 0)
			grouptag = "[TEMP] "
		elseif pl:GetUserGroup() == "user" then
			groupcolor = Color( 100, 100, 100 )
			grouptag = "[USER] "
		end

		self.Avatar:SetPlayer( pl )
		self.Name:SetTextColor( groupcolor )
		self.Name:SetText( pl:Nick() )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:Remove()
			return
		end

		if ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
			self.NumKills	=	self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end

		if ( self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths() ) then
			self.NumDeaths	=	self.Player:Deaths()
			self.Deaths:SetText( self.NumDeaths )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing	=	self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end

		--
		-- Connecting players go at the very bottom
		--
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 )
		end

		--
		-- This is what sorts the list. The panels are docked in the z order,
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos( self.Player:UserID() )

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--

		if ( self.Player:Team() == TEAM_CONNECTING ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 125 ) )
			return
		end

		if  ( !self.Player:Alive() ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 100, 200, 255 ) )
			return
		end

		if ( self.Player:IsAdmin() ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 255, 230, 255 ) )
			return
		end

		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 230, 230, 255 ) )

	end,
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" );

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD =
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardDefaultTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

		self.ScoresLeft = self:Add( "DScrollPanel" )
		self.ScoresLeft:SetWidth( 500 )
		self.ScoresLeft:Dock( LEFT )

		self.ScoresRight = self:Add( "DScrollPanel" )
		self.ScoresRight:SetWidth( 500 )
		self.ScoresRight:Dock( RIGHT )

	end,

	PerformLayout = function( self )

		self:SetSize( 1000, ScrH() - 200 )
		self:SetPos( ScrW() / 2 - 500, 100 )

	end,

	Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end,

	Think = function( self, w, h )

		self.Name:SetText( GetHostName() )

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		local rebuild = false
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.ScoreEntry ) ) then

				--
				-- Check if we should switch the player from one panel to the other.
				--

				if ( pl:Frags() > 5 ) and IsValid( pl.ParentPanel ) and ( pl.ParentPanel != self.ScoresRight )
				or ( pl:Frags() <= 5 ) and IsValid( pl.ParentPanel ) and ( pl.ParentPanel != self.ScoresLeft ) then
					pl.ScoreEntry = nil
					rebuild = true;
				else
					continue
				end

			end

			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )

			if pl:Frags() <= 5 then
				self.ScoresLeft:AddItem( pl.ScoreEntry )
				pl.ParentPanel = self.ScoresLeft
			else
				self.ScoresRight:AddItem( pl.ScoreEntry )
				pl.ParentPanel = self.ScoresRight
			end

		end

		--
		-- If there's a change in the scoreboard layout, rebuild it.
		--

		if rebuild then

			for id, pl in pairs( plyrs ) do

				pl.ScoreEntry = nil

			end

			self.ScoresLeft:Clear()
			self.ScoresRight:Clear()

		end

	end,
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" );

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if ( !IsValid( g_Scoreboard ) ) then
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
	end

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
	end

end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end

