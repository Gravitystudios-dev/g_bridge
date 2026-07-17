Gravity.RegisterClientProvider('input', 'esx_menu_dialog', {
    open = function(title, fields)
        local result, waiting = nil, true
        local field = fields[1] or {}
        Bridge.Adapter.core.UI.Menu.Open('dialog', GetCurrentResourceName(), ('gravity_input_%s'):format(GetGameTimer()), {
            title = title or field.label,
        }, function(data, menu)
            result, waiting = { value = data.value }, false
            menu.close()
        end, function(_, menu)
            waiting = false
            menu.close()
        end)
        while waiting do Wait(0) end
        return result
    end,
})
