Gravity.RegisterClientProvider('appearance', 'fivem-appearance', {
    open = function(data)
        TriggerEvent('fivem-appearance:client:openClothingShopMenu', data.isPedMenu or false)
        return true
    end,
    get = function() return exports['fivem-appearance']:getPedAppearance(PlayerPedId()) end,
    set = function(appearance) exports['fivem-appearance']:setPlayerAppearance(appearance) return true end,
    setClothing = function(clothing)
        exports['fivem-appearance']:setPedComponents(PlayerPedId(), clothing.components or {})
        exports['fivem-appearance']:setPedProps(PlayerPedId(), clothing.props or {})
        return true
    end,
})
