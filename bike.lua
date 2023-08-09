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
    RequestModel(GetHashKey(carro))
    while not HasModelLoaded(GetHashKey(carro)) do
        Citizen.Wait(100)
    end
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local vehicle = CreateVehicle(GetHashKey(carro), pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    if prevVehicle ~= nil then
        SetEntityAsMissionEntity(prevVehicle, true, true)
        DeleteVehicle(prevVehicle)
    end
    prevVehicle = vehicle
end

RegisterCommand('+bike', function()
    if not IsPlayerNearLocation(Config.BikeSpawnerLocation) then
        --[[ Commeneted out so it didnt spawn if someone hit button and not there you can add it or a Notification if you want
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", "You are too far away from the bike spawner location!"}
        })
            --]]
        return
    end

    if lib.getOpenMenu() ~= 'bike' then
        lib.showMenu('bike')
    end
end)

RegisterKeyMapping('+bike', 'Open the bike spawner', 'keyboard', Config.DefaultKey)
