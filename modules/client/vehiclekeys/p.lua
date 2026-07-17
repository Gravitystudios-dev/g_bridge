Gravity.RegisterClientProvider('vehiclekeys', 'p_carkeys', {
    give = function(plate) TriggerServerEvent('p_carkeys:CreateKeys', plate) return true end,
    remove = function(plate) TriggerServerEvent('p_carkeys:RemoveKeys', plate) return true end,
})
