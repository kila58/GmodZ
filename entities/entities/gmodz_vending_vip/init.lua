
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" ) -- and shared scripts are sent.

include('shared.lua')


function ENT:KeyValue()
end


function ENT:Initialize()

	self:SetModel("models/props/cs_office/Vending_machine.mdl");
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		phys:EnableMotion( false );
		phys:Wake()
	end

end

function ENT:Use(activator, caller)

	if activator:IsPlayer() then
		umsg.Start("ply_open_vending_vip", activator)
		umsg.End()
	end

end

function ENT:Think()

	self:NextThink( CurTime() + 999999 )
	return true;

end

-- Remove it from the spawn table.
function ENT:OnRemove()

end
