AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( "models/zombie/classic.mdl" );

    self:SetHullType( HULL_HUMAN );
    self:SetHullSizeNormal();
	
    self:SetSolid( SOLID_BBOX );
    self:SetMoveType( MOVETYPE_STEP );
	
	self:SetCustomCollisionCheck( true );
	
   	self:CapabilitiesAdd( CAP_MOVE_GROUND );
   	
    self:SetMaxYawSpeed( 30 );
	
	self.LastSeenEnemy = 0;
	self:AddRelationship( "player D_HT 99" );
	
	self:SetHealth( 80 );

	self.Dead = false;
	self.ActiveTime = CurTime() + 1;
	self.Awake = false;
	
end

function ENT:OnTakeDamage( dmg )
	
	if( self.Dead ) then return end
	self:SetHealth( self:Health() - dmg:GetDamage() );
	
	ParticleEffect( "blood_impact_red_01", dmg:GetDamagePosition(), Angle(0, 0, 0), self )
	
	if( self:Health() <= 0 ) then
		self:Die();
	end
	
end

function ENT:Wakeup()

	if self.ActiveTime < CurTime() then
		self:NextThink( CurTime() );
		self:TaskComplete()
	end
	
	self.ActiveTime = CurTime() + 10;
	
end

function ENT:GoBack()

	if self:IsCurrentSchedule( SCHED_FORCED_GO_RUN ) then return end

	if ((self:GetPos() - self.spawnPoint):LengthSqr() > 10000000) then
		self:SetLastPosition( self.spawnPoint );
		self:SetSchedule( SCHED_FORCED_GO_RUN )
	end
	
end

function ENT:SetSleep()

	self:NextThink( CurTime() + 20000 );

end

function ENT:SeeEnemy()
	
	self:UpdateEnemyMemory( self:GetEnemy(), self:GetEnemy():GetPos() );
	self.LastSeenEnemy = CurTime();
	
end

function ENT:CanTarget( ply )
	
	if( !ply:Alive() ) then return false end
	return true;
	
end

function ENT:FindEnemy()
	
	local epos
	local spos
	local dist
	local lastDist
	
	for _, v in pairs( player.GetAll() ) do
		
		epos = v:GetPos();
		spos = self:GetPos();
		dist = ( spos - epos ):LengthSqr();
		lastDist = 800000
		
		if ( dist < 800000 ) then
			
			if dist < lastDist then
				
				self:SetEnemy( v )
				return true;
			
			end
			
			lastDist = dist
			
		end
		
	end
	
	return false;
	
end

function ENT:Attack()

	self:SetSchedule( SCHED_MELEE_ATTACK1 );
	self:EmitSound( "npc/zombie/zo_attack" .. math.Round( math.Rand( 1, 2 )) .. ".wav", 70,90 );
	
	local dmginfo = DamageInfo()
	dmginfo:SetDamage( math.Rand( 25, 40 ))
	dmginfo:SetDamageType( DMG_SLASH ) --Bullet damage
	dmginfo:SetAttacker( self ) --First player found gets credit
	dmginfo:SetDamageForce( Vector( 0, 0, 1000 ) ) --Launch upwards
	
	-- Actually attack the enemy
	timer.Simple( 0.7, function()
	
		if self and self:IsValid() then
			
			if self:Health() <= 0 then return end
		
			-- Find the enemy in front of the entity.
			for _,v in pairs( ents.FindInSphere( (self:GetPos() + Vector( 0, 0, 50)) + self:GetForward() * 20, 50 )) do
				if v:IsPlayer() then
					v:TakeDamageInfo( dmginfo )
					ParticleEffect( "blood_impact_red_01", v:GetPos() + Vector( 0 ,0 ,50 ), Angle(0, 0, 0), v )
				end
			end
			
		end
	end )

end

-- This will be changed.
function ENT:Think()
	
	if self.ActiveTime < CurTime() and !self:IsCurrentSchedule( SCHED_FORCED_GO_RUN ) then
		self:SetSleep()
	end
	
	self:GoBack()
	
	if ( self.Dead or self:IsCurrentSchedule( SCHED_MELEE_ATTACK1 ) 
					or self:IsCurrentSchedule( SCHED_CHASE_ENEMY ) 
					or self:IsCurrentSchedule( SCHED_FORCED_GO_RUN ) ) then return true end
	
	self:SetMovementActivity( ACT_WALK );
	
	local enemyDist = 800000
	
	if self:GetEnemy() then
		enemyDist = (self:GetPos() - self:GetEnemy():GetPos()):LengthSqr()
	end
	
	if enemyDist < 800000 then
	
		if self:IsCurrentSchedule( SCHED_IDLE_WANDER ) then
			self:TaskComplete();
		end
		
		local distLoop = 0;
		
		-- Switch target with nearest enemy, if very close.
		for _, v in pairs( player.GetAll() ) do
			
			distLoop = (self:GetPos() - v:GetPos()):LengthSqr()

			if( self:CanTarget( v ) and distLoop <= 3000 and distLoop < enemyDist ) then

				self:SetEnemy( v );
				enemyDist = distLoop;
				
			end
			
		end
		
		-- If we're near, attack the enemy.
		if enemyDist <= 3000 then
			if self:IsCurrentSchedule( SCHED_CHASE_ENEMY ) then
				self:TaskComplete();
			end
			self:Attack()
		else
			self:SetSchedule( SCHED_CHASE_ENEMY );
		end
		
	else
	
		if !self:IsCurrentSchedule( SCHED_IDLE_WANDER ) then
			self:SetSchedule( SCHED_IDLE_WANDER );
		end
		
		self:FindEnemy()
		
	end
	
	return true
	
end

function ENT:OnRemove()

	local id = self.spawn

	if id then
		gamemode.MonsterSpawns[self.spawn].spawned = false;
		timer.Simple( math.Round( math.Rand( 15, 45 )), function()
			PlaceOneMob( id )
		end)
	end

end

function ENT:Die()
	
	self:EmitSound("npc/zombie/zombie_die".. math.random(1,3) ..".wav", 75, 70)
	self:TaskComplete();
	self:SetSchedule( SCHED_NPC_FREEZE );
	self.Dead = true;
	self:SetRenderFX( 23 );
	
	if math.random(0,3) != 0 then 
		local cash = ents.Create("gmodz_dollar")
		cash:SetPos( self:GetPos() + Vector( 0, 0, 5 ) )
		cash:Spawn()
		cash.amount = math.random( 1, 2 ) * 100
	end
	
	timer.Simple( 0.1, function()
		if( self and self:IsValid() ) then
			self:Remove();
		end
	end );
	
end