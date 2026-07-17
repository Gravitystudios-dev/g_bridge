Gravity.RegisterClientProvider('vehiclekeys', 'ic3d_vehiclekeys', {
    give = function(plate) exports.ic3d_vehiclekeys:ClientInventoryKeys('add', plate) return true end,
    remove = function(plate) exports.ic3d_vehiclekeys:ClientInventoryKeys('remove', plate) return true end,
})
