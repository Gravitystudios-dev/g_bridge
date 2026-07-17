Gravity.RegisterClientProvider('notification', 'brutal_notify', {
    send = function(message, notifyType, duration, options)
        exports.brutal_notify:SendAlert(options.title or 'Gravity Studios', message, duration, notifyType)
        return true
    end,
})
