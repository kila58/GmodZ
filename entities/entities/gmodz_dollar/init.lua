
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" ) -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetModel( "models/props/cs_assault/dollar.mdl" )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetUseType( SIMPLE_USE )
	self:AddEffects( EF_ITEM_BLINK )
	self:AddEffects( EF_DIMLIGHT )
	self.amount = 100;
	self.expire = 120;

	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		phys:EnableMotion( false );
		phys:Wake()
	end

end

function ENT:Use(activator, caller)

	-- If it's the player, then ask for a pickup.
	if activator:IsPlayer() then
		activator:AddMoney( self.amount );
		activator:ChatPrint("You picked up: $" .. self.amount)
		self:Remove()
	end

end

function ENT:Think()

	self:NextThink( CurTime() + self.expire )

	if !self.think then
		self.think = true;
	else
		self:Remove()
	end

	return true;

end
