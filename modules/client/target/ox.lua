Gravity.RegisterClientProvider('target', 'ox_target', {
    setEnabled = function(enabled)
        exports.ox_target:disableTargeting(not enabled)
        return true
    end,
    addBoxZone = function(id, data)
        return exports.ox_target:addBoxZone({
            name = id,
            coords = data.coords,
            size = data.size or vec3(data.length or 1.0, data.width or 1.0, data.height or 2.0),
            rotation = data.rotation or data.heading or 0.0,
            debug = data.debug or false,
            options = data.options or {},
        })
    end,
    removeZone = function(id)
        return exports.ox_target:removeZone(id)
    end,
    addSphereZone = function(data)
        return exports.ox_target:addSphereZone(data)
    end,
    addGlobal = function(options) return exports.ox_target:addGlobalOption(options) end,
    removeGlobal = function(names) return exports.ox_target:removeGlobalOption(names) end,
    addPlayer = function(options) return exports.ox_target:addGlobalPlayer(options) end,
    removePlayer = function(names) return exports.ox_target:removeGlobalPlayer(names) end,
    addVehicle = function(options) return exports.ox_target:addGlobalVehicle(options) end,
    removeVehicle = function(names) return exports.ox_target:removeGlobalVehicle(names) end,
    addModel = function(models, options) return exports.ox_target:addModel(models, options) end,
    removeModel = function(models, names) return exports.ox_target:removeModel(models, names) end,
    addEntity = function(netIds, options) return exports.ox_target:addEntity(netIds, options) end,
    removeEntity = function(netIds, names) return exports.ox_target:removeEntity(netIds, names) end,
    addLocalEntity = function(entities, options) return exports.ox_target:addLocalEntity(entities, options) end,
    removeLocalEntity = function(entities, names) return exports.ox_target:removeLocalEntity(entities, names) end,
})
