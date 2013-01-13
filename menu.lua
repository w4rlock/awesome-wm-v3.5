sudo="gksudo "

--ArchLinux
daemon_path="/etc/rc.d/"

--Gentoo
--daemon_path="/etc/init.d/"

myawesomemenu = {
   { "manual"      , env.terminal .. " -e man awesome" }                           , 
   { "edit theme"  , editor_cmd .. " " .. dir .. "/themes/default/theme.lua" } , 
   { "edit config" , editor_cmd .. " " .. dir .. "/rc.lua" }                   , 
   { "restart"     , awesome.restart }                                         , 
   { "quit"        , awesome.quit }
   }

develop = {
	{ "Eclipse"    , "eclipse" }    , 
	{ "NetBeans"    , "netbeans" }    , 
	{ "GVim"        , "gvim" }
	}
	
music = {
	{ "Ncmpcpp", env.terminal .. " -e ncmpcpp" },
	{ "Mocp",    env.terminal .. " -e mocp" }
	}

sniffs = {
	{ "Ettercap" , env.terminal .. " -e sudo wireshark" },
	{ "Wireshark" , env.terminal .. " -e sudo wireshark" }
	}

firewall = {
	{ "Ubuntu Firewall" , env.terminal .. " -e sudo gufw" } ,
	{ "Firestarter" , env.terminal .. " -e sudo firestarter" },
}

servicesmail = {
	{ "Bitlbee start",      sudo .. daemon_path .. "bitlbee start" }, 
	{ "Bitlbee stop",       sudo .. daemon_path .. "bitlbee stop" }
  }

servicessecurity = {
	{ "Iptables start",     sudo .. daemon_path .. "iptables start" }, 
	{ "Iptables stop",      sudo .. daemon_path .. "iptables stop" },
	{ "I2p start",          env.terminal .. " -e i2prouter start && firefox http://127.0.0.1:7657" },
	{ "I2p stop",           env.terminal .. " -e i2prouter stop" },
	{ "Privoxy start",      sudo .. daemon_path .. "privoxy start" }, 
	{ "Privoxy stop",       sudo .. daemon_path .. "privoxy stop" },
	{ "Tor start",          sudo .. daemon_path .. "tor start" },
	{ "Tor stop",           sudo .. daemon_path .. "tor stop" }
  }

servicesdatabases = {
	{ "Postgresql start",   sudo .. daemon_path .. "postgresql start" }, 
	{ "Postgresql stop",    sudo .. daemon_path .. "postgresql stop" }
  }
  
servicesservidores = {
	{ "Apache start",        sudo .. daemon_path .. "httpd start" }, 
	{ "Apache stop",         sudo .. daemon_path .. "httpd stop" },
	{ "Tomcat start",       sudo .. daemon_path .. "tomcat7 start" }, 
	{ "Tomcat stop",        sudo .. daemon_path .. "tomcat7 stop" }
}

services = {
  { "Servers",   servicesservidores},
  { "DataBases", servicesdatabases},
  { "Security",  servicessecurity},
  { "Mail",      servicesmail},
	{ "Ethernet start",     sudo .. daemon_path .. "net.eth1 start" },
	{ "Ethernet restart",   sudo .. daemon_path .. "net.eth1 restart" },
	{ "Mpd start",          sudo .. daemon_path .. "mpd start" }, 
	{ "Mpd stop",           sudo .. daemon_path .. "mpd stop" },
	{ "Sshd start",         sudo .. daemon_path .. "sshd start" }, 
	{ "Sshd stop",          sudo .. daemon_path .. "sshd stop" },
	}

browsers = {
	{ "Firefox"  , "firefox" }, 
	{ "Luakit"  , "luakit" }, 
	}

analyzersnet = {
	{ "Iftop"  , env.terminal .. " -e iftop"}
	}

wifi = {
	{"Wicd", "wicd-client"}
	}

scanners = {
	{"Nmap",  "zenmap"},
	{"Nbtscan", "urxvt -e nbtscan"}
	}

vulnerability = {
	{"Nessus", "nessus"},
	{"Nikto",   env.terminal .. " -e nikto --help"}
	}

exploits = {
	{"ExploitDB", ""},
	{"Fasttrack", "fasttrack"},
	{"Metaspl0it", "/opt/metasploit/msfconsole"},
	{"W3af", "w3af_gui"}
	}

network = {
	{ "Analyzers", analyzersnet },
	{ "Audit"    , vulnerability },
	{ "Browsers" , browsers },
	{ "Expl0its" , exploits}   , 
	{ "Scanners" , scanners}   , 
	{ "Sniffers" , sniffs}   , 
	{ "Wifi"     , wifi}
	}

myimagenMenu = {
    {"Gimp"     , "gimp"}     , 
    {"Gpicview" , "gpicview"} , 
    {"Nitrog3n" , "nitrogen"} 
	}


editors = {
    { "Vim"  , env.terminal .. " -e vim"} , 
    { "Gvim" , "gvim"}
	}

crypt = {
    { "TrueCrypt"  , "truecrypt"}    , 
    { "Gpa"        , "gpa"}          , 
    { "GpgCrypter" , "gpg-crypter"}
	}

utils = {
   {"Galculator", "galculator"}
   }

tools = {
	{ "Grub refresh" , sudo .. "grub-install /dev/sda"}, 
	{ "Thun4r"     , "thunar"}, 
	{ "Nautilus"   , "nautilus --no-desktop"},
	{ "VirtualBox" , "VirtualBox"}
	}

dataBase = { 
	{ "Query"      , "mysql-query"}, 
	{ "Emma"       , "emma"}, 
	{ "Workbench"  , "mysql-workbench"}, 
	{ "PhpMyadmin" , "firefox http://localhost/phpmyadmin/index.php"}
	}

mymainmenu = awful.menu({ items = {
	{ "Awes0me"  , myawesomemenu , beautiful.awesome_icon } , 
	{ "Gr4phics" , myimagenMenu} , 
	--{ "edit0rs"  , editors       , beautiful.editors},
	{ "Edit0rs"  , editors       , },
	{ "Mu5ic"    , music}        , 
	{ "Cryp7o"    , crypt}        , 
	--{ "Mysql"    , dataBase}     , 
	--{ "t00ls"    , tools         , beautiful.tools},
	{ "Tools"    , tools         , },
	{ "Develop"  , develop}      , 
	{ "Netw0rk"  , network}      , 
	{ "Servic3s"  , services}      , 
	{ "Util5"    , utils}
	}
    })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
