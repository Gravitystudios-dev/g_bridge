local active = false

Gravity.RegisterClientProvider('progress', 'esx_progressbar', {
    start = function(data)
        if active then return false end
        local completed, waiting = false, true
        local options = data.options or {}
        options.onFinish = function() completed, waiting, active = true, false, false if data.onFinish then data.onFinish() end end
        options.onCancel = function() completed, waiting, active = false, false, false if data.onCancel then data.onCancel() end end
        active = true
        Bridge.Adapter.core.Progressbar(data.label or Bridge.Translate('wait'), data.duration or 5000, options)
        while waiting do Wait(0) end
        return completed
    end,
    startCircle = function(data)
        return Gravity.ClientProviders.progress.esx_progressbar.start(data)
    end,
    isActive = function() return active end,
    cancel = function()
        if not active then return false end
        exports.esx_progressbar:CancelProgressbar()
        active = false
        return true
    end,
})
