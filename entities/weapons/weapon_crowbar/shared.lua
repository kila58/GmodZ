
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
    
SWEP.HoldType = "melee"

if CLIENT then

   SWEP.PrintName    = "Crowbar"
   SWEP.Slot         = 0
   SWEP.ViewModelFOV		= 70
  
   SWEP.ViewModelFlip = false
	SWEP.IconLetter	 = "6"
	SWEP.IconFont = "hl2mptypedeath"

end

SWEP.Base               = "weapon_cs_base"

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_crowbar.mdl"

SWEP.DrawCrosshair      = false
SWEP.Primary.Damage         = 12
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 0.6
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.Damage 		= 40
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.2

util.PrecacheSound("weapons/knife/knife_hit4.wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

function SWEP:PrimaryAttack()

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   self.Owner:LagCompensation(true)

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 55)

   local kmins = Vector(1,1,1) * -10
   local kmaxs = Vector(1,1,1) * 10

   local tr = util.TraceHull({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

   -- Hull might hit environment stuff that line does not hit
   if not IsValid(tr.Entity) then
      tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
   end

   local hitEnt = tr.Entity

   -- effects
   if IsValid(hitEnt) then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      local edata = EffectData()
      edata:SetStart(spos)
      edata:SetOrigin(tr.HitPos)
      edata:SetNormal(tr.Normal)
      edata:SetEntity(hitEnt)

      if hitEnt:IsPlayer() or hitEnt:IsNPC() then
         util.Effect("BloodImpact", edata)
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	  if SERVER then
		if tr.Hit then
			self.Owner:EmitSound("physics/concrete/rock_impact_hard" .. math.random( 1,3 ) .. ".wav", 70, 90 )
		else
			self.Owner:EmitSound("weapons/cbar_miss1.wav", 60, 95 + math.random(1, 10))
		end
	  end
   end

   self.Owner:SetAnimation( PLAYER_ATTACK1 )


   if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
      if hitEnt:IsPlayer() or hitEnt:IsNPC() then
		
		local dmg = DamageInfo()
		dmg:SetDamage(self.Primary.Damage)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self.Weapon or self)
		dmg:SetDamageForce(self.Owner:GetAimVector() * 5)
		dmg:SetDamagePosition(self.Owner:GetPos())
		dmg:SetDamageType(DMG_SLASH)
		
        hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
		hitEnt:TakeDamageInfo( dmg )
		
		self.Owner:EmitSound("weapons/cbar_hitbod" .. math.random(1,3) .. ".wav", 70, 100 )
		
      end
	end

   self.Owner:LagCompensation(false)
   
end

function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end

