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