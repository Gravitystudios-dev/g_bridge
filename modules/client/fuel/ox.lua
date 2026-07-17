-- ox_fuel stores the amount in the vehicle entity state.
Gravity.RegisterClientProvider('fuel', 'ox_fuel', {
    getFuel = function(vehicle)
        return Entity(vehicle).state.fuel or 0.0
    end,
    setFuel = function(vehicle, amount)
        Entity(vehicle).state.fuel = amount
        return true
    end,
})
