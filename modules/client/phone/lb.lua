Gravity.RegisterClientProvider('phone', 'lb-phone', {
    setDisabled = function(disabled) exports['lb-phone']:ToggleDisabled(disabled) return true end,
    open = function() exports['lb-phone']:ToggleOpen(true) return true end,
    close = function() exports['lb-phone']:ToggleOpen(false) return true end,
    isOpen = function() return exports['lb-phone']:IsOpen() == true end,
    isDisabled = function() return exports['lb-phone']:IsDisabled() == true end,
    getPhoneNumber = function() return exports['lb-phone']:GetEquippedPhoneNumber() end,
    closeApp = function() exports['lb-phone']:CloseApp() return true end,
    createCall = function(number, options)
        options = type(options) == 'table' and options or {}
        options.number = number or options.number
        return exports['lb-phone']:CreateCall(options) ~= false
    end,
    isInCall = function() return exports['lb-phone']:IsInCall() end,
    sendCompanyMessage = function(company, message, showLocation, anonymous)
        if showLocation then
            exports['lb-phone']:SendCompanyCoords(company, nil, anonymous == true)
        else
            exports['lb-phone']:SendCompanyMessage(company, message, anonymous == true)
        end
        return true
    end,
    isAirplaneModeEnabled = function() return exports['lb-phone']:GetAirplaneMode() == true end,
    isStreamerModeEnabled = function() return exports['lb-phone']:GetStreamerMode() == true end,
    setFlashlight = function(enabled) exports['lb-phone']:ToggleFlashlight(enabled == true) return true end,
    getFlashlightState = function() return exports['lb-phone']:GetFlashlight() == true end,
    sendAppMessage = function(appId, data)
        exports['lb-phone']:SendCustomAppMessage(appId, data or {})
        return true
    end,
    setLandscape = function(enabled) exports['lb-phone']:ToggleLandscape(enabled == true) return true end,
})
