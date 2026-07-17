Gravity.RegisterClientProvider('bossmenu', 'qb-management', {
    open = function() TriggerEvent('qb-bossmenu:client:OpenMenu') return true end,
})
