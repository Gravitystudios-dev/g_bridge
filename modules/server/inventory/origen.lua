local function findItem(items, name)
    for _, item in pairs(items or {}) do if item.name == name then return item end end
end

Gravity.RegisterServerProvider('inventory', 'origen_inventory', {
    getItem = function(source, item) return findItem(exports.origen_inventory:getInventoryItems(source), item) end,
    getItemCount = function(source, item, metadata) return exports.origen_inventory:getItemCount(source, item, metadata) or 0 end,
    getInventory = function(source) return exports.origen_inventory:getInventoryItems(source) or {} end,
    canCarryItem = function() return true end,
    addItem = function(source, item, amount, metadata, slot) return exports.origen_inventory:addItem(source, item, amount, metadata, slot) ~= false end,
    removeItem = function(source, item, amount, metadata, slot) return exports.origen_inventory:removeItem(source, item, amount, metadata, slot) ~= false end,
    registerUsableItem = function(item, callback) Bridge.Adapter.registerUsableItem(item, callback) return true end,
    getItemSlot = function(source, slot) return exports.origen_inventory:getSlot(source, slot) end,
    createShop = function(name, data)
        exports.origen_inventory:createShop(name, { label = data.label or data.name or name, slots = #(data.inventory or {}), items = data.inventory, locations = data.locations })
        return true
    end,
})
