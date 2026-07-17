Gravity.RegisterServerProvider('dispatch', 'cd_dispatch', {
    send = function(_, data)
        TriggerClientEvent('cd_dispatch:AddNotification', -1, {
            job_table = data.job, coords = data.coords, title = data.code, message = data.title,
            unique_id = ('gravity_%s_%s'):format(os.time(), math.random(1000, 9999)), sound = 1,
            blip = { sprite = data.blip.sprite or 1, scale = data.blip.scale or 1.2, colour = data.blip.color or 3, flashes = data.priority == 'high', text = data.blip.name or ('%s - %s'):format(data.code, data.title), time = data.time, radius = data.blip.radius or 0 },
        })
        return true
    end,
})
