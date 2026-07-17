Gravity.RegisterServerProvider('phone', 'qs-smartphone-pro', {
    getPhoneNumberByIdentifier = function(identifier)
        return exports['qs-smartphone-pro']:GetPhoneNumberFromIdentifier(identifier, true)
    end,
    getPhoneMetadata = function(source)
        return exports['qs-smartphone-pro']:getMetaFromSource(source)
    end,
    sendMessageFromApp = function(source, phoneNumber, message, appName)
        return exports['qs-smartphone-pro']:sendNewMessageFromApp(source, phoneNumber, message, appName)
    end,
    hasEmailAccount = function(source)
        return exports['qs-smartphone-pro']:hasEmailAccount(source) == true
    end,
    setJobDuty = function(source)
        return exports['qs-smartphone-pro']:setInJobDuty(source)
    end,
    removeJobDuty = function(source)
        return exports['qs-smartphone-pro']:removeFromJobDuty(source)
    end,
    isJobDuty = function(source)
        return exports['qs-smartphone-pro']:isInJobDuty(source) == true
    end,
})
