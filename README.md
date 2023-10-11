# CS2-plugins-lua
Includes 6 mini lua plugins for CS2

- Connect/disconnect events announcer
- Team switch announcer
- Advertisement
- Kill announcer with distance print
- Round end/start announcer
- Bomb explode announcer

![1696519118102](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/b8828d36-0c12-4194-969a-642f20feb42c)
![1696462889660](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/d577bdcf-8061-438d-b99a-36e2fb518a63)
![1696442132297](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/c9c87e28-922b-4b4d-8d0c-03767a1556a3)
![1696442460163](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/1b648968-de98-453f-8848-7c514f71a266)
![1696442440011](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/a64fc621-9969-4fab-bf96-d1c6e2b0fff5)
![image](https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/64fafb2d-45d1-49ae-bec1-0b1a80cef984)

## Install
Place it in **game\csgo\scripts** and add to **gamemode_*****.cfg** next lines:
```
sv_cheats 1
script_reload_code plugins
sv_cheats 0
```

## Requirements
- patching vscript.dll:
	- [method-1](https://hlmod.net/threads/source-2-skripting.64842/post-631602)
	- [method-2](https://github.com/Source2ZE/LuaUnlocker)
 	- [method-3](https://github.com/bklol/vscriptPatch/tree/main)
 	- [method-4](https://hlmod.net/threads/source-2-skripting.64842/page-6#post-631991)(easilier)

## Config file 
```
// -------------- output types
// Chat - print in common text chat								Color tags below
// Center - - print in common center window below middle		Doesn't support colors
// Panel - - print in common center win panel above middle		HTML font colors			| type only for adverts
// Hint - - print in common center tip below middle				Doesn't support colors      | type only for adverts

// -------------- colors
// {WHITE},{DARKRED},{PURPLE},{DARKGREEN},{LIGHTGREEN},{GREEN},{RED},{LIGHTGREY},{YELLOW},{ORANGE},{DARKGREY},{BLUE},{DARKBLUE},{GRAY},{DARKPURPLE},{LIGHTRED}

// -------------- usefull tags
// {NL} - new line
// {IP}	- server ip						taken from hostip ConVar
// {PORT} - server port					taken from hostport ConVar
// {MAXPL} - max players number 		taken from sv_visiblemaxplayers ConVar
// {PL} - current players number
// {MAP} - current map
// {NEXTMAP} - next map
// {TIME} - current server time
// {DISCORD} - discord link 			taken from "discord_invite_link" key
// {VK} - vkontakte link 				taken from "vk_link" key
// {TG} - telegram link 				taken from "telegram" key
// {SITE} - site link					taken from "site_link" key
// {INST} - instagram link              taken from "inst_link" key
// {TT} - tiktok link                   taken from "tik_tok_link" key
// {YT} - youtube link					taken from "youtube_link" key
// {STEAM} - steam group link           taken from "steam_link" key
// {GROUP} - group link                 taken from "community_link" key

"Plugins"
{
	"kill_announce"					"1"		// player death announcer [0 - off | 1 - on]
	"kill_announce_message"			" {DARKRED}[ KILL ]{WHITE} Игрок {DARKGREEN}{attacker}{WHITE} убил {DARKGREEN}{user} {WHITE}с расстояния: {DARKRED}{distance}м."
	//	{attacker} - killer
	//	{user} - victim
	//	{distance} - distance between at death
	//
	
	"bot_connect_announce"			"1"		// whether to display the connection of bots 
	"connect_announce"				"1"		// player connect announcer [0 - off | 1 - on]
	"connect_announce_message"		" {DARKRED}|| {WHITE} Игрок {DARKGREEN}{user} {WHITE}зашел на сервер{NL} {DARKRED}||{WHITE} Статус: {GREEN}{botstatus}{NL} {DARKRED}||{WHITE} IP: {GREEN}{ipclient}{NL} {DARKRED}||{WHITE} SteamID2: {GREEN}{steamid2}{NL} {DARKRED}||{WHITE} SteamID3: {GREEN}{steamid3}"
	//	{user} - player who connected
	//	{botstatus}	- bot or not?
	//	{steamid2}	- steamid2 STEAM_0:1:XXXXXXX
	//	{steamid3}	- steamid3 [U:1:XXXXXXX]
	//	{ipclient}	- ip address of client
	//
	
	"bot_disconnect_announce"		"1"		// whether to display the disconnection of bots [0 - off | 1 - on]
	"disconnect_announce"			"1"		// player disconnect announcer [0 - off | 1 - on]
	"disconnect_announce_message"	" {DARKRED}[ INFO ]{WHITE} Игрок {DARKGREEN}{user} {WHITE}вышел с сервера"
	//	{user} - player who disconnected
	//
	
	"change_team_announce"			"1"		// player change team announcer [0 - off | 1 - on]
	"change_team_announce_message"	" {DARKRED}[ TEAM ]{WHITE} Игрок {LIGHTGREEN}{user} {WHITE}перешел за команду {ORANGE}{team}"
	//	{user} - player who changed team
	//	{team}	- new team
	//
	
	"bomb_time_announce"			"1"		// announce every 20, 10, 5, 4, 3, 2, 1, 0 seconds explode remaining [0 - off | 1 - on]
	
	"round_start_message_status"	"0"		// round start announcer [0 - off | 1 - on]
	"round_start_message" // print message every round start block
	{
		"Center"		"Round started!"
	}
	
	"round_end_message_status"		"0"		// round end announcer [0 - off | 1 - on]	
	"round_end_message"	// print message every round end block
	{
		"Chat"			"Round End now!"
		"Center"		"Visit our site: {SITE}"
	}
	
	"time" 	"10.0" // time between ads. Set it to 0.0 if u want not use cycled advs below
	
	// if u want remove several links u can do this just delete all string and set value of key to void
	"discord_invite_link"		"3JbqDN4"										// Invlite-link to discord 			----> for {DISCORD} tag. In output prints like https://discord.gg/3JbqDN4
	"vk_link"					"https://vk.com/bgtroll"						// Link to vk profile or group 		----> for {VK} tag
	"telegram_link"				"https://t.me/ArrayListX"						// Link to telegram  				----> for {TG} tag	
	"site_link"					"https://mysite.ru/"							// Link on your own site			----> for {SITE} tag
	"inst_link"					"https://www.instagram.com/quake1011/"			// Link on your instagram			----> for {INST} tag
	"tik_tok_link"				"https://www.tiktok.com/@quake1011"				// Link on your tik tok				----> for {TT} tag
	"youtube_link"				"https://www.youtube.com/@quake1011"			// Link on your youtube				----> for {YT} tag
	"steam_link"				"https://steamcommunity.com/groups/quake1011"	// Link on your steam group			----> for {STEAM} tag
	"community_link"			"https://mycommunity.com/community/quake1011"	// Link on your own community		----> for {GROUP} tag
	
	"adverts"  
	{	
		
		"1"		// advert block
		{
			"Chat"			"{DARKRED}[ INFO ]{WHITE} Добавьте наш сервер в избранное: {DARKGREEN}{IP}:{PORT}" 
			"Center"		"Добавьте наш сервер в избранное: {IP}:{PORT}"
		}
		"2"		
		{
			"Chat"			"{YELLOW}---- ---- ---- Контакты ---- ---- ----{NL}{WHITE}Telegram - {DARKPURPLE}{TG}{NL}{WHITE}VK - {BLUE}{VK}{NL}{WHITE}Discord - {DARKBLUE}{DISCORD}{NL}{YELLOW}---- ---- ---- ---- ---- ---- ---- ----"
		}
		"3"		
		{
			"Chat"			"{DARKRED}[ INFO ]{WHITE} Введите {DARKGREEN}!rank {WHITE}для вывода личной статистики{DARKRED} (в разработке)"
			"Panel"
			{
				"message"	"<font color='#00FF00'>This contains <font class='fontSize-l'>cs_win_panel_round</font> advert</font>"		// text 
				"time"		"5"				//  time existing of message 
			}
			"Hint"		// gameinstructor_enable should be enabled on clients for them to see it because valve delete this option in settings. If hint dont work then type in console this command
			{
				"message"	"This contains env_instructor_hint advert"	// text 
				"time"		"5"				//  time existing of panel 
				"icon"		"icon_alert"		// icons for output near text https://developer.valvesoftware.com/wiki/Env_instructor_hint#Icons
			}
		}
		"4"		
		{
			"Chat"			"{DARKRED}[ INFO ] {WHITE}Игроки: {PL}/{MAXPL}{NL} {DARKRED}[ INFO ] {WHITE}Текущая карта: {MAP}{NL} {DARKRED}[ INFO ] {WHITE}Следующая карта: {NEXTMAP}"
		}
		"5"		
		{
			"Chat"			"{DARKRED}[ INFO ] {WHITE}Для смены карты введите в чат {GREEN}vote map_name"
		}
		"6"		
		{
			"Chat"			"Hello. I am a string and i so{NL}l{NL}o{NL}o{NL}o{NL}o{NL}o{NL}o{NL}o{NL}n{NL}g" // you can do infinite size of advert by {NL} tag. Of course while chat dont end :D
		}
	}
}
```

## About possible problems, please let me know: 

- discord - quake1011

[<img src="https://i.ibb.co/tJTTmxP/vk-process-mining.png" width="15.3%"/>](https://vk.com/bgtroll)
[<img src="https://i.ibb.co/VjhryGb/png-transparent-brand-logo-steam-gump-s.png" width="15.3%"/>](https://hlmod.ru/members/palonez.92448/)
[<img src="https://i.ibb.co/xHZPN0g/s-l500.png" width="15.3%"/>](https://steamcommunity.com/id/comecamecame)
[<img src="https://i.ibb.co/S0LyzmX/tg-process-mining.png" width="16.3%"/>](https://t.me/ArrayListX)
[<img src="https://i.ibb.co/Tb2gprD/2056021.png" width="15.3%"/>](https://github.com/Quake1011)
