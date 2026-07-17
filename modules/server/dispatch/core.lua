Gravity.RegisterServerProvider('dispatch', 'core_dispatch', {
    send = function(_, data)
        exports.core_dispatch:addCall(data.code, data.title, {}, { data.coords }, type(data.job) == 'string' and data.job or 'police', (data.notify or 3) * 1000, data.blip.sprite or 1, data.blip.color or 3, false)
        return true
    end,
})
