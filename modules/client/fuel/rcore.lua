Gravity.RegisterClientProvider('fuel', 'rcore_fuel', {
    getFuel = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
    setFuel = function(vehicle, amount)
        exports.rcore_fuel:SetVehicleFuel(vehicle, amount)
        return true
    end,
})
