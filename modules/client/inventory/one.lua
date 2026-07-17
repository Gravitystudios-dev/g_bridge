Gravity.RegisterClientProvider('inventory', 'one_inventory', {
    open = function(inventoryType, data) exports.one_inventory:OpenInventory(inventoryType, data) return true end,
    getItemCount = function(item, metadata) return exports.one_inventory:GetItemCount(item, metadata) or 0 end,
    getItemData = function(item) return exports.one_inventory:GetItemDefinition(item) end,
    getItems = function() return exports.one_inventory:GetInventoryItems() or {} end,
    getCurrentWeapon = function() return exports.one_inventory:GetEquippedWeapon() end,
    disarm = function() exports.one_inventory:DisarmPlayer() return true end,
})
