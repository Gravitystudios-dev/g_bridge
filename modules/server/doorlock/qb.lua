Gravity.RegisterServerProvider('doorlock', 'qb-doorlock', {
    getDoor = function()
        -- qb-doorlock does not expose a stable public getter for door definitions.
        return nil
    end,
    setState = function(doorId, locked)
        TriggerEvent('qb-doorlock:server:updateState', doorId, locked, 0, false, false, true, true)
        return true
    end,
})
