ENT.Spawnable = true
ENT.AdminSpawnable = true

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	--local health = self.HP()

	--hook.Add("HUDPaint", "cadehealth", function()
		--if !IsValid(self) then return end
		--local cadeposorigin = Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z+40)
		--local textpos = cadeposorigin:ToScreen()
		--draw.DrawText("Test","DebugFixedSmall",textpos.x,textpos.y,Color(0,0,255,255),TEXT_ALIGN_CENTER)
	--end)
end
