Gravity.RegisterClientProvider('inventory', 'core_inventory', {
    open = function(inventoryType, data)
        local inventory = type(data) == 'table' and (data.id or data) or data
        TriggerServerEvent('core_inventory:server:openInventory', inventoryType == 'player' and data or inventory, inventoryType == 'player' and 'otherplayer' or inventoryType)
        return true
    end,
    getItemCount = function(item) return exports.core_inventory:getItemCount(item) or 0 end,
    getItems = function() return exports.core_inventory:getInventory() or {} end,
})
