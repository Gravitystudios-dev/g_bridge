# Gravity Bridge

Gravity Bridge is a modular FiveM compatibility layer for ESX Legacy, QBCore and QBox. It gives resources one consistent API for framework data, money, inventory, UI and common third-party systems.

The bridge is provider-based: each integration lives in its own file under `modules/`. Providers can be selected explicitly or detected automatically with `auto`.

## Features

- ESX Legacy, QBCore and QBox adapters
- Player, job, duty, permissions and metadata helpers
- Money, personal banking and society accounts
- Inventory operations and advanced inventory helpers
- Notifications, progress bars, TextUI, input dialogs and menus
- `ox_target` and `qb-target` zones, entities, models and global targets
- Fuel, vehicle keys, appearance, doorlock, dispatch, boss menu and phone integrations
- Localisation, audit logs, Discord webhooks and version checking
- No permanent polling loops in the bridge core

## Installation

1. Place the resource in `resources/[gravity]/g_bridge`.
2. Start your framework and the resources used by your selected providers first.
3. Add this to `server.cfg`:

```cfg
ensure g_bridge
```

The bridge does not require `ox_lib` or `oxmysql`. They are used only when the selected provider itself requires them.

## Configuration

All options are in `config.lua`. Use `auto` for detection, or set the exact resource name.

```lua
Config.Framework = 'auto' -- esx, qb, qbx, auto
Config.Locale = 'it'      -- it, en
Config.Debug = false

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

Supported providers include `ox_lib`, `qbx_core`, `qb-core`, `es_extended`, `ox_target`, `qb-target`, `ox_inventory`, `qs-inventory`, `qb-inventory`, `ps-inventory`, `codem-inventory`, `core_inventory`, `origen_inventory`, `one_inventory`, `Renewed-Banking`, `qb-banking`, `okokBanking`, `esx_addonaccount`, `ps-dispatch`, `qs-dispatch`, `cd_dispatch`, `rcore_dispatch`, `lb-tablet` and `tk_dispatch`. Refer to `config.lua` for the complete list.

## Client usage

```lua
local Bridge = exports.gravity_bridge

Bridge:Notify({
    title = 'Garage',
    description = 'Vehicle stored successfully.',
    type = 'success',
})

if Bridge:IsOnDuty() then
    Bridge:ShowTextUI('[E] Open garage')
end

local completed = Bridge:Progress({
    label = 'Opening garage...',
    duration = 3000,
    canCancel = true,
})

Bridge:AddBoxZone('garage', {
    coords = vec3(215.0, -810.0, 30.0),
    size = vec3(2.0, 2.0, 2.0),
    options = {
        {
            name = 'open_garage',
            label = 'Open garage',
            icon = 'fa-solid fa-car',
            onSelect = function()
                print('Garage selected')
            end,
        },
    },
})
```

The `exports.gravity_bridge` object is available on both client and server. You can also retrieve a named module:

```lua
local Inventory = exports.gravity_bridge:GetModule('Inventory')
local items = Inventory.GetItems()
```

## Client exports

| Export | Description |
| --- | --- |
| `GetFramework()` | Returns `esx`, `qb` or `qbx`. |
| `GetPlayerData()` / `IsPlayerLoaded()` | Returns normalized local framework data and load state. |
| `GetIdentifier()` / `GetPlayerName()` / `GetJob()` / `IsOnDuty()` | Local player helpers. |
| `TriggerCallback(name, callback, ...)` | Calls an ESX/QB-compatible server callback. |
| `Notify(...)` | Sends a notification through the configured provider. |
| `Progress(data)` / `ProgressCircle(data)` | Starts a progress interaction. |
| `IsProgressActive()` / `CancelProgress()` | Controls the active progress interaction. |
| `ShowTextUI(text, options)` / `HideTextUI()` | Shows or hides TextUI. |
| `Input(title, fields)` | Opens a provider-specific input dialog. |
| `OpenMenu(id, data)` / `CloseMenu()` | Opens or closes a menu. |
| `AddBoxZone(id, data)` / `AddSphereZone(data)` / `RemoveZone(id)` | Manages target zones. |
| `AddGlobalTarget`, `AddPlayerTarget`, `AddVehicleTarget`, `AddModelTarget`, `AddEntityTarget`, | `AddLocalEntityTarget` | Adds target options; matching remove exports are available. |
| `OpenInventory(type, data)` | Opens the configured inventory. |
| `GetItemCount`, `GetItemData`, `GetInventoryItems`, `GetCurrentWeapon`, `Disarm` | Client inventory helpers. |
| `GetFuel(vehicle)` / `SetFuel(vehicle, amount)` | Reads or changes vehicle fuel. |
| `GiveVehicleKeys(vehicleOrPlate)` / `RemoveVehicleKeys(vehicleOrPlate)` | Manages vehicle keys. |
| `OpenAppearance(data)` / `GetAppearance()` / `SetAppearance(data)` / `SetClothing(data)` | Appearance helpers. |
| `TogglePhone(disabled)` | Enables or disables phone access. |
| `OpenBossMenu(job)` | Opens the selected boss menu. |
| `SendDispatch(data)` | Sends a dispatch alert from the local player. |
| `GetNetIdFromEntity`, `GetEntityFromNetId`, `GetPlayerState` | Entity and player-state utilities. |
| `DrawMarkerLabel(coords, label, color)` | Draws a world-space label. |

## Server usage

```lua
local Bridge = exports.gravity_bridge

local playerSource = source

if Bridge:RemoveMoney(playerSource, 'bank', 500, 'garage purchase') then
    Bridge:AddItem(playerSource, 'vehicle_keys', 1)
    Bridge:Notify(playerSource, 'Purchase completed', 'success')
end

Bridge:AddSocietyMoney(playerSource, 'police', 250)
Bridge:SendDispatch(playerSource, {
    title = 'Vehicle theft',
    code = '10-13',
    priority = 'high',
    job = { 'police', 'sheriff' },
})
```

## Server exports

| Export | Description |
| --- | --- |
| `GetFramework()` / `GetBridge()` / `GetModule(name)` | Framework name, complete bridge or named module. |
| `GetPlayer(source)` / `GetIdentifier(source)` / `GetName(source)` | Player helpers. |
| `GetGroup(source)` / `GetGroups(source)` / `HasGroup(source, group)` | Permission helpers. |
| `GetJob(source)` / `SetJob(source, job, grade)` | Reads or updates a player's job. |
| `IsOnDuty(source)` / `SetJobDuty(source, state)` | Reads or updates job duty. |
| `GetJobs()` / `GetJobLabels()` | Returns framework job definitions. |
| `GetDateOfBirth(source)` / `SetMetadata(source, key, value)` | Character information helpers. |
| `GetMoney` / `AddMoney` / `RemoveMoney` | Validated money operations. |
| `GetItem` / `GetItemCount` / `GetInventory` / `HasItem` | Inventory queries. |
| `CanCarryItem` / `AddItem` / `RemoveItem` | Validated inventory operations. |
| `GetItemSlot` / `GetItemData` / `CreateShop` / `RegisterStash` | Advanced inventory operations. |
| `CreateInventoryDrop` / `GetRawInventory` / `ClearInventory` / `SetItemMetadata` | Provider-specific inventory helpers. |
| `RegisterUsableItem` / `RegisterInventoryHook` | Registers inventory callbacks and hooks. |
| `RegisterCallback(name, callback)` | Registers an ESX/QB-compatible callback. |
| `GetBankBalance` / `Deposit` / `Withdraw` | Personal banking operations. |
| `GetSocietyBalance` / `AddSocietyMoney` / `RemoveSocietyMoney` | Society account operations. |
| `SetDoorState` / `GetDoor` | Doorlock operations. |
| `HasVehicleKeys` / `GiveVehicleKeys` / `RemoveVehicleKeys` | Server-side vehicle key helpers where supported. |
| `SendDispatch(source, data)` | Sends a normalized dispatch alert. |
| `Log(event, data, options)` / `SendWebhook(...)` | Audit logging and explicit Discord webhook delivery. |

Money and inventory operations return `false` when validation fails or the selected provider cannot complete the operation.

## Dispatch format

```lua
exports.gravity_bridge:SendDispatch(source, {
    title = 'Shots fired',
    code = '10-13',
    priority = 'high', -- low, medium, high
    job = { 'police' },
    time = 5,
    notify = 5,
    blip = {
        sprite = 161,
        color = 1,
        scale = 1.1,
        short = true,
    },
})
```

The bridge uses the player's current server position for client-originated dispatches and rate-limits repeated alerts.

## Modules

Server modules: `Framework`, `Inventory`, `Money`, `Banking`, `Society`, `Doorlock`, `VehicleKeys`, `Dispatch`, `Notify`, `Webhooks`.

Client modules: `Framework`, `Inventory`, `Fuel`, `VehicleKeys`, `Appearance`, `Notify`, `Progress`, `TextUI`, `Input`, `Menu`, `Target`, `Phone`, `BossMenu`, `Dispatch`, `Utils`, `Marker`.

## Adding a provider

Create one file in the matching `modules/` directory and register the provider:

```lua
Gravity.RegisterClientProvider('notification', 'my_notifications', {
    send = function(message, notifyType, duration, options)
        exports.my_notifications:show(message, notifyType, duration, options)
        return true
    end,
})
```

Then add `my_notifications` to the relevant order in `client/main.lua` and configure it with `Config.Notification = 'my_notifications'`.

## Localisation and logging

Set `Config.Locale` to `it` or `en`, then edit the corresponding file in `locales/`. Use `Translate()` for bridge messages.

The bridge records framework, money, inventory, banking, door, key, notification and player lifecycle events through `Log()`. Webhooks are sent only when a calling resource explicitly supplies its own webhook URL.

## License

See [LICENSE](LICENSE).
