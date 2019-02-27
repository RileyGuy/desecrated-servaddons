--[[

	chatCmd will be a global library like math or http or ents
	although it is a global library, it is suggested to use the module-style method of including this module in every script that uses it

	made by the hivemind

]]

-- Include guard to ensure that this module is only ever loaded once
if not chatCmd then

	-- chatCmd top level and commands tables
	chatCmd = {}
	chatCmd.commands = {}

	-- Variables used to determine commands
	-- These were changed to be part of chatCmd to allow for them to be modified after instantiation
	chatCmd.prefix = "!"
	chatCmd.privatePrefix = "."

	-- Parse the text sent by a player
	function chatCmd.Parse( sender, text, teamchat )

		-- Checking if the player is valid may not be necessary serverside
		if not ( sender and sender:IsValid() ) then return end

		-- Check if the first character matches any of the two desired prefixes
		local prefix = text:sub( 1, 1 ) == chatCmd.prefix
		local privatePrefix = text:sub( 1, 1 ) == chatCmd.privatePrefix

		if not ( prefix or privatePrefix ) then return end
		--if not string.match( text:sub( 1, 1 ), "[" .. chatCmd.prefix .. chatCmd.privatePrefix .. "]" ) then return end

		-- Get and split the rest of the message
		local args = string.Explode( " ", text:sub( 2 ) )
		local cmd = table.remove( args, 1 )

		-- Check if the command exists
		if not chatCmd.commands[ cmd ] then return end

		-- Get the callback function and the hideChat boolean.
		local callback, isPrivate = unpack( chatCmd.commands[ cmd ] )

		-- Execute the callback function
		callback( sender, args, privatePrefix )

		-- Hide the message parsed if required
		if isPrivate or privatePrefix then return "" end

	end

	-- Add a new command, hideChat defaults to false
	function chatCmd.AddCommand( name, callback, isPrivate )

		-- hideChat defaults to true if no value is entered
		if isPrivate == nil then isPrivate = true end

		-- Ensure that all parameters are of the correct type
		assert( type( name ) == "string", "Attempted to register non-string command name '" .. tostring( name ) .. "'" )
		assert( type( callback ) == "function", "Attempted to register non-function callback '" .. tostring( callback ) .. "'" )
		assert( type( isPrivate ) == "boolean", "Attempted to register non-boolean value '" .. tostring( isPrivate ) .. "'" )

		-- Insert a table at the desired index to represent a command
		chatCmd.commands[ name ] = { callback, isPrivate }

	end

	-- Remove an existing command
	function chatCmd.RemoveCommand( name )

		-- Ensure that all parameters are of the correct type
		assert( type( name ) == "string", "Attempted to delete command using non-string command name '" .. tostring( name ) .. "'" )

		-- Set the desired index to nil in order to 'delete' the existing command
		chatCmd.commands[ name ] = nil

	end

	-- Add the Parse function to the PlayerSay hook
	hook.Add( "PlayerSay", "CaptureChatCommands", chatCmd.Parse )

end


-- Return this module
return chatCmd
