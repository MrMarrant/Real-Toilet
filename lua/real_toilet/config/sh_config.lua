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

-- NET VAR
REAL_TOILET_CONFIG.NetVar = {}

-- Model Path
REAL_TOILET_CONFIG.Models = {}
REAL_TOILET_CONFIG.Models.Toilet = "models/real_toilet/real_toilet.mdl"
REAL_TOILET_CONFIG.Models.Laxative = "models/props_junk/garbage_plasticbottle001a.mdl"
REAL_TOILET_CONFIG.Models.OrangeJuice = ""
REAL_TOILET_CONFIG.Models.ToiletPaper = "models/paper_toilet/paper_toilet.mdl"

--Sound Path
REAL_TOILET_CONFIG.Sounds = {}
REAL_TOILET_CONFIG.Sounds.Flush = "real_toilet/flush.mp3"
REAL_TOILET_CONFIG.Sounds.Poop = "real_toilet/fart.mp3"
REAL_TOILET_CONFIG.Sounds.StomachNoise = {}
REAL_TOILET_CONFIG.Sounds.StomachNoise[1] = "real_toilet/stomach_01.mp3"
REAL_TOILET_CONFIG.Sounds.StomachNoise[2] = "real_toilet/stomach_02.mp3"
REAL_TOILET_CONFIG.Sounds.StomachNoise[3] = "real_toilet/stomach_03.mp3"
REAL_TOILET_CONFIG.Sounds.Open = "real_toilet/open.mp3"
REAL_TOILET_CONFIG.Sounds.Close = "real_toilet/close.mp3"
REAL_TOILET_CONFIG.Sounds.Drink = "real_toilet/drink.mp3"
REAL_TOILET_CONFIG.Sounds.PS1 = "real_toilet/ps1.mp3"

-- Settings
REAL_TOILET_CONFIG.Settings = {}
REAL_TOILET_CONFIG.Settings.PoopVars = {}
REAL_TOILET_CONFIG.Settings.PoopSpeed = 1
REAL_TOILET_CONFIG.Settings.RepetitionsUpdate = 14
REAL_TOILET_CONFIG.Settings.PaperToiletCount = 10
REAL_TOILET_CONFIG.Settings.PoopTime = 3
REAL_TOILET_CONFIG.Settings.MinPoopToilet = 80

if SERVER then
    CreateConVar( "PoopMeterEnabled", 1, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "When enable, active the poop meter that slowly decrease which inflicts malus on the player when too low.", 0, 1 )
end