Gravity.RegisterClientProvider('bossmenu', 'vms_bossmenu', {
    open = function(job) if not job then return false end exports.vms_bossmenu:openBossMenu(job, 'job') return true end,
})
