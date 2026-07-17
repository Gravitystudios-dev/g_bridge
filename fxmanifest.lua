fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Gravity Studios'
description 'Framework bridge for ESX Legacy, QBCore and QBox'
version '1.1.0'

shared_scripts {
    'config.lua',
    'locales/en.lua',
    'locales/it.lua',
    'shared/utils.lua',
    'shared/providers.lua',
    'shared/modules.lua',
    'shared/bridge.lua'
}

client_scripts {
    'adapters/client/esx.lua',
    'adapters/client/qb.lua',
    'adapters/client/qbx.lua',
    'modules/client/notifications/*.lua',
    'modules/client/progress/*.lua',
    'modules/client/textui/*.lua',
    'modules/client/input/*.lua',
    'modules/client/menu/*.lua',
    'modules/client/target/*.lua',
    'modules/client/inventory/*.lua',
    'modules/client/fuel/*.lua',
    'modules/client/vehiclekeys/*.lua',
    'modules/client/appearance/*.lua',
    'modules/client/phone/*.lua',
    'modules/client/bossmenu/*.lua',
    'client/main.lua'
}

server_scripts {
    'adapters/server/esx.lua',
    'adapters/server/qb.lua',
    'adapters/server/qbx.lua',
    'modules/server/inventory/*.lua',
    'modules/server/banking/*.lua',
    'modules/server/doorlock/*.lua',
    'modules/server/vehiclekeys/*.lua',
    'modules/server/dispatch/*.lua',
    'modules/server/society/*.lua',
    'modules/server/phone/*.lua',
    'modules/server/webhooks.lua',
    'server/main.lua'
}

dependencies {
    '/server:5181',
}
