include('shared.lua')

function ENT:OnRestore()
end

function ENT:Initialize()

	self.inv = nil;

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
function AskInvInfo( ent )
	
	net.Start( "inv_ent_ask_info" )
		net.WriteEntity( ent )
	net.SendToServer()
	
end

-- This receives the info.
-- This function receives the player inventory and sets it.
net.Receive( "inv_ent_receive_info", function( len )
	
	if !inv then inv = {} end
	
	local ent = net.ReadEntity()
	local id = net.ReadFloat()
	id = tonumber( id );
	inv[id] = net.ReadTable();
	ent.inv = id;
	
end)