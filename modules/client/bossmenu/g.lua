Gravity.RegisterClientProvider('bossmenu', 'g-bossmenu', {
    open = function(job) if not job then return false end exports['g-bossmenu']:OpenBossmenu(job) return true end,
})
