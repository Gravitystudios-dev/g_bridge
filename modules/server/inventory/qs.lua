Gravity.RegisterServerProvider('inventory', 'qs-inventory', {
    getItem = function(source, item)
        local inventory = exports['qs-inventory']:GetInventory(source) or {}

        for _, entry in pairs(inventory) do
            if entry.name == item then return entry end
        end
    end,
    getItemCount = function(source, item)
        return exports['qs-inventory']:GetItemTotalAmount(source, item) or 0
    end,
    getInventory = function(source)
        return exports['qs-inventory']:GetInventory(source) or {}
    end,
    canCarryItem = function(source, item, amount)
        return exports['qs-inventory']:CanCarryItem(source, item, amount)
    end,
    addItem = function(source, item, amount, metadata)
        return exports['qs-inventory']:AddItem(source, item, amount, nil, metadata) ~= false
    end,
    removeItem = function(source, item, amount, metadata)
        return exports['qs-inventory']:RemoveItem(source, item, amount, nil, metadata) ~= false
    end,
    registerUsableItem = function(item, callback)
        exports['qs-inventory']:CreateUsableItem(item, callback)
        return true
    end,
    getItemSlot = function(source, slot)
        local inventory = exports['qs-inventory']:GetInventory(source) or {}
        return inventory[slot]
    end,
    getItemData = function(item)
        local items = exports['qs-inventory']:GetItemList() or {}
        return items[item]
    end,
})
