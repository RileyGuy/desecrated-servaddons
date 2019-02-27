-- Import the chatCmd module
-- This will overwrite the global chatCmd variable as a local reference
-- This will also make sure that chatCmd is loaded no matter what
local chatCmd = include("desecreated/server/epicchatcommands.lua")

-- Gets a player's team color
local function PlayerTeamColor( ply )

	return team.GetColor(ply:Team())

end

local function RunServer( ply, args, isPrivate )

	-- Check if the player is an administrator
	if ply:IsAdmin() then

		-- Generate a scriptlet from the supplied arguments
		local scriptlet = table.concat( args, " " )

		-- Display the scriptlet
		if not isPrivate then
			chat.AddText(PlayerTeamColor(ply), ply:Nick(), Color(255,107,97), "@SERVER: ", Color(0, 255, 144), scriptlet )
		end

		-- Execute the scriptlet
		easylua.RunLua( ply, scriptlet )

	else

		-- Kill unauthorized users attempted to use this command
		ply:Fizzle()

	end

end

-- Create a chat command using the chatCmd library
chatCmd.AddCommand( "l", RunServer )

chatCmd.AddCommand( "cmd", function( ply, args, isPrivate )

	-- Admin only command
	if ply:IsAdmin() then

		-- Run the command with all the provided arguments
		-- The first arg will always be the command
		RunConsoleCommand(unpack(args)) 

		if not isPrivate then
			-- Print the command to chat
			chat.AddText(PlayerTeamColor(ply), ply:Nick(), Color(255,107,97), "@RCON: ", Color(0,255,144), table.concat( args, " " ) ) 
		end

	else

		-- Kill unauthorized players trying to use this
		ply:Fizzle()

	end

end )


local function RunClient(ply,args,isPrivate)
	local scriptlet = table.concat(args," ")
	
	if not isPrivate then
		--Print the command to chat.
		chat.AddText(team.GetColor(ply:Team()), ply:Nick(), Color(0,161,255), "@SELF: ", Color(0, 255, 144), scriptlet )
	end
	
	--Do some weird stuff that I don't understand. -Cyro
	local function X(ply,i) return luadev.GetPlayerIdentifier(ply,'cmd:'..i) end
	
	--Run the scriptlet on the client who ran the command.
	luadev.RunOnClient(scriptlet,ply,X(ply,"lm"),{ply=ply})

end

chatCmd.AddCommand( "lm", RunClient, true )

