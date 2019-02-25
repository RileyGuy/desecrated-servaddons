
-- Functions to make life easier
function IncludeServer( fileName )
	include( fileName )
	print( "SERVER: included file "..fileName )
end

function IncludeClient( fileName )
	AddCSLuaFile( fileName )
	print( "CLIENT: included file "..fileName )
end

function IncludeShared( fileName )
	IncludeClient( fileName )
	IncludeServer( fileName )
end

--IncludeServer( "desecreated/server/epicchatcommands.lua" )
--IncludeServer( "desecreated/server/luadevcmds.lua" )
--
--IncludeShared( "desecreated/shared/buildmode.lua" )
--IncludeShared( "desecreated/shared/starfallownertraces.lua" )

-- Runs a function on each file in a directory
-- Directory is relative to garrysmod/
-- The function accepts a single argument, the file path
function callbackOnDirectoryFiles( dir, callback )
	local fileList, dirList = file.Find( dir .. "*" , "LUA" )
	for k, v in pairs( fileList ) do
		-- file.Find returns local paths, so we must add the directory
		callback( dir .. v )
	end
end

callbackOnDirectoryFiles( "desecreated/server/", IncludeServer )
callbackOnDirectoryFiles( "desecreated/client/", IncludeClient )
callbackOnDirectoryFiles( "desecreated/shared/", IncludeShared )
