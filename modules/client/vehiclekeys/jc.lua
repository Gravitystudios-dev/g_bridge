Gravity.RegisterClientProvider('vehiclekeys', 'jc_vehiclekeys', {
    give = function(plate) exports.jc_vehiclekeys:GiveKeys(plate) return true end,
    remove = function(plate) exports.jc_vehiclekeys:RemoveKeys(plate) return true end,
})
