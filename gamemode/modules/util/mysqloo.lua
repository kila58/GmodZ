require( "mysqloo" )

sqloo = nil;
local db = mysqloo.connect( "23.29.125.100", "ggserv", "asdf1234", "ggserv", 3306 )
local dumpTables = false;
local createTables = false;

function db:onConnected()

    sqloo = self;
 
	-- Drop the tables if asked.
	if dumpTables then
		
		local q = self:query( "DROP TABLE players;" )
		
		function q:onSuccess( data )
			print( "Successfully dropped the 'players' table." )
		end
		function q:onError( err, sql )
			print( "Couldn't drop table 'players' from the Database. It might not exists." )
		end
		q:start()
		
		-- Drop the inventories table if asked.
		local q = self:query( "DROP TABLE inventories;" )
		
		function q:onSuccess( data )
			print( "Successfully dropped the 'inventories' table." )
		end
		function q:onError( err, sql )
			print( "Couldn't drop table 'inventories' from the Database. It might not exists." )
		end
		q:start()
		
	end
	
	-- Create the tables.
	if createTables then
	
		local q = self:query( "CREATE TABLE players( uid int PRIMARY KEY NOT NULL, health float, thirst float, hunger float );" );
		
		function q:onSuccess( data )
			print( "Successfully created the 'players' table." );
		end
		function q:onError( err, sql )
			print( "Error: ", err );
		end
		q:start()
		
		local q = self:query( "CREATE TABLE inventories( uid int, item int, slot int );" );
		
		function q:onSuccess( data )
			print( "Successfully created the 'inventories' table." );
		end
		function q:onError( err, sql )
			print( "Error: ", err );
		end
		q:start()
 
	end
 
end
 
function db:onConnectionFailed( err )
 
    print( "Connection to database failed!" )
    print( "Error:", err )
 
end
 
db:connect()