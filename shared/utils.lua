local Utils = {}

function Utils.sendNotification(playerId, title, description, type, duration) -- client side
    duration = duration or 5000
    
    lib.notify({
        title = title,
        description = description,
        type = type,
        showDuration = true,
        duration = duration
    })
end

function Utils.notifyPlayer(playerId, title, description, type, duration) -- server side
    TriggerClientEvent('ox_lib:notify', playerId, {
        title = title,
        description = description,
        type = type,
        duration = duration or 5000
    })
end

return Utils