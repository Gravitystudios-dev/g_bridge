Gravity.RegisterClientProvider('fuel', 'lc_fuel', {
    getFuel = function(vehicle)
        return exports.lc_fuel:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports.lc_fuel:SetFuel(vehicle, amount)
    end,
})
