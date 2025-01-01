fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'LS-DEV'
description 'ESX Fraktion Tracker with GPS Live-Sync'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
