Gravity.RegisterServerProvider('vehiclekeys', 'qbx_vehiclekeys', {
    hasKeys = function(source, vehicle)
        return exports.qbx_vehiclekeys:HasKeys(source, vehicle)
    end,
    give = function(source, vehicle, skipNotification)
        return exports.qbx_vehiclekeys:GiveKeys(source, vehicle, skipNotification) ~= false
    end,
    remove = function(source, vehicle, skipNotification)
        return exports.qbx_vehiclekeys:RemoveKeys(source, vehicle, skipNotification) ~= false
    end,
})
