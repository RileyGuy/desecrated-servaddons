-- Have a descriptive network string identifier
local networkStringName = "UpdateStarfallDrawOwnerLinesHook"

if SERVER then
	
	util.AddNetworkString( networkStringName )
	
	-- Don't override previous state if possible
	starfallTracerCommandStates = starfallTracerCommandStates or {}
	
	-- I want a descriptive global variable, but its a bit too verbose to use comfortably in code
	local t = starfallTracerCommandStates
	
	-- Make sure chat commands are loaded
	assert( chatCmd, "How did this run before chat commands?" )
	
	chatCmd.AddCommand( "sffinder", function( sender, args, isHidden )
		
		-- Index by steamID to avoid collisions and stuuff
		local id = sendr:SteamID()
		
		-- Toggle the state
		t[id] = not t[id]
		
		-- Send the new state
		net.Start( networkStringName )
		net.WriteBool( t[id] )
		net.Send( sender )
		
		-- Announce the command usage if not using the hidden suffix
		if not isHidden then
			chat.AddText( team.GetColor(sender:Team()), sender:Nick(), Color(0,255,144), " "..(t[id] and "activated" or "deactivated") .." starfall owner line traces!" )
		end
		
	end )
	
else
	
	local hookName = "DrawStarfallOwnerLines"
	
	-- Handle updates on the state of the command's activation
	net.Receive( networkStringName, function()
		
		local newState = net.ReadBool()
		
		-- Add the render hook if we have recieved a true state update, remove it if a false state update
		if newState then
			
			hook.Add( "PostDrawOpaqueRenderables", hookName, function()
				
				local thisPly = LocalPlayer()
				
				-- Make sure we can actually use a get owner function, if not just give up immediately
				if not pcall( thisPly.CPPIGetOwner, thisPly ) then
					hook.Remove( "PostDrawOpaqueRenderables", hookName )
				end
				
				for k, v in pairs( ents.FindByClass( "starfall_processor" ) ) do
					-- This relies on us having a prop protection addon, so make sure we have the function
					local owner = v:CPPIGetOwner()
					render.DrawLine( v:GetPos(), owner:GetPos(), HSVToColor( util.CRC(owner:SteamID()) % 360, 1, 1 ), false )
				end
				
			end )
			
		else
			
			-- Remove the hook if disabling
			hook.Remove( "PostDrawOpaqueRenderables", hookName )
			
		end
		
	end )
	
end