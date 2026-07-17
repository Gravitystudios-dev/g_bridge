local function detectFramework()
    local frameworkResources = {
        esx = 'es_extended',
        qb = 'qb-core',
        qbx = 'qbx_core',
    }

    if Config.Framework ~= 'auto' then
        local resource = frameworkResources[Config.Framework]
        if not resource then
            error(('Unsupported framework "%s". Use esx, qb or qbx.'):format(Config.Framework))
        end
        if not Gravity.ResourceStarted(resource) then
            error(('Configured framework "%s" is not started.'):format(Config.Framework))
        end
        return Config.Framework
    end
    if Gravity.ResourceStarted('qbx_core') then return 'qbx' end
    if Gravity.ResourceStarted('es_extended') then return 'esx' end
    if Gravity.ResourceStarted('qb-core') then return 'qb' end
    error('No supported framework found. Start es_extended, qb-core or qbx_core before gravity_bridge.')
end

local RELEASE_REPOSITORY = 'GravityStudios/g_bridge'

local function printBanner()
    local version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or 'unknown'
    print('^6[Gravity Studios]^7')
    print('^6 ^7')
    print('^6  ██████╗ ██████╗  █████╗ ██╗   ██╗██╗████████╗██╗   ██╗^7')
    print('^6 ██╔════╝ ██╔══██╗██╔══██╗██║   ██║██║╚══██╔══╝╚██╗ ██╔╝^7')
    print('^6 ██║  ███╗██████╔╝███████║██║   ██║██║   ██║    ╚████╔╝ ^7')
    print('^6 ██║   ██║██╔══██╗██╔══██║╚██╗ ██╔╝██║   ██║     ╚██╔╝  ^7')
    print('^6 ╚██████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║   ██║      ██║   ^7')
    print('^6  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝   ╚═╝      ╚═╝   ^7')
    print('^6 ^7')
    print(('^7Gravity Bridge ^8| ^7v%s'):format(version))
end

local function versionParts(version)
    local major, minor, patch = version:gsub('^v', ''):match('^(%d+)%.(%d+)%.(%d+)')
    return tonumber(major), tonumber(minor), tonumber(patch)
end

local function isNewerVersion(latest, current)
    local latestMajor, latestMinor, latestPatch = versionParts(latest)
    local currentMajor, currentMinor, currentPatch = versionParts(current)
    if not latestMajor or not currentMajor then return false end
    if latestMajor ~= currentMajor then return latestMajor > currentMajor end
    if latestMinor ~= currentMinor then return latestMinor > currentMinor end
    return latestPatch > currentPatch
end

local function checkVersion()
    local settings = Config.VersionCheck
    if not settings.enabled then return end

    local current = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '0.0.0'
    local endpoint = ('https://api.github.com/repos/%s/releases/latest'):format(RELEASE_REPOSITORY)

    PerformHttpRequest(endpoint, function(statusCode, body)
        if statusCode ~= 200 then
            Gravity.Debug('Version check failed (HTTP %s).', statusCode)
            return
        end

        local release = json.decode(body)
        local latest = release and release.tag_name
        if not latest then return end

        if isNewerVersion(latest, current) then
            print(('^3[Gravity Bridge]^7 Update available: ^3%s^7 → ^2%s^7'):format(current, latest))
            print(('^3[Gravity Bridge]^7 https://github.com/%s/releases/latest'):format(RELEASE_REPOSITORY))
        else
            print(('^2[Gravity Bridge]^7 Running the latest version (^7%s^7).'):format(current))
        end
    end, 'GET', '', { ['User-Agent'] = 'GravityBridge-VersionCheck' })
end

CreateThread(function()
    Bridge.Framework = detectFramework()
    Bridge.Adapter = GravityAdapters.server[Bridge.Framework]()
    printBanner()
    print(('[gravity_bridge] Gravity Studios bridge ready (%s)'):format(Bridge.Framework:upper()))
    checkVersion()
end)

local function player(source)
    Gravity.AssertServer()
    return Bridge.Adapter and Bridge.Adapter.getPlayer(source)
end

local function inventoryProvider()
    return Gravity.GetServerProvider('inventory', Config.Inventory, { 'ox_inventory', 'one_inventory', 'origen_inventory', 'codem-inventory', 'core_inventory', 'qs-inventory', 'ps-inventory', 'qb-inventory' })
end

local function bankingProvider()
    return Gravity.GetServerProvider('banking', Config.Banking, { 'Renewed-Banking', 'renewed-banking', 'qb-banking', 'okokBanking' })
end

local function doorlockProvider()
    return Gravity.GetServerProvider('doorlock', Config.Doorlock, { 'ox_doorlock', 'qb-doorlock' })
end

local function vehicleKeysProvider()
    return Gravity.GetServerProvider('vehiclekeys', Config.VehicleKeys, { 'qbx_vehiclekeys' })
end

local function dispatchProvider()
    return Gravity.GetServerProvider('dispatch', Config.Dispatch, {
        'ps-dispatch', 'qs-dispatch', 'cd_dispatch', 'rcore_dispatch',
        'lb-tablet', 'tk_dispatch', 'core_dispatch',
    })
end

local function societyProvider()
    return Gravity.GetServerProvider('society', Config.Society, {
        'esx_addonaccount', 'Renewed-Banking', 'qb-banking', 'okokBanking',
        'qs-banking', 'wasabi_banking', 'p_banking', 'RxBanking',
        'snipe-banking', 'prism_banking', 'nass_bossmenu', 'xnr-bossmenu',
        'tgg-banking', 'fd_banking', 'crm-banking', 'kartik-banking',
    })
end

function Bridge.GetPlayer(source) return player(source) end

function Bridge.GetIdentifier(source)
    local target = player(source)
    return target and Bridge.Adapter.getIdentifier(target) or nil
end

function Bridge.GetName(source)
    local target = player(source)
    return target and Bridge.Adapter.getName(target) or nil
end

function Bridge.GetGroups(source)
    local target = player(source)
    return target and Bridge.Adapter.getGroups(target) or {}
end

function Bridge.GetGroup(source)
    local groups = Bridge.GetGroups(source)
    for _, group in ipairs({ 'god', 'admin', 'mod', 'user' }) do
        if groups[group] then return group end
    end

    for group, enabled in pairs(groups) do
        if enabled then return group end
    end
    return nil
end

function Bridge.HasGroup(source, group)
    local target = player(source)
    if not target or type(group) ~= 'string' or group == '' then return false end
    return Bridge.Adapter.hasGroup(target, group) == true
end

function Bridge.GetJob(source)
    local target = player(source)
    return target and Bridge.Adapter.getJob(target) or nil
end

local function sameJob(job, name, grade)
    if not job or job.name ~= name then return false end
    return grade == nil or job.grade == tonumber(grade)
end

function Bridge.SetJob(source, job, grade)
    local target = player(source)
    if not target or type(job) ~= 'string' or job == '' or (grade ~= nil and tonumber(grade) == nil) then
        Gravity.Log('framework.job.set', { job = job, grade = grade, success = false }, { source = source, level = 'error' })
        return false
    end

    Bridge.Adapter.setJob(target, job, grade)
    local updatedJob = Bridge.Adapter.getJob(target)
    local success = sameJob(updatedJob, job, grade)

    Gravity.Log('framework.job.set', { job = job, grade = grade, success = success }, {
        source = source,
        level = success and 'success' or 'error',
    })
    return success
end

local function positiveInteger(value)
    value = tonumber(value)
    if not value or value <= 0 or value ~= math.floor(value) then return nil end
    return value
end

function Bridge.GetMoney(source, account)
    local target = player(source)
    return target and Bridge.Adapter.getMoney(target, account or 'cash') or 0
end

function Bridge.AddMoney(source, account, amount, reason)
    amount = positiveInteger(amount)
    local target = player(source)
    if not target or not amount then
        Gravity.Log('money.add', { account = account or 'cash', amount = amount, reason = reason, success = false }, { source = source, level = 'error' })
        return false
    end
    local success = Bridge.Adapter.addMoney(target, account or 'cash', amount, reason or 'gravity_bridge') ~= false
    Gravity.Log('money.add', { account = account or 'cash', amount = amount, reason = reason, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.RemoveMoney(source, account, amount, reason)
    amount = positiveInteger(amount)
    local target = player(source)
    local hasFunds = target and amount and Bridge.GetMoney(source, account) >= amount
    local success = hasFunds and Bridge.Adapter.removeMoney(target, account or 'cash', amount, reason or 'gravity_bridge') ~= false
    Gravity.Log('money.remove', { account = account or 'cash', amount = amount, reason = reason, success = success }, { source = source, level = success and 'success' or 'warning' })
    return success
end

function Bridge.GetItem(source, item)
    if type(item) ~= 'string' or item == '' then return nil end
    local provider = inventoryProvider()
    return provider and provider.getItem(source, item) or nil
end

function Bridge.GetItemCount(source, item, metadata)
    if type(item) ~= 'string' or item == '' then return 0 end
    local provider = inventoryProvider()
    return provider and provider.getItemCount(source, item, metadata) or 0
end

function Bridge.GetInventory(source)
    local provider = inventoryProvider()
    return provider and provider.getInventory(source) or {}
end

function Bridge.HasItem(source, item, amount)
    amount = positiveInteger(amount or 1)
    return amount and Bridge.GetItemCount(source, item) >= amount or false
end

function Bridge.CanCarryItem(source, item, amount)
    amount = positiveInteger(amount)
    if type(item) ~= 'string' or item == '' or not amount then return false end
    local provider = inventoryProvider()
    return provider and provider.canCarryItem(source, item, amount) or false
end

function Bridge.AddItem(source, item, amount, metadata, slot)
    amount = positiveInteger(amount)
    if type(item) ~= 'string' or item == '' or not amount then return false end
    if not player(source) or not Bridge.CanCarryItem(source, item, amount) then
        Gravity.Log('inventory.add', { item = item, amount = amount, metadata = metadata, success = false }, { source = source, level = 'warning' })
        return false
    end
    local provider = inventoryProvider()
    local success = provider and provider.addItem(source, item, amount, metadata, slot) or false
    Gravity.Log('inventory.add', { item = item, amount = amount, metadata = metadata, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.RemoveItem(source, item, amount, metadata, slot)
    amount = positiveInteger(amount)
    if type(item) ~= 'string' or item == '' or not amount then return false end
    if not player(source) or not Bridge.HasItem(source, item, amount) then
        Gravity.Log('inventory.remove', { item = item, amount = amount, metadata = metadata, success = false }, { source = source, level = 'warning' })
        return false
    end
    local provider = inventoryProvider()
    local success = provider and provider.removeItem(source, item, amount, metadata, slot) or false
    Gravity.Log('inventory.remove', { item = item, amount = amount, metadata = metadata, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.RegisterUsableItem(item, callback)
    assert(type(callback) == 'function', 'Usable item callback must be a function.')
    local provider = inventoryProvider()
    return provider and provider.registerUsableItem(item, callback) or false
end

function Bridge.RegisterCallback(name, callback)
    Bridge.Adapter.registerCallback(name, callback)
end

function Bridge.GetBankBalance(source)
    local provider = bankingProvider()
    return provider and provider.getBalance(source) or 0
end

function Bridge.Deposit(source, amount, reason)
    local provider = bankingProvider()
    local success = provider and provider.deposit(source, amount, reason) or false
    Gravity.Log('banking.deposit', { amount = amount, reason = reason, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.Withdraw(source, amount, reason)
    local provider = bankingProvider()
    local success = provider and provider.withdraw(source, amount, reason) or false
    Gravity.Log('banking.withdraw', { amount = amount, reason = reason, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.SetDoorState(doorId, locked)
    local provider = doorlockProvider()
    local success = provider and provider.setState(doorId, locked) or false
    Gravity.Log('doorlock.state.set', { doorId = doorId, locked = locked, success = success }, { level = success and 'success' or 'error' })
    return success
end

function Bridge.GetDoor(doorId)
    local provider = doorlockProvider()
    return provider and provider.getDoor(doorId) or nil
end

function Bridge.HasVehicleKeys(source, vehicle)
    local provider = vehicleKeysProvider()
    return provider and provider.hasKeys(source, vehicle) or false
end

function Bridge.GiveVehicleKeys(source, vehicle, skipNotification)
    local provider = vehicleKeysProvider()
    local success = provider and provider.give(source, vehicle, skipNotification) or false
    Gravity.Log('vehiclekeys.give', { vehicle = vehicle, skipNotification = skipNotification, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.RemoveVehicleKeys(source, vehicle, skipNotification)
    local provider = vehicleKeysProvider()
    local success = provider and provider.remove(source, vehicle, skipNotification) or false
    Gravity.Log('vehiclekeys.remove', { vehicle = vehicle, skipNotification = skipNotification, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.GetItemSlot(source, slot)
    local provider = inventoryProvider()
    return provider and provider.getItemSlot and provider.getItemSlot(source, tonumber(slot)) or nil
end

function Bridge.GetItemData(item)
    local provider = inventoryProvider()
    return provider and provider.getItemData and provider.getItemData(item) or nil
end

function Bridge.CreateInventoryDrop(prefix, items, coords)
    local provider = inventoryProvider()
    return provider and provider.createDrop and provider.createDrop(prefix, items, coords) or false
end

function Bridge.CreateShop(name, data)
    if type(name) ~= 'string' or name == '' or type(data) ~= 'table' then return false end
    local provider = inventoryProvider()
    return provider and provider.createShop and provider.createShop(name, data) or false
end

function Bridge.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if type(id) ~= 'string' or id == '' then return false end
    local provider = inventoryProvider()
    return provider and provider.registerStash and provider.registerStash(id, label or id, slots or 50, weight or 100000, owner, groups, coords) or false
end

function Bridge.GetRawInventory(id)
    local provider = inventoryProvider()
    return provider and provider.getRawInventory and provider.getRawInventory(id) or nil
end

function Bridge.ClearInventory(id, keep)
    local provider = inventoryProvider()
    return provider and provider.clearInventory and provider.clearInventory(id, keep) or false
end

function Bridge.SetItemMetadata(id, slot, metadata)
    local provider = inventoryProvider()
    return provider and provider.setMetadata and provider.setMetadata(id, slot, metadata or {}) or false
end

function Bridge.RegisterInventoryHook(event, callback, options)
    assert(type(callback) == 'function', 'Inventory hook callback must be a function.')
    local provider = inventoryProvider()
    return provider and provider.registerHook and provider.registerHook(event, callback, options) or nil
end

local dispatchCooldowns = {}

function Bridge.SendDispatch(source, data)
    if type(data) ~= 'table' or type(data.title) ~= 'string' or data.title == '' or type(data.code) ~= 'string' or data.code == '' then
        return false
    end

    source = tonumber(source)
    data.title = data.title:sub(1, 160)
    data.code = data.code:sub(1, 32)

    local coords = data.coords
    if source and source > 0 then
        local ped = GetPlayerPed(source)
        if ped ~= 0 then coords = GetEntityCoords(ped) end
    end
    if not coords or not tonumber(coords.x) or not tonumber(coords.y) or not tonumber(coords.z) then return false end

    data.coords = vector3(coords.x, coords.y, coords.z)
    data.priority = ({ low = true, medium = true, high = true })[data.priority] and data.priority or 'low'
    data.time = math.max(1, math.min(tonumber(data.time) or 5, 60))
    data.notify = math.max(1, math.min(tonumber(data.notify) or 5, 60))
    data.blip = type(data.blip) == 'table' and data.blip or {}

    local provider = dispatchProvider()
    local success = provider and provider.send(source, data) or false
    Gravity.Log('dispatch.send', { code = data.code, title = data.title, job = data.job, success = success }, {
        source = source,
        level = success and 'success' or 'error',
    })
    return success
end

function Bridge.IsOnDuty(source)
    local job = Bridge.GetJob(source)
    return job and job.onduty ~= false or false
end

function Bridge.SetJobDuty(source, onDuty)
    local target = player(source)
    if not target or not Bridge.Adapter.setJobDuty then return false end
    local success = Bridge.Adapter.setJobDuty(target, onDuty == true) ~= false
    Gravity.Log('framework.job.duty', { onDuty = onDuty == true, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.GetJobs()
    return Bridge.Adapter and Bridge.Adapter.getJobs and Bridge.Adapter.getJobs() or {}
end

function Bridge.GetJobLabels()
    local labels = {}
    for name, job in pairs(Bridge.GetJobs()) do labels[name] = job.label or name end
    return labels
end

function Bridge.GetDateOfBirth(source)
    local target = player(source)
    return target and Bridge.Adapter.getDateOfBirth and Bridge.Adapter.getDateOfBirth(target) or nil
end

function Bridge.SetMetadata(source, key, value)
    local target = player(source)
    if not target or type(key) ~= 'string' or key == '' or not Bridge.Adapter.setMetadata then return false end
    return Bridge.Adapter.setMetadata(target, key, value) ~= false
end

local function validSocietyOperation(job, amount)
    amount = tonumber(amount)
    return type(job) == 'string' and job ~= '' and amount and amount > 0 and amount == math.floor(amount), amount
end

function Bridge.GetSocietyBalance(source, job)
    if type(job) ~= 'string' or job == '' then return 0 end
    local provider = societyProvider()
    return provider and tonumber(provider.getBalance(source, job)) or 0
end

function Bridge.AddSocietyMoney(source, job, amount)
    local valid
    valid, amount = validSocietyOperation(job, amount)
    if not valid then return false end
    local provider = societyProvider()
    local success = provider and provider.addMoney(source, job, amount) or false
    Gravity.Log('society.money.add', { job = job, amount = amount, success = success }, { source = source, level = success and 'success' or 'error' })
    return success
end

function Bridge.RemoveSocietyMoney(source, job, amount)
    local valid
    valid, amount = validSocietyOperation(job, amount)
    if not valid or Bridge.GetSocietyBalance(source, job) < amount then return false end
    local provider = societyProvider()
    local success = provider and provider.removeMoney(source, job, amount) or false
    Gravity.Log('society.money.remove', { job = job, amount = amount, success = success }, { source = source, level = success and 'success' or 'warning' })
    return success
end

function Bridge.Notify(source, message, notifyType, duration, options)
    TriggerClientEvent('gravity_bridge:client:notify', source, message, notifyType, duration, options)
    Gravity.Log('notification.send', { message = message, type = notifyType, duration = duration, options = options }, { source = source })
end

AddEventHandler('playerJoining', function()
    if Bridge.Framework == 'esx' then return end
    Gravity.Log('player.joining', {}, { source = source })
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer, isNew)
    local name = xPlayer and xPlayer.getName and xPlayer.getName() or GetPlayerName(playerId) or Gravity.Translate('webhook_unknown_player')
    local firstJoin = isNew == true
    Gravity.Log('player.joining', {
        title = Gravity.Translate(firstJoin and 'webhook_first_join_title' or 'webhook_relog_title'),
        message = firstJoin
            and Gravity.Translate('webhook_first_join_message', name)
            or Gravity.Translate('webhook_relog_message', name),
        firstJoin = firstJoin,
    }, { source = playerId, level = 'success' })
end)

AddEventHandler('playerDropped', function(reason)
    Gravity.Log('player.dropped', { reason = reason }, { source = source })
end)

local function notifyJobUpdated(playerId, job, previousJob)
    if type(playerId) ~= 'number' then return end
    TriggerEvent('gravity_bridge:server:jobUpdated', playerId, job, previousJob)
end

-- Forward the framework job events through one bridge event. This also covers
-- job changes initiated by resources that do not call Bridge.SetJob.
AddEventHandler('esx:setJob', function(playerId, job, previousJob)
    if Bridge.Framework == 'esx' then notifyJobUpdated(playerId, job, previousJob) end
end)

AddEventHandler('QBCore:Server:OnJobUpdate', function(playerId, job)
    if Bridge.Framework == 'qb' or Bridge.Framework == 'qbx' then notifyJobUpdated(playerId, job) end
end)

Gravity.RegisterModule('Framework', {
    GetFramework = Bridge.GetFramework,
    GetPlayer = Bridge.GetPlayer,
    GetIdentifier = Bridge.GetIdentifier,
    GetName = Bridge.GetName,
    GetGroup = Bridge.GetGroup,
    GetGroups = Bridge.GetGroups,
    HasGroup = Bridge.HasGroup,
    GetJob = Bridge.GetJob,
    SetJob = Bridge.SetJob,
    IsOnDuty = Bridge.IsOnDuty,
    SetJobDuty = Bridge.SetJobDuty,
    GetJobs = Bridge.GetJobs,
    GetJobLabels = Bridge.GetJobLabels,
    GetDateOfBirth = Bridge.GetDateOfBirth,
    SetMetadata = Bridge.SetMetadata,
})
Gravity.RegisterModule('Inventory', {
    GetItem = Bridge.GetItem,
    GetItemCount = Bridge.GetItemCount,
    GetInventory = Bridge.GetInventory,
    HasItem = Bridge.HasItem,
    CanCarryItem = Bridge.CanCarryItem,
    AddItem = Bridge.AddItem,
    RemoveItem = Bridge.RemoveItem,
    RegisterUsableItem = Bridge.RegisterUsableItem,
    GetItemSlot = Bridge.GetItemSlot,
    GetItemData = Bridge.GetItemData,
    CreateDrop = Bridge.CreateInventoryDrop,
    CreateShop = Bridge.CreateShop,
    RegisterStash = Bridge.RegisterStash,
    GetRawInventory = Bridge.GetRawInventory,
    Clear = Bridge.ClearInventory,
    SetMetadata = Bridge.SetItemMetadata,
    RegisterHook = Bridge.RegisterInventoryHook,
})

Gravity.RegisterModule('Money', {
    GetMoney = Bridge.GetMoney,
    AddMoney = Bridge.AddMoney,
    RemoveMoney = Bridge.RemoveMoney,
})

Gravity.RegisterModule('Banking', {
    GetBalance = Bridge.GetBankBalance,
    Deposit = Bridge.Deposit,
    Withdraw = Bridge.Withdraw,
})

Gravity.RegisterModule('Doorlock', {
    SetState = Bridge.SetDoorState,
    GetDoor = Bridge.GetDoor,
})

Gravity.RegisterModule('VehicleKeys', {
    Has = Bridge.HasVehicleKeys,
    Give = Bridge.GiveVehicleKeys,
    Remove = Bridge.RemoveVehicleKeys,
})

Gravity.RegisterModule('Dispatch', { SendAlert = Bridge.SendDispatch })
Gravity.RegisterModule('Society', {
    GetBalance = Bridge.GetSocietyBalance,
    AddMoney = Bridge.AddSocietyMoney,
    RemoveMoney = Bridge.RemoveSocietyMoney,
})

Gravity.RegisterModule('Notify', { Send = Bridge.Notify })
Gravity.RegisterModule('Webhooks', { Log = Gravity.Log, SendWebhook = Gravity.SendWebhook })

exports('GetFramework', Bridge.GetFramework)
exports('GetBridge', function() return Bridge end)
exports('GetModule', Gravity.GetModule)
exports('Log', Gravity.Log)
exports('SendWebhook', Gravity.SendWebhook)
exports('Translate', Bridge.Translate)
exports('GetPlayer', Bridge.GetPlayer)
exports('GetIdentifier', Bridge.GetIdentifier)
exports('GetName', Bridge.GetName)
exports('GetGroup', Bridge.GetGroup)
exports('GetGroups', Bridge.GetGroups)
exports('HasGroup', Bridge.HasGroup)
exports('GetJob', Bridge.GetJob)
exports('SetJob', Bridge.SetJob)
exports('IsOnDuty', Bridge.IsOnDuty)
exports('SetJobDuty', Bridge.SetJobDuty)
exports('GetJobs', Bridge.GetJobs)
exports('GetJobLabels', Bridge.GetJobLabels)
exports('GetDateOfBirth', Bridge.GetDateOfBirth)
exports('SetMetadata', Bridge.SetMetadata)
exports('GetMoney', Bridge.GetMoney)
exports('AddMoney', Bridge.AddMoney)
exports('RemoveMoney', Bridge.RemoveMoney)
exports('GetItem', Bridge.GetItem)
exports('GetItemCount', Bridge.GetItemCount)
exports('GetInventory', Bridge.GetInventory)
exports('HasItem', Bridge.HasItem)
exports('CanCarryItem', Bridge.CanCarryItem)
exports('AddItem', Bridge.AddItem)
exports('RemoveItem', Bridge.RemoveItem)
exports('RegisterUsableItem', Bridge.RegisterUsableItem)
exports('GetItemSlot', Bridge.GetItemSlot)
exports('GetItemData', Bridge.GetItemData)
exports('CreateInventoryDrop', Bridge.CreateInventoryDrop)
exports('CreateShop', Bridge.CreateShop)
exports('RegisterStash', Bridge.RegisterStash)
exports('GetRawInventory', Bridge.GetRawInventory)
exports('ClearInventory', Bridge.ClearInventory)
exports('SetItemMetadata', Bridge.SetItemMetadata)
exports('RegisterInventoryHook', Bridge.RegisterInventoryHook)
exports('RegisterCallback', Bridge.RegisterCallback)
exports('Notify', Bridge.Notify)
exports('GetBankBalance', Bridge.GetBankBalance)
exports('Deposit', Bridge.Deposit)
exports('Withdraw', Bridge.Withdraw)
exports('SetDoorState', Bridge.SetDoorState)
exports('GetDoor', Bridge.GetDoor)
exports('HasVehicleKeys', Bridge.HasVehicleKeys)
exports('GiveVehicleKeys', Bridge.GiveVehicleKeys)
exports('RemoveVehicleKeys', Bridge.RemoveVehicleKeys)
exports('SendDispatch', Bridge.SendDispatch)
exports('GetSocietyBalance', Bridge.GetSocietyBalance)
exports('AddSocietyMoney', Bridge.AddSocietyMoney)
exports('RemoveSocietyMoney', Bridge.RemoveSocietyMoney)

RegisterNetEvent('gravity_bridge:server:dispatch', function(data)
    local playerSource = source
    local now = GetGameTimer()
    if dispatchCooldowns[playerSource] and now - dispatchCooldowns[playerSource] < 1000 then return end
    dispatchCooldowns[playerSource] = now
    Bridge.SendDispatch(playerSource, data)
end)

AddEventHandler('playerDropped', function()
    dispatchCooldowns[source] = nil
end)

RegisterNetEvent('gravity_bridge:server:openInventory', function(inventoryType, data)
    local playerSource = source
    if type(inventoryType) ~= 'string' or (type(data) ~= 'table' and inventoryType ~= 'player') then return end
    local _, resource = inventoryProvider()
    if resource ~= 'ps-inventory' and resource ~= 'qb-inventory' then return end

    if inventoryType == 'player' then
        local target = type(data) == 'table' and tonumber(data.id or data.source) or tonumber(data)
        if not target then return end
        local playerPed, targetPed = GetPlayerPed(playerSource), GetPlayerPed(target)
        if playerPed == 0 or targetPed == 0 or #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 5.0 then return end
        exports[resource]:OpenInventoryById(playerSource, target)
    elseif inventoryType == 'shop' and type(data.type) == 'string' then
        exports[resource]:OpenShop(playerSource, data.type)
    elseif inventoryType == 'stash' then
        exports[resource]:OpenInventory(playerSource, data)
    end
end)

RegisterNetEvent('gravity_bridge:server:vehicleKeys', function(action, netId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not vehicle or vehicle == 0 or GetEntityType(vehicle) ~= 2 then return end

    local ped = GetPlayerPed(source)
    if ped == 0 or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 25.0 then return end

    if action == 'give' then
        Bridge.GiveVehicleKeys(source, vehicle)
    elseif action == 'remove' then
        Bridge.RemoveVehicleKeys(source, vehicle)
    end
end)
