Gravity.RegisterClientProvider('notification', 'is_ui', {
    send = function(message, notifyType, duration, options)
        exports.is_ui:Notify(message, options.title, duration, notifyType)
        return true
    end,
})
