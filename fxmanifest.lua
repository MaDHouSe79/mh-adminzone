fx_version 'cerulean'
games { 'gta5' }

author 'Nick Perry'
description 'Admin Zone'
version '1.0.4'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- change en to your language
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'
