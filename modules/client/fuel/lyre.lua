Gravity.RegisterClientProvider('fuel', 'lyre_fuel', {
    getFuel = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
    setFuel = function(vehicle, amount)
        exports.lyre_fuel:SetFuel(vehicle, amount)
        return true
    end,
})
