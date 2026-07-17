GravityAdapters = GravityAdapters or { server = {}, client = {} }

GravityAdapters.client.esx = function()
    local ESX = exports['es_extended']:getSharedObject()
    return {
        core = ESX,
        getPlayerData = function() return ESX.GetPlayerData() end,
        triggerCallback = function(name, callback, ...) ESX.TriggerServerCallback(name, callback, ...) end,
        notify = function(message, notifyType)
            ESX.ShowNotification(message, notifyType or 'inform')
        end,
    }
end
