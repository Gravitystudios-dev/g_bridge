Gravity.RegisterClientProvider('progress', 'ox_lib', {
    start = function(data)
        return exports.ox_lib:progressCircle({ duration = data.duration or 5000, label = data.label or Bridge.Translate('wait'), position = data.position or 'bottom', canCancel = data.canCancel ~= false, disable = data.disable or {}, anim = data.anim, prop = data.prop, useWhileDead = data.useWhileDead or false })
    end,
    startCircle = function(data)
        return exports.ox_lib:progressCircle({ duration = data.duration or 5000, label = data.label or Bridge.Translate('wait'), position = data.position or 'bottom', canCancel = data.canCancel ~= false, disable = data.disable or {}, anim = data.anim, prop = data.prop, useWhileDead = data.useWhileDead or false })
    end,
    isActive = function() return exports.ox_lib:progressActive() == true end,
    cancel = function()
        exports.ox_lib:cancelProgress()
        return true
    end,
})
