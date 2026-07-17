Gravity.RegisterClientProvider('fuel', 'cdn-fuel', {
    getFuel = function(vehicle)
        return exports['cdn-fuel']:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports['cdn-fuel']:SetFuel(vehicle, amount)
    end,
})
