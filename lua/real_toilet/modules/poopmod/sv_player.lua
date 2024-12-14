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
    REAL_TOILET_CONFIG.Settings.PoopVars[self]["PoopValue"] = value
end

function meta:GetPoopValue()
    local vars = REAL_TOILET_CONFIG.Settings.PoopVars[self]
    if vars == nil then return 0 end

    local result = vars["PoopValue"]
    if result == nil then return 0 end

    return result
end

function meta:PoopUpdate()
    if not REAL_TOILET_CONFIG.Settings.PoopSpeed or not REAL_TOILET_CONFIG.Settings.PoopMeterEnabled then return end
    if #ents.FindByClass("real_toilet") == 0 then return end --? If there are no toilets on the map
    if not self:Alive() then return end

    local poop_meter = self:GetPoopValue()

    self:SetPoopValue(poop_meter and math.Clamp(poop_meter - REAL_TOILET_CONFIG.Settings.PoopSpeed, 0, 100) or 100)
    print("Poop meter : " .. poop_meter)

    if (poop_meter <= 50) then
        local chance = math.random(1, 100)
        if chance >= (100 - poop_meter) then
            self:EmitSound(REAL_TOILET_CONFIG.Sounds.StomachNoise, 75, math.random(90, 110))
        end
    end

    if poop_meter <= 10 then
        -- TODO : Pénalité : Vitesse de déplacement réduite, effet d'hud ?
    end
end


util.AddNetworkString("SitOnEntity")

-- Fonction pour faire asseoir un joueur sur une entité
function SitPlayerOnEntity(ply, targetEnt, offsetVec, offsetAng)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not IsValid(targetEnt) then return end

    -- Créer un siège dynamique à la position voulue
    local seat = ents.Create("prop_vehicle_prisoner_pod")
    if not IsValid(seat) then return end

    -- Configurer le siège
    seat:SetModel("models/nova/airboat_seat.mdl") -- Modèle de siège standard
    seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
    seat:SetPos(targetEnt:LocalToWorld(offsetVec)) -- Position en fonction du vecteur local
    seat:SetAngles(targetEnt:LocalToWorldAngles(offsetAng or Angle(0, 0, 0))) -- Orientation optionnelle
    seat:Spawn()
    seat:Activate()

    -- Désactiver la physique du siège pour le fixer à l'entité
    seat:SetMoveType(MOVETYPE_NONE)
    seat:SetParent(targetEnt) -- Attache le siège à l'entité cible

    -- Faire asseoir le joueur
    ply:EnterVehicle(seat)

    -- Nettoyage automatique du siège quand le joueur se lève
    seat:CallOnRemove("PlayerExitSeat", function()
        if IsValid(ply) and ply:GetVehicle() == seat then
            ply:ExitVehicle()
        end
    end)
end

-- Commande pour tester (exemple)
concommand.Add("sit_on_entity", function(ply, cmd, args)
    if not ply:IsAdmin() then return end -- Autorisé seulement aux admins

    local targetEnt = ply:GetEyeTrace().Entity -- Entité visée par le joueur
    if not IsValid(targetEnt) then
        ply:ChatPrint("Regardez une entité valide pour utiliser cette commande.")
        return
    end

    local offsetVec = Vector(0, 0, 50) -- Exemple d'offset
    local offsetAng = Angle(0, 0, 0) -- Exemple d'angle
    SitPlayerOnEntity(ply, targetEnt, offsetVec, offsetAng)
end)