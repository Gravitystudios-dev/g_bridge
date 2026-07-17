Gravity.RegisterClientProvider('appearance', 'illenium-appearance', {
    open = function(data)
        TriggerEvent('illenium-appearance:client:openClothingShopMenu', data.isPedMenu or false)
        return true
    end,
    get = function() return exports['illenium-appearance']:getPedAppearance(PlayerPedId()) end,
    set = function(appearance) exports['illenium-appearance']:setPlayerAppearance(appearance) return true end,
    setClothing = function(clothing)
        exports['illenium-appearance']:setPedComponents(PlayerPedId(), clothing.components or {})
        exports['illenium-appearance']:setPedProps(PlayerPedId(), clothing.props or {})
        return true
    end,
})
