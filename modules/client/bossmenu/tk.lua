Gravity.RegisterClientProvider('bossmenu', 'tk_bosstablet', {
    open = function() exports.tk_bosstablet:openBossMenu() return true end,
})
