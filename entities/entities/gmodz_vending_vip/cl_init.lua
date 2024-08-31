include('shared.lua')

function ENT:OnRestore()
end

function ENT:Initialize()

	self.id = "none"
	AskItemInfo( self );

end

function ENT:Draw()

	self:DrawModel( true )
	self:DrawShadow( true )
	//DrawItemInfo( LocalPlayer() );

end

function ENT:PhysicsUpdate()

end

function ENT:Think()
end

surface.CreateFont("MingeFont2", { size = 28, weight = 12, antialias = false, font = "Arial", outline = true})

hook.Add( "PostDrawOpaqueRenderables", "example", function()
	cam.Start3D2D( Vector( 451.697357, -12075.956055, -542.968750), Angle( -180, -168, 90 ), -0.3 )
		draw.DrawText("VIP Vending Machine", "MingeFont2", 0, 0, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end )

-- This asks the info of this item to the server.
function AskItemInfo( ent )

	net.Start( "item_ask_info" )
		net.WriteEntity( ent )
	net.SendToServer()

end

-- This receives the info.
-- This function receives the player inventory and sets it.
net.Receive( "item_receive_info", function( len )

	local ent = net.ReadEntity()
	ent.id = net.ReadString()

end)
