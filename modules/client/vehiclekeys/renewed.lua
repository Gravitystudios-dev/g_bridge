Gravity.RegisterClientProvider('vehiclekeys', 'Renewed-Vehiclekeys', {
    give = function(plate) exports['Renewed-Vehiclekeys']:addKey(plate) return true end,
    remove = function(plate) exports['Renewed-Vehiclekeys']:removeKey(plate) return true end,
})
