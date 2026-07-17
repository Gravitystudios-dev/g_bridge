Gravity.RegisterClientProvider('fuel', 'x-fuel', {
    getFuel = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
    setFuel = function(vehicle, amount)
        exports['x-fuel']:SetFuel(vehicle, amount)
        return true
    end,
})
