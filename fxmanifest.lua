-- fxmanifest.lua

fx_version 'cerulean'
game 'gta5'

author 'Apollyon_world'
description 'Commande de rename (admin only)'
version '1.0.0'

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua', -- Assurez-vous que 'oxmysql' est installé et utilisé
    'rename_command.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
