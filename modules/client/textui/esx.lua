Gravity.RegisterClientProvider('textui', 'es_extended', {
    show = function(text)
        Bridge.Adapter.core.ShowHelpNotification(text)
        return true
    end,
    hide = function()
        return true
    end,
})
