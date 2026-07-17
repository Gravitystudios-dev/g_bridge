Gravity.RegisterServerProvider('inventory', 'ox_inventory', {
    getItem = function(source, item)
        local slots = exports.ox_inventory:Search(source, 'slots', item)
        if not slots or #slots == 0 then return nil end

        local first = slots[1]
        return {
            name = first.name,
            label = first.label,
            count = first.count,
            amount = first.count,
            slot = first.slot,
            metadata = first.metadata,
        }
    end,
    getItemCount = function(source, item, metadata)
        return exports.ox_inventory:Search(source, 'count', item, metadata) or 0
    end,
    getInventory = function(source)
        return exports.ox_inventory:GetInventoryItems(source) or {}
    end,
    canCarryItem = function(source, item, amount)
        return exports.ox_inventory:CanCarryItem(source, item, amount)
    end,
    addItem = function(source, item, amount, metadata, slot)
        return exports.ox_inventory:AddItem(source, item, amount, metadata, slot) ~= false
    end,
    removeItem = function(source, item, amount, metadata, slot)
        return exports.ox_inventory:RemoveItem(source, item, amount, metadata, slot) ~= false
    end,
    registerUsableItem = function(item)
        Gravity.Debug('"%s" is registered by ox_inventory item definitions; registration skipped.', item)
        return false
    end,
    getItemSlot = function(source, slot) return exports.ox_inventory:GetSlot(source, slot) end,
    getItemData = function(item) return exports.ox_inventory:Items(item) end,
    createDrop = function(prefix, items, coords) return exports.ox_inventory:CustomDrop(prefix, items, coords) end,
    createShop = function(name, data)
        exports.ox_inventory:RegisterShop(name, data)
        return true
    end,
    registerStash = function(id, label, slots, weight, owner, groups, coords)
        exports.ox_inventory:RegisterStash(id, label, slots, weight, owner, groups, coords)
        return true
    end,
    getRawInventory = function(id) return exports.ox_inventory:GetInventory(id) end,
    clearInventory = function(id, keep)
        exports.ox_inventory:ClearInventory(id, keep)
        return true
    end,
    setMetadata = function(id, slot, metadata)
        exports.ox_inventory:SetMetadata(id, slot, metadata)
        return true
    end,
    registerHook = function(event, callback, options) return exports.ox_inventory:registerHook(event, callback, options) end,
})
