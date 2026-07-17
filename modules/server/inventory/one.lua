local function findItem(items, name)
    for _, item in pairs(items or {}) do if item.name == name then return item end end
end

Gravity.RegisterServerProvider('inventory', 'one_inventory', {
    getItem = function(source, item) return findItem(exports.one_inventory:GetInventoryItems(source), item) end,
    getItemCount = function(source, item, metadata) return exports.one_inventory:GetItemCount(source, item, metadata) or 0 end,
    getInventory = function(source) return exports.one_inventory:GetInventoryItems(source) or {} end,
    canCarryItem = function() return true end,
    addItem = function(source, item, amount, metadata, slot) return exports.one_inventory:AddItem(source, item, amount, metadata, slot) ~= false end,
    removeItem = function(source, item, amount, metadata, slot) return exports.one_inventory:RemoveItem(source, item, amount, metadata, slot) ~= false end,
    registerUsableItem = function(item, callback) Bridge.Adapter.registerUsableItem(item, callback) return true end,
    getItemSlot = function(source, slot) return exports.one_inventory:GetSlot(source, slot) end,
    getItemData = function(item) return exports.one_inventory:GetItemDefinition(item) end,
    createDrop = function(_, items, coords) return exports.one_inventory:CreateDrop(coords, items) end,
    createShop = function(name, data) return exports.one_inventory:RegisterShop({ name = name, label = data.label or data.name or name, coords = data.coords or data.locations, jobs = data.groups, inventory = data.inventory }) end,
    registerStash = function() return true end,
    getRawInventory = function(id) return exports.one_inventory:GetInventory(id) end,
    clearInventory = function(id) exports.one_inventory:ClearInventory(id) return true end,
    setMetadata = function(id, slot, metadata) exports.one_inventory:SetItemMetadata(id, slot, metadata) return true end,
    registerHook = function(event, callback, options) return exports.one_inventory:RegisterHook(event, callback, options) end,
})
