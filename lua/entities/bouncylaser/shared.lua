AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Bouncing Laser"
ENT.Category = "doomtaters"
ENT.Author = "doomtaters"

ENT.Spawnable = true

function bounceTrace( start, dir, len, max, filter, carryIn )

	if max <= 0 then return end
	
	carryIn = carryIn or {}

	local traceData = {
		start = start,
		endpos = start+dir*len,
		filter = filter,
		mask = MASK_SOLID
	}

	local trace = util.TraceLine( traceData )
	table.insert( carryIn, trace )
	
	if trace.Hit and max > 1 then
		local reflect = trace.Normal - 2*trace.HitNormal*trace.HitNormal:Dot(trace.Normal)
		return bounceTrace( trace.HitPos, reflect, len, max-1, filter, carryIn )
	else
		return carryIn
	end
end

local bounceCount = 16

if SERVER then

	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if not phys:IsValid() then
			phys:Wake()
		end
	end

else

	function ENT:Draw()
		self:DrawModel()
		local traces = bounceTrace( self:GetPos(), self:GetUp(), 1024, bounceCount, {self} )
		for k, trace in pairs(traces) do
			local col = HSVToColor( 240+(k/bounceCount)*120,1,1)
			render.DrawLine( trace.StartPos, trace.HitPos, col, true )
		end
	end
end
