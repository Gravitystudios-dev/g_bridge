-- Framework inventory fallback used when no dedicated inventory resource is selected.
Gravity.RegisterServerProvider('inventory', 'framework', {
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
})
