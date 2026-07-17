Gravity.RegisterClientProvider('phone', 'yseries', {
    setDisabled = function(disabled) exports.yseries:ToggleDisabled(disabled) return true end,
})
