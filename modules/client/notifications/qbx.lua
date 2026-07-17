Gravity.RegisterClientProvider('notification', 'qbx_core', {
    send = function(message, notifyType, duration, options)
        return exports.qbx_core:Notify(
            message,
            notifyType or 'inform',
            duration or 5000,
            options.title,
            options.position,
            options.style,
            options.icon,
            options.iconColor
        )
    end,
})
