
--AddCSLuaFile()

if SERVER then
	
	util.AddNetworkString("chatadddesecrated")
	
	chat={}
	
	function chat.AddText(...)
		
	local args={...}
	
	if type(args[1])=="Player" then ply=args[1] else ply=player.GetAll() end
					
		net.Start("chatadddesecrated")
		net.WriteInt(#args,8)
					
		for k,v in pairs(args) do
			if type(v)=="string" then
				net.WriteData(util.Compress(v),128)
			elseif type(v)=="table" then
				net.WriteInt(v.r,9)
				net.WriteInt(v.g,9)
				net.WriteInt(v.b,9)
			end
		end
		
		net.Send(ply)
		
	end

else

	net.Receive("chatadddesecrated",function(len,ply)
		local argslen=net.ReadInt(8)
		local args={}
		for I=1,argslen/2,1 do
			table.insert(args,Color(net.ReadInt(9),net.ReadInt(9),net.ReadInt(9)))
			table.insert(args,util.Decompress(net.ReadData(128)))
		end
		chat.AddText(unpack(args))
	end)

end

--By KAPTAIN KRUNCH, actually I just converted a usermessage script from facepunch to net so yeah. Nothing special.
