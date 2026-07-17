Gravity.RegisterClientProvider('vehiclekeys', 'qb-vehiclekeys', {
    give = function(plate)
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
        return true
    end,
})
