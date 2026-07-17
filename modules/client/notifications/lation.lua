Gravity.RegisterClientProvider('notification', 'lation_ui', {
    send = function(message, notifyType, duration, options)
        exports.lation_ui:notify({ title = options.title, message = message, type = notifyType, duration = duration, icon = options.icon })
        return true
    end,
})
