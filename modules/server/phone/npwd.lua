Gravity.RegisterServerProvider('phone', 'npwd', {
    generatePhoneNumber = function()
        return exports.npwd:generatePhoneNumber()
    end,
    getPhoneNumberBySource = function(source)
        local data = exports.npwd:getPlayerData({ source = source })
        return data and data.phoneNumber or nil
    end,
    getPhoneNumberByIdentifier = function(identifier)
        local data = exports.npwd:getPlayerData({ identifier = identifier })
        return data and data.phoneNumber or nil
    end,
    canReceiveCalls = function(source)
        return exports.npwd:isPlayerBusy(source) ~= true
    end,
    sendMessage = function(from, to, message, attachments)
        if type(to) ~= 'string' or attachments ~= nil then return false end
        return exports.npwd:emitMessage({
            senderNumber = from,
            targetNumber = to,
            message = message,
        })
    end,
})
