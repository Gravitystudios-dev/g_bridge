Gravity.RegisterClientProvider('notification', 'ox_lib', {
    send = function(message, notifyType, duration, options)
        return exports.ox_lib:notify({ title = options.title, description = message, type = notifyType, duration = duration, position = options.position })
    end,
})
