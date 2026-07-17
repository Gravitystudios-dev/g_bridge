Gravity.RegisterClientProvider('inventory', 'codem-inventory', {
    open = function(inventoryType, data)
        if inventoryType == 'player' then TriggerEvent('codem-inventory:client:openplayerinventory', data)
        elseif inventoryType == 'shop' then TriggerEvent('codem-inventory:openshop', data.type)
        else TriggerServerEvent('inventory:server:OpenInventory', inventoryType, data) end
        return true
    end,
    getItemCount = function(item) return exports['codem-inventory']:GetItemsTotalAmount(item) or 0 end,
    getItemData = function(item) local items = exports['codem-inventory']:GetItemList() or {} return items[item] end,
    getItems = function() local inventory = exports['codem-inventory']:GetClientPlayerInventory() or {} return inventory.items or inventory.inventory or inventory end,
})
