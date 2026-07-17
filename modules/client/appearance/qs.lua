Gravity.RegisterClientProvider('appearance', 'qs-appearance', {
    open = function(data)
        local config = data.config or exports['qs-appearance']:GetDefaultConfig()

        exports['qs-appearance']:startPlayerCustomization(function(appearance)
            if data.onSubmit then data.onSubmit(appearance) end
        end, config)

        return true
    end,
    get = function() return exports['qs-appearance']:getPedAppearance(PlayerPedId()) end,
    set = function(appearance) exports['qs-appearance']:setPlayerAppearance(appearance) return true end,
    setClothing = function(clothing)
        exports['qs-appearance']:setPedComponents(PlayerPedId(), clothing.components or {})
        exports['qs-appearance']:setPedProps(PlayerPedId(), clothing.props or {})
        return true
    end,
})
