Gravity.RegisterClientProvider('vehiclekeys', 'is_vehiclekeys', {
    give = function(plate) exports.is_vehiclekeys:GiveKey(plate) return true end,
    remove = function(plate) exports.is_vehiclekeys:RemoveKey(plate) return true end,
})
