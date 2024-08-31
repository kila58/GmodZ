include('shared.lua')

function ENT:OnRestore()
end

function ENT:Initialize()

	self:DrawShadow( true )

end

function ENT:Draw()
	
	self:DrawModel()

end

function ENT:PhysicsUpdate()

end

function ENT:Think()

	self:SetLocalAngles( Angle(0, self:GetLocalAngles().y + FrameTime() * 15, 0) )

end