Gravity.RegisterClientProvider('notification', 'qb-core', {
    send = function(message, notifyType, duration)
        return Bridge.Adapter.notify(message, notifyType, duration)
    end,
})
