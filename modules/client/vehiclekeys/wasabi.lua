Gravity.RegisterClientProvider('vehiclekeys', 'wasabi_carlock', {
    give = function(plate)
        return exports.wasabi_carlock:GiveKey(plate)
    end,
    remove = function(plate)
        return exports.wasabi_carlock:RemoveKey(plate)
    end,
})
