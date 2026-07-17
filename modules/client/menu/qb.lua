Gravity.RegisterClientProvider('menu', 'qb-menu', {
    open = function(_, data)
        return exports['qb-menu']:openMenu(data.options or {})
    end,
    close = function()
        return exports['qb-menu']:closeMenu()
    end,
})
