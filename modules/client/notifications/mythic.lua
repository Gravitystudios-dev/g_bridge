Gravity.RegisterClientProvider('notification', 'mythic_notify', {
    send = function(message, notifyType, duration)
        return exports.mythic_notify:SendAlert(notifyType, message, duration)
    end,
})
