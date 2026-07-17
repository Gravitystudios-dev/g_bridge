Gravity.RegisterClientProvider('vehiclekeys', 'brutal_carkeys', {
    give = function(plate) exports.brutal_keys:addVehicleKey(plate, 'car') return true end,
    remove = function(plate) exports.brutal_keys:removeKey(plate, true) return true end,
})
