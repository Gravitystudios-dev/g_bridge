Gravity.RegisterClientProvider('bossmenu', 'esx_society', {
    open = function(job)
        if not job then return false end
        TriggerEvent('esx_society:openBossMenu', job, function() end, { wash = false })
        return true
    end,
})
