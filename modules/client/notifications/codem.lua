Gravity.RegisterClientProvider('notification', 'codem-notification', {
    send = function(message, notifyType, duration)
        TriggerEvent('codem-notification:Create', message, notifyType, nil, duration)
        return true
    end,
})
