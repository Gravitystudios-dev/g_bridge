Gravity.RegisterClientProvider('fuel', 'hex_1_fuel', {
    getFuel = function(vehicle)
        return exports.hex_1_fuel:GetFuel(vehicle)
    end,
    setFuel = function(vehicle, amount)
        return exports.hex_1_fuel:SetFuel(vehicle, amount)
    end,
})
