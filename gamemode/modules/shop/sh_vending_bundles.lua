-- BUNDLE ITEMS to be sold in the vending machine.
--
-- { item, count, price }

BUNDLES = {

			{"soda", 25, 500},
			{"banana", 25, 500},
			{"painkillers", 10, 1000},
			{"fuel", 1, 100},
			{"cade", 1, 1000},
			{"pistolammo", 30, 1000},
			{"shotammo", 32, 1500},
			{"smgammo", 50, 1800},
			{"rifleammo", 50, 2600},
			{"sniperammo", 25, 3000},
			{"uzi", 1, 2000},
			{"pump", 1, 2000},
			{"deagle", 1, 4000},
			{"scout", 1, 5000},
			{"awp", 1, 25000}

		}

BUNDLES_VIP = {

			{"soda", 25, 250},
			{"banana", 25, 250},
			{"painkillers", 10, 500},
			{"pistolammo", 30, 500},
			{"shotammo", 32, 750},
			{"smgammo", 50, 900},
			{"rifleammo", 50, 1300},
			{"sniperammo", 25, 1500},
			{"uzi", 1, 500},
			{"pump", 1, 500},
			{"deagle", 1, 1000},
			{"scout", 1, 1250},
			{"awp", 1, 12500}

		}

function BundleItem( id )
	return BUNDLES[id][1]
end

function BundleCount( id )
	return BUNDLES[id][2]
end

function BundlePrice( id )
	return BUNDLES[id][3]
end

function BundleItem_vip( id )
	return BUNDLES_VIP[id][1]
end

function BundleCount_vip( id )
	return BUNDLES_VIP[id][2]
end

function BundlePrice_vip( id )
	return BUNDLES_VIP[id][3]
end
