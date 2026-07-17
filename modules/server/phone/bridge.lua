local function phoneProvider()
    return Gravity.GetServerProvider('phone', Config.Phone, { 'lb-phone', 'npwd', 'qs-smartphone-pro', 'yseries' })
end

local function validSource(source)
    source = tonumber(source)
    if not source or source <= 0 or GetPlayerPing(source) < 0 then return nil end
    return source
end

local function phoneAction(method, ...)
    local provider = phoneProvider()
    return provider and provider[method] and provider[method](...) or false
end

function Bridge.SetPhoneDisabled(source, disabled)
    source = validSource(source)
    if not source then return false end

    local provider = phoneProvider()
    if provider and provider.setDisabled then
        return provider.setDisabled(source, disabled == true) ~= false
    end

    -- Providers without a server export keep the existing client-event fallback.
    TriggerClientEvent('gravity_bridge:client:phone', source, disabled == true)
    return true
end

function Bridge.IsPhoneDisabled(source)
    source = validSource(source)
    if not source then return nil end
    local provider = phoneProvider()
    return provider and provider.isDisabled and provider.isDisabled(source) or nil
end

function Bridge.GetPhoneSourceByNumber(number)
    if type(number) ~= 'string' or number == '' then return nil end
    return phoneAction('getSourceByPhone', number)
end

function Bridge.GetPhoneSourceByImei(imei)
    if type(imei) ~= 'string' or imei == '' then return nil end
    return phoneAction('getSourceByImei', imei)
end

function Bridge.GetPhoneSourceByIdentifier(identifier)
    if type(identifier) ~= 'string' or identifier == '' then return nil end
    return phoneAction('getSourceByIdentifier', identifier)
end

function Bridge.GetPhoneNumber(source)
    source = validSource(source)
    if not source then return nil end
    return phoneAction('getPhoneNumberBySource', source)
end

function Bridge.GetPhoneNumberByImei(imei)
    if type(imei) ~= 'string' or imei == '' then return nil end
    return phoneAction('getPhoneNumberByImei', imei)
end

function Bridge.GetPhoneNumberByIdentifier(identifier)
    if type(identifier) ~= 'string' or identifier == '' then return nil end
    return phoneAction('getPhoneNumberByIdentifier', identifier)
end

function Bridge.GetPhoneImei(number)
    if type(number) ~= 'string' or number == '' then return nil end
    return phoneAction('getImeiByPhone', number)
end

function Bridge.GetPhoneImeiByIdentifier(identifier)
    if type(identifier) ~= 'string' or identifier == '' then return nil end
    return phoneAction('getImeiByIdentifier', identifier)
end

function Bridge.RecoverPhoneSim(imei, number)
    if type(imei) ~= 'string' or imei == '' or type(number) ~= 'string' or number == '' then return false end
    return phoneAction('recoverSim', imei, number)
end

function Bridge.ChangePhoneNumber(imei, number)
    if type(imei) ~= 'string' or imei == '' or type(number) ~= 'string' or number == '' then return false end
    return phoneAction('changePhoneNumber', imei, number)
end

function Bridge.GeneratePhoneNumber()
    return phoneAction('generatePhoneNumber')
end

function Bridge.CreatePhoneSim(source, number)
    source = validSource(source)
    if not source or (number ~= nil and type(number) ~= 'string') then return false end
    return phoneAction('createSimCard', source, number)
end

function Bridge.CreatePhoneCall(targetNumber, targetSource, callerNumber, callerSource, anonymous)
    if type(targetNumber) ~= 'string' or targetNumber == '' or type(callerNumber) ~= 'string' or callerNumber == '' then return false end
    callerSource = validSource(callerSource)
    targetSource = targetSource and validSource(targetSource) or nil
    if not callerSource then return false end
    return phoneAction('createCall', targetNumber, targetSource, callerNumber, callerSource, anonymous == true)
end

function Bridge.EndPhoneCall(callId)
    callId = tonumber(callId)
    if not callId then return false end
    return phoneAction('endCall', callId)
end

function Bridge.IsPlayerInPhoneCall(source)
    source = validSource(source)
    if not source then return false, nil end
    local provider = phoneProvider()
    if provider and provider.isInCall then return provider.isInCall(source) end
    return false, nil
end

function Bridge.CanReceivePhoneCalls(source)
    source = validSource(source)
    if not source then return false end
    return phoneAction('canReceiveCalls', source)
end

function Bridge.GetPhoneCallData(callId)
    callId = tonumber(callId)
    if not callId then return nil end
    return phoneAction('getCallData', callId)
end

function Bridge.RemovePlayerFromPhoneCall(source)
    source = validSource(source)
    if not source then return false end
    return phoneAction('removeFromCall', source)
end

function Bridge.SendPhoneMessage(from, to, message, attachments)
    if type(from) ~= 'string' or from == '' or (type(to) ~= 'string' and type(to) ~= 'table') or type(message) ~= 'string' or message == '' then return false end
    if attachments ~= nil and type(attachments) ~= 'string' then return false end
    return phoneAction('sendMessage', from, to, message, attachments)
end

function Bridge.SendPhoneMessageAdvanced(participants, message, senderNumber, phoneImei, channelId, attachments)
    if type(participants) ~= 'table' or type(message) ~= 'string' or message == '' or type(senderNumber) ~= 'string' or senderNumber == '' or type(phoneImei) ~= 'string' or phoneImei == '' then return false end
    return phoneAction('sendMessageAdvanced', participants, message, senderNumber, phoneImei, channelId, attachments)
end

function Bridge.SendPhoneMessageFromApp(source, phoneNumber, message, appName)
    source = validSource(source)
    if not source or type(phoneNumber) ~= 'string' or phoneNumber == '' or type(message) ~= 'string' or message == '' then return false end
    if appName ~= nil and type(appName) ~= 'string' then return false end
    return phoneAction('sendMessageFromApp', source, phoneNumber, message, appName)
end

function Bridge.GetPhoneMetadata(source)
    source = validSource(source)
    if not source then return nil end
    return phoneAction('getPhoneMetadata', source)
end

function Bridge.HasPhoneEmailAccount(source)
    source = validSource(source)
    if not source then return false end
    return phoneAction('hasEmailAccount', source)
end

function Bridge.SetPhoneJobDuty(source)
    source = validSource(source)
    if not source then return false end
    return phoneAction('setJobDuty', source)
end

function Bridge.RemovePhoneJobDuty(source)
    source = validSource(source)
    if not source then return false end
    return phoneAction('removeJobDuty', source)
end

function Bridge.IsPhoneJobDuty(source)
    source = validSource(source)
    if not source then return false end
    return phoneAction('isJobDuty', source)
end

function Bridge.SendPhoneNotification(notification, targetType, target)
    if type(notification) ~= 'table' or type(targetType) ~= 'string' or targetType == '' then return false end
    return phoneAction('sendNotification', notification, targetType, target)
end

function Bridge.SendPhoneMail(data, receiverType, receiver)
    if type(data) ~= 'table' or type(receiverType) ~= 'string' or receiverType == '' then return false end
    return phoneAction('sendMail', data, receiverType, receiver)
end

function Bridge.DeletePhoneMail(id)
    if id == nil then return false end
    return phoneAction('deleteMail', id)
end

function Bridge.SendPhoneCellBroadcast(target, title, content, iconUrl)
    target = validSource(target)
    if not target or type(title) ~= 'string' or title == '' or type(content) ~= 'string' or content == '' then return false end
    return phoneAction('sendCellBroadcast', target, title, content, iconUrl)
end

function Bridge.AddPhoneYPayTransaction(senderNumber, recipientNumber, amount, reason)
    if type(senderNumber) ~= 'string' or senderNumber == '' or type(recipientNumber) ~= 'string' or recipientNumber == '' or type(reason) ~= 'string' then return false end
    amount = tonumber(amount)
    if not amount or amount <= 0 then return false end
    return phoneAction('addYPayTransaction', senderNumber, recipientNumber, amount, reason)
end

function Bridge.SendDarkChatMessage(username, channel, message)
    if type(username) ~= 'string' or username == '' or type(channel) ~= 'string' or channel == '' or type(message) ~= 'string' or message == '' then return false end
    return phoneAction('sendDarkChatMessage', username, channel, message)
end

function Bridge.GetPhoneContacts(imei)
    if type(imei) ~= 'string' or imei == '' then return nil end
    return phoneAction('getContacts', imei)
end

function Bridge.BlockPhoneContact(contactData, imei)
    if type(contactData) ~= 'table' or type(imei) ~= 'string' or imei == '' then return false end
    return phoneAction('blockContact', contactData, imei)
end

function Bridge.GetBlockedPhoneNumbers(imei)
    if type(imei) ~= 'string' or imei == '' then return {} end
    return phoneAction('getBlockedNumbers', imei)
end

function Bridge.AddPhoneContact(number, data)
    if type(number) ~= 'string' or number == '' or type(data) ~= 'table' then return false end
    return phoneAction('addContact', number, data)
end

function Bridge.AddRecentPhoneCall(toNumber, imei, callType, anonymous)
    if type(toNumber) ~= 'string' or toNumber == '' or type(imei) ~= 'string' or imei == '' or type(callType) ~= 'string' or callType == '' then return false end
    return phoneAction('addRecentCall', toNumber, imei, callType, anonymous == true)
end

function Bridge.GetPhoneGroupLeader(groupId)
    groupId = tonumber(groupId)
    if not groupId then return nil end
    return phoneAction('getGroupLeader', groupId)
end

function Bridge.IsPhoneGroupLeader(groupId, source)
    groupId, source = tonumber(groupId), validSource(source)
    if not groupId or not source then return false end
    return phoneAction('isGroupLeader', groupId, source)
end

function Bridge.GetPhoneGroupMembers(groupId)
    groupId = tonumber(groupId)
    if not groupId then return {} end
    return phoneAction('getGroupMembers', groupId)
end

function Bridge.FindPhoneGroupByMember(source)
    source = validSource(source)
    if not source then return nil end
    return phoneAction('findGroupByMember', source)
end

function Bridge.GetPhoneJobStatus(groupId)
    groupId = tonumber(groupId)
    if not groupId then return nil end
    return phoneAction('getJobStatus', groupId)
end

function Bridge.SetPhoneJobStatus(groupId, status)
    groupId = tonumber(groupId)
    if not groupId or type(status) ~= 'string' or status == '' then return false end
    return phoneAction('setJobStatus', groupId, status)
end

function Bridge.GetPhoneGroupMembersCount(groupId)
    groupId = tonumber(groupId)
    if not groupId then return 0 end
    return phoneAction('getGroupMembersCount', groupId)
end

function Bridge.CreatePhoneGroupBlip(groupId, name, data)
    groupId = tonumber(groupId)
    if not groupId or type(name) ~= 'string' or name == '' or type(data) ~= 'table' then return false end
    return phoneAction('createGroupBlip', groupId, name, data)
end

function Bridge.RemovePhoneGroupBlip(groupId, name)
    groupId = tonumber(groupId)
    if not groupId or type(name) ~= 'string' or name == '' then return false end
    return phoneAction('removeGroupBlip', groupId, name)
end

function Bridge.SendPhoneGroupEvent(groupId, event, args)
    groupId = tonumber(groupId)
    if not groupId or type(event) ~= 'string' or event == '' then return false end
    return phoneAction('sendGroupEvent', groupId, event, args or {})
end

function Bridge.SetPhoneGroupData(groupId, key, data)
    groupId = tonumber(groupId)
    if not groupId or type(key) ~= 'string' or key == '' then return false end
    return phoneAction('setGroupData', groupId, key, data or {})
end

function Bridge.GetPhoneGroupData(groupId, key)
    groupId = tonumber(groupId)
    if not groupId or type(key) ~= 'string' or key == '' then return nil end
    return phoneAction('getGroupData', groupId, key)
end

function Bridge.DestroyPhoneGroupData(groupId, key)
    groupId = tonumber(groupId)
    if not groupId or type(key) ~= 'string' or key == '' then return false end
    return phoneAction('destroyGroupData', groupId, key)
end

function Bridge.NotifyPhoneGroup(groupId, message, timeout)
    groupId = tonumber(groupId)
    if not groupId or type(message) ~= 'string' or message == '' then return false end
    return phoneAction('notifyGroup', groupId, message, timeout)
end
