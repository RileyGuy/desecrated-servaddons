--  no arguments just passes the file itself
AddCSLuaFile()

if SERVER then 
	
	-- Include the chat commands
	local chatCmd = include("desecreated/modules/chatcommands.lua")
	
	function ToggleBuild( ply )
		
		ply.IsInBuild = not ply.IsInBuild
		ply:SetNWBool("IsInBuild",ply.IsInBuild)
		ply:Spawn()
		chat.AddText(team.GetColor(ply:Team()),ply:Nick().." has ".. (ply.IsInBuild and "enabled " or "disabled ") .."build mode.")
		
	end
	
	-- Prevent build mode players from taking or giving damage
	hook.Add("EntityTakeDamage","Test",function(target,dmginfo)
			
		attacker = dmginfo:GetAttacker()
		attOwner = attacker:CPPIGetOwner()
		if attOwner then
			return target.IsInBuild or attacker.IsInBuild or attOwner.IsInBuild
		else
			return target.IsInBuild or attacker.IsInBuild
		end
		
	end)

	chatCmd.AddCommand("build",ToggleBuild)	

end

-- Only allow players in build mode to noclip
-- Always allow admins to noclip
-- Shared for clientside prediction
hook.Add("PlayerNoClip","BuildRestrict",function(ply,ncstate)
		
	return ply:GetNWBool("IsInBuild") or ply:IsAdmin()
	
end)
