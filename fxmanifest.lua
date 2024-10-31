fx_version 'cerulean'
games { 'gta5' }

author ''
description 'Admin Zone'
version '1.0.0'

shared_scripts {'@qb-core/shared/locale.lua', 'locales/en.lua', 'config.lua',}
client_scripts {'client/main.lua',}
server_scripts {'server/main.lua', 'server/update.lua',}
