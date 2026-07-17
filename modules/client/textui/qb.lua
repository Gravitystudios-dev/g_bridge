Gravity.RegisterClientProvider('textui', 'qb-core', {
    show = function(text, options)
        return exports['qb-core']:DrawText(text, (options and options.position) or 'left')
    end,
    hide = function()
        return exports['qb-core']:HideText()
    end,
})
