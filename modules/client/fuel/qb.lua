Gravity.RegisterClientProvider('fuel', 'qb-fuel', {
    getFuel = function(vehicle)
        return exports['qb-fuel']:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports['qb-fuel']:SetFuel(vehicle, amount)
    end,
})
