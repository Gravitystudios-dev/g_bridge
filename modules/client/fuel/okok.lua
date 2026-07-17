Gravity.RegisterClientProvider('fuel', 'okokGasStation', {
    getFuel = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
    setFuel = function(vehicle, amount)
        exports.okokGasStation:SetFuel(vehicle, amount)
        return true
    end,
})
