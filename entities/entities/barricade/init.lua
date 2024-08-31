AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/concrete_barrier001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
		phys:EnableMotion(false)
	end
	self.HP = 500
end

function ENT:OnTakeDamage(info)
	self.HP = self.HP-info:GetDamage()
	if !self.opos then
		self.opos=self:GetPos()
		timer.Simple(.2,function() if self:IsValid() then self:EmitSound("physics/cardboard/cardboard_box_break2.wav",100,math.random(70,120)) self:SetPos(self.opos) self.opos = false end end)
	end
	--local attacker = dmg:GetAttacker()
	if self.HP <= 0 then
		self:EmitSound("physics/cardboard/cardboard_box_break2.wav",100,50)
		local effectdata = EffectData()
		effectdata:SetStart( self:GetPos() )
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetScale( 1 )
		util.Effect( "HelicopterMegaBomb", effectdata )
		self:Remove()
	end
	--if attacker:InInnerSafezone() or attacker:HasGodMode() then
	--	dmg:ScaleDamage(0)
	--	return
	--end
end
