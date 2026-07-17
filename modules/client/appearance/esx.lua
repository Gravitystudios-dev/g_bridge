Gravity.RegisterClientProvider('appearance', 'esx_skin', {
    open = function(data)
        TriggerEvent('esx_skin:openSaveableMenu', function()
            if data.onSubmit then data.onSubmit() end
        end, function()
            if data.onCancel then data.onCancel() end
        end)
        return true
    end,
    get = function()
        local result
        TriggerEvent('skinchanger:getSkin', function(skin) result = skin end)
        local expires = GetGameTimer() + 2000
        while result == nil and GetGameTimer() < expires do Wait(0) end
        return result
    end,
    set = function(appearance) TriggerEvent('skinchanger:loadSkin', appearance) return true end,
    setClothing = function(clothing) TriggerEvent('skinchanger:loadClothes', clothing.skin or {}, clothing) return true end,
})
