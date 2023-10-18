function IsPlayerNearLocation(coords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local dist = #(playerCoords - vector3(coords.x, coords.y, coords.z))
    
    return dist <= Config.MaxDistance
end
local vehicleOptions = {}
for index, vehicleName in ipairs(Config.Vehicles) do
    table.insert(vehicleOptions, {label = vehicleName, value = vehicleName, args = {id = 'vehicles'}, close = false, icon = 'car'})
end

lib.registerMenu({
    id='bike',
    title='Bike Spawner',
    position='top-right',
    options=vehicleOptions
}, function(selected, scrollIndex, args)


    if args.id == 'vehicles' then
        print(Config.Vehicles[selected])
        spawnveh(Config.Vehicles[selected])
    end 
    
end)

function spawnveh(carro)
    local hash = joaat(carro)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end

    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local vehicle = CreateVehicle(hash, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    SetPedIntoVehicle(playerPed, vehicle, -1)

    if prevVehicle then
        SetEntityAsMissionEntity(prevVehicle, true, true)
        DeleteVehicle(prevVehicle)
    end
    
    prevVehicle = vehicle
    lib.notify({
        title = 'Vehicle Spawned',
        description = 'Your vehicle has been spawned.',
        type = 'success'
    })
end


RegisterCommand('bikespawner', function()
    if not IsPlayerNearLocation(Config.BikeSpawnerLocation) then
return
    end

    if lib.getOpenMenu() ~= 'bike' then
        lib.showMenu('bike')
    end
end)

RegisterKeyMapping('bikespawner', 'Open the bike spawner', 'keyboard', Config.DefaultKey)
