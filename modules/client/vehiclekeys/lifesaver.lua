Gravity.RegisterClientProvider('vehiclekeys', 'LifeSaver_KeySystem', {
    entityRequired = true,
    give = function(vehicle)
        exports.LifeSaver_KeySystem:AddCarkey(GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
        return true
    end,
    remove = function(vehicle)
        exports.LifeSaver_KeySystem:RemoveCarkey(GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
        return true
    end,
})
