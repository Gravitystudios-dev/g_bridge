Gravity.RegisterClientProvider('menu', 'esx_menu_default', {
    open = function(id, data)
        local elements = {}
        for index, option in ipairs(data.options or {}) do elements[index] = { label = option.label or option.title, value = index } end
        Bridge.Adapter.core.UI.Menu.Open('default', GetCurrentResourceName(), id, { title = data.title or id, align = data.align or 'top-left', elements = elements }, function(selection, menu)
            local option = data.options[selection.current.value]
            if option.onSelect then option.onSelect(option) end
            if option.event then TriggerEvent(option.event, option.args) end
            if option.close ~= false then menu.close() end
        end, function(_, menu) menu.close() end)
        return true
    end,
    close = function() return Bridge.Adapter.core.UI.Menu.CloseAll() end,
})
