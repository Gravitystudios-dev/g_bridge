Gravity.RegisterClientProvider('vehiclekeys', 'MrNewbVehicleKeys', {
    give = function(plate) exports.MrNewbVehicleKeys:GiveKeysByPlate(plate) return true end,
    remove = function(plate) exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate) return true end,
})
