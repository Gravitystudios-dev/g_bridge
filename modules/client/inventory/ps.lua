Gravity.RegisterClientProvider('inventory', 'ps-inventory', {
    open = function(inventoryType, data) TriggerServerEvent('gravity_bridge:server:openInventory', inventoryType, data) return true end,
    getItemData = function(item) return Bridge.Adapter.core.Shared.Items[item] end,
    getItems = function() return Bridge.GetPlayerData().items or {} end,
    getItemCount = function(item)
        local count = 0
        for _, entry in pairs(Bridge.GetPlayerData().items or {}) do if entry.name == item then count = count + (entry.amount or 0) end end
        return count
    end,
})
