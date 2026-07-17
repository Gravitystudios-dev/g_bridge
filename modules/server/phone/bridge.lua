function Bridge.SetPhoneDisabled(source, disabled)
    source = tonumber(source)
    if not source or source <= 0 or GetPlayerPing(source) < 0 then return false end
    TriggerClientEvent('gravity_bridge:client:phone', source, disabled == true)
    return true
end
