Gravity.RegisterServerProvider('dispatch', 'tk_dispatch', {
    send = function(_, data)
        exports.tk_dispatch:addCall({
            title = data.title, code = data.code, priority = data.priority, coords = data.coords, showTime = (data.notify or 5) * 1000, jobs = data.job,
            blip = { sprite = data.blip.sprite or 1, scale = data.blip.scale or 1.1, color = data.blip.color or 1, flash = data.priority == 'high', shortRange = data.blip.short ~= false },
        })
        return true
    end,
})
