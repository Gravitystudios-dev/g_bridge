local function detectFramework()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if Gravity.ResourceStarted('qbx_core') then return 'qbx' end
    if Gravity.ResourceStarted('es_extended') then return 'esx' end
    if Gravity.ResourceStarted('qb-core') then return 'qb' end
    error('No supported framework found.')
end

CreateThread(function()
    Bridge.Framework = detectFramework()
    Bridge.Adapter = GravityAdapters.client[Bridge.Framework]()
    Gravity.Debug('Client bridge ready (%s)', Bridge.Framework)
end)

function Bridge.GetPlayerData()
    return Bridge.Adapter and Bridge.Adapter.getPlayerData() or {}
end

function Bridge.IsPlayerLoaded()
    local data = Bridge.GetPlayerData()
    if Bridge.Framework == 'esx' then return data.loaded == true or data.identifier ~= nil end
    return data.citizenid ~= nil or data.charid ~= nil or data.charId ~= nil
end

function Bridge.GetIdentifier()
    local data = Bridge.GetPlayerData()
    return data.identifier or data.citizenid or data.charid or data.charId
end

function Bridge.GetPlayerName()
    local data = Bridge.GetPlayerData()
    local charinfo = data.charinfo or {}
    local name = ('%s %s'):format(charinfo.firstname or data.firstName or '', charinfo.lastname or data.lastName or '')
    name = name:gsub('^%s*(.-)%s*$', '%1')
    return name ~= '' and name or GetPlayerName(PlayerId())
end

local function normalizeJob(job)
    job = job or {}

    local grade = job.grade
    local gradeLevel = 0
    local gradeName = job.grade_name

    if type(grade) == 'table' then
        gradeLevel = tonumber(grade.level or grade.grade or 0) or 0
        gradeName = gradeName or grade.name
    else
        gradeLevel = tonumber(grade) or 0
    end

    return {
        name = job.name,
        label = job.label,
        grade = gradeLevel,
        gradeName = gradeName,
        onduty = job.onduty ~= false,
    }
end

function Bridge.GetJob()
    return normalizeJob(Bridge.GetPlayerData().job)
end

function Bridge.IsOnDuty()
    return Bridge.GetJob().onduty ~= false
end

function Bridge.TriggerCallback(name, callback, ...)
    if Bridge.Adapter then
        Bridge.Adapter.triggerCallback(name, callback, ...)
    end
end

local function clientProvider(category, configured, order)
    return Gravity.GetClientProvider(category, configured, order)
end

function Bridge.Notify(message, notifyType, duration, options)
    if type(message) == 'table' then
        options = message
        message = options.description or options.message
        notifyType = options.type
        duration = options.duration
    else
        options = options or {}
    end
    local provider = clientProvider('notification', Config.Notification, {
        'ox_lib', 'qbx_core', 'qb-core', 'es_extended', 'okokNotify', 'mythic_notify',
        'brutal_notify', 'is_ui', 'lation_ui', 'g-notifications', 'vms_notifyv2',
        'wasabi_uikit', 'codem-notification',
    })
    if not provider then return false end
    local types = { success = 'success', error = 'error', warning = 'warning', inform = 'inform', primary = 'inform' }
    return provider.send(message, types[notifyType] or 'inform', duration or options.duration or 5000, options)
end

function Bridge.Progress(data)
    local provider = clientProvider('progress', Config.Progress, { 'ox_lib', 'qb-core', 'esx_progressbar' })
    return provider and provider.start(data or {}) or false
end

function Bridge.ProgressCircle(data)
    local provider = clientProvider('progress', Config.Progress, { 'ox_lib', 'qb-core', 'esx_progressbar' })
    if not provider then return false end
    return (provider.startCircle or provider.start)(data or {})
end

function Bridge.IsProgressActive()
    local provider = clientProvider('progress', Config.Progress, { 'ox_lib', 'qb-core', 'esx_progressbar' })
    return provider and provider.isActive and provider.isActive() or false
end

function Bridge.CancelProgress()
    local provider = clientProvider('progress', Config.Progress, { 'ox_lib', 'qb-core', 'esx_progressbar' })
    return provider and provider.cancel and provider.cancel() or false
end

function Bridge.ShowTextUI(text, options)
    local provider = clientProvider('textui', Config.TextUI, { 'ox_lib', 'qb-core', 'es_extended' })
    return provider and provider.show(text, options) or false
end

function Bridge.HideTextUI()
    local provider = clientProvider('textui', Config.TextUI, { 'ox_lib', 'qb-core', 'es_extended' })
    return provider and provider.hide() or false
end

function Bridge.Input(title, fields)
    local provider = clientProvider('input', Config.Input, { 'ox_lib', 'qb-input', 'esx_menu_dialog' })
    if provider then return provider.open(title, fields) end
    Gravity.Debug('%s', Bridge.Translate('input_unavailable'))
end

function Bridge.OpenMenu(id, data)
    assert(type(id) == 'string' and id ~= '', 'Menu id must be a non-empty string.')
    local provider = clientProvider('menu', Config.Menu, { 'ox_lib', 'qb-menu', 'esx_menu_default' })
    if provider then return provider.open(id, data or {}) end
    Gravity.Debug('%s', Bridge.Translate('menu_unavailable'))
    return false
end

function Bridge.CloseMenu()
    local provider = clientProvider('menu', Config.Menu, { 'ox_lib', 'qb-menu', 'esx_menu_default' })
    return provider and provider.close() or false
end

function Bridge.OpenInventory(inventoryType, data)
    local provider = clientProvider('inventory', Config.Inventory, { 'ox_inventory', 'one_inventory', 'origen_inventory', 'codem-inventory', 'core_inventory', 'qs-inventory', 'ps-inventory', 'qb-inventory', 'framework' })
    return provider and provider.open(inventoryType, data) or false
end

local function clientInventoryProvider()
    return clientProvider('inventory', Config.Inventory, { 'ox_inventory', 'one_inventory', 'origen_inventory', 'codem-inventory', 'core_inventory', 'qs-inventory', 'ps-inventory', 'qb-inventory', 'framework' })
end

function Bridge.GetItemCount(item, metadata)
    local provider = clientInventoryProvider()
    return provider and provider.getItemCount and provider.getItemCount(item, metadata) or 0
end

function Bridge.GetItemData(item)
    local provider = clientInventoryProvider()
    return provider and provider.getItemData and provider.getItemData(item) or nil
end

function Bridge.GetInventoryItems()
    local provider = clientInventoryProvider()
    return provider and provider.getItems and provider.getItems() or {}
end

function Bridge.GetCurrentWeapon()
    local provider = clientInventoryProvider()
    return provider and provider.getCurrentWeapon and provider.getCurrentWeapon() or nil
end

function Bridge.Disarm(state)
    local provider = clientInventoryProvider()
    return provider and provider.disarm and provider.disarm(state) or false
end

function Bridge.GetFuel(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return 0.0 end
    local provider = clientProvider('fuel', Config.Fuel, {
        'ox_fuel', 'lc_fuel', 'ps-fuel', 'qb-fuel', 'LegacyFuel',
        'cdn-fuel', 'qs-fuelstations', 'bit-fuel', 'hex_1_fuel', 'rcore_fuel',
        'x-fuel', 'myFuel', 'lyre_fuel', 'okokGasStation', 'Renewed-Fuel',
    })
    return provider and provider.getFuel(vehicle) or 0.0
end

function Bridge.SetFuel(vehicle, amount)
    if not vehicle or not DoesEntityExist(vehicle) then return false end
    amount = tonumber(amount)
    if not amount then return false end
    local provider = clientProvider('fuel', Config.Fuel, {
        'ox_fuel', 'lc_fuel', 'ps-fuel', 'qb-fuel', 'LegacyFuel',
        'cdn-fuel', 'qs-fuelstations', 'bit-fuel', 'hex_1_fuel', 'rcore_fuel',
        'x-fuel', 'myFuel', 'lyre_fuel', 'okokGasStation', 'Renewed-Fuel',
    })
    if not provider then return false end
    return provider.setFuel(vehicle, amount) ~= false
end

local function vehicleKeysProvider(remove)
    local order = remove
        and {
            'qbx_vehiclekeys', 'qs-vehiclekeys', 'wasabi_carlock', '0r-vehiclekeys',
            'Renewed-Vehiclekeys', 'MrNewbVehicleKeys', 'ak47_vehiclekeys', 'ak47_qb_vehiclekeys',
            'brutal_carkeys', 'filo_vehiclekey', 'jc_vehiclekeys', 'is_vehiclekeys',
            'mm_carkeys', 'LifeSaver_KeySystem', 'ic3d_vehiclekeys', 'p_carkeys',
        }
        or {
            'qbx_vehiclekeys', 'qs-vehiclekeys', 'qb-vehiclekeys', 'wasabi_carlock', '0r-vehiclekeys',
            'Renewed-Vehiclekeys', 'MrNewbVehicleKeys', 'ak47_vehiclekeys', 'ak47_qb_vehiclekeys',
            'brutal_carkeys', 'filo_vehiclekey', 'jc_vehiclekeys', 'is_vehiclekeys',
            'mm_carkeys', 'LifeSaver_KeySystem', 'tgiann-hotwire', 'ic3d_vehiclekeys', 'p_carkeys',
        }
    return clientProvider('vehiclekeys', Config.VehicleKeys, order)
end

local function isVehicle(entity)
    return type(entity) == 'number' and DoesEntityExist(entity) and IsEntityAVehicle(entity)
end

function Bridge.GiveVehicleKeys(vehicleOrPlate)
    local provider = vehicleKeysProvider(false)
    if not provider then return false end
    if provider.entityRequired then
        return isVehicle(vehicleOrPlate) and provider.give(vehicleOrPlate) or false
    end
    if isVehicle(vehicleOrPlate) then
        return provider.give(GetVehicleNumberPlateText(vehicleOrPlate), vehicleOrPlate) ~= false
    end
    return type(vehicleOrPlate) == 'string' and vehicleOrPlate ~= '' and provider.give(vehicleOrPlate, nil) ~= false or
    false
end

function Bridge.RemoveVehicleKeys(vehicleOrPlate)
    local provider = vehicleKeysProvider(true)
    if not provider or not provider.remove then return false end
    if provider.entityRequired then
        return isVehicle(vehicleOrPlate) and provider.remove(vehicleOrPlate) or false
    end
    if isVehicle(vehicleOrPlate) then
        return provider.remove(GetVehicleNumberPlateText(vehicleOrPlate), vehicleOrPlate) ~= false
    end
    return type(vehicleOrPlate) == 'string' and vehicleOrPlate ~= '' and provider.remove(vehicleOrPlate, nil) ~= false or
    false
end

function Bridge.OpenAppearance(data)
    local provider = clientProvider('appearance', Config.Appearance, {
        'illenium-appearance', 'fivem-appearance', 'qs-appearance', '4bit_appearance',
        'qb-clothing', 'esx_skin',
    })
    return provider and provider.open(data or {}) or false
end

local function appearanceProvider()
    return clientProvider('appearance', Config.Appearance, {
        'illenium-appearance', 'fivem-appearance', 'qs-appearance', '4bit_appearance',
        'qb-clothing', 'esx_skin',
    })
end

local function decodeAppearance(data)
    if type(data) ~= 'string' then return data end
    local success, decoded = pcall(json.decode, data)
    return success and decoded or nil
end

function Bridge.GetAppearance()
    local provider = appearanceProvider()
    return provider and provider.get and provider.get() or nil
end

function Bridge.SetAppearance(appearance)
    appearance = decodeAppearance(appearance)
    if type(appearance) ~= 'table' then return false end
    local provider = appearanceProvider()
    return provider and provider.set and provider.set(appearance) or false
end

function Bridge.SetClothing(clothing)
    clothing = decodeAppearance(clothing)
    if type(clothing) ~= 'table' then return false end
    local provider = appearanceProvider()
    return provider and provider.setClothing and provider.setClothing(clothing) or false
end

function Bridge.AddBoxZone(id, data)
    assert(type(id) == 'string', 'Target zone id must be a string.')
    assert(type(data) == 'table' and data.coords, 'Target zone data.coords is required.')
    local provider = clientProvider('target', Config.Target, { 'ox_target', 'qb-target' })
    if provider then return provider.addBoxZone(id, data) end
    Gravity.Debug('%s', Bridge.Translate('target_unavailable'))
end

function Bridge.RemoveZone(id)
    local provider = clientProvider('target', Config.Target, { 'ox_target', 'qb-target' })
    return provider and provider.removeZone(id) or false
end

local function targetProvider()
    return clientProvider('target', Config.Target, { 'ox_target', 'qb-target' })
end

function Bridge.SetTargetEnabled(enabled)
    local provider = targetProvider()
    return provider and provider.setEnabled and provider.setEnabled(enabled == true) or false
end

function Bridge.AddSphereZone(data)
    assert(type(data) == 'table' and data.coords, 'Sphere zone data.coords is required.')
    local provider = targetProvider()
    return provider and provider.addSphereZone and provider.addSphereZone(data) or false
end

function Bridge.AddGlobalTarget(options)
    local provider = targetProvider()
    return provider and provider.addGlobal and provider.addGlobal(options) or false
end

function Bridge.RemoveGlobalTarget(names)
    local provider = targetProvider()
    return provider and provider.removeGlobal and provider.removeGlobal(names) or false
end

function Bridge.AddPlayerTarget(options)
    local provider = targetProvider()
    return provider and provider.addPlayer and provider.addPlayer(options) or false
end

function Bridge.RemovePlayerTarget(names)
    local provider = targetProvider()
    return provider and provider.removePlayer and provider.removePlayer(names) or false
end

function Bridge.AddVehicleTarget(options)
    local provider = targetProvider()
    return provider and provider.addVehicle and provider.addVehicle(options) or false
end

function Bridge.RemoveVehicleTarget(names)
    local provider = targetProvider()
    return provider and provider.removeVehicle and provider.removeVehicle(names) or false
end

function Bridge.AddModelTarget(models, options)
    local provider = targetProvider()
    return provider and provider.addModel and provider.addModel(models, options) or false
end

function Bridge.RemoveModelTarget(models, names)
    local provider = targetProvider()
    return provider and provider.removeModel and provider.removeModel(models, names) or false
end

function Bridge.AddEntityTarget(netIds, options)
    local provider = targetProvider()
    return provider and provider.addEntity and provider.addEntity(netIds, options) or false
end

function Bridge.RemoveEntityTarget(netIds, names)
    local provider = targetProvider()
    return provider and provider.removeEntity and provider.removeEntity(netIds, names) or false
end

function Bridge.AddLocalEntityTarget(entities, options)
    local provider = targetProvider()
    return provider and provider.addLocalEntity and provider.addLocalEntity(entities, options) or false
end

function Bridge.RemoveLocalEntityTarget(entities, names)
    local provider = targetProvider()
    return provider and provider.removeLocalEntity and provider.removeLocalEntity(entities, names) or false
end

function Bridge.TogglePhone(disabled)
    local provider = clientProvider('phone', Config.Phone, { 'lb-phone', 'npwd', 'qs-smartphone-pro', 'yseries' })
    return provider and provider.setDisabled(disabled == true) or false
end

function Bridge.OpenBossMenu(job)
    local provider = clientProvider('bossmenu', Config.BossMenu, {
        'qbx_management', 'qb-management', 'esx_society', 'okokBossMenu',
        'vms_bossmenu', 'xnr-bossmenu', 'g-bossmenu', 'tk_bosstablet',
    })
    job = job or Bridge.GetJob().name
    return provider and provider.open(job) or false
end

function Bridge.SendDispatch(data)
    if type(data) ~= 'table' or type(data.title) ~= 'string' or type(data.code) ~= 'string' then return false end
    data.coords = data.coords or GetEntityCoords(PlayerPedId())
    data.time = tonumber(data.time) or 5
    data.street = data.street or
    GetStreetNameFromHashKey(GetStreetNameAtCoord(data.coords.x, data.coords.y, data.coords.z))
    TriggerServerEvent('gravity_bridge:server:dispatch', data)
    return true
end

function Bridge.GetNetIdFromEntity(entity, timeout)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return 0 end
    local expires = GetGameTimer() + (tonumber(timeout) or 2000)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    while netId == 0 and GetGameTimer() < expires do
        Wait(50)
        netId = NetworkGetNetworkIdFromEntity(entity)
    end
    return netId
end

function Bridge.GetEntityFromNetId(netId, timeout)
    netId = tonumber(netId)
    if not netId then return 0 end
    local expires = GetGameTimer() + (tonumber(timeout) or 2000)
    local entity = NetworkGetEntityFromNetworkId(netId)
    while entity == 0 and GetGameTimer() < expires do
        Wait(50)
        entity = NetworkGetEntityFromNetworkId(netId)
    end
    return entity
end

function Bridge.GetPlayerState()
    local ped = PlayerPedId()
    local state = LocalPlayer.state
    return {
        ped = ped,
        coords = GetEntityCoords(ped),
        dead = state.isDead == true or state.dead == true or IsEntityDead(ped),
        cuffed = IsPedCuffed(ped),
        ragdoll = IsPedRagdoll(ped),
        jumping = IsPedJumping(ped),
        inWater = IsEntityInWater(ped),
        vehicle = GetVehiclePedIsIn(ped, false),
    }
end

function Bridge.DrawMarkerLabel(coords, label, color)
    if not coords or not label then return false end
    local visible, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not visible then return false end
    color = color or { 61, 135, 255, 255 }
    SetTextCentre(true)
    SetTextScale(0.0, 0.25)
    SetTextDropShadow(1, 0, 0, 0, 100)
    SetTextEntry('STRING')
    AddTextComponentString(('%s\n%sm'):format(label, math.floor(#(GetEntityCoords(PlayerPedId()) - coords))))
    SetTextColour(color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 255)
    DrawText(screenX, screenY)
    return true
end

Gravity.RegisterModule('Framework',
    { GetFramework = Bridge.GetFramework, GetPlayerData = Bridge.GetPlayerData, IsPlayerLoaded = Bridge.IsPlayerLoaded, GetIdentifier =
    Bridge.GetIdentifier, GetPlayerName = Bridge.GetPlayerName, GetJob = Bridge.GetJob, IsOnDuty = Bridge.IsOnDuty })
Gravity.RegisterModule('Notify', { Send = Bridge.Notify })
Gravity.RegisterModule('Progress',
    { Start = Bridge.Progress, StartCircle = Bridge.ProgressCircle, IsActive = Bridge.IsProgressActive, Cancel = Bridge
    .CancelProgress })
Gravity.RegisterModule('TextUI', { Show = Bridge.ShowTextUI, Hide = Bridge.HideTextUI })
Gravity.RegisterModule('Input', { Open = Bridge.Input })
Gravity.RegisterModule('Menu', { Open = Bridge.OpenMenu, Close = Bridge.CloseMenu })
Gravity.RegisterModule('Target', {
    SetEnabled = Bridge.SetTargetEnabled,
    AddBoxZone = Bridge.AddBoxZone,
    AddSphereZone = Bridge.AddSphereZone,
    RemoveZone = Bridge.RemoveZone,
    AddGlobal = Bridge.AddGlobalTarget,
    RemoveGlobal = Bridge.RemoveGlobalTarget,
    AddPlayer = Bridge.AddPlayerTarget,
    RemovePlayer = Bridge.RemovePlayerTarget,
    AddVehicle = Bridge.AddVehicleTarget,
    RemoveVehicle = Bridge.RemoveVehicleTarget,
    AddModel = Bridge.AddModelTarget,
    RemoveModel = Bridge.RemoveModelTarget,
    AddEntity = Bridge.AddEntityTarget,
    RemoveEntity = Bridge.RemoveEntityTarget,
    AddLocalEntity = Bridge.AddLocalEntityTarget,
    RemoveLocalEntity = Bridge.RemoveLocalEntityTarget,
})
Gravity.RegisterModule('Inventory', {
    Open = Bridge.OpenInventory,
    GetItemCount = Bridge.GetItemCount,
    GetItemData = Bridge.GetItemData,
    GetItems = Bridge.GetInventoryItems,
    GetCurrentWeapon = Bridge.GetCurrentWeapon,
    Disarm = Bridge.Disarm,
})
Gravity.RegisterModule('Fuel', { Get = Bridge.GetFuel, Set = Bridge.SetFuel })
Gravity.RegisterModule('VehicleKeys', { Give = Bridge.GiveVehicleKeys, Remove = Bridge.RemoveVehicleKeys })
Gravity.RegisterModule('Appearance', { Open = Bridge.OpenAppearance, Get = Bridge.GetAppearance, Set = Bridge.SetAppearance, SetClothing = Bridge.SetClothing })
Gravity.RegisterModule('Phone', { SetDisabled = Bridge.TogglePhone })
Gravity.RegisterModule('BossMenu', { Open = Bridge.OpenBossMenu })
Gravity.RegisterModule('Dispatch', { SendAlert = Bridge.SendDispatch })
Gravity.RegisterModule('Utils',
    { GetNetIdFromEntity = Bridge.GetNetIdFromEntity, GetEntityFromNetId = Bridge.GetEntityFromNetId, GetPlayerState =
    Bridge.GetPlayerState })
Gravity.RegisterModule('Marker', { Draw = Bridge.DrawMarkerLabel })

RegisterNetEvent('gravity_bridge:client:notify', function(message, notifyType, duration, options)
    Bridge.Notify(message, notifyType, duration, options)
end)

RegisterNetEvent('gravity_bridge:client:phone', function(disabled)
    Bridge.TogglePhone(disabled == true)
end)

local function notifyJobUpdated(job, previousJob)
    TriggerEvent('gravity_bridge:client:jobUpdated', normalizeJob(job), normalizeJob(previousJob))
end

-- Forward the native event through one event so dependent resources can
-- immediately repeat their job checks after any job change.
RegisterNetEvent('esx:setJob', function(job, previousJob)
    if Bridge.Framework == 'esx' then notifyJobUpdated(job, previousJob) end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    if Bridge.Framework == 'qb' or Bridge.Framework == 'qbx' then notifyJobUpdated(job) end
end)

exports('GetFramework', Bridge.GetFramework)
exports('GetBridge', function() return Bridge end)
exports('GetModule', Gravity.GetModule)
exports('Translate', Bridge.Translate)
exports('GetPlayerData', Bridge.GetPlayerData)
exports('IsPlayerLoaded', Bridge.IsPlayerLoaded)
exports('GetIdentifier', Bridge.GetIdentifier)
exports('GetPlayerName', Bridge.GetPlayerName)
exports('GetJob', Bridge.GetJob)
exports('IsOnDuty', Bridge.IsOnDuty)
exports('TriggerCallback', Bridge.TriggerCallback)
exports('Notify', Bridge.Notify)
exports('Progress', Bridge.Progress)
exports('ProgressCircle', Bridge.ProgressCircle)
exports('IsProgressActive', Bridge.IsProgressActive)
exports('CancelProgress', Bridge.CancelProgress)
exports('ShowTextUI', Bridge.ShowTextUI)
exports('HideTextUI', Bridge.HideTextUI)
exports('Input', Bridge.Input)
exports('OpenMenu', Bridge.OpenMenu)
exports('CloseMenu', Bridge.CloseMenu)
exports('AddBoxZone', Bridge.AddBoxZone)
exports('RemoveZone', Bridge.RemoveZone)
exports('SetTargetEnabled', Bridge.SetTargetEnabled)
exports('AddSphereZone', Bridge.AddSphereZone)
exports('AddGlobalTarget', Bridge.AddGlobalTarget)
exports('RemoveGlobalTarget', Bridge.RemoveGlobalTarget)
exports('AddPlayerTarget', Bridge.AddPlayerTarget)
exports('RemovePlayerTarget', Bridge.RemovePlayerTarget)
exports('AddVehicleTarget', Bridge.AddVehicleTarget)
exports('RemoveVehicleTarget', Bridge.RemoveVehicleTarget)
exports('AddModelTarget', Bridge.AddModelTarget)
exports('RemoveModelTarget', Bridge.RemoveModelTarget)
exports('AddEntityTarget', Bridge.AddEntityTarget)
exports('RemoveEntityTarget', Bridge.RemoveEntityTarget)
exports('AddLocalEntityTarget', Bridge.AddLocalEntityTarget)
exports('RemoveLocalEntityTarget', Bridge.RemoveLocalEntityTarget)
exports('OpenInventory', Bridge.OpenInventory)
exports('GetItemCount', Bridge.GetItemCount)
exports('GetItemData', Bridge.GetItemData)
exports('GetInventoryItems', Bridge.GetInventoryItems)
exports('GetCurrentWeapon', Bridge.GetCurrentWeapon)
exports('Disarm', Bridge.Disarm)
exports('GetFuel', Bridge.GetFuel)
exports('SetFuel', Bridge.SetFuel)
exports('GiveVehicleKeys', Bridge.GiveVehicleKeys)
exports('RemoveVehicleKeys', Bridge.RemoveVehicleKeys)
exports('OpenAppearance', Bridge.OpenAppearance)
exports('GetAppearance', Bridge.GetAppearance)
exports('SetAppearance', Bridge.SetAppearance)
exports('SetClothing', Bridge.SetClothing)
exports('TogglePhone', Bridge.TogglePhone)
exports('OpenBossMenu', Bridge.OpenBossMenu)
exports('SendDispatch', Bridge.SendDispatch)
exports('GetNetIdFromEntity', Bridge.GetNetIdFromEntity)
exports('GetEntityFromNetId', Bridge.GetEntityFromNetId)
exports('GetPlayerState', Bridge.GetPlayerState)
exports('DrawMarkerLabel', Bridge.DrawMarkerLabel)
