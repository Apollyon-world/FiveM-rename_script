fx_version 'cerulean'
game 'gta5'

author 'Apollyon_world'
description 'Commande de rename (admin only)'
version '1.0.0'

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'rename_command.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
