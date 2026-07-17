Gravity.RegisterClientProvider('vehiclekeys', '0r-vehiclekeys', {
    give = function(plate)
        return exports['0r-vehiclekeys']:GiveKeys(plate)
    end,
    remove = function(plate)
        return exports['0r-vehiclekeys']:RemoveKeys(plate)
    end,
})
