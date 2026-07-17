Gravity.RegisterClientProvider('bossmenu', 'xnr-bossmenu', {
    open = function(job) if not job then return false end exports['xnr-bossmenu']:openBossmenu(job) return true end,
})
