Gravity.RegisterServerProvider('dispatch', 'lb-tablet', {
    send = function(_, data)
        local jobs = type(data.job) == 'table' and data.job or { data.job or 'police' }
        for _, job in ipairs(jobs) do
            exports['lb-tablet']:AddDispatch({
                priority = data.priority, code = data.code, title = data.title, description = data.description or ('%s - %s'):format(data.code, data.title),
                location = { label = data.street or '', coords = vec2(data.coords.x, data.coords.y) }, time = data.time * 60, job = job,
                blip = { sprite = data.blip.sprite or 1, size = data.blip.scale or 1.2, color = data.blip.color or 3, shortRange = data.blip.short ~= false, label = data.blip.name or data.title, flashes = data.priority == 'high' },
            })
        end
        return true
    end,
})
