Gravity.RegisterClientProvider('fuel', 'LegacyFuel', {
    getFuel = function(vehicle)
        return exports.LegacyFuel:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports.LegacyFuel:SetFuel(vehicle, amount)
    end,
})
