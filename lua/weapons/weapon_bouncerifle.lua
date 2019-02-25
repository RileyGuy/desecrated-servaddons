
SWEP.PrintName			= "Bounce Rifle"
SWEP.Author			= "doomtaters"
SWEP.Category			= "doomtaters"
SWEP.Instructions		= "point in general direction"

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.ViewModel			= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"

local ShootSound = Sound( "npc/strider/fire.wav" )

SWEP.MaxBounceCount = 6

--function bounceTrace( start, dir, len, max, filter, carryIn )

function SWEP:FireBeam( start, endPos )
	
end

function SWEP:PrimaryAttack()

	local traces = bounceTrace( self.Owner:EyePos(), self.Owner:EyeAngles():Forward(), 1e6, self.MaxBounceCount, {} )

	for k, v in pairs( traces ) do
		self:FireBeam( v.StartPos, v.HitPos )
		if v.Entity and v.Entity:Health() > 0 then
			--v.Entity:TakeDamageInfo(
			break
		end
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )

end

function SWEP:SecondaryAttack()

end
