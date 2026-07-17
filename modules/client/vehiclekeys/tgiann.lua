Gravity.RegisterClientProvider('vehiclekeys', 'tgiann-hotwire', {
    give = function(plate) exports['tgiann-hotwire']:GiveKeyPlate(plate, true) return true end,
})
