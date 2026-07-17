Gravity.RegisterClientProvider('notification', 'es_extended', {
    send = function(message, notifyType, duration)
        return Bridge.Adapter.notify(message, notifyType, duration)
    end,
})
