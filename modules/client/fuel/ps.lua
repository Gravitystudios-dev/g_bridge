Gravity.RegisterClientProvider('fuel', 'ps-fuel', {
    getFuel = function(vehicle)
        return exports['ps-fuel']:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports['ps-fuel']:SetFuel(vehicle, amount)
    end,
})
