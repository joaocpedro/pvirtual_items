fx_version 'bodacious'
game 'gta5'
    
description 'Produção de items'
version '1.0.0'

client_scripts {
	"@vrp/lib/utils.lua", 
	"config.lua",
	"client.lua" 
}

server_scripts {
	"@vrp/lib/utils.lua",  
	"config.lua",
	"server.lua" 	
}