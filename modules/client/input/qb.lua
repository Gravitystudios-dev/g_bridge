Gravity.RegisterClientProvider('input', 'qb-input', {
    open = function(title, fields)
        return exports['qb-input']:ShowInput({ header = title, inputs = fields })
    end,
})
