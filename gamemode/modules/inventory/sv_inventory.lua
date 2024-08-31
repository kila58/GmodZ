-- Functions in this file are related to the inventories.

-- THIS IS UGLY, I AM SORRY I WAS TIRED WHEN I FIRST MADE IT.
-- BUT IT WORKS!

util.AddNetworkString("AskDropItem")
util.AddNetworkString("AskUseItem")
util.AddNetworkString("AskPickupItemInv")

local Ply = FindMetaTable("Player")

-- This function creates a new inventory
function CreateInventory( size )

	-- If there's no inventory, create one.
	if !inv then inv = {} end

	local id = math.Round( math.Rand( 0, 3000 ))
	while inv[id] do
		id = math.Round( math.Rand( 0, 3000 ))
	end

	local i = 1
	size = size or 20;
	inv[id] = {}

	-- Setup the inventory.
	for i = 1, size, 1 do
		inv[id][i] = {}
		inv[id][i].item = "none"
		inv[id][i].count = 0
	end

	inv[id].weapon = 0;
	inv[id].melee = 0;

	return id;

end

-- This function loops through players and saves them.
function SaveAllInventories()

	-- Loop da hoop!
	for _,pl in pairs(player.GetAll()) do

		pl:SaveInventory()

	end

end

-- This function deletes an inventory from the inventory table.
function DeleteInventory( id )

	if !inv then return end

	inv[id] = nil

end

-- This function drops an inventory to the ground.
function DropInventory( id, pos )

	if !inv then return end
	if !inv[id] then return end

	local ent = ents.Create( "gmodz_inv" )
	ent:SetPos( pos );
	ent:Spawn();
	ent.inv = id;

	for _,v in pairs(player.GetAll()) do
		SendEntInvInfo( ent, v );
	end

end

-- This function adds an item to in the inventory. If slot is entered and empty, it'll add the item to this slot.
function InventoryAddItem( id, item, count, slot )

	if !inv[id] then
		print( "Inventory [" .. id .. "] doesn't exists." )
		return 0
	end

	local slot = HasItem( id, item )

	if slot > 0 then
		inv[id][slot].count = inv[id][slot].count + count;
		return slot;
	end

	-- Check each item.
	for k,v in pairs(inv[id]) do

		if type(v) != "table" then break end

		if v.item == "none" then
			print("Adding item: " .. item .. " to inventory " .. id)
			v.item = item
			v.count = count or 1
			return k
		end

	end

	return 0

end

-- This function removes an item from the inventory.
function InventoryRemoveItem( id, slot, count, ply )

	if !inv[id] then return end

	count = count or 1;

	if inv[id][slot].count <= count then
		if ply then
			items[inv[ply.inventory][slot].item].OnDrop( inv[ply.inventory][slot], ply )
		end
		inv[id][slot].item = "none"
		inv[id][slot].count = 0
	else
		inv[id][slot].count = inv[id][slot].count - count
	end

end

-- Function to check if an inventory is full. True if full, false if not.
function InventoryFull( id )

	if !inv[id] then return true end

	for k, v in pairs( inv[id] ) do

		if type(v) == "table" then
			if v.item == "none" then return false end
		end

	end

	return true

end

-- This function check if there's an item in the given inventory.
-- Returns the slot of the item.
function HasItem( id, item )

	if !inv[id] then return 0 end

	for k,v in pairs( inv[id] ) do

		if k != "weapon" and k != "melee" then
			if v.item == item then
				return k
			end
		end

	end

	return 0

end

-- This function returns true or false if the inventory has an item in the slot.
function HasItemInSlot( id, slot )

	if !inv[id] then return end

	if inv[id][slot] and inv[id][slot].item != "none" then
		return true;
	end

	return false;

end

-- Returns the first empty slot of the inventory.
function GetInvEmptySlot( id )

	-- Check if slot is valid.
	if !inv[id] then
		print( "Inventory [" .. id .. "] doesn't exists." )
		return 0
	end

	-- Do stuff yoyo.
	for k,v in pairs(inv[id]) do

		if type(v) == "table" then
			if v.item == "none" then
				return k
			end
		end

	end

	-- If no there was no empty slots, return 0.
	return 0

end

-- Add an inventory to a player.
-- return: The Inventory ID
function Ply:AddInventory( size )

	if self.inventory then
		DeleteInventory( self.inventory )
	end

	-- Create an inventory for the player.
	self.inventory = CreateInventory( size )
	self:SendInventory()

	return self.inventory

end

-- Add a bank inventory to the player.
-- return: The Inventory ID
function Ply:AddBankInventory( size )

	if self.bankInv then
		DeleteInventory( self.bankInv )
	end

	self.bankInv = CreateInventory( size )
	self:SendBank()

	return self.bankInv

end

-- Use the selected item.
function Ply:UseItem( slot )

	-- If there's no inventory.
	if !self.inventory or self.inventory == 0 then return end

	local item = items[inv[self.inventory][slot].item]

	-- Check if true is returned, if it is, delete the item.
	item.OnUse( inv[self.inventory][slot], self )

	if item.isAmmo then
		self:RemoveItem( slot, inv[self.inventory][slot].count )
		self:SendItem( slot );
	elseif item.removeOnUse then
		self:RemoveItem( slot, 1 )
		self:SendItem( slot );
	end

end

-- This function removes an from the player.
function Ply:RemoveItem( slot, count )

	if !self.inventory or self.inventory == 0 or !self or !self:Alive() then return end

	count = count or 1;

	InventoryRemoveItem( self.inventory, slot, count, self );

end

-- This function gives the player an item.
function Ply:AddItem( item, count )

	count = count or 1

	-- If there's no inventory.
	if !self.inventory or self.inventory == 0 or !self or !self:Alive() then return false end

	local slot = HasItem( self.inventory, item )
	local doPickup = false;

	-- If there is already an item, add to its count, else add a new one and do the "OnPickup" action.
	if slot and slot > 0 then
		inv[self.inventory][slot].count = inv[self.inventory][slot].count + count
	else
		slot = InventoryAddItem( self.inventory, item, count );
		doPickup = true;
	end

	if slot and slot > 0 then

		if doPickup then items[item].OnPickup( inv[self.inventory][slot], self ) end
		self:SendItem( slot )
		return true

	else
		return false
	end

end

-- Drops the inventory at the player's feets.
function Ply:DropInventory()

	print(self.inventory)
	if !self.inventory then return end

	local pos = self:GetPos()

	-- Trace to check where it hits.
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos - Vector( 0, 0, 400 );
	tracedata.filter = player.GetAll();
	tracedata.mask = MASK_PLAYERSOLID
	local trace = util.TraceLine(tracedata)
	if trace.Hit then
	   pos = trace.HitPos
	end

	DropInventory( self.inventory, pos )
	self.inventory = 0;
	self:SendInventory()

end

-- This function drops the item at the selected slot.
function Ply:DropItem( slot, count )

	if !self.inventory or self.inventory == 0 then return end

	local item = inv[self.inventory][slot].item
	local itemCount = inv[self.inventory][slot].count
	count = count or itemCount

	if count <= 0 then count = 1 end
	if count > itemCount then count = itemCount end

	-- This drops an item if there's one.
	items[item].OnDrop( inv[self.inventory][slot], self )
	items.SpawnItem( item, self:GetPos(), count )

	inv[self.inventory][slot].count = inv[self.inventory][slot].count - count

	if inv[self.inventory][slot].count == 0 then
		inv[self.inventory][slot].item = "none"
	end

	self:SendItem( slot )

end

-- This function asks for the inventory of the player.
net.Receive( "ply_ask_inventory", function( len, ply )
	ply:SendInventory()
end)

-- This function asks for the inventory of the player.
local function AskDropItem(length,pl)
	local id = net.ReadUInt(16)
	local count = net.ReadUInt(32)
	if HasItemInSlot(pl.inventory,id) then
		pl:DropItem(id,math.Round(count))
	end
end
net.Receive("AskDropItem",AskDropItem)

-- This function asks to use an item.
local function AskUseItem(length,pl)
	local id = net.ReadUInt(16)
	if HasItemInSlot(pl.inventory,id) then
		pl:UseItem(id)
	end
end
net.Receive("AskUseItem",AskUseItem)

-- This function asks to pickup an item from an inventory.
local function AskPickupItemInv(length,pl)
	local slot = net.ReadUInt(16)
	local id = net.ReadUInt(16)
	if HasItemInSlot(slot,id) then
		pl:AddItem(inv[slot][id].item,inv[slot][id].count)
		InventoryRemoveItem(slot,id,inv[slot][id].count)
		for k,v in pairs(player.GetAll()) do
			v:SendInvInfo(slot)
		end
	end
end
net.Receive("AskPickupItemInv",AskPickupItemInv)

-- This function sends the information of the entity.
function Ply:SendInvInfo( i, info )

	if !i or !inv[i] then return end

	net.Start( "inv_receive_info" )
		net.WriteFloat( i )
		net.WriteTable( inv[i] )
		net.WriteFloat( info or 0 ) -- Inventory type.
	net.Send( self )

end

-- This function attempts to get the iventory of a player.
-- returns true if it does and false if it fails.
function Ply:GetInventory()

	local fn = "gmodz/ply_" .. self:UniqueID() .. ".txt"
	-- Check if the list of entities to place on the current map is there.
	if file.Exists( fn, "data" ) then
		local fr = file.Read( fn );

		local t = util.JSONToTable( fr )

		self:SetHealth( t.hp or 100 )
		self:SetThirst( t.thirst or 100 )
		self:SetHunger( t.hunger or 100 )
		self:SetPos( t.pos )

		-- Give ammunitions
		for kind,count in pairs(t.ammunitions) do

			self:GiveAmmo( count, kind )

		end

		-- Get the inventory again.
		if t.inv then
			self:AddInventory( 20 )
			inv[self.inventory] = t.inv
			for k,v in pairs(inv[self.inventory]) do

				if type(v) == "table" and v.item != "none" then
					items[v.item].OnPickup( k, self )
				end

			end
			self:SendInventory()
		else
			self:AddInventory( 20 )
			self:AddItem( "soda" )
			self:AddItem( "banana" )
			self:AddItem( "painkillers" )
		end

		return true
	else
		self:AddInventory( 20 )
		self:AddItem( "soda" )
		self:AddItem( "banana" )
		self:AddItem( "painkillers" )

		return false
	end

end

-- This function attempts to get the iventory of a player.
-- returns true if it does and false if it fails.
function Ply:GetBank()

	local fn = "gmodz_banks/bank_" .. self:UniqueID() .. ".txt"
	-- Check if the list of entities to place on the current map is there.
	if file.Exists( fn, "data" ) then
		local fr = file.Read( fn );

		local t = util.JSONToTable( fr )

		-- Get the inventory again.
		if t.bank and self:GetUserGroup() == "donator" then
			self:AddBankInventory( 20 )
			inv[self.bankInv] = t.bank
			self:SendBank()
		elseif t.bank then
		    self:AddBankInventory( 15 )
			inv[self.bankInv] = t.bank
			self:SendBank()
		else
			self:AddBankInventory( 15 )
		end

		return true
	else
		self:AddBankInventory( 15 )
		return false
	end

end

-- This function attempts to save the player's actual inventory.
function Ply:SaveInventory()

	-- Setup the save table.
	local t = {}

	t.hp 			= self:Health()
	t.thirst 		= self:Thirst()
	t.hunger		= self:Hunger()
	t.pos			= self:GetPos()

	t.ammunitions	= { Pistol 		= self:GetAmmoCount( "Pistol" ),
						SMG1 		= self:GetAmmoCount( "SMG1" ),
						AR2			= self:GetAmmoCount( "AR2" ),
						Buckshot	= self:GetAmmoCount( "Buckshot" ),
						SniperRound = self:GetAmmoCount( "SniperRound" )
					}

	t.inv			= inv[self.inventory] or nil

	-- Check if directory exists.
	if (not file.IsDir("gmodz", "data")) then
		file.CreateDir("gmodz")
	end

	local fn = "gmodz/ply_" .. self:UniqueID() .. ".txt"
	file.Write( fn, util.TableToJSON( t ))

end

-- This function saves the player's bank.
function Ply:SaveBank()

	-- Setup the save table.
	if !self.bankInv then return end
	local t = {}

	t.bank			= inv[self.bankInv] or nil

	-- Check if directory exists.
	if (not file.IsDir("gmodz_banks", "data")) then
		file.CreateDir("gmodz_banks")
	end

	local fn = "gmodz_banks/bank_" .. self:UniqueID() .. ".txt"
	file.Write( fn, util.TableToJSON( t ))

end

-- This function sends the inventory information to the player.
function Ply:SendInventory()

	local toSend = inv[self.inventory]

	if self.inventory <= 0 then
		toSend = {}
	end
	net.Start( "ply_receive_inventory" )
		net.WriteTable( toSend )
	net.Send( self )

end

-- This function sends the bank to the player.
function Ply:SendBank()

	if !self.bankInv then return end

	self:SendInvInfo( self.bankInv, 1 )

end

-- This function sends the inventory information to the player.
function Ply:SendItem( slot )

	slot = tonumber(slot)

	if self.inventory > 0 then
		net.Start( "ply_receive_item" )
			net.WriteInt( slot, 8 )
			net.WriteFloat( inv[self.inventory][slot].count )
			net.WriteString( inv[self.inventory][slot].item )
		net.Send( self )
	end

end

-- This function asks to transfer an item to the inventory.
function TransferToInv( slot, from, to )

	if !slot or !from or !to then return false end
	if not HasItemInSlot( from, slot ) then return false end
	if InventoryFull( to ) then return false end

	local newSlot = InventoryAddItem( to, inv[from][slot].item, inv[from][slot].count );
	InventoryRemoveItem( from, slot, inv[from][slot].count );

	if newSlot > 0 then
		return true
	else
		return false
	end

end

-- This function transfer an item from the inventory to the bank.
function Ply:TransferToBank( slot )

	if !slot then return end
	if !inv[self.inventory] or !inv[self.bankInv] then return end

	items[inv[self.inventory][slot].item].OnDrop( inv[self.inventory][slot], self )

	if TransferToInv( slot, self.inventory, self.bankInv ) then
		self:SendInventory()
		self:SendBank()
		self:SaveInventory()
		self:SaveBank()
	end

end

-- This function transfer an item from the inventory to the bank.
function Ply:TransferToInv( slot )

	if !slot then return end
	if !inv[self.inventory] or !inv[self.bankInv] then return end

	if TransferToInv( slot, self.bankInv, self.inventory ) then
		self:SendInventory()
		self:SendBank()
		self:SaveInventory()
		self:SaveBank()
	end

end

-- Check if the player can buy an item.
function Ply:BuyItem( item, count, price )

	if !items[item] then return end
	price = price or 0

	local slot = HasItem( self.inventory, item )

	if slot == 0 then slot = GetInvEmptySlot( self.inventory ) end
	if slot == 0 then return end

	if self:GetMoney() < price then
		return
	else
		self:AddMoney( -price )
		self:AddItem( item, count );
		self:SaveInventory()
	end

end

-- Check if the player can salvage an item.
function Ply:SalvageItem( slot )

	if !self:InInnerSafezone() then return end
	if !self.inventory then return end
	if slot == 0 then return end

	local item = inv[self.inventory][slot].item

	if !item or item == "none" then
		return
	elseif items[item].salvage == false then
		return
	else
		self:RemoveItem( slot, 1 )
		self:SendInventory()
		self:SaveInventory()
		self:AddMoney( items[item].points or 20 )
	end

end

net.Receive( "buy_bundle", function( len, ply )

	local bundle = net.ReadFloat()

	if bundle == 0 then return end
	ply:BuyItem( BundleItem( bundle ), BundleCount( bundle ), BundlePrice( bundle ) )

end)

net.Receive( "buy_bundle_vip", function( len, ply )

	local bundle = net.ReadFloat()

	if bundle == 0 then return end
	ply:BuyItem( BundleItem_vip( bundle ), BundleCount_vip( bundle ), BundlePrice_vip( bundle ) )

end)

-- This function receives the call for the player to transfer to the bank.
net.Receive( "ply_ask_movebank", function( len, ply )

	local slot = net.ReadFloat()

	if ply:InInnerSafezone() then
		ply:TransferToBank( slot )
	end

end)

-- This function receives the call for the player to transfer to the bank.
net.Receive( "ply_ask_moveinv", function( len, ply )

	local slot = net.ReadFloat()

	if ply:InInnerSafezone() then
		ply:TransferToInv( slot )
	end

end)

net.Receive( "ply_salvage", function( len, ply )

	local slot = net.ReadFloat()

	if slot and ply:InInnerSafezone() then
		ply:SalvageItem( slot )
	end

end)

function saveINV()
	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
			v:SaveInventory()
			--if v:IsAdmin() then
			--v:ChatPrint( "Saved everyones data." )
		end
	end
end
timer.Create("saveINV", 30, 0, saveINV)