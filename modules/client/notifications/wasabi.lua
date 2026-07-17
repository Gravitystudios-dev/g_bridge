Gravity.RegisterClientProvider('notification', 'wasabi_uikit', {
    send = function(message, notifyType, duration, options)
        exports.wasabi_uikit:Notification({ title = options.title or message, description = options.title and message or nil, type = notifyType == 'inform' and 'info' or notifyType, duration = duration })
        return true
    end,
})
