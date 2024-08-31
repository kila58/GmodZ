resource.AddWorkshop ("132907756") -- the map
resource.AddWorkshop ("165772389") -- the map's models/textures
resource.AddWorkshop ("104506205") -- helis
resource.AddWorkshop ("301175145") -- collection
resource.AddWorkshop ("104483020") -- SCars Slim
resource.AddWorkshop ("106926982") -- SCars Bikes


 function GM:GetFallDamage( ply, speed )

	return ( speed / 8 )

end

util.AddNetworkString( "ply_receive_inventory" )
util.AddNetworkString( "ply_receive_item" )
util.AddNetworkString( "ply_ask_inventory" )
util.AddNetworkString( "ply_ask_dropitem" )
util.AddNetworkString( "ply_ask_useitem" )
util.AddNetworkString( "ply_ask_movebank" )
util.AddNetworkString( "ply_ask_moveinv" )
util.AddNetworkString( "item_ask_info" )
util.AddNetworkString( "item_receive_info" )
util.AddNetworkString( "ply_salvage" )
util.AddNetworkString( "buy_bundle" )
util.AddNetworkString( "buy_bundle_vip" )
util.AddNetworkString( "inv_ent_ask_info" )
util.AddNetworkString( "inv_ask_info" )
util.AddNetworkString( "inv_ent_receive_info" )
util.AddNetworkString( "inv_receive_info" )
util.AddNetworkString( "inv_open_id" )
util.AddNetworkString( "im_cheating" )
util.AddNetworkString( "inform_money" )
util.AddNetworkString( "rank" )
util.AddNetworkString( "rank_inform" )

resource.AddFile( "materials/icons/in_hp_sil.png" )
resource.AddFile( "materials/icons/bg_hp_sil.png" )
resource.AddFile( "materials/icons/bg_bullet.png" )

resource.AddFile("materials/scope/scope_normal.vtf")
resource.AddFile("materials/scope/scope_normal.vmt")

function GM:Initialize()

	inv = {}
	gamemode.ItemSpawns = {}
	gamemode.MonsterSpawns = {}
	gamemode.Monsters = {}

	LoadSpawns( "items" )
	LoadSpawns( "mobs" )

end

hook.Add("InitPostEntity", "steamjetfilter", function()

    RunConsoleCommand("con_filter_enable", 1)
    RunConsoleCommand("con_filter_text_out", "Attempting to create unknown particle system 'steam_jet_80'") 
	
end)

concommand.Add( "reset",function( ply )
if ply:GetUserGroup() == "superadmin" then
		local Players_all = player.GetAll()
		for i = 1, table.Count(Players_all) do
			local plys = Players_all[i]
			plys:SaveInventory()
			plys:ChatPrint("[WARNING] Map will restart in 30 seconds.")
		end
		timer.Create("reset", 30, 1, function()
			RunConsoleCommand( "gamemode", "dayz" )
			RunConsoleCommand( "changelevel", "rp_stalker" )
		end)
		ply:ChatPrint( "Everyones data saved." )
	end
end )

-- Cheating 30 min ban.
net.Receive("im_cheating", function( len, ply )
	ply:Kick("Please turn r_3dsky to 1 or ajust cl_cmdrate to 30.")
end)