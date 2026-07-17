Gravity.RegisterServerProvider('dispatch', 'qs-dispatch', {
    send = function(_, data)
        TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = data.job, callLocation = data.coords, callCode = { code = data.code, snippet = data.code }, message = data.title,
            flashes = data.priority == 'high',
            blip = { sprite = data.blip.sprite or 1, scale = data.blip.scale or 1.5, colour = data.blip.color or 1, flashes = data.priority == 'high', text = data.blip.name or data.title, time = data.time * 60000 },
        })
        return true
    end,
})
