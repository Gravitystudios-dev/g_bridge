Gravity.RegisterClientProvider('inventory', 'qb-inventory', {
    open = function(inventoryType, data)
        TriggerServerEvent('inventory:server:OpenInventory', inventoryType, data)
        TriggerEvent('inventory:client:SetCurrentStash', data)
        return true
    end,
    getItemCount = function(item)
        local count = 0
        for _, entry in pairs(Bridge.GetPlayerData().items or {}) do
            if entry.name == item then count = count + (entry.amount or entry.count or 0) end
        end
        return count
    end,
    getItemData = function(item) return Bridge.Adapter.core.Shared.Items[item] end,
    getItems = function() return Bridge.GetPlayerData().items or {} end,
})
