local function findItem(items, name)
    for _, item in pairs(items or {}) do if item.name == name then return item end end
end

Gravity.RegisterServerProvider('inventory', 'codem-inventory', {
    getItem = function(source, item) return findItem(exports['codem-inventory']:GetInventory(source), item) end,
    getItemCount = function(source, item) return exports['codem-inventory']:GetItemsTotalAmount(source, item) or 0 end,
    getInventory = function(source) return exports['codem-inventory']:GetInventory(source) or {} end,
    canCarryItem = function() return true end,
    addItem = function(source, item, amount, metadata, slot) return exports['codem-inventory']:AddItem(source, item, amount, slot, metadata) ~= false end,
    removeItem = function(source, item, amount, _, slot) return exports['codem-inventory']:RemoveItem(source, item, amount, slot) ~= false end,
    registerUsableItem = function(item, callback) Bridge.Adapter.registerUsableItem(item, callback) return true end,
    getItemSlot = function(source, slot) return exports['codem-inventory']:GetItemBySlot(source, slot) end,
})
