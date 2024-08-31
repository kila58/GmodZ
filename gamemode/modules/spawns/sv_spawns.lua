
--
-- Functions in this files are related to items and mob spawning.
--

-- Function that adds monster spawn.
function AddMonsterSpawn( pos )

	local t = {}
	t.pos = pos
	t.spawned = false;

	table.insert( gamemode.MonsterSpawns, t )
	print("Monster Spawn Added...");

end

-- Function that adds a monster spawn.
function AddItemSpawn( pos )

	local t = {}
	t.pos = pos
	t.item = "none";
	t.spawned = false;

	table.insert( gamemode.ItemSpawns, t )

end

-- Console command to add a spawn.
concommand.Add( "gmodz_addspawn", function( ply, cmd, args )

	if ply:IsAdmin() then

		if args[1] == "mobs" then
			AddMonsterSpawn( ply:GetPos() )
			ply:PrintMessage( HUD_PRINTTALK, "Monster spawn added at your position." );
		elseif args[1] == "items" then
			AddItemSpawn( ply:GetPos() )
			ply:PrintMessage( HUD_PRINTTALK, "Item spawn added at your position." );
		end

	end

end )

-- This function saves the given type of spawns in the files.
function SaveSpawns( genre )

	if genre == "mobs" then
		file.Write( game.GetMap() .. "_gmodz_" .. genre .. ".txt", util.TableToJSON( gamemode.MonsterSpawns ))
	elseif genre == "items" then
		file.Write( game.GetMap() .. "_gmodz_" .. genre .. ".txt", util.TableToJSON( gamemode.ItemSpawns ))
	end

end

concommand.Add( "gmodz_savespawns", function( ply, cmd, args )

	SaveSpawns( args[1] );

end)

-- This function replaces items on load.
function ReplaceItems()

	for k,v in pairs( gamemode.ItemSpawns ) do

		if v.spawned then

			if !items[v.item] then
				v.spawned = false
			else
				local ent = items.SpawnItem( v.item, v.pos )
				ent.spawn = k
			end

		end

	end

	SaveSpawns( "items" );

end


-- Function that place items on the map. TEMPORARY.
function PlaceItems()

	local name
	local ent

	for k,v in pairs( gamemode.ItemSpawns ) do

		//v.spawned = false;
		if !v.spawned then

			name = items.GetRandomItem()

			ent = items.SpawnItem( name, v.pos )
			ent.spawn = k
			v.item = name
			v.spawned = true;

		end

	end

	-- Save the new spawns.
	SaveSpawns( "items" );

end

-- Function that place items on the map. TEMPORARY.
function PlaceMobs( forced )

	local ent

	for k,v in pairs( gamemode.MonsterSpawns ) do

		if !v.spawned or forced then

			-- Rnadom mob, might be a fast zombie!
			if math.random( 4 ) == 4 then
				ent = ents.Create( "gmodz_fastmob" )
			else
				ent = ents.Create( "gmodz_mob" )
			end

			ent.spawn = k
			ent.spawnPoint = v.pos
			ent:SetPos( v.pos )
			ent:Spawn()
			v.spawned = true;

		end

	end

	-- Save the new spawns.
	SaveSpawns( "mobs" );

end

-- This function places one mob.
function PlaceOneMob( id )

	if !gamemode.MonsterSpawns[id] then return end

	local where = gamemode.MonsterSpawns[id]
	if where.spawned then return end

	local ent
	-- Rnadom mob, might be a fast zombie!
	if math.random( 4 ) == 4 then
		ent = ents.Create( "gmodz_fastmob" )
	else
		ent = ents.Create( "gmodz_mob" )
	end

	ent.spawn = id
	ent.spawnPoint = where.pos
	ent:SetPos( where.pos )
	ent:Spawn()
	where.spawned = true;

end

-- This function loads the give type of spawns in the gamemode.
function LoadSpawns( genre )

	local fn = game.GetMap() .. "_gmodz_" .. genre .. ".txt"

	-- Check if the list of entities to place on the current map is there.
	if ( !file.Exists( fn, "data" )) then
		print("[GMODZ ERROR] - Couldn't find " .. genre .. " spawn file.")
		return
	else

		local fr = file.Read( fn );
		-- Check for which thing to load.
		if genre == "mobs" then
			gamemode.MonsterSpawns = util.JSONToTable( fr );
		elseif genre == "items" then
			gamemode.ItemSpawns = util.JSONToTable( fr );
		else
			return
		end

	end


end

gamemode.ItemSpawnInterval 			= 300;		-- Item spawn every 120 seconds.

-- Spawn points coordonates.
gamemode.SpawnPoints = {
							Vector( 1204, 12652, -50 ),
							Vector( -2181, 13243, 510 ),
							Vector( -5984, 13141, 150 ),
							Vector( -8732, 10066, -300 ),
							Vector( -7164, 7417, -676 ),
							Vector( -8949, 3277, -582 ),
							Vector( -8638, 826, -694 ),
							Vector( -6846, 181, -690 ),
							Vector( -9550, -7342, -338 ),
							Vector( -13480, -12379, -256 ),
							Vector( -10785, -13603, -614 ),
							Vector( -6388, -13597, -300 ),
							Vector( 5174, -12780, -156 ),
							Vector( 11748, -13384, -366 ),
							Vector( 12654, -8253, -322 ),
							Vector( 13535, -6245, -250 ),
							Vector( 12389, -1161, -496 ),
							Vector( 12008, 2173, -672 ),
							Vector( 11245, 5181, -565 ),
							Vector( 5763, 7029, -614 ),
							Vector( 3761, 7433, -590 ),
							Vector( 4897, 13476, -476 ),
							Vector( 9512, 13661, -332 ),
							Vector( 4052, -894,-240 )
						}

function GM:PlayerInitialSpawn( ply )

	ply:KillSilent()
	ply:Spectate(OBS_MODE_FIXED)

	timer.Create( ply:UniqueID() .. "wakemobs", 3, 0, function()

		if ply:Alive() then
			ply:WakeEnemies( 4000000 )
		end

	end)

end

-- Reset the player's stats
function GM:PlayerSpawn( ply )

	if !ply.authed then
		return false
	end
	if ply:GetObserverMode() != OBS_MODE_NONE then
		ply:Spectate( OBS_MODE_NONE )
		ply:UnSpectate();
	end

	ply:RemoveAllAmmo();
	ply:ResetStats()
	ply:RetrieveStats()

	-- Initial spawn.
	if !ply.respawns then
		ply.respawns = true
		ply:AddInventory( 20 ) -- No inventory yet.
		ply:GetInventory()
		ply:GetBank()
	end

end

function GM:OnEntityCreated( ent )

	-- If it's a monster.
	if ( ent:GetClass() == "gmodz_mob" ) or (ent:GetClass() == "gmodz_fastmob" ) then
		table.insert( gamemode.Monsters, ent )
	end

end

function GM:InitPostEntity()

	for _,v in pairs( ents.FindByClass( "prop_physics" )) do
		v:Remove();
	end

	-- Remove info_player_starts to place new ones.
	for _,v in pairs( ents.FindByClass( "info_player_start" )) do
		v:Remove();
	end

	-- Create new spawns.
	for _,v in pairs( gamemode.SpawnPoints ) do
		local spawn = ents.Create("info_player_start")
		spawn:SetPos( v )
		spawn:Spawn()
	end

	-- This replaces items on the map.
	ReplaceItems()

	-- Create a vending machine
	local vending = ents.Create( "gmodz_vending" )
	vending:SetPos( Vector( 235.968292, -12050.679688, -631.968750) )
	vending:SetAngles( Angle( 0, -225, 0 ))
	vending:Spawn()

	--local vendingvip = ents.Create( "gmodz_vending_vip" )
	--vendingvip:SetPos( Vector( 461.697357, -12099.956055, -635.968750) )
	--vendingvip:SetAngles( Angle( 0, -168, 0 ))
	--vendingvip:Spawn()

	-- Place mobs afer 5 seconds.
	timer.Simple( 5, function() PlaceMobs( true ) end);

	-- Place the items then start a timer to place them every 'GIVEN INTERVAL' seconds.
	timer.Create( "timerItemSpawn", gamemode.ItemSpawnInterval, 0, function()
		PlaceItems();
		print("Placing Items on the map, next in " .. gamemode.ItemSpawnInterval .. " seconds.");
	end)

end