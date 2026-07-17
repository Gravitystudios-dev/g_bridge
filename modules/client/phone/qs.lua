Gravity.RegisterClientProvider('phone', 'qs-smartphone-pro', {
    setDisabled = function(disabled) exports['qs-smartphone-pro']:SetCanOpenPhone(not disabled) return true end,
    close = function() exports['qs-smartphone-pro']:ClosePhone() return true end,
    isOpen = function() return exports['qs-smartphone-pro']:InPhone() == true end,
    isInCamera = function() return exports['qs-smartphone-pro']:IsInCamera() == true end,
    createCall = function(number, options)
        options = type(options) == 'table' and options or {}
        return exports['qs-smartphone-pro']:createCall(options.name or 'Unknown', number, options.image, options.anonymous == true) ~= false
    end,
    isInCall = function() return exports['qs-smartphone-pro']:isInCall() == true end,
    cancelCall = function() exports['qs-smartphone-pro']:endCall() return true end,
    setSOS = function(enabled) exports['qs-smartphone-pro']:setSOS(enabled == true) return true end,
})
