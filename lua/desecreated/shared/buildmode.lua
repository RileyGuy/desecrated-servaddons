--  no arguments just passes the file itself
AddCSLuaFile()

if SERVER then 
	
	include( "desecreated/server/epicchatcommands.lua" )
	
	function ToggleBuild( ply )
		
		ply.IsInBuild = not ply.IsInBuild
		ply:SetNWBool("IsInBuild",ply.IsInBuild)
		ply:Spawn()
		chat.AddText(team.GetColor(ply:Team()),ply:Nick(),Color(255,255,255,255)," has "..(ply.IsInBuild and "enabled " or "disabled ") .."build mode.")
		
	end
	
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

-- Shared for clientside prediction
hook.Add("PlayerNoClip","BuildRestrict",function(ply,ncstate)
		
	return ply:GetNWBool("IsInBuild") or ply:IsAdmin()
	
end)
