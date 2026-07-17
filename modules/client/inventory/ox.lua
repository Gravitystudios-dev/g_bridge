Gravity.RegisterClientProvider('inventory', 'ox_inventory', {
    open = function(inventoryType, data)
        exports.ox_inventory:openInventory(inventoryType, data)
        return true
    end,
    getItemCount = function(item, metadata) return exports.ox_inventory:Search('count', item, metadata) or 0 end,
    getItemData = function(item) return exports.ox_inventory:Items(item) end,
    getItems = function() return exports.ox_inventory:GetPlayerItems() or {} end,
    getCurrentWeapon = function() return exports.ox_inventory:getCurrentWeapon() end,
    disarm = function(state) TriggerEvent('ox_inventory:disarm', state ~= false) return true end,
})
