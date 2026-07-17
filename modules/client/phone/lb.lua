Gravity.RegisterClientProvider('phone', 'lb-phone', {
    setDisabled = function(disabled) exports['lb-phone']:ToggleDisabled(disabled) return true end,
})
