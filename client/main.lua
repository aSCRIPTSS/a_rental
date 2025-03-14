local Utils = require("shared.utils")
local QBCore = exports['qb-core']:GetCoreObject()
local pedsSpawned = false
local blips = {}

local function createBlip(options)
    if not options.coords or type(options.coords) ~= 'table' and type(options.coords) ~= 'vector3' then
        return error(('createBlip() expected coords in a vector3 or table but received %s'):format(options.coords))
    end
    local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
    SetBlipSprite(blip, options.sprite or 1)
    SetBlipDisplay(blip, options.display or 4)
    SetBlipScale(blip, options.scale or 1.0)
    SetBlipColour(blip, options.colour or 1)
    SetBlipAsShortRange(blip, options.shortRange or false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(options.title or 'No Title Given')
    EndTextCommandSetBlipName(blip)
    return blip
end

local function deleteBlips()
    if not next(blips) then return end
    for i = 1, #blips do
        local blip = blips[i]
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
end

local function initBlips()
    for i = 1, #Config.Rentals do
        local rental = Config.Rentals[i]
        if rental.ShowBlip then
            local blipOptions = {
                coords = rental.Npc.coords,
                display = Config.Blips.display,
                scale = Config.Blips.scale,
                shortRange = true,
                title = 'Rental'
            }

            if rental.Type == 'car' then
                blipOptions.sprite = 225
                blipOptions.colour = 3
                blipOptions.title = 'Vehicle Rental'
            elseif rental.Type == 'boat' then
                blipOptions.sprite = 427
                blipOptions.colour = 29
                blipOptions.title = 'Boat Rental'
            elseif rental.Type == 'air' then
                blipOptions.sprite = 423
                blipOptions.colour = 5
                blipOptions.title = 'Air Rental'
            else
                blipOptions.sprite = Config.Blips.sprite
                blipOptions.colour = Config.Blips.colour
            end

            blips[#blips + 1] = createBlip(blipOptions)
        end
    end
end

local function spawnPeds()
    if not Config.Rentals or not next(Config.Rentals) or pedsSpawned then return end

    for i = 1, #Config.Rentals do
        local currentRental = Config.Rentals[i]
        local currentNpc = currentRental.Npc
        currentNpc.model = type(currentNpc.model) == 'string' and joaat(currentNpc.model) or currentNpc.model

        RequestModel(currentNpc.model)
        while not HasModelLoaded(currentNpc.model) do
            Wait(0)
        end

        local ped = CreatePed(0, currentNpc.model, currentNpc.coords.x, currentNpc.coords.y, currentNpc.coords.z - 1, currentNpc.heading, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, currentNpc.scenario, true, true)
        currentNpc.pedHandle = ped

        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Rent Vehicle',
                icon = 'fa-solid fa-car',
                onSelect = function()
                    TriggerEvent('Rental:client:openRentalMenu', currentRental)
                end
            },
            {
                label = 'Return Vehicle',
                icon = 'fa-solid fa-car',
                items = 'rentalpapers',
                onSelect = function()
                    TriggerEvent('Rental:client:deletevehicle')
                end,
                canInteract = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    return vehicle > 0
                end
            }
        })
    end

    pedsSpawned = true
end

local function deletePeds()
    if not Config.Peds or not next(Config.Peds) or not pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        if current.pedHandle then
            DeletePed(current.pedHandle)
        end
    end
    pedsSpawned = false
end

local function isThisParkAvaiable(coords)
    return not IsPositionOccupied(coords.x, coords.y, coords.z, 3, false, true, false)
end

RegisterNetEvent('Rental:client:openRentalMenu', function(rental)
    local rentalMenu = {
        id = 'rental_menu',
        title = 'Rental Center',
        options = {}
    }

    for i = 1, #Config.Vehicles do
        local currentVehicle = Config.Vehicles[i]
        if currentVehicle.type == rental.Type then
            local selectedParams = {}

            selectedParams = {
                event = "Rental:client:openPaymentMenu",
                args = {
                    vehicle = {
                        name = currentVehicle.name,
                        model = currentVehicle.modelName,
                        price = currentVehicle.price,
                        needLicense = currentVehicle.needLicense
                    },
                    currentRental = rental
                }
            }

            rentalMenu.options[#rentalMenu.options + 1] = {
                title = currentVehicle.name,
                description = 'Price: $' .. currentVehicle.price,
                icon = "car",
                onSelect = function()
                    TriggerEvent(selectedParams.event, selectedParams.args)
                end
            }
        end
    end

    rentalMenu.options[#rentalMenu.options + 1] = {
        title = 'Exit',
        icon = "sign-out-alt",
        onSelect = function()
            lib.hideContext()
        end
    }

    lib.registerContext(rentalMenu)
    lib.showContext('rental_menu')
end)

RegisterNetEvent('Rental:client:openPaymentMenu', function(data)
    local paymentMenu = {
        id = 'payment_menu',
        title = 'Payment Type',
        options = {
            {
                title = 'Bank Payment',
                description = 'Pay securely via bank transfer.',
                icon = "money-check-dollar",
                onSelect = function()
                    TriggerEvent("Rental:client:attemptRentVehicle", {
                        paymentType = 'bank',
                        vehicle = data.vehicle,
                        currentRental = data.currentRental
                    })
                end
            },
            {
                title = 'Cash Payment',
                description = 'Pay directly with cash.',
                icon = "money-bill",
                onSelect = function()
                    TriggerEvent("Rental:client:attemptRentVehicle", {
                        paymentType = 'cash',
                        vehicle = data.vehicle,
                        currentRental = data.currentRental
                    })
                end
            },
            {
                title = 'Exit',
                icon = "sign-out-alt",
                onSelect = function()
                    lib.hideContext()
                end
            }
        }
    }

    lib.registerContext(paymentMenu)
    lib.showContext('payment_menu')
end)

RegisterNetEvent("Rental:client:attemptRentVehicle", function(data)
    local isParkFree = false
    local availablePark = nil

    for i, v in ipairs(data.currentRental.VehicleSpawn) do
        if isThisParkAvaiable(v.coords) then
            isParkFree = true
            availablePark = v
            break
        end
    end

    if isParkFree then
        TriggerServerEvent("Rental:server:attemptPayRent", data.paymentType, data.vehicle, availablePark)
    else
        Utils.sendNotification(1, 'The parking lot is currently full. Please try again later.', 'error', 5000);
    end
end)

RegisterNetEvent("Rental:client:deletevehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, true)
    if vehicle > 0 then
        local currentPlate = GetVehicleNumberPlateText(vehicle)
        local PlayerData = QBCore.Functions.GetPlayerData()
        if currentPlate then
            if PlayerData then
                local citizenid = PlayerData.citizenid
                local pitems = exports.ox_inventory:GetPlayerItems()
                local count = #pitems
                local flag = false
                for c, d in pairs(pitems) do
                    count = count - 1
                    if "rentalpapers" == d.name then
                        local info = d['metadata']
                        if info and citizenid == info.citizenid and currentPlate == info.plate then
                            for i = 0, 5 do
                                BreakOffVehicleWheel(vehicle, i, true, false, true, false)
                            end
                            Wait(500)
                            for i = 0, 5 do
                                SetVehicleDoorBroken(vehicle, i, true)
                            end
                            Wait(500)
                            SetVehicleEngineHealth(vehicle, 10.0)
                            Wait(500)
                            TriggerServerEvent("rental:server:removepaper", d)
                            DeleteVehicle(vehicle)
                            flag = true
                            count = 0
                            break
                        end
                    end
                end
                while count > 1 do
                    Wait(100)
                end
                if not flag then
                    Utils.sendNotification(1, 'I cannot take a vehicle without its papers.', 'error', 5000);
                end
            else
                Utils.sendNotification(1, 'I cannot take a vehicle without its papers.', 'error', 5000);
            end
        else
            Utils.sendNotification(1, 'No vehicle plate number found', 'error', 5000);
        end
    else
        Utils.sendNotification(1, 'No vehicle', 'error', 5000);
    end
end)

RegisterNetEvent("Rental:client:vehicleSpawn", function(vehicleModel, vehiclePrice, availablePark, cb)
    local model = vehicleModel

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    SetModelAsNoLongerNeeded(model)

    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetEntityHeading(veh, availablePark.heading)
        exports[Config.FuelExport]:SetFuel(veh, 100.0)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        local currentPlate = QBCore.Functions.GetPlate(veh)

        TriggerServerEvent("qb-rental:purchase", vehiclePrice)
        TriggerServerEvent("Rental:server:giveRentalPaper", model, currentPlate)
    end, availablePark.coords, true)

    local timeout = 10
    while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
        timeout = timeout - 1
        Wait(1000)
    end
end)

RegisterNetEvent("Rental:client:payRent", function(paymentType, vehicle, availablePark)
    TriggerServerEvent("Rental:server:payRent", paymentType, vehicle, availablePark)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteBlips()
    deletePeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    spawnPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deletePeds()
end)

CreateThread(function()
    initBlips()
    spawnPeds()
end)