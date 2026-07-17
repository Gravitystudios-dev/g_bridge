Gravity.RegisterClientProvider('vehiclekeys', 'qs-vehiclekeys', {
    entityRequired = true,
    give = function(vehicle)
        local plate = GetVehicleNumberPlateText(vehicle)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        return exports['qs-vehiclekeys']:GiveKeys(plate, model, true) ~= false
    end,
    remove = function(vehicle)
        local plate = GetVehicleNumberPlateText(vehicle)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        return exports['qs-vehiclekeys']:RemoveKeys(plate, model) ~= false
    end,
})
