Gravity.RegisterClientProvider('notification', 'vms_notifyv2', {
    send = function(message, notifyType, duration, options)
        exports.vms_notifyv2:Notification({ title = options.title, description = message, type = notifyType, time = duration })
        return true
    end,
})
