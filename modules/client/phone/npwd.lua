Gravity.RegisterClientProvider('phone', 'npwd', {
    setDisabled = function(disabled) exports.npwd:setPhoneDisabled(disabled) return true end,
    open = function() exports.npwd:setPhoneVisible(true) return true end,
    close = function() exports.npwd:setPhoneVisible(false) return true end,
    isOpen = function() return exports.npwd:isPhoneVisible() == true end,
    isDisabled = function() return exports.npwd:isPhoneDisabled() == true end,
    getPhoneNumber = function() return exports.npwd:getPhoneNumber() end,
    createCall = function(number) return exports.npwd:startPhoneCall(number) ~= false end,
    isInCall = function() return exports.npwd:isInCall() == true end,
    cancelCall = function() exports.npwd:endCall() return true end,
    sendAppMessage = function(_, data)
        exports.npwd:sendUIMessage(data or {})
        return true
    end,
})
