Gravity.RegisterClientProvider('notification', 'okokNotify', {
    send = function(message, notifyType, duration, options)
        return exports.okokNotify:Alert(options.title or 'Gravity Studios', message, duration, notifyType)
    end,
})
