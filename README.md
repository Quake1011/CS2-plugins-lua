# CS2-plugins-lua

**IMPORTANT: Since when the map is changed, the player_connect event is not executed, in which all important data is transmitted, it was decided to kick all players at those moments when the map is changed so that they manually perform this event. Without it, the plugin is really useless and will not work.**

Includes 9 mini lua plugins for CS2

- Mini-admin
- Voting for map
- Ammo and health refill after kill
- Connect/disconnect events announcer
- Team switch announcer
- Advertisement
- Kill announcer with distance print
- Round end/start announcer
- Bomb explode announcer

https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/50b5fdc8-c219-4b69-9a0d-c0cf7e02ea92
![image](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/7a1a3172-cbd2-46dd-8b57-a84f0e47f457)
![image](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/9d107fa1-e816-43ba-8cb6-fd1f5d323fa3)
![1696519118102](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/b8828d36-0c12-4194-969a-642f20feb42c)
![1696462889660](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/d577bdcf-8061-438d-b99a-36e2fb518a63)
![1696442132297](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/c9c87e28-922b-4b4d-8d0c-03767a1556a3)
![1696442460163](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/1b648968-de98-453f-8848-7c514f71a266)
![1696442440011](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/a64fc621-9969-4fab-bf96-d1c6e2b0fff5)
![273487569-64fafb2d-45d1-49ae-bec1-0b1a80cef984](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/eda2567b-42f2-4a3e-b9b9-51c67ce18f0f)


## Install
1) Place it in **game\csgo\scripts** if folder not exist then you should to make it
2) Add to **gamemode_your_gamemode_name.cfg** next lines:
```
sv_cheats 1
script_reload_code plugins
sv_cheats 0
```
3) Reload the server


## Requirements
- patching vscript.dll:
	- [method-1](https://hlmod.net/threads/source-2-skripting.64842/post-631602)
	- [method-2](https://github.com/Source2ZE/LuaUnlocker)
 	- [method-3](https://github.com/bklol/vscriptPatch/tree/main)
 	- [method-4](https://hlmod.net/threads/source-2-skripting.64842/page-6#post-631991)(easilier)

## Config file 
```
// -------------- output types
// Chat - print in common text chat                                	Color tags below
// Center - - print in common center window below middle        	Doesn't support colors
// Panel - - print in common center win panel above middle        	HTML font colors            | type only for adverts
// Hint - - print in common center tip below middle                	Doesn't support colors      | type only for adverts

// -------------- colors
// {WHITE},{DARKRED},{PURPLE},{DARKGREEN},{LIGHTGREEN},{GREEN},{RED},{LIGHTGREY},{YELLOW},{ORANGE},{DARKGREY},{BLUE},{DARKBLUE},{GRAY},{DARKPURPLE},{LIGHTRED}

// -------------- usefull tags
// {NL} - new line
// {IP} - server ip taken from hostip ConVar
// {PORT} - server port taken from hostport ConVar
// {MAXPL} - max players number taken from sv_visiblemaxplayers ConVar
// {PL} - current players number
// {MAP} - current map
// {NEXTMAP} - next map
// {TIME} - local server time

// -------------- medias
// {DISCORD} - discord link taken from "discord_invite_link" key
// {VK} - vkontakte link taken from "vk_link" key
// {TG} - telegram link taken from "telegram_link" key
// {SITE} - site link taken from "site_link" key
// {INST} - instagram link taken from "inst_link" key
// {TT} - tiktok link taken from "tik_tok_link" key
// {YT} - youtube link taken from "youtube_link" key
// {STEAM} - steam group link taken from "steam_link" key
// {GROUP} - group link taken from "community_link" key

// AVAILABLE ADMIN COMMANDS:
//
//    login <password>	// Getting admin rights
//        @password - admin password taken from "admin_password" key below. Required for using all these commands(string)
//
//    kickit <uid> <reason>    // kick player
//        @uid - userid of client(int) It was any userid or @all text if u want to kick all exclude self
//        @reason - reason of kick(string) 
//
//    setmap <map> <changetime>		// change map after N time
//        @map - name of map to change. For example de_mirage(string)
//        @changetime - value of counter until map changing in seconds(int)
//
//    conexec <convar> <newvalue>		// execute convar 
//        @convar - console variable name. For example sv_cheats(string)
//        @newvalue - new value of convar(any)
//
//    asay <message>			// send message by admin in chat
//        @message - message which prints after admin tag(string)
//
//    hp <uid> <value>			// set hp for player
//        @uid - userid of client(int)
//        @value - new value of health(int)
//
//    size <uid> <value>			// set size for player
//        @uid - userid of client(int)
//        @value - new value of size(float)
//
//    clr <uid> <r> <g> <b> <a>		// set color and alpha for player
//        @uid - userid of client(int)
//        @r - rate of red color(int)(0-255)
//        @g - rate of green color(int)(0-255)
//        @b - rate of blue color(int)(0-255)
//        @a - rate of alpha(int)(0-255)
//
//    grav <uid> <value>		// set gravity for player
//        @uid - userid of client(int)
//        @value - new value of gravity(float)
//
//    fric <uid> <value>			// set friction for player
//        @uid - userid of client(int)
//        @value - new value of friction(float)
//
//    disarm <uid> <weapon_classname>		// disarm player
//        @uid - userid of client(int)
//        @weapon_classname - classname of weapon which will removed from client currently equipements(string) It was any classweapon or @all text if u want to disarm all weapon of client
//
//    killit <uid>			// kill player
//        @uid - userid of client(int)
//
//    changeteam <uid> <team>		// change player team
//        @uid - userid of client(int)
//        @team - new team(string)		available values 		CT - ct or 3		T - t or 2		SPECS - spec or 1
//
//    hudstatus <uid> <status>			// set friction for player
//        @uid - userid of client(int)
//        @status - turn off or turn on the HUD display(bool)(0 / 1)
//
// AVAILABLE PLAYER COMMANDS:
//        
//    votemap <mapname>		// voting to mapchange
//        @mapname - name of map for want to vote(string)
//
//    suicide		// suicide command without sv_cheats 1

"Plugins"
{
	// ========================VOTEMAP BLOCK========================
	"votemap_enable"					"1" // enable voting to map or not?				[    0 - off			|    1 - on		]
	"votemap_require_votes"				"0.7" // required number of votes to change map		If float value - ratio of votes(0.1 - 1.0) | If integer value - real votes (1 - ...)
	"votemap_enable_message"			"1" // enable message of voting to map or not?				[    0 - off			|    1 - on		]
	"votemap_voted_message"				"{ORANGE}[VOTES] {WHITE}The player {DARKBLUE}{user} {WHITE}voted for the map {RED}{namemap} {GREEN}[{current}/{need}]" // message when player voted successfully
	//    {user} - player who voted
	//    {namemap} - name of map
	//    {current} - current number of voted	
	//    {need} - required number of votes to change map	
	//
	
	"endmatch_mapchange_message"		"{YELLOW}[MAP] {GREEN}Until the map change{GREEN} is left: {RED}{seconds}{GREEN}s. Connect to server again!" // message when match end and map changing
	//    {seconds}			- time in seconds until map changing
	//
	
	// ========================ADMIN BLOCK========================
	"admin_password"			"ldk95e5hg"				// password for logon server
	"admin_message_tag"			"{RED}[ADMIN] "			// admin tag at the beginning of the message
	"admin_message_color"		"{PURPLE}"				// color of admins message. Supported all symbols which less 128 encoding of ASCII
	"admin_kickmessage_enable"	"1"	// enable message of kick or not?				[    0 - off			|    1 - on		]
	"admin_kickall_message"		"{PURPLE}[KICK] {WHITE}Player {RED}{user} {WHITE}kicked by reason: {RED}{reason}"
	//    {user} - kicked user
	//    {reason} - reason of kick
	//
	
	"admin_mapchange_message_counter_status"			"1" // Enable chat counter before map changing by admin?	[    0 - off			|    1 - on		]
	"admin_mapchange_message"	"{YELLOW}[MAP] {GREEN}Until the map change to {RED}{changemap}{GREEN} is left: {RED}{seconds}{GREEN}s."			// timer message before map change
	//    {seconds}			- time in seconds until map changing
	//    {changemap}		- map to changing
	//
	
	// ========================HEALTH REFILLER BLOCK========================
    "health_refill"				"1"    // Refill health when player kill?				[    0 - off			|    1 - on		]
	"health_refill_value"		"all"  // How many hp restore?							[	all - all hp will restored	|	N - N-value will restored]
	
    // ========================AMMO REFILLER BLOCK========================
    "kill_ammo_refill"			"1"    // Refill ammo when player kill?                 [    0 - off		|    1 - on		]
    "ammo_type_refill"			"1"    // Type of ammo for refilling					[    1 - clip		|    2 - reserved	|    3 - all        ]
    "all_equiped_weapon"		"0"    // Refill all equipped weapons or currently?    	[    0 - currently	|    1 - all		]

    // ========================KILL ANNOUNCER BLOCK========================
    "kill_announce"				"1"        // player death announcer 					[0 - off | 1 - on]
    "kill_announce_message"		"{DARKRED}[ KILL ]{WHITE} Игрок {DARKGREEN}{attacker}{WHITE} убил {DARKGREEN}{user} {WHITE}с расстояния: {DARKRED}{distance}м."
    //    {attacker} - killer
    //    {user} - victim
    //    {distance} - distance between at death
    //
 
    // ========================CONNECT/DISCONNECT ANNOUNCER BLOCK========================
    "bot_connect_announce"		"1" // whether to display the connection of bots
    "connect_announce"			"1" // player connect announcer 						[0 - off | 1 - on]
    "connect_announce_message"	"{DARKRED}|| {WHITE} Игрок {DARKGREEN}{user} {WHITE}зашел на сервер{NL} {DARKRED}||{WHITE} Статус: {GREEN}{botstatus}{NL} {DARKRED}||{WHITE} IP: {GREEN}{ipclient}{NL} {DARKRED}||{WHITE} SteamID2: {GREEN}{steamid2}{NL} {DARKRED}||{WHITE} SteamID3: {GREEN}{steamid3}"
    //    {user} - player who connected
    //    {botstatus}    - bot or not?
    //    {steamid2}    - steamid2 STEAM_0:1:XXXXXXX
    //    {steamid3}    - steamid3 [U:1:XXXXXXX]
    //    {ipclient}    - ip address of client
    //
 
    "bot_disconnect_announce"	"1" // whether to display the disconnection of bots 	[0 - off | 1 - on]
    "disconnect_announce"		"1" // player disconnect announcer 						[0 - off | 1 - on]
    "disconnect_announce_message"    "{DARKRED}[ INFO ]{WHITE} Игрок {DARKGREEN}{user} {WHITE}вышел с сервера"
    //    {user} - player who disconnected
    //
 
    // ========================CHANGE TEAM ANNOUNCER BLOCK========================
    "change_team_announce"		"1" // player change team announcer 					[0 - off | 1 - on]
    "change_team_announce_message"	"{DARKRED}[ TEAM ]{WHITE} Игрок {LIGHTGREEN}{user} {WHITE}перешел за команду {ORANGE}{team}"
    //    {user} - player who changed team
    //    {team}    - new team
    //
 
    // ========================BOMB TIMER ANNOUNCER BLOCK========================
    "bomb_time_announce"		"1" // announce every 20, 10, 5, 4, 3, 2, 1, 0 seconds explode remaining [0 - off | 1 - on]
 
    // ========================ROUND END/START ANNOUNCER BLOCK========================
    "round_start_message_status"	"0" // round start announcer 						[0 - off | 1 - on]
    "round_start_message" // print message every round start block
    {
        "Center"				"Round started!"
    }
 
    "round_end_message_status"	"0" // round end announcer 								[0 - off | 1 - on]
    "round_end_message" // print message every round end block
    {
        "Chat"					"Round End now!"
        "Center"				"Visit our site: {SITE}"
    }
 
    // ========================ADVERTISEMENT BLOCK========================
    "time"     "10.0" // time between ads. Set it to 0.0 if u want not use cycled advs below
 
    // if u want remove several links u can do this just delete all string and set value of key to void
    "discord_invite_link"		"3JbqDN4" // Invlite-link to discord ----> for {DISCORD} tag. In output prints like https://discord.gg/3JbqDN4
    "vk_link"					"https://vk.com/bgtroll" // Link to vk profile or group ----> for {VK} tag
    "telegram_link"				"https://t.me/ArrayListX" // Link to telegram ----> for {TG} tag
    "site_link"					"https://mysite.ru/" // Link on your own site ----> for {SITE} tag
    "inst_link"					"https://www.instagram.com/quake1011/" // Link on your instagram ----> for {INST} tag
    "tik_tok_link"				"https://www.tiktok.com/@quake1011" // Link on your tik tok ----> for {TT} tag
    "youtube_link"				"https://www.youtube.com/@quake1011" // Link on your youtube ----> for {YT} tag
    "steam_link"				"https://steamcommunity.com/groups/quake1011" // Link on your steam group ----> for {STEAM} tag
    "community_link"			"https://mycommunity.com/community/quake1011" // Link on your own community ----> for {GROUP} tag
 
    "adverts"
    {
    
        "1" // advert block
        {
            "Chat"            	"{DARKRED}[ INFO ]{WHITE} Добавьте наш сервер в избранное: {DARKGREEN}{IP}:{PORT}"
            "Center"        	"Добавьте наш сервер в избранное: {IP}:{PORT}"
        }
        "2"    
        {
            "Chat"            	"{YELLOW}---- ---- ---- Контакты ---- ---- ----{NL}{WHITE}Telegram - {DARKPURPLE}{TG}{NL}{WHITE}VK - {BLUE}{VK}{NL}{WHITE}Discord - {DARKBLUE}{DISCORD}{NL}{YELLOW}---- ---- ---- ---- ---- ---- ---- ----"
        }
        "3"    
        {
            "Chat"            	"{DARKRED}[ INFO ]{WHITE} Введите {DARKGREEN}!rank {WHITE}для вывода личной статистики{DARKRED} (в разработке)"
            "Panel"
            {
                "message"    	"<font color='#00FF00'>This contains <font class='fontSize-l'>cs_win_panel_round</font> advert</font>" // text
                "time"        	"5" //  time existing of message
            }
            "Hint" // gameinstructor_enable should be enabled on clients for them to see it because valve delete this option in settings. If hint dont work then type in console this command
            {
                "message"    	"This contains env_instructor_hint advert" // text
                "time"        	"5" //  time existing of panel
                "icon"        	"icon_alert" // icons for output near text https://developer.valvesoftware.com/wiki/Env_instructor_hint#Icons
            }
        }
		"4"
        {
            "Chat"              "{DARKRED}[ INFO ] {WHITE}Игроки: {PL}/{MAXPL}{NL} {DARKRED}[ INFO ] {WHITE}Текущая карта: {MAP}{NL}{DARKRED}[ INFO ] {WHITE}Следующая карта: {NEXTMAP}"
        }
        "5"    
        {
            "Chat"            	"{DARKRED}[ INFO ] {WHITE}Для смены карты введите в консоль {GREEN}votemap map_name{NL}{DARKRED}[ INFO ] {WHITE}Время сервера: {PURPLE}{TIME}"
        }
        "6"    
        {
            "Chat"            	"Hello. I am a string and i so{NL}l{NL}o{NL}o{NL}o{NL}o{NL}o{NL}o{NL}o{NL}n{NL}g" // you can do infinite size of advert by {NL} tag. Of course while chat dont end :D
        }
    }
}
```
## Credits
https://github.com/deaFPS
https://vk.com/prodby4realraze(testing)

## About possible problems, please let me know: 
- discord - quake1011
All icons below are clickabled
[<img src="https://i.ibb.co/tJTTmxP/vk-process-mining.png" width="15.3%"/>](https://vk.com/bgtroll)
[<img src="https://i.ibb.co/VjhryGb/png-transparent-brand-logo-steam-gump-s.png" width="15.3%"/>](https://hlmod.ru/members/palonez.92448/)
[<img src="https://i.ibb.co/xHZPN0g/s-l500.png" width="15.3%"/>](https://steamcommunity.com/id/comecamecame)
[<img src="https://i.ibb.co/S0LyzmX/tg-process-mining.png" width="16.3%"/>](https://t.me/ArrayListX)
[<img src="https://i.ibb.co/Tb2gprD/2056021.png" width="15.3%"/>](https://github.com/Quake1011)
