
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" ) -- and shared scripts are sent.

include('shared.lua')


function ENT:KeyValue()
end


function ENT:Initialize()

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetUseType( SIMPLE_USE )
	self.item = "none";
	self.count = 1;
	
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		phys:EnableMotion( false );
		phys:Wake()
	end

end

function ENT:Use(activator, caller)

	-- If it's the player, then ask for a pickup.
	if activator:IsPlayer() then
		if activator:AddItem( self.id, self.count ) then
			self:Remove();
		end
	end

end

function ENT:Think()

	self:NextThink( CurTime() + 999999 )
	return true;
	
end

-- Remove it from the spawn table.
function ENT:OnRemove()

	if self.spawn then 
		gamemode.ItemSpawns[self.spawn].spawned = false
	end

end

-- This receives the item ask info.
net.Receive( "item_ask_info", function( len, ply )

	local ent = net.ReadEntity()
	
	if ent and ent.id and ent.id != "none" then
		SendItemInfo( ent, ply )
	end

end)

-- This function sends the information of the entity.
function SendItemInfo( ent, ply )

	net.Start( "item_receive_info" )
		net.WriteEntity( ent ); 
		net.WriteString( ent.id );
	net.Send( ply )

end