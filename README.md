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

## Install
Place it in **game\csgo\scripts** and add to **gamemode_*****.cfg** next lines:
```
sv_cheats 1
script_reload_code plugins
sv_cheats 0
```

## Requirements
- patch vscript.dll: [method-1](https://hlmod.net/threads/source-2-skripting.64842/post-631602) or [method-2](https://github.com/Source2ZE/LuaUnlocker) or [method-3](https://github.com/bklol/vscriptPatch/tree/main)

## Config file 
```
"Plugins"
{	
	"kill_announce"					"1"		// player death announcer [0 - off | 1 - on]
	"kill_announce_message"			" {DARKRED}[ KILL ]{WHITE} The player {DARKGREEN}{attacker}{WHITE} killed {DARKGREEN}{user} {WHITE}from a distance: {DARKRED}{distance}m."
	//	{attacker} - killer
	//	{user} - victim
	//	{distance} - distance between at death
	//
	
	"connect_announce"				"1"		// player connect announcer [0 - off | 1 - on]
	"connect_announce_message"		" {DARKRED}[ INFO ]{WHITE} The player {DARKGREEN}{user} {WHITE}logged into the server{botstatus} {steamid}"
	//	{user} - player who connected
	//	{botstatus}	- bot or not?
	//	{steamid}	- steamid2 STEAM_0:1:XXXXXXX
	//
	
	"disconnect_announce"			"1"		// player disconnect announcer [0 - off | 1 - on]
	"disconnect_announce_message"	" {DARKRED}[ INFO ]{WHITE} The player {DARKGREEN}{user} {WHITE}logged out of the server{botstatus}"
	//	{user} - player who disconnected
	//	{botstatus}	- bot or not?
	//
	
	"change_team_announce"			"1"		// player change team announcer [0 - off | 1 - on]
	"change_team_announce_message"	" {DARKRED}[ TEAM ]{WHITE} The player {LIGHTGREEN}{user} {WHITE}switched to the team {ORANGE}{team}"
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
		"Center"		"Visit our site: mysite.ru"
	}
	
	"time" 	"35.0" // time between ads. Set it to 0.0 if u want not use cycled advs below
	"discord"			"https://discord.gg/3JbqDN4"		// for {DISCORD} tag
	"vk"				"https://vk.com/bgtroll"			// for {VK} tag
	"telegram"			"https://t.me/ArrayListX"			// for {TG} tag	
	"adverts"  
	{	
		
		"1"		// advert block
		{
			"Chat"			" {DARKRED}[ INFO ]{WHITE} Add our server to your favorites: {DARKGREEN}{IP}:{PORT}"
			"Center"		"Add our server to your favorites: {IP}:{PORT}"
		}
		"2"		
		{
			"Chat"			" {YELLOW}---- ---- ---- Contacts ---- ---- ----{NL}{WHITE}Telegram - {DARKPURPLE}{TG}{NL}{WHITE}VK - {BLUE}{VK}{NL}{WHITE}Discord - {DARKBLUE}{DISCORD}{NL}{YELLOW}---- ---- ---- ---- ---- ---- ---- ----"
		}
		"3"		
		{
			"Chat"			" {DARKRED}[ INFO ]{WHITE} Type the {DARKGREEN}!rank {WHITE}to display personal statistics{DARKRED}"
		}
		"4"		
		{
			"Chat"			" {DARKRED}[ INFO ] {WHITE}Players: {PL}/{MAXPL}{NL} {DARKRED}[ INFO ] {WHITE}Current map: {MAP}{NL} {DARKRED}[ INFO ] {WHITE}Next map: {NEXTMAP}"
		}
	}
}

// -------------- output types (for round events, advert)
// Chat - print in common text chat
// Center - - print in common center window below middle

// -------------- colors (This is for chat only)
// {WHITE} - white
// {DARKRED}
// {PURPLE}
// {DARKGREEN}
// {LIGHTGREEN}
// {GREEN}
// {RED}
// {LIGHTGREY}
// {YELLOW}
// {ORANGE}
// {DARKGREY}
// {BLUE}
// {DARKBLUE}
// {GRAY}
// {DARKPURPLE}
// {LIGHTRED}

// -------------- usefull tags
// {NL} - new line
// {IP}	- server ip						taken from hostip ConVar
// {PORT} - server port					taken from hostport ConVar
// {MAXPL} - max players number 		taken from sv_visiblemaxplayers ConVar
// {PL} - current players number
// {MAP} - current map
// {NEXTMAP} - next map
// {TIME} - current server time
// {DISCORD} - discord link 			taken from "discord" key
// {VK} - vkontakte link 				taken from "vk" key
// {TG} - telegram link 				taken from "telegram" key
```

## About possible problems, please let me know: 

- discord - quake1011

[<img src="https://i.ibb.co/tJTTmxP/vk-process-mining.png" width="15.3%"/>](https://vk.com/bgtroll)
[<img src="https://i.ibb.co/VjhryGb/png-transparent-brand-logo-steam-gump-s.png" width="15.3%"/>](https://hlmod.ru/members/palonez.92448/)
[<img src="https://i.ibb.co/xHZPN0g/s-l500.png" width="15.3%"/>](https://steamcommunity.com/id/comecamecame)
[<img src="https://i.ibb.co/S0LyzmX/tg-process-mining.png" width="16.3%"/>](https://t.me/ArrayListX)
[<img src="https://i.ibb.co/Tb2gprD/2056021.png" width="15.3%"/>](https://github.com/Quake1011)
