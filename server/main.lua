ESX = exports['es_extended']:getSharedObject()

local playerData = {}

-- Job und Tracker prüfen
RegisterServerEvent('esx_factiontracker:checkTrackerItem')
AddEventHandler('esx_factiontracker:checkTrackerItem', function(coords, vehicleType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.job.name ~= 'unemployed' then
        local hasTracker = xPlayer.getInventoryItem('tracker').count > 0

        if hasTracker then
            playerData[src] = {
                coords = coords,
                job = xPlayer.job.name,
                vehicleType = vehicleType
            }
        else
            playerData[src] = nil
        end

        -- Sync an alle Spieler senden
        TriggerClientEvent('esx_factiontracker:syncBlips', -1, playerData)
    end
end)


-- Job per Callback senden
ESX.RegisterServerCallback('esx_factiontracker:getPlayerJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.job.name)
end)

-- Spieler-Disconnect entfernen
AddEventHandler('playerDropped', function()
    local src = source
    playerData[src] = nil
    TriggerClientEvent('esx_factiontracker:syncBlips', -1, playerData)
end)
