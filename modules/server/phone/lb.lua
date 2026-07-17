Gravity.RegisterServerProvider('phone', 'lb-phone', {
    getSourceByPhone = function(phoneNumber)
        return exports['lb-phone']:GetSourceFromNumber(phoneNumber)
    end,
    getPhoneNumberBySource = function(source)
        return exports['lb-phone']:GetEquippedPhoneNumber(source)
    end,
    getPhoneNumberByIdentifier = function(identifier)
        return exports['lb-phone']:GetEquippedPhoneNumber(identifier)
    end,
    sendNotification = function(notification, targetType, target)
        if targetType == 'source' then target = tonumber(target) end
        if target == nil then return false end
        return exports['lb-phone']:SendNotification(target, notification)
    end,
    sendMessage = function(from, to, message, attachments)
        if type(to) ~= 'string' then return false end
        return exports['lb-phone']:SendMessage(from, to, message, attachments)
    end,
    sendMail = function(data)
        return exports['lb-phone']:SendMail(data)
    end,
    deleteMail = function(id)
        return exports['lb-phone']:DeleteMail(id)
    end,
    addContact = function(phoneNumber, data)
        return exports['lb-phone']:AddContact(phoneNumber, data)
    end,
    createCall = function(targetNumber, _, callerNumber, callerSource, anonymous)
        return exports['lb-phone']:CreateCall({
            source = callerSource,
            phoneNumber = callerNumber,
        }, targetNumber, {
            requirePhone = false,
            hideNumber = anonymous == true,
        })
    end,
    getCallData = function(callId)
        return exports['lb-phone']:GetCall(callId)
    end,
    endCall = function(callId)
        local call = exports['lb-phone']:GetCall(callId)
        local source = call and call.caller and call.caller.source
        if not source and call and call.callee then source = call.callee.source end
        if not source then return false end
        return exports['lb-phone']:EndCall(source)
    end,
    isInCall = function(source)
        return exports['lb-phone']:IsInCall(source)
    end,
    canReceiveCalls = function(source)
        local inCall = exports['lb-phone']:IsInCall(source)
        return inCall ~= true
    end,
    sendDarkChatMessage = function(username, channel, message)
        return exports['lb-phone']:SendDarkChatMessage(username, channel, message)
    end,
})
