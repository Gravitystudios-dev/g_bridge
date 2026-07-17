Gravity.RegisterClientProvider('vehiclekeys', 'qbx_vehiclekeys', {
    entityRequired = true,
    give = function(vehicle)
        TriggerServerEvent('gravity_bridge:server:vehicleKeys', 'give', VehToNet(vehicle))
        return true
    end,
    remove = function(vehicle)
        TriggerServerEvent('gravity_bridge:server:vehicleKeys', 'remove', VehToNet(vehicle))
        return true
    end,
})
