Gravity.RegisterClientProvider('fuel', 'bit-fuel', {
    getFuel = function(vehicle)
        return exports['bit-fuel']:GetFuelLevel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports['bit-fuel']:SetFuel(vehicle, amount)
    end,
})
