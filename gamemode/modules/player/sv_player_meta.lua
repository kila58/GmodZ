-- Functions in this file will all be related to the player.

local Ply = FindMetaTable("Player")

--
-- This function is called on connection, this initialize player
--
function Ply:Initialize()

	-- Basic variables.
	self.itemVars = {}

	self.maxThirst		= 100;		-- Maximum amount of thirst.
	self:SetThirst( self.maxThirst )
	self.maxHunger		= 100;		-- Maximum amount of hunger.
	self:SetHunger( self.maxHunger )
	self.maxStamina		= 100;
	self:SetStamina( self.maxStamina )
	self.stamNextChange	= CurTime();

	self:StripAll()

	self.baseWalkSpeed 	= 140;
	self.baseRunSpeed	= 210;
	self:SetWalkSpeed( self.baseWalkSpeed );
	self:SetRunSpeed( self.baseRunSpeed );

	if self:GetUserGroup() == "vip" then
	self:SetModel("models/player/gasmask.mdl");
	--elseif self:GetUserGroup() == "superadmin" then
	--self:SetModel("models/half-dead/gopniks/slav.mdl");
    else
	self:SetModel("models/player/gasmask.mdl");
	end

end

--
-- This function resets the stats of a player.
--
function Ply:ResetStats()

	self:SetThirst( self.maxThirst )
	self:SetHunger( self.maxHunger )
	self:SetStamina( self.maxStamina )
	self.stamNextChange = CurTime()

	self:StripAll()

	self:AddInventory( 20 )
	self:AddItem( "soda" )
	self:AddItem( "banana" )
	self:AddItem( "painkillers" )

end


--
-- This either sets the stats of a player or create new ones for newcomers.
-- return: false if not connected.
--
function Ply:RetrieveStats()

	-- Check if we're connected first.
	if sqloo then

		local uid = self:UniqueID();
		local name = self:Nick();
		local q = sqloo:query( "SELECT * FROM players WHERE uid=".. uid .. ";");
		local ply = self;
		-- Do stuff here.
		function q:onSuccess( data )

			-- If there's stats, set them to our player, else create new stats.
			print( "DATA: " .. #data )
			if #data > 0 then

				local res = data[1]

				print("UID: " .. res.uid)
				ply:SetHealth( res.health )
				ply:SetThirst( res.thirst )
				ply:SetHunger( res.hunger )

			else
				-- Unique ID, HP, Thirst, Hunger, Inventory ID
				q = sqloo:query( "INSERT INTO players VALUES (" .. uid .. ", " .. 100 .. "," .. 80 .. ", " .. 80 .. ");")
				q:start();
				function q:onSuccess( data )
					if #data > 0 then
						PrintTable( data[1] )
					end
				end
				print("Creating new information for user: " .. name);
			end

		end

		function q:onError( err, sql )
			print( err );
		end
		q:start();

	else
		return false;
	end

end

--
-- This function saves the stats of the player.
-- return: false if the db is not connected.
--
function Ply:SaveStats()

	-- Check if we're connected first.
	if sqloo then

		-- Local variables
		local uid = self:UniqueID();
		local hp = self:Health();
		local thirst = self:Thirst();
		local hunger = self:Hunger();
		local inventory = self:Inventory();

		local q = sqloo:query( "SELECT * FROM players WHERE uid = ".. uid );
		function q:onSuccess( data )
			print(#data);
		end
		function q:onError( err, sql )
			print( err );
		end
		q:start();

	else
		return false;
	end

end

-- This function wakes nearby enemies when called.
function Ply:WakeEnemies( rangesqr )

	for k,v in pairs( gamemode.Monsters ) do

		if !v or !v:IsValid() then
			table.remove( gamemode.Monsters, k )
		elseif (self:GetPos() - v:GetPos()):LengthSqr() <= rangesqr then
			v:Wakeup();
		end

	end

end

--
-- This function gets the current amount of thirst.
-- return: amount of thirst.
--
function Ply:Thirst()
	return self.thirst or 100;
end

--
-- This function gets the current amount of hunger.
-- return: amount of thirst.
--
function Ply:Hunger()
	return self.hunger or 100;
end

--
-- This function gets the current amount of hunger.
-- return: amount of thirst.
--
function Ply:Stamina()
	return self.stamina or 100;
end

--
-- This function sets the current amount of thirst, not below 0 or above the maximum.
--
function Ply:SetThirst( amount )

	if !self.thirst then self.thirst = self.maxThirst end

	-- Kill the player when out of thirst.
	if amount < 0 then
		if self:Alive() then self:Kill() end
		self.thirst = 0;
	elseif amount > self.maxThirst then
		self.thirst = self.maxThirst
	else
		self.thirst = amount;
	end

	umsg.Start( "ply_thirst", self )
		umsg.Float( self.thirst )
	umsg.End()

end

--
-- This function sets the current amount of thirst, not below 0 or above the maximum.
--
function Ply:SetStamina( amount )

	if !self.stamina then self.stamina = self.maxStamina end

	-- When is the next stamina tick going to be?
	if amount < self.stamina then
		self.stamNextChange = CurTime() + 3;
	end

	-- Update if we're at 0 for the first time.
	if amount <= 0 and self.stamina > 0 then
		self.sendStam = CurTime() - 1;
	end

	-- Kill the player when out of thirst.
	if amount < 0 then
		self.stamina = 0;
	elseif amount > self.maxStamina then
		self.stamina = self.maxStamina
	else
		self.stamina = amount;
	end

	-- Don't overuse the usermessages.
	if !self.sendStam then self.sendStam = CurTime() + 0.2 end

	if self.sendStam < CurTime() then
		umsg.Start( "ply_stamina", self )
			umsg.Float( self.stamina )
		umsg.End()
		self.sendStam = CurTime() + 0.2;
	end

end

-- This function heals the player without going over the max amount of HP.
function Ply:Heal( amount )

	if ( self:Health() + amount ) > 100 then
		self:SetHealth( 100 )
	else
		self:SetHealth( self:Health() + amount )
	end

	-- Ah small sound when you heal.
	self:SendLua("surface.PlaySound('items/medshot4.wav')")

end

--
-- This function refunds ammunition and strip then strips the weapon.
--
function Ply:RefundWeapon( cl )

	local wep = self:GetWeapon( cl )
	if !IsValid(wep) then return end

	local clip = wep:Clip1() or 0
	if clip > 0 then
		self:GiveAmmo( clip, wep:GetPrimaryAmmoType() )
	end

	self:StripWeapon( cl )

end

--
-- This function strips every weapon from a player.
--
function Ply:StripAll()

	self:StripWeapons()

	if self.itemVars then

		for k,v in pairs(self.itemVars) do
			v = false;
		end

	end

end

--
-- This function sets the current amount of hunger, not below 0 or above the maximum.
--
function Ply:SetHunger( amount )

	if !self.hunger then self.hunger = self.maxHunger end

	-- Kill the player when out of hunger.
	if amount < 0 then
		if self:Alive() then self:Kill() end
		self.hunger = 0;
	elseif amount > self.maxHunger then
		self.hunger = self.maxHunger
	else
		self.hunger = amount;
	end

	umsg.Start( "ply_hunger", self )
		umsg.Float( self.hunger )
	umsg.End()

end

-- Money
function Ply:SaveMoney()

	-- Check if directory exists.
	if (not file.IsDir("gmodz_money", "data")) then
		file.CreateDir("gmodz_money")
	end

	local txt = string.gsub( self:SteamID(), ":", "_" )

	local fn = "gmodz_money/".. txt ..".txt"
	file.Write( fn, self:GetMoney() )

end

-- Money
function Ply:AddMoney( amount )
	if !self:GetMoney() then self.money = 0 end
	self:SetMoney( self:GetMoney() + amount )
end

function Ply:GetMoney()
	if !self.money then
		local txt = string.gsub( self:SteamID(), ":", "_" )
		local fn = "gmodz_money/" .. txt .. ".txt"
		if file.Exists( fn, "data" ) then
			self.money = tonumber(file.Read( fn )) or 0
		end
	end
	return self.money
end

-- Money
function Ply:SetMoney( amount )
	self.money = amount
	self:InformMoney()
	self:SaveMoney()
end

-- Money
function Ply:InformMoney()
	net.Start("inform_money")
		net.WriteFloat( self:GetMoney() or 0 )
	net.Send( self )
end
