fx_version "cerulean"
game { "gta5" }

author 'Zaps6000'
description 'bike spawner.'
version '1.0.0'

lua54 'yes'

client_script 'bike.lua'

shared_scripts {
    '@ox_lib/init.lua',
  'config.lua'
}


dependency 'ox_lib'
