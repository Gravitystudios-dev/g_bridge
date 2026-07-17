Config = {}

Config.Framework = 'auto' -- esx, qb, qbx, auto
Config.Debug = false

Config.VersionCheck = {
    enabled = true,
}

-- Available locales are defined in locales/.
Config.Locale = 'en'

-- Notification resource:
Config.Notification = 'auto' -- [
    -- ox_lib,
    -- qbx_core,
    -- qb-core,
    -- es_extended,
    -- okokNotify,
    -- mythic_notify,
    -- brutal_notify,
    -- is_ui,
    -- lation_ui,
    -- g-notifications,
    -- vms_notifyv2,
    -- wasabi_uikit,
    -- codem-notification
-- ]

-- Progress resource:
Config.Progress = 'auto' -- [
    -- ox_lib,
    -- qb-core,
    -- esx_progressbar
-- ]

-- TextUI resource:
Config.TextUI = 'auto' -- ox_lib, qb-core, es_extended

-- Input resource:
Config.Input = 'auto' -- ox_lib, qb-input, esx_menu_dialog

-- Menu resource:
Config.Menu = 'auto' -- ox_lib, qb-menu, esx_menu_default

-- Target resource:
Config.Target = 'auto' -- ox_target, qb-target

-- Inventory resource:
Config.Inventory = 'auto' -- ox_inventory, qs-inventory, qb-inventory, ps-inventory, codem-inventory, core_inventory, origen_inventory, one_inventory, framework

-- Personal banking:
Config.Banking = 'auto' -- auto, framework, Renewed-Banking, qb-banking, okokBanking

-- Fuel resource:
Config.Fuel = 'auto' -- auto, ox_fuel, ps-fuel, LegacyFuel, lc_fuel, qb-fuel, cdn-fuel, qs-fuelstations, bit-fuel, hex_1_fuel, rcore_fuel, x-fuel, myFuel, lyre_fuel, okokGasStation, Renewed-Fuel

-- Vehicle key resource:
Config.VehicleKeys = 'auto' -- auto, qbx_vehiclekeys, qs-vehiclekeys, qb-vehiclekeys, wasabi_carlock, 0r-vehiclekeys, Renewed-Vehiclekeys, MrNewbVehicleKeys, ak47_vehiclekeys, ak47_qb_vehiclekeys, brutal_carkeys, filo_vehiclekey, jc_vehiclekeys, is_vehiclekeys, mm_carkeys, LifeSaver_KeySystem, tgiann-hotwire, ic3d_vehiclekeys, p_carkeys

-- Appearance resource:
Config.Appearance = 'auto' -- auto, illenium-appearance, fivem-appearance, qs-appearance, 4bit_appearance, qb-clothing, esx_skin

-- Doorlock resource:
Config.Doorlock = 'auto' -- auto, ox_doorlock, qb-doorlock

-- Dispatch resource:
Config.Dispatch = 'auto' -- auto, ps-dispatch, qs-dispatch, cd_dispatch, rcore_dispatch, lb-tablet, tk_dispatch, core_dispatch, none

-- Shared society account resource:
Config.Society = 'auto' -- auto, esx_addonaccount, Renewed-Banking, qb-banking, okokBanking, qs-banking, wasabi_banking, p_banking, RxBanking, snipe-banking, prism_banking, nass_bossmenu, xnr-bossmenu, tgg-banking, fd_banking, crm-banking, kartik-banking, none

-- Boss menu resource:
Config.BossMenu = 'auto' -- auto, esx_society, qbx_management, qb-management, okokBossMenu, vms_bossmenu, xnr-bossmenu, g-bossmenu, tk_bosstablet, none

-- Phone resource (used to enable/disable phone access):
Config.Phone = 'auto' -- auto, lb-phone, npwd, qs-smartphone-pro, yseries, none
