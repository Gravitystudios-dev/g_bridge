Gravity.RegisterClientProvider('vehiclekeys', 'ak47_qb_vehiclekeys', {
    give = function(plate, vehicle) exports.ak47_qb_vehiclekeys:GiveKey(plate, vehicle and not NetworkGetEntityIsNetworked(vehicle)) return true end,
    remove = function(plate, vehicle) exports.ak47_qb_vehiclekeys:RemoveKey(plate, vehicle and not NetworkGetEntityIsNetworked(vehicle)) return true end,
})
