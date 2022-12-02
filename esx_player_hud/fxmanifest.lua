fx_version 'adamant'
lua54 "yes"
game "gta5"

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
	'html/css/grid.css',
	'html/js/main.js',
	'html/img/*',
	'html/fonts/*'
}

server_scripts {
    'server.lua',
	'html/fonts/font.lua'
}

client_script 'client.lua'