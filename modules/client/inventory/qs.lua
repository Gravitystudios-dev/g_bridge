Gravity.RegisterClientProvider('inventory', 'qs-inventory', {
    open = function(inventoryType, data)
        TriggerServerEvent('inventory:server:OpenInventory', inventoryType, data)
        TriggerEvent('inventory:client:SetCurrentStash', data)
        return true
    end,
    getItemCount = function(item)
        local count = 0
        for _, entry in pairs(exports['qs-inventory']:getUserInventory() or {}) do
            if entry.name == item then count = count + (entry.amount or entry.count or 0) end
        end
        return count
    end,
    getItemData = function(item)
        local items = exports['qs-inventory']:GetItemList() or {}
        return items[item]
    end,
    getItems = function() return exports['qs-inventory']:getUserInventory() or {} end,
})
