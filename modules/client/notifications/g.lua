Gravity.RegisterClientProvider('notification', 'g-notifications', {
    send = function(message, notifyType, duration, options)
        exports['g-notifications']:Notify({ title = options.title or 'Notification', description = message, type = notifyType == 'inform' and 'info' or notifyType, duration = duration })
        return true
    end,
})
