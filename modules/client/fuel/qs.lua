Gravity.RegisterClientProvider('fuel', 'qs-fuelstations', {
    getFuel = function(vehicle)
        return exports['qs-fuelstations']:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports['qs-fuelstations']:SetFuel(vehicle, amount)
    end,
})
