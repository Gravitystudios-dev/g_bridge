Gravity.RegisterClientProvider('vehiclekeys', 'filo_vehiclekey', {
    give = function(plate) exports.filo_vehiclekey:GiveKeys(plate) return true end,
    remove = function(plate) exports.filo_vehiclekey:RemoveKeys(plate) return true end,
})
