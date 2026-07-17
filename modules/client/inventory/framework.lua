local function playerItems()
    local data = Bridge.GetPlayerData()
    return data.items or data.inventory or {}
end

local function matchesMetadata(item, metadata)
    if metadata == nil then return true end
    local info = type(item) == 'table' and (item.info or item.metadata) or nil
    if type(info) ~= 'table' then return false end
    for key, value in pairs(metadata) do
        if info[key] ~= value then return false end
    end
    return true
end

Gravity.RegisterClientProvider('inventory', 'framework', {
    open = function()
        return false
    end,
    getItemCount = function(itemName, metadata)
        local count = 0
        for _, item in pairs(playerItems()) do
            if item.name == itemName and matchesMetadata(item, metadata) then
                count = count + (tonumber(item.amount or item.count or item.quantity) or 0)
            end
        end
        return count
    end,
    getItemData = function(itemName)
        local core = Bridge.Adapter and Bridge.Adapter.core
        local shared = core and core.Shared
        return shared and shared.Items and shared.Items[itemName] or nil
    end,
    getItems = playerItems,
    getCurrentWeapon = function()
        return nil
    end,
    disarm = function(state)
        if state == false then return true end
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
        return true
    end,
})
