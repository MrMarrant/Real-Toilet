-- Real Toilet, this is an addon for Garry's mod game, used mainly for roleplay actions or in a visual immersion context.
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
-- along with this program.  If not, see [gnu.org](https://www.gnu.org/licenses/).

local meta = FindMetaTable("Player")

function meta:NewPoopMeter()
    self:SetPoopValue(100)
end

function meta:SetPoopValue(value)
    REAL_TOILET_CONFIG.Settings.PoopVars[self] = REAL_TOILET_CONFIG.Settings.PoopVars[self] or {}
    REAL_TOILET_CONFIG.Settings.PoopVars[self]["PoopValue"] = math.Clamp(value, 0, 100)
end

function meta:GetPoopValue()
    local vars = REAL_TOILET_CONFIG.Settings.PoopVars[self]
    if vars == nil then return 0 end

    local result = vars["PoopValue"]
    if result == nil then return 0 end

    return result
end

function meta:PoopUpdate()
    if not REAL_TOILET_CONFIG.Settings.PoopSpeed or not GetConVar("PoopMeterEnabled"):GetBool() then return end
    if #ents.FindByClass("real_toilet") == 0 then return end --? If there are no toilets on the map
    if not self:Alive() then return end

    local poop_meter = self:GetPoopValue()
    poop_meter = poop_meter and math.Clamp(poop_meter - REAL_TOILET_CONFIG.Settings.PoopSpeed, 0, 100) or 100
    self:SetPoopValue(poop_meter)
    if (poop_meter <= 50) then
        local chance = math.random(1, 50)
        if chance >= poop_meter then
            self:EmitSound(REAL_TOILET_CONFIG.Sounds.StomachNoise[math.random(#REAL_TOILET_CONFIG.Sounds.StomachNoise)], 75, math.random(90, 110))
        end
    end

    if poop_meter <= 10 and (not self._ToiletOldWalkSpeed or not self._ToiletOldRunSpeed) then
        self:SetPoopStatus()
    end
end

function meta:SetPoopStatus()
    local old_walk = self:GetWalkSpeed()
    local old_run = self:GetRunSpeed()
    self._ToiletOldWalkSpeed = old_walk
    self._ToiletOldRunSpeed = old_run
    self:SetWalkSpeed(old_walk * 0.7)
    self:SetRunSpeed(old_run * 0.7)
end