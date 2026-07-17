Gravity.RegisterServerProvider('dispatch', 'rcore_dispatch', {
    send = function(_, data)
        TriggerEvent('rcore_dispatch:server:sendAlert', {
            code = data.code, default_priority = data.priority, coords = data.coords, job = data.job, text = data.title, type = 'alerts', blip_time = data.time,
            blip = { sprite = data.blip.sprite or 1, scale = data.blip.scale or 1.1, colour = data.blip.color or 1, text = data.blip.name or data.title },
        })
        return true
    end,
})
