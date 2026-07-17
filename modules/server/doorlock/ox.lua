Gravity.RegisterServerProvider('doorlock', 'ox_doorlock', {
    getDoor = function(doorId)
        return exports.ox_doorlock:getDoor(doorId)
    end,
    setState = function(doorId, locked)
        exports.ox_doorlock:setDoorState(doorId, locked)
        return true
    end,
})
