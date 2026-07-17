Gravity.RegisterClientProvider('bossmenu', 'qbx_management', {
    open = function() exports.qbx_management:OpenBossMenu('job') return true end,
})
