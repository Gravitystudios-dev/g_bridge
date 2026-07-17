# Gravity Bridge

Gravity Bridge is a modular FiveM compatibility layer for **ESX Legacy**, **QBCore** and **QBox**. It gives resources one stable API for framework data and for common third-party systems such as inventories, targeting, notifications, fuel, vehicle keys, banking, dispatch and appearance.

The bridge keeps integrations in independent provider files under `modules/`. Your scripts call the bridge API; changing a provider normally only requires changing `config.lua`.

## Highlights

- ESX Legacy, QBCore and QBox adapters
- Automatic framework and provider detection, with explicit configuration when needed
- Normalized player, job, duty, permission, money, inventory and metadata helpers
- Client UI: notifications, progress bars, TextUI, input dialogs and menus
- `ox_target` and `qb-target` zones, models, entities, global and player/vehicle targets
- Fuel, vehicle keys, appearance, doorlock, dispatch, society accounts, boss menus and phone controls
- Advanced inventory helpers (shops, stashes, drops, metadata and hooks)
- Localisation, structured audit logs, optional Discord webhooks and version checking
- Separate client/server modules and provider files; no permanent polling loop in the bridge core

## Requirements

- FiveM server artifact `5181` or newer
- One supported framework: `es_extended`, `qb-core` or `qbx_core`
- Any additional resource required by the provider you select

Gravity Bridge itself has no hard dependency on `ox_lib`, `oxmysql` or a specific inventory. Those resources are required only by the provider you choose.

## Installation

1. Copy this resource to `resources/[gravity]/g_bridge`.
2. Start the framework and every provider resource before the bridge.
3. Add the bridge to `server.cfg`:

```cfg
ensure es_extended        # or qb-core / qbx_core
ensure g_bridge
```

If you use `auto`, the bridge selects the first started resource in its internal provider order. Start order therefore matters when more than one compatible resource is running. For a deterministic setup, set the provider name explicitly in `config.lua`.

## Configuration

All settings are in [`config.lua`](config.lua):

```lua
Config.Framework = 'auto' -- esx, qb, qbx, auto
Config.Debug = false
Config.Locale = 'en'      -- it or en

Config.VersionCheck = {
    enabled = true,
}

Config.Notification = 'auto'
Config.Progress = 'auto'
Config.TextUI = 'auto'
Config.Input = 'auto'
Config.Menu = 'auto'
Config.Target = 'auto'
Config.Inventory = 'auto'
Config.Banking = 'auto'
Config.Fuel = 'auto'
Config.VehicleKeys = 'auto'
Config.Appearance = 'auto'
Config.Doorlock = 'auto'
Config.Dispatch = 'auto'
Config.Society = 'auto'
Config.BossMenu = 'auto'
Config.Phone = 'auto'
```

Use `none` to disable optional categories that support it (dispatch, society, boss menu and phone). Server inventory and banking providers can fall back to the framework when `auto` cannot find an external provider. Provider names are case-sensitive and must match the resource name used by the server.

### Supported providers

The following providers are included in this release. The framework adapters are always selected from `es_extended`, `qb-core` and `qbx_core`.

| Category | Providers |
| --- | --- |
| Notification | `ox_lib`, `qbx_core`, `qb-core`, `es_extended`, `okokNotify`, `mythic_notify`, `brutal_notify`, `is_ui`, `lation_ui`, `g-notifications`, `vms_notifyv2`, `wasabi_uikit`, `codem-notification` |
| Progress | `ox_lib`, `qb-core`, `esx_progressbar` |
| TextUI | `ox_lib`, `qb-core`, `es_extended` |
| Input | `ox_lib`, `qb-input`, `esx_menu_dialog` |
| Menu | `ox_lib`, `qb-menu`, `esx_menu_default` |
| Target | `ox_target`, `qb-target` |
| Inventory | `ox_inventory`, `qs-inventory`, `qb-inventory`, `ps-inventory`, `codem-inventory`, `core_inventory`, `origen_inventory`, `one_inventory`, `framework` |
| Banking | `framework`, `Renewed-Banking`, `renewed-banking`, `qb-banking`, `okokBanking` |
| Fuel | `ox_fuel`, `ps-fuel`, `LegacyFuel`, `lc_fuel`, `qb-fuel`, `cdn-fuel`, `qs-fuelstations`, `bit-fuel`, `hex_1_fuel`, `rcore_fuel`, `x-fuel`, `myFuel`, `lyre_fuel`, `okokGasStation`, `Renewed-Fuel` |
| Vehicle keys | `qbx_vehiclekeys`, `qs-vehiclekeys`, `qb-vehiclekeys`, `wasabi_carlock`, `0r-vehiclekeys`, `Renewed-Vehiclekeys`, `MrNewbVehicleKeys`, `ak47_vehiclekeys`, `ak47_qb_vehiclekeys`, `brutal_carkeys`, `filo_vehiclekey`, `jc_vehiclekeys`, `is_vehiclekeys`, `mm_carkeys`, `LifeSaver_KeySystem`, `tgiann-hotwire`, `ic3d_vehiclekeys`, `p_carkeys` |
| Appearance | `illenium-appearance`, `fivem-appearance`, `qs-appearance`, `4bit_appearance`, `qb-clothing`, `esx_skin` |
| Doorlock | `ox_doorlock`, `qb-doorlock` |
| Dispatch | `ps-dispatch`, `qs-dispatch`, `cd_dispatch`, `rcore_dispatch`, `lb-tablet`, `tk_dispatch`, `core_dispatch`, `none` |
| Society | `esx_addonaccount`, `Renewed-Banking`, `qb-banking`, `okokBanking`, `qs-banking`, `wasabi_banking`, `p_banking`, `RxBanking`, `snipe-banking`, `prism_banking`, `nass_bossmenu`, `xnr-bossmenu`, `tgg-banking`, `fd_banking`, `crm-banking`, `kartik-banking`, `none` |
| Boss menu | `esx_society`, `qbx_management`, `qb-management`, `okokBossMenu`, `vms_bossmenu`, `xnr-bossmenu`, `g-bossmenu`, `tk_bosstablet`, `none` |
| Phone | `lb-phone`, `npwd`, `qs-smartphone-pro`, `yseries`, `none` |

## API conventions

The bridge exposes the same object through resource exports on both sides:

```lua
local Bridge = exports.gravity_bridge

-- Equivalent direct style:
exports.gravity_bridge:Notify('Hello', 'success')
```

Client-only exports must be called from a client script. Server-only exports must be called from a server script. Most mutating server methods return `true` on success and `false` when validation fails, the player does not exist, or the selected provider cannot perform the operation. Optional provider methods return `false`, `nil` or an empty table when the provider is disabled or unavailable.

## Client API

### Framework and player data

| Export | Signature / result |
| --- | --- |
| `GetFramework()` | `esx`, `qb` or `qbx` |
| `GetPlayerData()` | Raw player data from the active adapter |
| `IsPlayerLoaded()` | Boolean |
| `GetIdentifier()` | Normalized identifier string or `nil` |
| `GetPlayerName()` | Character name or the FiveM player name |
| `GetJob()` | `{ name, label, grade, gradeName, onduty }` |
| `IsOnDuty()` | Boolean |
| `TriggerCallback(name, callback, ...)` | Calls the active ESX/QB-compatible server callback |

### UI

```lua
Bridge:Notify({
    title = 'Garage',
    description = 'Vehicle stored successfully.',
    type = 'success',
    duration = 5000,
})

local finished = Bridge:Progress({
    label = 'Opening garage...',
    duration = 3000,
    canCancel = true,
})

Bridge:ShowTextUI('[E] Open garage')
-- Bridge:HideTextUI()

local values = Bridge:Input('Vehicle details', {
    { type = 'input', label = 'Plate', required = true },
})

Bridge:OpenMenu('garage', {
    { header = 'Garage', isMenuHeader = true },
})
```

Exports: `Notify(message, type, duration, options)`, `Progress(data)`, `ProgressCircle(data)`, `IsProgressActive()`, `CancelProgress()`, `ShowTextUI(text, options)`, `HideTextUI()`, `Input(title, fields)`, `OpenMenu(id, data)` and `CloseMenu()`.

`Notify` also accepts an options table (`description` or `message`, `type`, `duration`). Input and menu data keep the format expected by the selected provider.

### Targeting

```lua
Bridge:AddBoxZone('garage', {
    coords = vec3(215.0, -810.0, 30.0),
    size = vec3(2.0, 2.0, 2.0),
    rotation = 0.0,
    options = {
        {
            name = 'open_garage',
            label = 'Open garage',
            icon = 'fa-solid fa-car',
            distance = 2.0,
            groups = { mechanic = 0 },
            onSelect = function()
                print('Garage selected')
            end,
        },
    },
})
```

Exports: `AddBoxZone(id, data)`, `AddSphereZone(data)`, `RemoveZone(id)`, `SetTargetEnabled(enabled)`, plus `AddGlobalTarget`, `AddPlayerTarget`, `AddVehicleTarget`, `AddModelTarget`, `AddEntityTarget`, `AddLocalEntityTarget` and their matching `Remove...` exports.

Target option tables are passed through the provider adapter. Keep the option shape compatible with `ox_target`/`qb-target` (`name`, `label`, `icon`, distance, groups/job restrictions and callbacks).

### Inventory, vehicles and appearance

```lua
Bridge:OpenInventory('stash', { id = 'police_armoury' })
local count = Bridge:GetItemCount('water')
local item = Bridge:GetItemData('water')
local items = Bridge:GetInventoryItems()

local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
Bridge:SetFuel(vehicle, 75.0)
local fuel = Bridge:GetFuel(vehicle)
Bridge:GiveVehicleKeys(vehicle)

Bridge:OpenAppearance()
local appearance = Bridge:GetAppearance()
```

Inventory exports: `OpenInventory(type, data)`, `GetItemCount(item, metadata)`, `GetItemData(item)`, `GetInventoryItems()`, `GetCurrentWeapon()` and `Disarm(state)`.

Vehicle/appearance exports: `GetFuel(vehicle)`, `SetFuel(vehicle, amount)`, `GiveVehicleKeys(vehicleOrPlate)`, `RemoveVehicleKeys(vehicleOrPlate)`, `OpenAppearance(data)`, `GetAppearance()`, `SetAppearance(data)`, `SetClothing(data)`, `TogglePhone(disabled)` and `OpenBossMenu(job)`.

Vehicle key providers may require an entity, while others accept a plate. The bridge handles both forms where the provider supports them.

### Dispatch and utilities

```lua
Bridge:SendDispatch({
    title = 'Shots fired',
    code = '10-13',
    priority = 'high', -- low, medium, high
    job = { 'police', 'sheriff' },
    time = 5,
    notify = 5,
    blip = { sprite = 161, color = 1, scale = 1.1, short = true },
})

local netId = Bridge:GetNetIdFromEntity(vehicle)
local entity = Bridge:GetEntityFromNetId(netId)
local state = Bridge:GetPlayerState()
```

`SendDispatch` requires `title` and `code`; it fills the local coordinates and street when omitted. Utility exports are `GetNetIdFromEntity(entity, timeout)`, `GetEntityFromNetId(netId, timeout)`, `GetPlayerState()` and `DrawMarkerLabel(coords, label, color)`.

## Server API

### Framework, jobs and permissions

Exports: `GetFramework()`, `GetPlayer(source)`, `GetIdentifier(source)`, `GetName(source)`, `GetGroup(source)`, `GetGroups(source)`, `HasGroup(source, group)`, `GetJob(source)`, `SetJob(source, job, grade)`, `IsOnDuty(source)`, `SetJobDuty(source, state)`, `GetJobs()`, `GetJobLabels()`, `GetDateOfBirth(source)` and `SetMetadata(source, key, value)`.

`GetJob(source)` returns the adapter's normalized job table. Job updates are also forwarded through `gravity_bridge:server:jobUpdated` and `gravity_bridge:client:jobUpdated` (see [Events](#events)).

### Money and personal banking

```lua
local source = source

if Bridge:RemoveMoney(source, 'bank', 500, 'garage purchase') then
    Bridge:AddMoney(source, 'cash', 100, 'garage refund')
end

local bank = Bridge:GetBankBalance(source)
Bridge:Deposit(source, 250, 'Paycheck')
Bridge:Withdraw(source, 100, 'Purchase')
```

Money exports are `GetMoney(source, account)`, `AddMoney(source, account, amount, reason)`, `RemoveMoney(source, account, amount, reason)`, `GetBankBalance(source)`, `Deposit(source, amount, reason)` and `Withdraw(source, amount, reason)`. Amounts for add/remove and society operations must be positive integers; removal also checks the current balance.

### Inventory

Exports: `GetItem(source, item)`, `GetItemCount(source, item, metadata)`, `GetInventory(source)`, `HasItem(source, item, amount)`, `CanCarryItem(source, item, amount)`, `AddItem(source, item, amount, metadata, slot)`, `RemoveItem(source, item, amount, metadata, slot)`, `RegisterUsableItem(item, callback)`, `GetItemSlot(source, slot)`, `GetItemData(item)`, `CreateInventoryDrop(prefix, items, coords)`, `CreateShop(name, data)`, `RegisterStash(id, label, slots, weight, owner, groups, coords)`, `GetRawInventory(id)`, `ClearInventory(id, keep)`, `SetItemMetadata(id, slot, metadata)` and `RegisterInventoryHook(event, callback, options)`.

Provider-specific data such as shop, stash, metadata and hook payloads is intentionally passed through without being rewritten. Follow the documentation of the selected inventory resource for those tables.

### Society, doorlock, keys and dispatch

```lua
local job = 'police'

if Bridge:AddSocietyMoney(source, job, 250) then
    print('Society account updated')
end

Bridge:SetDoorState('police_armoury', true)
Bridge:GiveVehicleKeys(source, 'POLICE1')

Bridge:SendDispatch(source, {
    title = 'Vehicle theft',
    code = '10-35',
    priority = 'high',
    job = { 'police' },
})
```

Exports: `GetSocietyBalance(source, job)`, `AddSocietyMoney(source, job, amount)`, `RemoveSocietyMoney(source, job, amount)`, `SetDoorState(doorId, locked)`, `GetDoor(doorId)`, `HasVehicleKeys(source, vehicle)`, `GiveVehicleKeys(source, vehicle, skipNotification)`, `RemoveVehicleKeys(source, vehicle, skipNotification)` and `SendDispatch(source, data)`.

Dispatch data accepts `title`, `code`, `priority`, `job`, `coords`, `time`, `notify` and `blip`. The server validates the title/code, clamps timers to 1-60 seconds, fills coordinates from `source` when possible and rate-limits repeated client-originated alerts.

### Notifications, logs and webhooks

```lua
Bridge:Notify(source, 'Purchase completed', 'success', 5000)

local record = Bridge:Log('garage.purchase', {
    message = 'Vehicle purchased',
    plate = 'ABC123',
}, { source = source, level = 'success' })

Bridge:SendWebhook(MyWebhookUrl, 'garage.purchase', {
    message = 'Vehicle purchased',
    plate = 'ABC123',
}, { source = source, level = 'success' })
```

`Notify(source, message, notifyType, duration, options)` forwards to the client notification provider. `Log(event, data, options)` returns a structured record and emits `gravity_bridge:server:log`. `SendWebhook(url, event, data, options)` sends a Discord embed and returns the same record. Keep webhook URLs in the calling resource's server-side configuration; the bridge does not store one globally.

## Modules

Named modules are available with `exports.gravity_bridge:GetModule(name)`. They expose the same functions as the top-level API and are useful when a resource wants to keep a smaller dependency surface.

| Side | Modules |
| --- | --- |
| Client | `Framework`, `Notify`, `Progress`, `TextUI`, `Input`, `Menu`, `Target`, `Inventory`, `Fuel`, `VehicleKeys`, `Appearance`, `Phone`, `BossMenu`, `Dispatch`, `Utils`, `Marker` |
| Server | `Framework`, `Inventory`, `Money`, `Banking`, `Doorlock`, `VehicleKeys`, `Dispatch`, `Society`, `Notify`, `Webhooks` |

```lua
local Inventory = exports.gravity_bridge:GetModule('Inventory')
local items = Inventory.GetItems()
```

The module table is also available through the `GetModule` export on the matching side. Modules are registered during bridge startup, so dependent resources should start after `g_bridge`.

## Events

| Event | Side | Payload |
| --- | --- | --- |
| `gravity_bridge:client:notify` | Client | `message, notifyType, duration, options` |
| `gravity_bridge:client:jobUpdated` | Client | `job, previousJob` (normalized client job tables) |
| `gravity_bridge:server:jobUpdated` | Server | `playerId, job, previousJob` |
| `gravity_bridge:server:dispatch` | Server | Dispatch data sent by a client |
| `gravity_bridge:server:log` | Server | Structured log record returned by `Log` |

Use the normalized job events instead of listening separately to ESX and QBCore job events when writing framework-agnostic resources.

## Adding a provider

Keep each integration in its own file. Do not add unrelated provider branches to a shared `resources.lua` file.

Example client provider:

```lua
Gravity.RegisterClientProvider('notification', 'my_notifications', {
    send = function(message, notifyType, duration, options)
        exports.my_notifications:show(message, notifyType, duration, options)
        return true
    end,
})
```

Example server provider:

```lua
Gravity.RegisterServerProvider('society', 'my_society', {
    getBalance = function(source, job)
        return exports.my_society:getBalance(job) or 0
    end,
    addMoney = function(source, job, amount)
        return exports.my_society:addMoney(job, amount) ~= false
    end,
    removeMoney = function(source, job, amount)
        return exports.my_society:removeMoney(job, amount) ~= false
    end,
})
```

Then:

1. Add the file to the matching `modules/client/<category>/` or `modules/server/<category>/` directory.
2. Add the resource name to the category order in `client/main.lua` or `server/main.lua`.
3. Add the name to the corresponding comment/list in `config.lua`.
4. Set `Config.<Category>` to the provider name and ensure the dependency starts first.

The public adapter contract is intentionally small, but provider-specific limitations still apply. Test every method that your resource depends on with the selected third-party resource.

## Localisation, debugging and updates

Set `Config.Locale` to `en` or `it`. Bridge messages live in [`locales/en.lua`](locales/en.lua) and [`locales/it.lua`](locales/it.lua); use the exported `Translate(key, ...)` helper for bridge-compatible text.

Set `Config.Debug = true` while integrating a provider. The server version checker compares the resource metadata version in `fxmanifest.lua` with the latest GitHub release; disable it with `Config.VersionCheck.enabled = false` if your server has no outbound HTTP access.

## License

See [`LICENSE`](LICENSE).
