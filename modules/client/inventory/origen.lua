Gravity.RegisterClientProvider('inventory', 'origen_inventory', {
    open = function(inventoryType, data) exports.origen_inventory:openInventory(inventoryType, data) return true end,
    getItemCount = function(item, metadata) return exports.origen_inventory:Search('count', item, metadata) or 0 end,
    getItemData = function(item) return exports.origen_inventory:Items(item) end,
    getItems = function() return exports.origen_inventory:getPlayerInventory() or {} end,
})
