Gravity.RegisterClientProvider('menu', 'ox_lib', {
    open = function(id, data)
        exports.ox_lib:registerContext({ id = id, title = data.title or id, menu = data.menu, options = data.options or {}, canClose = data.canClose ~= false })
        return exports.ox_lib:showContext(id)
    end,
    close = function() return exports.ox_lib:hideContext() end,
})
