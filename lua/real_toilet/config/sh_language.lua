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

--[[
* Returns the element to be translated according to the server language.
* @string langName Language name (ex : en, fr)
* @table data The table contain the translations
--]]
function real_toilet.AddLanguage(langName, data)
    if (type(langName) == "string" and type(data) == "table") then
        REAL_TOILET_LANG[langName] = data
    end
end

--[[
* Returns the element to be translated according to the server language.
* @string name Element to translate.
--]]
function real_toilet.GetTranslation(name)
    local langUsed = REAL_TOILET_CONFIG.LangServer
    if not REAL_TOILET_LANG[langUsed] then
        langUsed = "en" -- Default lang is EN.
    end
    return string.format( REAL_TOILET_LANG[langUsed][ name ] or "Not Found" )
end