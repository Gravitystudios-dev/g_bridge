Gravity.RegisterClientProvider('phone', 'yseries', {
    setDisabled = function(disabled)
        exports.yseries:ToggleDisabled(disabled == true)
        return true
    end,
    open = function() exports.yseries:ToggleOpen(true) return true end,
    close = function() exports.yseries:ToggleOpen(false) return true end,
    isOpen = function() return exports.yseries:IsOpen() == true end,
    isDisabled = function() return exports.yseries:IsDisabled() == true end,
    closeApp = function() exports.yseries:CloseApp() return true end,
    createCall = function(number, options) return exports.yseries:CreateCall(number, options) == true end,
    isInCall = function() return exports.yseries:IsInCall() end,
    cancelCall = function() exports.yseries:CancelCall() return true end,
    getCallStatus = function(number) return exports.yseries:GetTargetPlayerCallStatus(number) end,
    getCallConfig = function() return exports.yseries:GetCallConfig() end,
    getJobStage = function() return exports.yseries:GetJobStage() end,
    getGroupId = function() return exports.yseries:GetGroupId() end,
    isGroupLeader = function() return exports.yseries:IsGroupLeader() == true end,
    sendCompanyMessage = function(company, message, showLocation, anonymous)
        exports.yseries:SendCompanyMessage(company, message, showLocation, anonymous == true)
        return true
    end,
    isAirplaneModeEnabled = function() return exports.yseries:AirplaneModeEnabled() == true end,
    isStreamerModeEnabled = function() return exports.yseries:StreamerModeEnabled() == true end,
    setStreamerMode = function(enabled, updateUi)
        exports.yseries:UpdateStreamerMode(enabled == true, updateUi ~= false)
        return true
    end,
    setFlashlight = function(enabled)
        exports.yseries:ToggleFlashlight(enabled == true)
        return true
    end,
    getFlashlightState = function() return exports.yseries:GetFlashlightState() == true end,
    sendAppMessage = function(appId, data)
        exports.yseries:SendAppMessage(appId, data or {})
        return true
    end,
    setLandscape = function(enabled)
        if enabled == nil then
            exports.yseries:ToggleLandscape()
        else
            exports.yseries:ToggleLandscape(enabled == true)
        end
        return true
    end,
    isAppInstalled = function(appId) return exports.yseries:IsAppInstalled(appId) == true end,
    getCurrentApp = function(appId) return exports.yseries:GetCurrentAppId(appId) end,
    setNuiFocusKeepInput = function(focus)
        exports.yseries:SetNuiFocusKeepInput(focus == true)
        return true
    end,
})
