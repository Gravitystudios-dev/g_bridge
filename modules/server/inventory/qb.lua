-- qb-inventory stores player items through QBCore; this keeps that integration isolated.
Gravity.RegisterServerProvider('inventory', 'qb-inventory', {
    getItem = function(source, item)
        local player = Bridge.GetPlayer(source)
        return player and Bridge.Adapter.getItem(player, item) or nil
    end,
    getItemCount = function(source, item)
        local data = Bridge.GetItem(source, item)
        return data and (data.count or data.amount or 0) or 0
    end,
    getInventory = function(source)
        local player = Bridge.GetPlayer(source)
        return player and Bridge.Adapter.getInventory(player) or {}
    end,
    canCarryItem = function(source, item, amount)
        local player = Bridge.GetPlayer(source)
        return player and Bridge.Adapter.canCarryItem(player, item, amount) or false
    end,
    addItem = function(source, item, amount, metadata)
        local player = Bridge.GetPlayer(source)
        return player and Bridge.Adapter.addItem(player, item, amount, metadata) ~= false
    end,
    removeItem = function(source, item, amount, metadata)
        local player = Bridge.GetPlayer(source)
        return player and Bridge.Adapter.removeItem(player, item, amount, metadata) ~= false
    end,
    registerUsableItem = function(item, callback)
        Bridge.Adapter.registerUsableItem(item, callback)
        return true
    end,
    getItemSlot = function(source, slot) return exports['qb-inventory']:GetItemBySlot(source, slot) end,
    getItemData = function(item) return Bridge.Adapter.core.Shared.Items[item] end,
    createShop = function(name, data)
        local items = data.inventory or data.items or {}
        for index, item in ipairs(items) do
            item.slot = item.slot or index
            item.amount = item.amount or 1000
        end
        exports['qb-inventory']:CreateShop({ name = name, label = data.label or name, slots = data.slots or #items, items =
        items })
        return true
    end,
    registerStash = function() return true end,
    getRawInventory = function(id) return exports['qb-inventory']:GetInventory(id) end,
    clearInventory = function(id, keep)
        exports['qb-inventory']:ClearInventory(id, keep)
        return true
    end,
})
