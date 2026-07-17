Gravity.RegisterServerProvider('phone', 'yseries', {
    setDisabled = function(source, disabled)
        return exports.yseries:ToggleDisabled(source, disabled == true) ~= false
    end,
    isDisabled = function(source)
        return exports.yseries:IsDisabled(source)
    end,
    getSourceByPhone = function(phoneNumber)
        return exports.yseries:GetPlayerSourceIdByPhoneNumber(phoneNumber)
    end,
    getSourceByImei = function(phoneImei)
        return exports.yseries:GetPlayerSourceIdByPhoneImei(phoneImei)
    end,
    getSourceByIdentifier = function(identifier)
        return exports.yseries:GetPlayerSourceIdByIdentifier(identifier)
    end,
    getPhoneNumberByIdentifier = function(identifier)
        return exports.yseries:GetPhoneNumberByIdentifier(identifier)
    end,
    getPhoneNumberByImei = function(phoneImei)
        return exports.yseries:GetPhoneNumberByImei(phoneImei)
    end,
    getPhoneNumberBySource = function(source)
        return exports.yseries:GetPhoneNumberBySourceId(source)
    end,
    getImeiByPhone = function(phoneNumber)
        return exports.yseries:GetPhoneImeiByPhoneNumber(phoneNumber)
    end,
    getImeiByIdentifier = function(identifier)
        return exports.yseries:GetPhoneImeiByIdentifier(identifier)
    end,
    recoverSim = function(phoneImei, simNumber)
        return exports.yseries:RecoverSimCard(phoneImei, simNumber)
    end,
    changePhoneNumber = function(phoneImei, simNumber)
        return exports.yseries:ChangePhoneNumber(phoneImei, simNumber)
    end,
    generatePhoneNumber = function() return exports.yseries:GeneratePhoneNumber() end,
    createSimCard = function(source, simNumber)
        return exports.yseries:CreateSimCard(source, simNumber)
    end,
    createCall = function(targetNumber, targetSource, callerNumber, callerSource, anonymous)
        return exports.yseries:CallContact(targetNumber, targetSource, callerNumber, callerSource, anonymous == true)
    end,
    endCall = function(callId) return exports.yseries:EndCall(callId) end,
    isInCall = function(source) return exports.yseries:IsInCall(source) end,
    canReceiveCalls = function(source) return exports.yseries:CanReceiveCalls(source) == true end,
    getCallData = function(callId) return exports.yseries:GetCallData(callId) end,
    removeFromCall = function(source)
        exports.yseries:RemovePlayerFromServerCall(source)
        return true
    end,
    sendMessage = function(from, to, message, attachments)
        return exports.yseries:SendMessageTo(from, to, message, attachments)
    end,
    sendMessageAdvanced = function(participants, message, senderNumber, phoneImei, channelId, attachments)
        return exports.yseries:SendMessage(participants, message, senderNumber, phoneImei, channelId, attachments)
    end,
    sendNotification = function(notification, targetType, target)
        return exports.yseries:SendNotification(notification, targetType, target)
    end,
    sendMail = function(data, receiverType, receiver)
        return exports.yseries:SendMail(data, receiverType, receiver)
    end,
    deleteMail = function(id) return exports.yseries:DeleteMail(id) end,
    sendCellBroadcast = function(target, title, content, iconUrl)
        return exports.yseries:CellBroadcast(target, title, content, iconUrl)
    end,
    addYPayTransaction = function(senderNumber, recipientNumber, amount, reason)
        return exports.yseries:YPayAddTransaction(senderNumber, recipientNumber, amount, reason)
    end,
    sendDarkChatMessage = function(username, channel, message)
        return exports.yseries:SendDarkChatMessage(username, channel, message)
    end,
    getContacts = function(phoneImei) return exports.yseries:GetContacts(phoneImei) end,
    blockContact = function(contactData, phoneImei)
        return exports.yseries:BlockContact(contactData, phoneImei)
    end,
    getBlockedNumbers = function(phoneImei)
        return exports.yseries:GetBlockedNumbers(phoneImei)
    end,
    addContact = function(phoneNumber, data)
        return exports.yseries:AddContact(phoneNumber, data)
    end,
    addRecentCall = function(toNumber, phoneImei, callType, anonymous)
        return exports.yseries:AddRecentCall(toNumber, phoneImei, callType, anonymous == true)
    end,
    getGroupLeader = function(groupId) return exports.yseries:GetGroupLeader(groupId) end,
    isGroupLeader = function(groupId, source) return exports.yseries:IsGroupLeader(groupId, source) == true end,
    getGroupMembers = function(groupId) return exports.yseries:GetGroupMembers(groupId) end,
    findGroupByMember = function(source) return exports.yseries:FindGroupByMember(source) end,
    getJobStatus = function(groupId) return exports.yseries:GetJobStatus(groupId) end,
    setJobStatus = function(groupId, status) return exports.yseries:SetJobStatus(groupId, status) end,
    getGroupMembersCount = function(groupId) return exports.yseries:GetGroupMembersCount(groupId) end,
    createGroupBlip = function(groupId, name, data)
        return exports.yseries:CreateBlipForGroup(groupId, name, data)
    end,
    removeGroupBlip = function(groupId, name)
        return exports.yseries:RemoveBlipForGroup(groupId, name)
    end,
    sendGroupEvent = function(groupId, event, args)
        return exports.yseries:SendGroupEvent(groupId, event, args)
    end,
    setGroupData = function(groupId, key, data)
        return exports.yseries:SetGroupData(groupId, key, data)
    end,
    getGroupData = function(groupId, key)
        return exports.yseries:GetGroupData(groupId, key)
    end,
    destroyGroupData = function(groupId, key)
        return exports.yseries:DestroyGroupData(groupId, key)
    end,
    notifyGroup = function(groupId, message, timeout)
        return exports.yseries:NotifyGroup(groupId, message, timeout)
    end,
})
