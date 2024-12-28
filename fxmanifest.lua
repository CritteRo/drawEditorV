fx_version 'cerulean'
game 'gta5'

author 'CritteR & YOU(if you PR this)'
description 'drawEditorV helps you easily create, modify and export to lua text and other drawables. Menu framework by Warxander'

version '4'
dependency '/server:12168'

client_scripts {
    'util/warmenu.lua',
    'util/cl_functions.lua',
    'util/cl_button_scaleform.lua',
    'client/cl_editor_menu.lua',
    'client/cl_editor_main.lua',
}

server_script 'saves/sv_saveFiles.lua'