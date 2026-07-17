Gravity.RegisterClientProvider('vehiclekeys', 'ak47_vehiclekeys', {
    give = function(plate, vehicle) exports.ak47_vehiclekeys:GiveKey(plate, vehicle and not NetworkGetEntityIsNetworked(vehicle)) return true end,
    remove = function(plate, vehicle) exports.ak47_vehiclekeys:RemoveKey(plate, vehicle and not NetworkGetEntityIsNetworked(vehicle)) return true end,
})
