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
	if (self:GetIsFull() or self:GetPaperAvailable() <= 0 or IsValid(self:GetSeat())) then return end

	self:CreateSeat(ply)
	-- TODO : Gérer la chasse deau
	-- TODO : Gérer le papier toilette
	-- TODO : Le joueur doit rester au moins 3 secondes avant de pouvoir se lever.
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
end

function ENT:ExitToilet(ply)
	local seat = self:GetSeat()
	if (seat) then
		seat:Remove()
		self:SetSeat(nil)
		if (ply:Alive()) then
			ply:ExitVehicle()
			ply:SetPos(self:GetPos() + Vector(40, 0, 0))
			ply._ToiletSeat = nil
		end
	end
end

local function ManageToiletSeat(ply)
	if (ply._ToiletSeat) then
		ply._ToiletSeat:ExitToilet(ply)
		ply._ToiletSeat = nil
	end
end

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn.ManageToiletSeat", ManageToiletSeat)
hook.Add("PlayerDeath", "PlayerDeath.ManageToiletSeat", ManageToiletSeat)
hook.Add("PlayerChangedTeam", "PlayerChangedTeam.ManageToiletSeat", ManageToiletSeat)
hook.Add( "CanExitVehicle", "CanExitVehicle.ToiletPoop", function( veh, ply )
	if (ply._ToiletSeat) then
		ply._ToiletSeat:ExitToilet(ply)
	end
end )