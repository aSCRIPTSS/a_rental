Config = Config or {}

Config.FuelExport = "cdn-fuel"
Config.EnableBankPayment = false

Config.Blips = {
    sprite = 225,
    display = 2,
    scale = 0.7,
    colour = 32,
}

Config.Rentals = {
    {
        ShowBlip = true,
        Type = 'car',
        Npc = {
            coords = vector3(111.53, -1089.1, 29.3),
            heading = 26.08,
            model = "s_m_m_dockwork_01",
            scenario = "WORLD_HUMAN_CLIPBOARD_FACILITY",
        },
        VehicleSpawn = {
            { coords = vector3(111.43, -1080.67, 28.73), heading = 340.45 },
            { coords = vector3(108.03, -1079.21, 28.73), heading = 338.4 },
            { coords = vector3(104.43, -1078.2, 28.73), heading = 340.37 },
        },
    },
    {
        ShowBlip = true,
        Type = 'boat',
        Npc = {
            coords = vector3(-802.78, -1495.64, 1.60),
            heading = 209.34,
            model = "s_m_m_dockwork_01",
            scenario = "WORLD_HUMAN_CLIPBOARD_FACILITY",
        },
        VehicleSpawn = {
            { coords = vector3(-800.0, -1500.0, 0.0), heading = 120.0 },
            { coords = vector3(-805.0, -1505.0, 0.0), heading = 120.0 },
        },
    },
    {
        ShowBlip = true,
        Type = 'air',
        Npc = {
            coords = vector3(-1100.73, -2878.97, 13.95),
            heading = 147.78,
            model = "s_m_m_dockwork_01",
            scenario = "WORLD_HUMAN_CLIPBOARD_FACILITY",
        },
        VehicleSpawn = {
            { coords = vector3(-1112.23, -2883.59, 13.95), heading = 152.19 },
        },
    },
}

Config.Vehicles = {
    { name = 'BMX', modelName = 'bmx', price = 200, needLicense = false, menuIcon = 'fa-solid fa-bicycle', type = 'car'},
    { name = 'Scorcher', modelName = 'scorcher', price = 200, needLicense = false, menuIcon = 'fa-solid fa-bicycle', type = 'car' },
    { name = 'Faggio', modelName = 'faggio', price = 250, needLicense = false, menuIcon = 'fa-solid fa-motorcycle', type = 'car' },
    { name = 'Panto', modelName = 'panto', price = 250, needLicense = false, menuIcon = 'fa-solid fa-car-side', type = 'car' },
    { name = 'Bison', modelName = 'bison', price = 500, needLicense = false, menuIcon = 'fa-solid fa-truck-pickup', type = 'car' },
    { name = 'Dinghy', modelName = 'dinghy', price = 1000, needLicense = false, menuIcon = 'fa-solid fa-ship', type = 'boat' },
    { name = 'Seashark', modelName = 'seashark', price = 800, needLicense = false, menuIcon = 'fa-solid fa-ship', type = 'boat' },
    { name = 'Maverick', modelName = 'maverick', price = 5000, needLicense = true, menuIcon = 'fa-solid fa-helicopter', type = 'air' },
    { name = 'Duster', modelName = 'duster', price = 3000, needLicense = true, menuIcon = 'fa-solid fa-plane', type = 'air' }
}