
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

-- New fancy way
local rootDir = "addons/servaddons/lua/desecreated/"

-- Runs a function on each file in a directory
-- Directory is relative to garrysmod/
-- The function accepts a single argument, the file path
function callbackOnDirectoryFiles( dir, callback )
	local dirList, fileList = file.Find( dir, "MOD" )
	for k, v in pairs( fileList ) do
		-- file.Find returns local paths, so we must add the directory
		-- file.Find also doesn't care how many forward slashes you use, so I add one just in case
		callback( dir.."/"..v )
	end
end

callbackOnDirectoryFiles( rootDir.."server/", IncludeServer )
callbackOnDirectoryFiles( rootDir.."client/", IncludeClient )
callbackOnDirectoryFiles( rootDir.."shared/", IncludeShared )
