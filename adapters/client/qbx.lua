GravityAdapters = GravityAdapters or { server = {}, client = {} }

-- QBox exposes its compatibility layer as the qb-core resource. It is used here
-- only for QB-style player data and callbacks; native notifications use qbx_core.
GravityAdapters.client.qbx = function()
    local QBCore = exports['qb-core']:GetCoreObject()

    return {
        core = exports.qbx_core,
        getPlayerData = function() return QBCore.Functions.GetPlayerData() end,
        triggerCallback = function(name, callback, ...) QBCore.Functions.TriggerCallback(name, callback, ...) end,
        notify = function(message, notifyType, duration)
            exports.qbx_core:Notify(message, notifyType or 'inform', duration)
        end,
    }
end
