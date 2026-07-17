Gravity.RegisterClientProvider('fuel', 'myFuel', {
    getFuel = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
    setFuel = function(vehicle, amount)
        exports.myFuel:SetFuel(vehicle, amount)
        return true
    end,
})
