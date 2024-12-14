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

local function NewPoopPlayerInitialSpawn(ply)
    ply:NewPoopMeter()
end
hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn.NewPoopMeter", NewPoopPlayerInitialSpawn)
hook.Add("PlayerDeath", "PlayerDeath.NewPoopMeter", NewPoopPlayerInitialSpawn)
hook.Add("PlayerChangedTeam", "PlayerChangedTeam.NewPoopMeter", NewPoopPlayerInitialSpawn)

local function PoopThink()
    for _, v in ipairs(player.GetAll()) do
        if not v:Alive() then continue end
        v:PoopUpdate()
    end
end
timer.Create("PoopThink", REAL_TOILET_CONFIG.Settings.RepetitionsUpdate, 0, PoopThink)