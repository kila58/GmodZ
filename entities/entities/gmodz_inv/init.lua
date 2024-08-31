
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" ) -- and shared scripts are sent.

include('shared.lua')


function ENT:KeyValue()
end

-- Woo now inventories move!
function ENT:Initialize()

	self:SetModel( "models/Items/item_item_crate.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER );
	self:SetUseType( SIMPLE_USE );
	self.inv = nil;
	self.expire = false;
	
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
--		phys:EnableMotion( false );
		phys:Wake();
	end

end

function ENT:Use(activator, caller)

	-- If it's the player, then ask for a pickup.
	if activator:IsPlayer() and self.inv then
		net.Start( "inv_open_id" )
			net.WriteFloat( self.inv )
		net.Send( activator )
	end

end

function ENT:Think()

	self:NextThink( CurTime() + 300 )
	
	if !self.expire then
		self.expire = true;
	else
		self:Remove();
	end
	return true;
	
end

-- Remove it from the spawn table.
function ENT:OnRemove()

	-- Will delete the inventory.
	DeleteInventory( self.inv )

end

-- This receives the item ask info.
net.Receive( "inv_ent_ask_info", function( len, ply )

	local ent = net.ReadEntity()
	
	if ent and ent.id and ent.id != "none" then
		SendEntItemInfo( ent, ply )
	end

end)

-- This function sends the information of the entity.
function SendEntInvInfo( ent, ply )

	if !ent.inv then return end
	
	ent.inv = tonumber( ent.inv )

	net.Start( "inv_ent_receive_info" )
		net.WriteEntity( ent ); 
		net.WriteFloat( tonumber( ent.inv ))
		net.WriteTable( inv[ent.inv] )
	net.Send( ply )

end