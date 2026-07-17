Gravity.RegisterServerProvider('inventory', 'ps-inventory', {
    getItem = function(source, item) return exports['ps-inventory']:GetItemByName(source, item) end,
    getItemCount = function(source, item) local entry = exports['ps-inventory']:GetItemByName(source, item) return entry and (entry.amount or entry.count or 0) or 0 end,
    getInventory = function(source) local inventory = exports['ps-inventory']:GetInventory(source) return inventory and (inventory.items or inventory) or {} end,
    canCarryItem = function() return true end,
    addItem = function(source, item, amount, metadata, slot) return exports['ps-inventory']:AddItem(source, item, amount, slot, metadata) ~= false end,
    removeItem = function(source, item, amount, _, slot) return exports['ps-inventory']:RemoveItem(source, item, amount, slot) ~= false end,
    registerUsableItem = function(item, callback) Bridge.Adapter.registerUsableItem(item, callback) return true end,
    getItemSlot = function(source, slot) return exports['ps-inventory']:GetItemBySlot(source, slot) end,
    getItemData = function(item) return Bridge.Adapter.core.Shared.Items[item] end,
    createShop = function(name, data)
        local items = data.inventory or data.items or {}
        exports['ps-inventory']:CreateShop({ name = name, label = data.label or name, slots = #items, items = items })
        return true
    end,
})
