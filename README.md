# CS2-plugins-lua
Includes 5 mini lua plugs for cs2(con/discon evs, team switch, ads, kill distance, round start/end announce)

## Install
Place it in **game\csgo\scripts** and add to **gamemode_*****.cfg** next lines:
```
sv_cheats 1
script_reload_code plugins
sv_cheats 0
```

## Config file 
```
"Reklama"
{	
	"kill_announce"					"1"		// player death announcer [0 - off | 1 - on]
	"kill_announce_message"			" {DARKRED}[ KILL ]{WHITE} The player {DARKGREEN}{attacker}{WHITE} killed the player {DARKGREEN}{user} {WHITE}from a distance of: {DARKRED}{distance}м."
	//	{attacker} - killer
	//	{user} - victim
	//	{distance} - distance between at death
	
	"connect_announce"				"1"		// player connect announcer [0 - off | 1 - on]
	"connect_announce_message"		" {DARKRED}[ INFO ]{WHITE} The player {DARKGREEN}{user} {WHITE}logged into the server{botstatus}"
	//	{user} - player who connected
	//	{botstatus}	- bot or not?
	//
	
	"disconnect_announce"			"1"		// player disconnect announcer [0 - off | 1 - on]
	"disconnect_announce_message"	" {DARKRED}[ INFO ]{WHITE} The player {DARKGREEN}{user} {WHITE}logged out of the server{botstatus}"
	//	{user} - player who disconnected
	//	{botstatus}	- bot or not?
	//
	"change_team_announce"			"1"		// player change team announcer [0 - off | 1 - on]
	"change_team_announce_message"	" {DARKRED}[ TEAM ]{WHITE} The player {LIGHTGREEN}{user} switched to the team {ORANGE}{team}"
	//	{user} - player who changed team
	//	{team}	- new team
	//
	
	"round_start_message_status"	"1"		// round start announcer [0 - off | 1 - on]
	"round_start_message" // print message every round start 
	{
		"Center"		"Round started!"
	}
	
	"round_end_message_status"		"1"		// round end announcer [0 - off | 1 - on]	
	"round_end_message"	// print message every round end
	{
		"Chat"			"Round End now!"
		"Center"		"Visit our site: mysite.ru"
	}
	
	"time" 	"10.0"// time between ads. Set it to 0.0 if u want not use cycled advs below
	"discord"			"https://discord.gg/3J7qDN4"		// for {DISCORD} tag
	"vk"				"https://vk.com/bgtroll"			// for {VK} tag
	"telegram"			"https://t.me/personallink"			// for {TG} tag	
	"adverts"  
	{	
		
		"1"		// advert block
		{
			"Chat"			" {DARKRED}[ INFO ]{WHITE} Add our server to your favorites: {DARKGREEN}{IP}:{PORT}"
			"Center"		"Add our server to your favorites: {IP}:{PORT}"
		}
		"2"		
		{
			"Chat"			" {YELLOW}---- ---- ---- Contacts ---- ---- ----{NL}{WHITE}Telegram - {DARKPURPLE}{TG}{NL}{WHITE}Vkontakte - {BLUE}{VK}{NL}{WHITE}Discord - {DARKBLUE}{DISCORD}{NL}{YELLOW}---- ---- ---- ---- ---- ---- ---- ----"
		}
		"3"		
		{
			"Chat"			" {DARKRED}[ INFO ]{WHITE} Type the {DARKGREEN}!rank {WHITE}to display personal statistics{DARKRED}"
		}
		"4"		
		{
			"Chat"			" {DARKRED}[ INFO ] {WHITE}Кол-во игроков {PL}/{MAXPL}{NL} {DARKRED}[ INFO ] {WHITE}Текущая карта {MAP}{NL} {DARKRED}[ INFO ] {WHITE}Следующая карта {NEXTMAP}"
		}
	}
}

// -------------- output types
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
