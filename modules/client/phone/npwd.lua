Gravity.RegisterClientProvider('phone', 'npwd', {
    setDisabled = function(disabled) exports.npwd:setPhoneDisabled(disabled) return true end,
})
