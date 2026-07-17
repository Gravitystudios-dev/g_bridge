local function normalizeOptions(options)
    local normalized = {}

    for index, option in ipairs(options or {}) do
        local entry = {}
        for key, value in pairs(option) do entry[key] = value end
        entry.action = entry.action or entry.onSelect

        if entry.groups and not entry.job then
            if type(entry.groups) == 'string' then
                entry.job = { [entry.groups] = 0 }
            elseif type(entry.groups) == 'table' then
                entry.job = entry.groups
            end
        end

        entry.item = entry.item or entry.items
        normalized[index] = entry
    end

    return normalized
end

local function targetData(options, distance)
    options = normalizeOptions(options)
    return { options = options, distance = distance or (options[1] and options[1].distance) or 2.0 }
end

local function networkEntities(netIds)
    if type(netIds) == 'number' then netIds = { netIds } end
    local entities = {}
    for index, netId in ipairs(netIds or {}) do
        entities[index] = NetworkGetEntityFromNetworkId(netId)
    end
    return entities
end

Gravity.RegisterClientProvider('target', 'qb-target', {
    setEnabled = function(enabled)
        exports['qb-target']:AllowTargeting(enabled)
        return true
    end,
    addBoxZone = function(id, data)
        return exports['qb-target']:AddBoxZone(id, data.coords, data.length or 1.0, data.width or 1.0, {
            name = id,
            heading = data.heading or data.rotation or 0.0,
            debugPoly = data.debug or false,
            minZ = data.minZ,
            maxZ = data.maxZ,
        }, {
            options = data.options or {},
            distance = data.distance or 2.0,
        })
    end,
    removeZone = function(id)
        return exports['qb-target']:RemoveZone(id)
    end,
    addSphereZone = function(data)
        local id = data.name or ('gravity_sphere_%s'):format(GetGameTimer())
        exports['qb-target']:AddCircleZone(id, data.coords, data.radius or 1.0, {
            name = id,
            debugPoly = data.debug or false,
            useZ = data.useZ ~= false,
        }, targetData(data.options, data.distance))
        return id
    end,
    addPlayer = function(options) return exports['qb-target']:AddGlobalPlayer(targetData(options)) end,
    removePlayer = function(names) return exports['qb-target']:RemoveGlobalPlayer(names) end,
    addVehicle = function(options) return exports['qb-target']:AddGlobalVehicle(targetData(options)) end,
    removeVehicle = function(names) return exports['qb-target']:RemoveGlobalVehicle(names) end,
    addModel = function(models, options) return exports['qb-target']:AddTargetModel(models, targetData(options)) end,
    removeModel = function(models, names) return exports['qb-target']:RemoveTargetModel(models, names) end,
    addEntity = function(netIds, options)
        return exports['qb-target']:AddTargetEntity(networkEntities(netIds), targetData(options))
    end,
    removeEntity = function(netIds, names)
        return exports['qb-target']:RemoveTargetEntity(networkEntities(netIds), names)
    end,
    addLocalEntity = function(entities, options)
        return exports['qb-target']:AddTargetEntity(entities, targetData(options))
    end,
    removeLocalEntity = function(entities, names)
        return exports['qb-target']:RemoveTargetEntity(entities, names)
    end,
})
