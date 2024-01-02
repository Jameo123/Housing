fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts{
    'client/client.lua',
    "@ag_framework/initialise/cInit.lua"
}

server_scripts{
    'server/server.lua',
    "@ag_framework/initialise/sInit.lua",
	'@ag_framework/locale.lua',
	'@ag_framework/database/lib/mysql.lua'
}

shared_scripts{
    'shared/config.lua'
}