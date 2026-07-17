Gravity.RegisterClientProvider('progress', 'qb-core', {
    start = function(data)
        local completed, waiting = nil, true
        exports['qb-core']:GetCoreObject().Functions.Progressbar(data.name or 'gravity_progress', data.label or Bridge.Translate('wait'), data.duration or 5000, data.useWhileDead or false, data.canCancel ~= false, data.disable or {}, data.anim or {}, data.prop or {}, {}, function() completed, waiting = true, false end, function() completed, waiting = false, false end)
        while waiting do Wait(0) end
        return completed
    end,
    startCircle = function(data)
        local provider = Gravity.ClientProviders.progress['qb-core']
        return provider.start(data)
    end,
    isActive = function()
        return Gravity.ResourceStarted('progressbar') and exports.progressbar:isDoingSomething() or false
    end,
    cancel = function()
        TriggerEvent('progressbar:client:cancel')
        return true
    end,
})
