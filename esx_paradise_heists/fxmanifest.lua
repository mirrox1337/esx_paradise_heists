fx_version 'adamant'

game 'gta5'

description 'Paradise Heists'

version '1.0.0'

-- server_scripts {
-- 	'@mysql-async/lib/MySQL.lua',
-- 	'@es_extended/locale.lua',
-- 	'server/main.lua'
-- }

client_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'client/client.lua',
	'client/fleeca.lua',
	'client/drilling.lua',
	'client/hacking.lua',

	'locales/cs.lua',
}

server_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'server/server.lua',

	'locales/cs.lua',
}

dependencies {
	'es_extended',
}