local Utils = require("shared.utils")
local QBCore = exports['qb-core']:GetCoreObject()
local vehiclelist = {}
local payreturn = {}

RegisterServerEvent('Rental:server:attemptPayRent', function(paymentType, vehicle, availablePark)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local driverLicense = Player.PlayerData.metadata["licences"]["driver"]
    if vehicle.needLicense and not driverLicense then
        return Utils.notifyPlayer(src, 'A valid driver\'s license is required to rent this vehicle.')
    end

    local playerCash = Player.PlayerData.money["cash"]
    local playerBankCash = Player.PlayerData.money["bank"]

    if (paymentType == 'cash' and playerCash >= vehicle.price) or (paymentType == 'bank' and playerBankCash >= vehicle.price) then
        TriggerClientEvent('Rental:client:payRent', src, paymentType, vehicle, availablePark)
    else
        Utils.notifyPlayer(src, 'You do not have sufficient funds to rent this vehicle.')
    end
end)

RegisterServerEvent('Rental:server:payRent', function(paymentType, vehicle, availablePark)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    Player.Functions.RemoveMoney(paymentType, vehicle.price, "rentals")
    Utils.notifyPlayer(src, 'Vehicle rented for: $' .. vehicle.price)
    TriggerClientEvent('Rental:client:vehicleSpawn', src, vehicle.model, vehicle.price, availablePark)
    payreturn[vehicle.model] = vehicle.price
end)

RegisterServerEvent('Rental:server:giveRentalPaper', function(model, plateText)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local PlayerData = Player.PlayerData
    local currentTimeStamp = os.time()
    local newTimeStamp = currentTimeStamp + 3600
    vehiclelist[plateText] = newTimeStamp

    local metadata = {
        temporaryOwner = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname,
        citizenid = PlayerData.citizenid,
        vehicleModel = model,
        plate = plateText,
        description = 'Temporary Owner: ' .. PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname .. 
                      ' | Plate: ' .. plateText .. 
                      ' | Vehicle: ' .. model:gsub("^%l", string.upper) .. 
                      ' | Rent On: ' .. os.date("%Y-%m-%d %H:%M:%S", newTimeStamp),
    }

    exports.ox_inventory:AddItem(src, 'rentalpapers', 1, metadata)
end)

RegisterServerEvent("rental:server:removepaper", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    exports.ox_inventory:RemoveItem(src, data.name, 1, _, data.slot)

    local amount = payreturn[data.metadata.vehicleModel] or 25
    amount = math.round((amount / 2))
    Player.Functions.AddMoney("cash", amount, "rentals-return")
end)