AddCSLuaFile()
local math = _G.math

function math.sign(num)  
	if num > 0 then
		num = 1
	elseif num < 0 then
		num = -1
	else 
		num = 0
	end

	return num
end


math.deg2Rad = math.pi / 180
math.rad2Deg = 180 / math.pi
math.epsilon = 1.401298e-45

include("topameng_quaternions.lua")
include("topameng_vector3.lua")


local AngMeta = FindMetaTable("Angle")


function AngMeta:ToQuat()
	return Quaternion.New():SetEuler(self.p,self.y,self.r)
end

function Quaternion:ToAng()
	local Ang = self:ToEulerAngles()
	return Angle(Ang.x,Ang.y,Ang.z)
end