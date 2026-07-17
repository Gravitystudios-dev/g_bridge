Gravity.RegisterClientProvider('vehiclekeys', 'mm_carkeys', {
    give = function(plate, vehicle) exports.mm_carkeys:GiveKeyItem(plate, vehicle) return true end,
    remove = function(plate) exports.mm_carkeys:RemoveKeyItem(plate) return true end,
})
