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

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "MrMarrant"
ENT.PrintName = "Toilet"
ENT.Spawnable = true
ENT.Category = "Real Toilet"
ENT.AutomaticFrameAdvance = true

-- Set up every var related to the entity we will use
function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsFull")
    self:NetworkVar("Bool", 1, "HasPoop")
    self:NetworkVar("Bool", 2, "IsFlushed")
    self:NetworkVar("Int", 0, "PaperAvailable")
    self:NetworkVar("Entity", 0, "Seat")
end