----------------------------------------------
-- MALAJUBE, great band, check it out guys. --
----------------------------------------------

-- Items metatable.
items = {}

-- This function adds an item to the 'items' table.
items.AddItem = function ( id, cat, chance )

	cat = cat or "misc"
	chance = chance or 10

	-- Check if the item already exists.
	if items[id] then
		print("Couldn't add item '" .. name .. "' because it already exists.")
		return
	end

	-- Pretty self explanatory.
	local new = {}
	new.name 				= "Item"
	new.maxStack			= 10;
	new.maxCount 			= 0;
	new.model 				= "models/weapons/w_smg_mac10.mdl"
	new.tooltip 			= ""
	new.removeOnUse 		= true;
	new.isPrimary 			= false;
	new.isSecondary			= false;
	new.isMelee				= false;
	new.isAmmo				= false;
	new.canSpawn			= true;
	new.ent					= nil;
	new.offset				= nil
	new.salvage				= false
	new.points				= 0;
	new.category			= cat


	new.OnUse = function( self, ply )
	end
	new.OnPickup = function( self, ply )
	end
	new.OnDrop = function( self, ply )
	end

	items[id] = new;

	-- Chances of spawning an item by categories.
	if SERVER then
		if categories[cat] then

			categories[cat][id] = chance
			if chance > categories[cat].totchance then
				categories[cat].totchance = chance
			end

		end
	end

	return items[id]

end


-- SERVER ONLY FUNCTIONS
if SERVER then

-- Categories for randomisation.
categories = {}
categories["thirst"] = {}
categories["thirst"].totchance = 0
categories["hunger"] = {}
categories["hunger"].totchance = 0
categories["health"] = {}
categories["health"].totchance = 0
categories["weapons"] = {}
categories["weapons"].totchance = 0
categories["ammo"] = {}
categories["ammo"].totchance = 0
categories["misc"] = {}
categories["misc"].totchance = 0

-- This function creates an item at the desired position.
items.SpawnItem = function( id, pos, count )

	if items[id].isAmmo and !count then
		count = math.random( 10, 20 );
	else
		count = count or 1;
	end

	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos - Vector( 0, 0, 400 );
	tracedata.filter = player.GetAll();
	tracedata.mask = MASK_PLAYERSOLID
	local trace = util.TraceLine(tracedata)
	if trace.Hit then
	   pos = trace.HitPos
	end

	local item = ents.Create( "gmodz_item" )
	item:SetModel( items[id].model )
	item:Spawn()
	item:SetPos( pos + Vector(0, 0, item:OBBMaxs().z ) + (items[id].offset or Vector(0, 0, 0)))
	item.id = id
	item.count = count

	return item

end

items.GetRandomItem = function()

	local randCat = math.Rand( 0, 100 );
	local cat;
	local item;

		-- TODO:
		-- Make this shit automated so it's not messy.
		--
	if randCat >= 93 then
		cat = "misc"
	elseif randCat >= 83 and randCat < 93 then
		cat = "health"
	elseif randCat >= 55 and randCat < 83 then
		cat = "ammo"
	elseif randCat >= 40 and randCat < 55 then
		cat = "weapons"
	elseif randCat >= 20 and randCat < 40 then
		cat = "thirst"
	else
		cat = "hunger"
	end

	math.random( os.time() )
	local randItem = math.random( 0, categories[cat].totchance );
	local lastRandom
	local t = {}

	-- Get the actual item.
	for k,v in pairs(categories[cat]) do

		if k != "totchance" then

			if randItem <= v then
				table.insert( t, k );
			end

		end
	end

	item = t[math.random(#t)];
	print( item )
	return item or "soda";

end

-- This function returns a table of spawnable items.
items.GetSpawnables = function()

	local t = {}

	for k,v in pairs( items ) do

		if type(v) != "function" then

			if v.canSpawn then
				table.insert( t, k );
			end

		end

	end

	return t;

end

end
-- END HERE


---------------------------------------------------------------
-- THIRST ITEMS BELOW
---------------------------------------------------------------

local Drink = function( ply, amount )

	ply:SetThirst( ply:Thirst() + amount )
	ply:SendLua("surface.PlaySound('ambient/water/water_spray" .. math.random(1,3) .. ".wav')")

end

local milk = items.AddItem( "milk", "thirst", 20 )
milk.model = "models/props_junk/garbage_milkcarton001a.mdl"
milk.name = "Milk"
milk.maxCount = 10
milk.OnUse = function( self, ply )

	Drink( ply, 50 )

end

local literwater = items.AddItem( "literwater", "thirst", 10 )
literwater.model = "models/props_junk/garbage_plasticbottle003a.mdl"
literwater.name = "2L Water"
literwater.maxCount = 10
literwater.OnUse = function( self, ply )

	Drink( ply, 100 )

end

local water = items.AddItem( "water", "thirst", 30 )
water.model = "models/props/cs_office/Water_bottle.mdl"
water.name = "Water Bottle"
water.maxCount = 10
water.OnUse = function( self, ply )

	Drink( ply, 70 )

end

local soda = items.AddItem( "soda", "thirst", 40 )
soda.model = "models/props_junk/PopCan01a.mdl"
soda.name = "Soda Can"
soda.maxCount = 10
soda.OnUse = function( self, ply )

	Drink( ply, 20 )

end

---------------------------------------------------------------
-- HUNGER ITEMS BELOW
---------------------------------------------------------------

local Eat = function( ply, amount )

	ply:SetHunger( ply:Hunger() + amount )
	ply:SendLua("surface.PlaySound('npc/headcrab/headbite.wav')")

end

local fastfood = items.AddItem( "fastfood", "hunger", 10 )
fastfood.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
fastfood.name = "Fast Food"
fastfood.maxCount = 10
fastfood.OnUse = function( self, ply )

	Eat( ply, 100 )

end

local orange = items.AddItem( "orange", "hunger", 35 )
orange.model = "models/props/cs_italy/orange.mdl"
orange.name = "Orange"
orange.maxCount = 10
orange.OnUse = function( self, ply )

	Eat( ply, 20 )

end

local banana = items.AddItem( "banana", "hunger", 35 )
banana.model = "models/props/cs_italy/bananna_bunch.mdl"
banana.name = "Banana"
banana.maxCount = 10
banana.OnUse = function( self, ply )

	Eat( ply, 25 )

end

local melon = items.AddItem( "melon", "hunger", 10 )
melon.model = "models/props_junk/watermelon01.mdl"
melon.name = "Melon"
melon.maxCount = 10
melon.OnUse = function( self, ply )

	Eat( ply, 50 )

end

local beans = items.AddItem( "beans", "hunger", 10 )
beans.model = "models/props_junk/garbage_metalcan001a.mdl"
beans.name = "Can of Beans"
beans.maxCount = 10
beans.OnUse = function( self, ply )

	Eat( ply, 70 )

end

---------------------------------------------------------------
-- HEALTH ITEMS BELOW
---------------------------------------------------------------

local bloodpack = items.AddItem( "bloodpack", "health", 10 )
bloodpack.model = "models/weapons/w_package.mdl"
bloodpack.name = "Blood Pack"
bloodpack.OnUse = function( self, ply )

	ply:Heal( 100 );

end

local healthkit = items.AddItem( "healthkit", "health", 30 )
healthkit.model = "models/Items/HealthKit.mdl"
healthkit.name = "Health Kit"
healthkit.OnUse = function( self, ply )

	ply:Heal( 60 )

end

local painkillers = items.AddItem( "painkillers", "health", 60 )
painkillers.model = "models/props_junk/PopCan01a.mdl" -- REAL MODEL: "models/w_models/weapons/w_eq_painpills.mdl"
painkillers.name = "Painkillers"
painkillers.OnUse = function( self, ply )

	ply:Heal( 20 )

end

---------------------------------------------------------------
-- WEAPON ITEMS BELOW
---------------------------------------------------------------

-- Function for the secondary weapons' OnUse
local secWepUse = function( self, ply )

	if ply.itemVars["secondary"] and ply:HasWeapon(items[self.item].ent) then
		ply:RefundWeapon(items[self.item].ent)
		ply.itemVars["secondary"] = nil
		ply:SendLua("surface.PlaySound('physics/metal/weapon_footstep2.wav')")
	else
		if ply.itemVars["secondary"] then
			ply:RefundWeapon(ply.itemVars["secondary"])
		end

		ply:Give(items[self.item].ent)
		ply:SelectWeapon(items[self.item].ent)
		ply.itemVars["secondary"] = items[self.item].ent
		ply:SendLua("surface.PlaySound('physics/metal/weapon_footstep1.wav')")
	end

end

local secDrop = function( self, ply )

	if ply.itemVars["secondary"] and ply:HasWeapon(items[self.item].ent) then
		ply:RefundWeapon(items[self.item].ent)
		ply.itemVars["secondary"] = nil;
	end

end

-- Function for the primary weapons' OnUse
local primWepUse = function( self, ply )

	if ply.itemVars["primary"] and ply:HasWeapon(items[self.item].ent) then
		ply:RefundWeapon(items[self.item].ent)
		ply.itemVars["primary"] = nil
		ply:SendLua("surface.PlaySound('physics/metal/weapon_footstep2.wav')")
	else
		if ply.itemVars["primary"] then
			ply:RefundWeapon(ply.itemVars["primary"])
		end

		ply:Give(items[self.item].ent)
		ply:SelectWeapon(items[self.item].ent)
		ply.itemVars["primary"] = items[self.item].ent
		ply:SendLua("surface.PlaySound('physics/metal/weapon_footstep1.wav')")
	end

end

local primDrop = function( self, ply )

	if ply.itemVars["primary"] and ply:HasWeapon(items[self.item].ent) then
		ply:RefundWeapon(items[self.item].ent)
		ply.itemVars["primary"] = nil;
	end

end

-- Function for the melee weapons' OnUse
local meleeWepUse = function( self, ply )

	if ply.itemVars["melee"] and ply:HasWeapon(items[self.item].ent) then
		ply:StripWeapon(items[self.item].ent)
		ply.itemVars["melee"] = nil
		ply:SendLua("surface.PlaySound('physics/metal/weapon_footstep2.wav')")
	else
		if ply.itemVars["melee"] then
			ply:StripWeapon(ply.itemVars["melee"])
		end

		ply:Give(items[self.item].ent)
		ply:SelectWeapon(items[self.item].ent)
		ply.itemVars["melee"] = items[self.item].ent
		ply:SendLua("surface.PlaySound('physics/metal/weapon_footstep1.wav')")
	end

end

local meleeDrop = function( self, ply )

	if ply.itemVars["melee"] and ply:HasWeapon(items[self.item].ent) then
		ply:StripWeapon(items[self.item].ent)
		ply.itemVars["melee"] = nil;
	end

end

local cb = items.AddItem( "crowbar", "weapons", 10 )
cb.model = "models/weapons/w_crowbar.mdl"
cb.name = "Crowbar"
cb.ent = "weapon_crowbar"
cb.isSecondary = true;
cb.removeOnUse = false;
cb.salvage = true;
cb.points = 50;
cb.OnUse = meleeWepUse
cb.OnDrop = meleeDrop

local knife = items.AddItem( "knife", "weapons", 10 )
knife.model = "models/weapons/w_knife_t.mdl"
knife.name = "Knife"
knife.ent = "weapon_knife"
knife.isSecondary = true;
knife.removeOnUse = false;
knife.salvage = true;
knife.points = 50;
knife.OnUse = meleeWepUse
knife.OnDrop = meleeDrop

local stick = items.AddItem( "stick", "weapons", 10 )
stick.model = "models/weapons/w_stunbaton.mdl"
stick.name = "Stun Stick"
stick.ent = "weapon_stunbaton"
stick.isSecondary = true;
stick.removeOnUse = false;
stick.salvage = true;
stick.points = 50;
stick.OnUse = meleeWepUse
stick.OnDrop = meleeDrop

local fuel = items.AddItem ( "fuel", " weapons", 70 )
fuel.model = "models/props_junk/gascan001a.mdl"
fuel.model = "Gas Can"
fuel.model = "weapon_scarrefuel"
fuel.isSecondary = true;
fuel.removeOnUse = false;
fuel.salvage = true;
fuel.points = 50;
fuel.OnUse = meleeWepUse
fuel.OnDrop = meleeDrop


local deagle = items.AddItem( "deagle", "weapons", 15 )
deagle.model = "models/weapons/w_pist_deagle.mdl"
deagle.name = "Desert Eagle"
deagle.ent = "weapon_deagle"
deagle.isSecondary = true;
deagle.removeOnUse = false;
deagle.salvage = true;
deagle.points = 400;
deagle.OnUse = secWepUse
deagle.OnDrop = secDrop

local glock = items.AddItem( "glock", "weapons", 25 )
glock.model = "models/weapons/w_pist_glock18.mdl"
glock.name = "Glock18"
glock.ent = "weapon_glock"
glock.isSecondary = true;
glock.removeOnUse = false;
glock.salvage = true;
glock.points = 100;
glock.OnUse = secWepUse
glock.OnDrop = secDrop

local p228 = items.AddItem( "p228", "weapons", 25 )
p228.model = "models/weapons/w_pist_p228.mdl"
p228.name = "P228"
p228.ent = "weapon_p228"
p228.isSecondary = true;
p228.removeOnUse = false;
p228.salvage = true;
p228.points = 100;
p228.OnUse = secWepUse
p228.OnDrop = secDrop

local usp = items.AddItem( "usp", "weapons", 25 )
usp.model = "models/weapons/w_pist_usp.mdl"
usp.name = "USP"
usp.ent = "weapon_usp"
usp.isSecondary = true;
usp.removeOnUse = false;
usp.salvage = true;
usp.points = 100;
usp.OnUse = secWepUse
usp.OnDrop = secDrop

local ak47 = items.AddItem( "ak47", "weapons", 12 )
ak47.model = "models/weapons/w_rif_ak47.mdl"
ak47.name = "AK47"
ak47.ent = "weapon_ak47"
ak47.isPrimary = true;
ak47.removeOnUse = false;
ak47.salvage = true;
ak47.points = 250;
ak47.OnUse = primWepUse
ak47.OnDrop = primDrop

local scout = items.AddItem( "scout", "weapons", 12 )
scout.model = "models/weapons/w_snip_scout.mdl"
scout.name = "Scout"
scout.ent = "weapon_scout"
scout.isPrimary = true;
scout.removeOnUse = false;
scout.salvage = true;
scout.points = 250;
scout.OnUse = primWepUse
scout.OnDrop = primDrop

local galil = items.AddItem( "galil", "weapons", 12 )
galil.model = "models/weapons/w_rif_galil.mdl"
galil.name = "Galil"
galil.ent = "weapon_galil"
galil.isPrimary = true;
galil.removeOnUse = false;
galil.salvage = true;
galil.points = 250;
galil.OnUse = primWepUse
galil.OnDrop = primDrop

local m4 = items.AddItem( "m4", "weapons", 12 )
m4.model = "models/weapons/w_rif_m4a1.mdl"
m4.name = "M4A1"
m4.ent = "weapon_m4"
m4.isPrimary = true;
m4.removeOnUse = false;
m4.salvage = true;
m4.points = 250;
m4.OnUse = primWepUse
m4.OnDrop = primDrop

local pump = items.AddItem( "pump", "weapons", 12 )
pump.model = "models/weapons/w_shot_m3super90.mdl"
pump.name = "Pump Shotgun"
pump.ent = "weapon_pumpshotgun"
pump.isPrimary = true;
pump.removeOnUse = false;
pump.salvage = true;
pump.points = 250;
pump.OnUse = primWepUse
pump.OnDrop = primDrop

local xm1014 = items.AddItem( "xm1014", "weapons", 6 )
xm1014.model = "models/weapons/w_shot_xm1014.mdl"
xm1014.name = "XM1014"
xm1014.ent = "weapon_autoshotgun"
xm1014.isPrimary = true;
xm1014.removeOnUse = false;
xm1014.salvage = true;
xm1014.points = 250;
xm1014.OnUse = primWepUse
xm1014.OnDrop = primDrop

local uzi = items.AddItem( "uzi", "weapons", 15 )
uzi.model = "models/weapons/w_smg_mac10.mdl"
uzi.name = "UZI"
uzi.ent = "weapon_mac10"
uzi.isSecondary = true;
uzi.removeOnUse = false;
uzi.salvage = true;
uzi.points = 175;
uzi.OnUse = secWepUse
uzi.OnDrop = secDrop

local mp5 = items.AddItem( "mp5", "weapons", 15 )
mp5.model = "models/weapons/w_smg_mp5.mdl"
mp5.name = "MP5"
mp5.ent = "weapon_mp5"
mp5.isPrimary = true;
mp5.removeOnUse = false;
mp5.salvage = true;
mp5.points = 175;
mp5.OnUse = primWepUse
mp5.OnDrop = primDrop

local tmp = items.AddItem( "tmp", "weapons", 15 )
tmp.model = "models/weapons/w_smg_tmp.mdl"
tmp.name = "TMP"
tmp.ent = "weapon_tmp"
tmp.isSecondary = true;
tmp.removeOnUse = false;
tmp.salvage = true;
tmp.points = 175;
tmp.OnUse = secWepUse
tmp.OnDrop = secDrop

local ump = items.AddItem( "ump", "weapons", 15 )
ump.model = "models/weapons/w_smg_ump45.mdl"
ump.name = "UMP"
ump.ent = "weapon_ump"
ump.isPrimary = true;
ump.removeOnUse = false;
ump.salvage = true;
ump.points = 175;
ump.OnUse = primWepUse
ump.OnDrop = primDrop

local para = items.AddItem( "para", "weapons", 2 )
para.model = "models/weapons/w_mach_m249para.mdl"
para.name = "M249"
para.ent = "weapon_para"
para.isPrimary = true;
para.removeOnUse = false;
para.salvage = true;
para.points = 800;
para.OnUse = primWepUse
para.OnDrop = primDrop

local awp = items.AddItem( "awp", "weapons", 1 )
awp.model = "models/weapons/w_snip_awp.mdl"
awp.name = "AWP"
awp.ent = "weapon_awp"
awp.isPrimary = true;
awp.removeOnUse = false;
awp.salvage = true;
awp.points = 1200;
awp.OnUse = primWepUse
awp.OnDrop = primDrop

local g3sg1 = items.AddItem( "g3sg1", "weapons", 1 )
g3sg1.model = "models/weapons/w_snip_g3sg1.mdl"
g3sg1.name = "g3sg1"
g3sg1.ent = "weapon_g3sg1"
g3sg1.isPrimary = true;
g3sg1.removeOnUse = false;
g3sg1.salvage = true;
g3sg1.points = 1200;
g3sg1.OnUse = primWepUse
g3sg1.OnDrop = primDrop

local sg552 = items.AddItem( "sg552", "weapons", 12 )
sg552.model = "models/weapons/w_rif_sg552.mdl"
sg552.name = "sg552"
sg552.ent = "weapon_sg552"
sg552.isPrimary = true;
sg552.removeOnUse = false;
sg552.salvage = true;
sg552.points = 250;
sg552.OnUse = primWepUse
sg552.OnDrop = primDrop

local p90 = items.AddItem( "p90", "weapons", 12 )
p90.model = "models/weapons/w_smg_p90.mdl"
p90.name = "p90"
p90.ent = "weapon_p90"
p90.isPrimary = true;
p90.removeOnUse = false;
p90.salvage = true;
p90.points = 250;
p90.OnUse = primWepUse
p90.OnDrop = primDrop


---------------------------------------------------------------
-- AMMUNITION ITEMS BELOW
---------------------------------------------------------------

local ammoUse = function( self, ply )

	ply:SetAmmo( ply:GetAmmoCount(items[self.item].ent) + self.count, items[self.item].ent )
	ply:SendLua("surface.PlaySound('items/ammo_pickup.wav')")

end

local pistolammo = items.AddItem( "pistolammo", "ammo", 30 )
pistolammo.model = "models/Items/357ammobox.mdl"
pistolammo.name = "Pistol ammo"
pistolammo.ent = "Pistol"
pistolammo.isAmmo = true;
pistolammo.OnUse = ammoUse

local smgammo = items.AddItem( "smgammo", "ammo", 30 )
smgammo.model = "models/Items/BoxSRounds.mdl"
smgammo.name = "SMG ammo"
smgammo.ent = "SMG1"
smgammo.isAmmo = true;
smgammo.OnUse = ammoUse

local shotammo = items.AddItem( "shotammo", "ammo", 10 )
shotammo.model = "models/Items/BoxBuckshot.mdl"
shotammo.name = "Shotgun ammo"
shotammo.ent = "Buckshot"
shotammo.isAmmo = true;
shotammo.OnUse = ammoUse

local rifleammo = items.AddItem( "rifleammo", "ammo", 25 )
rifleammo.model = "models/Items/BoxMRounds.mdl"
rifleammo.name = "Rifle ammo"
rifleammo.ent = "AR2"
rifleammo.isAmmo = true;
rifleammo.OnUse = ammoUse

local sniperammo = items.AddItem( "sniperammo", "ammo", 5 )
sniperammo.model = "models/Items/item_item_crate.mdl"
sniperammo.name = "Sniper ammo"
sniperammo.ent = "SniperRound"
sniperammo.isAmmo = true;
sniperammo.OnUse = ammoUse

items.ammoTranslations = setmetatable({
	['pistol'] = 'pistolammo',
	['smg1'] = 'smgammo',
	['buckshot'] = 'shotammo',
	['ar2'] = 'rifleammo',
	['sniperround'] = 'sniperammo'
}, {
	__index = function(tbl, key)
		return rawget(tbl, key) or rawget(tbl, key:lower())
	end
})

---------------------------------------------------------------
-- MISC ITEMS BELOW
---------------------------------------------------------------

local flight = items.AddItem( "flight", "misc", 100 )
flight.model = "models/props_c17/light_cagelight02_on.mdl"
flight.name = "Flashlight"
flight.maxCount = 1
flight.offset = Vector( 0, 0, 15 )
flight.OnPickup = function( self, ply )

	ply.itemVars["flashlight"] = true;

end
flight.OnDrop = function( self, ply )

	ply.itemVars["flashlight"] = false;
	if ply:FlashlightIsOn() then
		ply:Flashlight( false )
	end

end

local cade = items.AddItem( "cade", "misc", 40 )
cade.model = "models/props_junk/cardboard_box003a.mdl"
cade.name = "Barricade"
cade.maxCount = 1
cade.offset = Vector( 0, 0, 15 )
cade.OnUse = function( self, ply )
	if ply:InInnerSafezone() or ply:InOuterSafezone() then
		return
	else
		local tracedata,shootpos = {},ply:EyePos()

		tracedata.start = shootpos
		tracedata.endpos = shootpos+(ply:GetAimVector()*85)
		tracedata.filter = {ply}
		local trace = util.TraceLine(tracedata)

		local Bar = ents.Create("barricade")
		Bar:SetPos(trace.HitPos)
		Bar:SetAngles(Angle(0,ply:EyeAngles().y,0))
		Bar:Spawn()
		Bar:SetPos(Bar:GetPos()-Vector(0,0,14))
		Bar.OwnedUID = ply:UniqueID()
	end
end
