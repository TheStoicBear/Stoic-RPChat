author "TheStoicBear"
description "Stoic-RPChat"
version "0.2.4"
fx_version "cerulean"
game "gta5"

client_script "source/client.lua"

server_script {
  "source/server.lua",
  "source/showid.lua"
}

shared_scripts {
  "@ND_Core/init.lua",
  "config.lua",
  '@ox_lib/init.lua'
}

dependencies {
    "ox_lib",
    "ND_Core",
    "ND_Characters",
  }
