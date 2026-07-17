GravityAdapters = GravityAdapters or { server = {}, client = {} }

GravityAdapters.client.qb = function()
    local QBCore = exports['qb-core']:GetCoreObject()
    return {
        core = QBCore,
        getPlayerData = function() return QBCore.Functions.GetPlayerData() end,
        triggerCallback = function(name, callback, ...) QBCore.Functions.TriggerCallback(name, callback, ...) end,
        notify = function(message, notifyType, duration)
            QBCore.Functions.Notify(message, notifyType or 'primary', duration)
        end,
    }
end
