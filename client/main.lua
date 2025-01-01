local playerBlips = {}
local jobName = nil
ESX = nil

-- ESX Initialisieren
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

-- Blip-Logik aktualisieren
RegisterNetEvent('esx_factiontracker:syncBlips')
AddEventHandler('esx_factiontracker:syncBlips', function(players)
    -- Lösche alte Blips
    for _, blip in pairs(playerBlips) do
        RemoveBlip(blip)
    end
    playerBlips = {}

    -- Neue Blips setzen
    for playerId, player in pairs(players) do
        if player.job == jobName then
            local pedCoords = player.coords
            local vehicleType = player.vehicleType

            -- Blip-Symbol basierend auf Fahrzeugart
            local blipSprite = 280 -- Standard für zu Fuß
            if vehicleType == "car" then blipSprite = 800
            elseif vehicleType == "helicopter" then blipSprite = 583
            elseif vehicleType == "boat" then blipSprite = 410 end

            local blip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
            SetBlipSprite(blip, blipSprite)
            SetBlipColour(blip, 39) -- Grau
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)

            -- Blip-Name
            if tonumber(playerId) == GetPlayerServerId(PlayerId()) then
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Du (Fraktions-Tracker)")
            else
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Fraktionsmitglied")
            end
            EndTextCommandSetBlipName(blip)

            table.insert(playerBlips, blip)
        end
    end
end)

-- Job und Tracker prüfen
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- 1 Sekunde für schnellere Updates

        ESX.TriggerServerCallback('esx_factiontracker:getPlayerJob', function(job)
            jobName = job
        end)

        -- Check, ob Item vorhanden ist
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleType = "onfoot"

        if vehicle ~= 0 then
            local class = GetVehicleClass(vehicle)
            if class == 14 then vehicleType = "boat"
            elseif class == 15 or class == 16 then vehicleType = "helicopter"
            else vehicleType = "car" end
        end

        TriggerServerEvent('esx_factiontracker:checkTrackerItem', coords, vehicleType)
    end
end)
