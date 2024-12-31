-- SCP-1025, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2024  MrMarrant aka BIBI.
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(REAL_TOILET_CONFIG.Models.Toilet)
	self:InitVar()
	self:RebuildPhysics()
	timer.Simple(0.5, function()
		if (not IsValid(self)) then return end

		self:ResetSequence(2)
		self:EmitSound(REAL_TOILET_CONFIG.Sounds.Open, 75, math.random(90, 110))
	end)
end

-- Initialise the physic of the entity
function ENT:RebuildPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

-- Use specially for the physics sounds
function ENT:PhysicsCollide(data, physobj)
	if data.DeltaTime > 0.2 then
		if data.Speed > 250 then
			self:EmitSound("physics/plastic/plastic_box_impact_hard" .. math.random(1, 4) .. ".wav", 75, math.random( 100, 110 ))
		else
			self:EmitSound("physics/plastic/plastic_box_impact_soft" .. math.random(1, 4) .. ".wav", 75, math.random( 100, 110 ))
		end
	end
end

function ENT:Use(ply)
	if (not IsValid(ply)) then return end
	if (not ply:IsPlayer()) then return end
	if (IsValid(self:GetSeat())) then return end
	if (self:GetPaperAvailable() <= 0) then ply:ChatPrint(real_toilet.GetTranslation("no_paper")) return end

	if (self:GetIsFull() and not self:GetIsFlushed()) then
		self:SetIsFlushed(true)
		self:ResetSequence(4)
		self:EmitSound(REAL_TOILET_CONFIG.Sounds.Flush, 75, math.random(90, 110))
		timer.Create("ToiletFlush." .. self:EntIndex(), self:SequenceDuration() + 1, 1, function()
			if (not IsValid(self)) then return end

			self:SetIsFull(false)
			self:SetIsFlushed(false)
			if (self:GetPaperAvailable() >= 0) then
				self:ResetSequence(2)
				self:EmitSound(REAL_TOILET_CONFIG.Sounds.Open, 75, math.random(90, 110))
			end
		end)
	elseif ((ply:GetPoopValue() <= REAL_TOILET_CONFIG.Settings.MinPoopToilet or not GetConVar("PoopMeterEnabled"):GetBool()) and not self:GetIsFull()) then
		self:CreateSeat(ply)
		self:SetHasPoop(false)
		ply:SetPoopValue(100)
		timer.Create("ToiletPoop." .. ply:EntIndex(), REAL_TOILET_CONFIG.Settings.PoopTime, 1, function()
			if (not IsValid(ply)) then return end

			if (math.random(1, 500) == 1) then
				self:EmitSound(REAL_TOILET_CONFIG.Sounds.PS1)
			else
				self:EmitSound(REAL_TOILET_CONFIG.Sounds.Poop, 150, math.random(90, 110))
			end
			self:SetHasPoop(true)
			if (ply._ToiletOldWalkSpeed or ply._ToiletOldRunSpeed) then
				ply:SetWalkSpeed(ply._ToiletOldWalkSpeed)
				ply:SetRunSpeed(ply._ToiletOldRunSpeed)
				ply._ToiletOldWalkSpeed = nil
				ply._ToiletOldRunSpeed = nil
			end
		end)
	end
end

function ENT:CreateSeat(ply)
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	if not IsValid(seat) then return end

	seat:SetModel("models/nova/airboat_seat.mdl")
	seat:SetNoDraw(true)
	seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	seat:SetPos(self:GetPos() + Vector(1, 0, 23))
	seat:SetAngles(self:GetAngles() + Angle(0, -90, 0))
	seat:Spawn()
	seat:Activate()

	seat:SetMoveType(MOVETYPE_NONE)
	seat:SetParent(self)

	ply:EnterVehicle(seat)
	ply._ToiletSeat = self
	self:SetSeat(seat)
end

-- Intialise every var related to the entity
function ENT:InitVar( )
	self:SetIsFull(false)
	self:SetPaperAvailable(REAL_TOILET_CONFIG.Settings.PaperToiletCount)
	self:SetSeat(nil)
	self:SetHasPoop(false)
	self:SetIsFlushed(false)
end

function ENT:ExitToilet(ply)
	if (not ply._ToiletSeat:GetHasPoop()) then return end
	self:SetPaperAvailable(math.Clamp(self:GetPaperAvailable() - 1, 0, REAL_TOILET_CONFIG.Settings.PaperToiletCount))
	if (self:GetPaperAvailable() <= 0) then self:SetBodygroup(1, 1) end
	self:CleanToilet(ply)
	self:SetIsFull(true)
	self:ResetSequence(1)
	timer.Create("ToiletClose." .. self:EntIndex(), self:SequenceDuration() - 0.1, 1, function()
		if (not IsValid(self)) then return end

		self:EmitSound(REAL_TOILET_CONFIG.Sounds.Close, 75, math.random(90, 110))
	end)
end

function ENT:CleanToilet(ply)
	local seat = self:GetSeat()
	if (seat) then
		seat:Remove()
		self:SetSeat(nil)
		self:SetHasPoop(false)
		if (ply:Alive()) then
			ply:ExitVehicle()
			ply:SetPos(self:GetPos() + (self:GetForward() * 40))
			ply._ToiletSeat = nil
		end
	end
end

local function ManageToiletSeat(ply)
	ply._ToiletOldWalkSpeed = nil
	ply._ToiletOldRunSpeed = nil
	if (ply._ToiletSeat) then
		ply._ToiletSeat:CleanToilet(ply)
		ply._ToiletSeat = nil
	end
end

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn.ManageToiletSeat", ManageToiletSeat)
hook.Add("PlayerDeath", "PlayerDeath.ManageToiletSeat", ManageToiletSeat)
hook.Add("PlayerChangedTeam", "PlayerChangedTeam.ManageToiletSeat", ManageToiletSeat)
hook.Add( "CanExitVehicle", "CanExitVehicle.ToiletPoop", function( veh, ply )
	if (ply._ToiletSeat) then
		ply._ToiletSeat:ExitToilet(ply)
		return false
	end
end )