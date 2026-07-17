local function findItem(items, name)
    for _, item in pairs(items or {}) do if item.name == name then return item end end
end

Gravity.RegisterServerProvider('inventory', 'core_inventory', {
    getItem = function(source, item) return findItem(exports.core_inventory:getItems(source), item) end,
    getItemCount = function(source, item) return exports.core_inventory:getItemCount(source, item) or 0 end,
    getInventory = function(source) return exports.core_inventory:getItems(source) or {} end,
    canCarryItem = function() return true end,
    addItem = function(source, item, amount, metadata) return exports.core_inventory:addItem(source, item, amount, metadata) ~= false end,
    removeItem = function(source, item, amount) return exports.core_inventory:removeItem(source, item, amount) ~= false end,
    registerUsableItem = function(item, callback) Bridge.Adapter.registerUsableItem(item, callback) return true end,
    getItemSlot = function(source, slot) return exports.core_inventory:getItemBySlot(source, slot) end,
})
