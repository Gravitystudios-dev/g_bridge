--[[
    Gravity Bridge
    Main configuration

    Set a resource to `auto` to let the bridge detect the first started
    provider in its fallback order. Set an explicit resource name when you
    want to force a specific integration.
]]

Config = {}

-- ============================================================================
-- General
-- ============================================================================

Config.Framework = 'auto' -- 'auto', 'esx', 'qb', 'qbx'
Config.Locale = 'en'       -- Locales are available in locales/.
Config.Debug = false

Config.VersionCheck = {
    enabled = true,
}

-- ============================================================================
-- Interface
-- ============================================================================

-- Notifications:
-- 'auto', 'ox_lib', 'qbx_core', 'qb-core', 'es_extended', 'okokNotify',
-- 'mythic_notify', 'brutal_notify', 'is_ui', 'lation_ui', 'g-notifications',
-- 'vms_notifyv2', 'wasabi_uikit', 'codem-notification'
Config.Notification = 'auto'

-- Progress bars:
-- 'auto', 'ox_lib', 'qb-core', 'esx_progressbar'
Config.Progress = 'auto'

-- Text UI:
-- 'auto', 'ox_lib', 'qb-core', 'es_extended'
Config.TextUI = 'auto'

-- Input dialogs:
-- 'auto', 'ox_lib', 'qb-input', 'esx_menu_dialog'
Config.Input = 'auto'

-- Menus:
-- 'auto', 'ox_lib', 'qb-menu', 'esx_menu_default'
Config.Menu = 'auto'

-- Targeting:
-- 'auto', 'ox_target', 'qb-target'
Config.Target = 'auto'

-- ============================================================================
-- Gameplay
-- ============================================================================

-- Inventory:
-- 'auto', 'ox_inventory', 'qs-inventory', 'qb-inventory', 'ps-inventory',
-- 'codem-inventory', 'core_inventory', 'origen_inventory', 'one_inventory',
-- 'framework'
Config.Inventory = 'auto'

-- Fuel:
-- 'auto', 'ox_fuel', 'ps-fuel', 'LegacyFuel', 'lc_fuel', 'qb-fuel',
-- 'cdn-fuel', 'qs-fuelstations', 'bit-fuel', 'hex_1_fuel', 'rcore_fuel',
-- 'x-fuel', 'myFuel', 'lyre_fuel', 'okokGasStation', 'Renewed-Fuel'
Config.Fuel = 'auto'

-- Vehicle keys:
-- 'auto', 'qbx_vehiclekeys', 'qs-vehiclekeys', 'qb-vehiclekeys',
-- 'wasabi_carlock', '0r-vehiclekeys', 'Renewed-Vehiclekeys',
-- 'MrNewbVehicleKeys', 'ak47_vehiclekeys', 'ak47_qb_vehiclekeys',
-- 'brutal_carkeys', 'filo_vehiclekey', 'jc_vehiclekeys', 'is_vehiclekeys',
-- 'mm_carkeys', 'LifeSaver_KeySystem', 'tgiann-hotwire',
-- 'ic3d_vehiclekeys', 'p_carkeys'
Config.VehicleKeys = 'auto'

-- Appearance:
-- 'auto', 'illenium-appearance', 'fivem-appearance', 'qs-appearance',
-- '4bit_appearance', 'qb-clothing', 'esx_skin'
Config.Appearance = 'auto'

-- Door lock:
-- 'auto', 'ox_doorlock', 'qb-doorlock'
Config.Doorlock = 'auto'

-- ============================================================================
-- Services
-- ============================================================================

-- Personal banking:
-- 'auto', 'framework', 'Renewed-Banking', 'qb-banking', 'okokBanking'
Config.Banking = 'auto'

-- Dispatch:
-- 'auto', 'ps-dispatch', 'qs-dispatch', 'cd_dispatch', 'rcore_dispatch',
-- 'lb-tablet', 'tk_dispatch', 'core_dispatch', 'none'
Config.Dispatch = 'auto'

-- Shared society account:
-- 'auto', 'esx_addonaccount', 'Renewed-Banking', 'qb-banking',
-- 'okokBanking', 'qs-banking', 'wasabi_banking', 'p_banking', 'RxBanking',
-- 'snipe-banking', 'prism_banking', 'nass_bossmenu', 'xnr-bossmenu',
-- 'tgg-banking', 'fd_banking', 'crm-banking', 'kartik-banking', 'none'
Config.Society = 'auto'

-- Boss menu:
-- 'auto', 'esx_society', 'qbx_management', 'qb-management', 'okokBossMenu',
-- 'vms_bossmenu', 'xnr-bossmenu', 'g-bossmenu', 'tk_bosstablet', 'none'
Config.BossMenu = 'auto'

-- Phone access control:
-- 'auto', 'lb-phone', 'npwd', 'qs-smartphone-pro', 'yseries', 'none'
Config.Phone = 'auto'
