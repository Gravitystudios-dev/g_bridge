Gravity.RegisterClientProvider('fuel', 'Renewed-Fuel', {
    getFuel = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
    setFuel = function(vehicle, amount)
        exports['Renewed-Fuel']:SetFuel(vehicle, amount)
        return true
    end,
})
