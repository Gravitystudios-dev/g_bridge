Gravity.RegisterServerProvider('dispatch', 'ps-dispatch', {
    send = function(_, data)
        TriggerEvent('ps-dispatch:server:notify', {
            message = data.title, codeName = data.code, code = data.code, icon = data.icon or 'fa-solid fa-bell',
            priority = data.priority == 'high' and 1 or 2, coords = data.coords,
            alert = { radius = data.blip.radius or 0, sprite = data.blip.sprite or 1, scale = data.blip.scale or 1.1, color = data.blip.color or 1, flash = data.priority == 'high', length = data.time },
            length = data.time, jobs = data.job,
        })
        return true
    end,
})
