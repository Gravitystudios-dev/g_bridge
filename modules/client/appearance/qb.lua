Gravity.RegisterClientProvider('appearance', 'qb-clothing', {
    open = function()
        TriggerEvent('qb-clothing:client:openOutfitMenu')
        return true
    end,
    set = function(appearance)
        TriggerEvent('qb-clothing:client:loadPlayerClothing', appearance, PlayerPedId())
        return true
    end,
    setClothing = function(clothing)
        TriggerEvent('qb-clothing:client:loadOutfit', { outfitData = clothing })
        return true
    end,
})
