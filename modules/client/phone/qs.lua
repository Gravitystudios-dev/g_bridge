Gravity.RegisterClientProvider('phone', 'qs-smartphone-pro', {
    setDisabled = function(disabled) exports['qs-smartphone-pro']:SetCanOpenPhone(not disabled) return true end,
})
