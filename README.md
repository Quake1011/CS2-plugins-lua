# CS2-plugins-lua

**IMPORTANT: Only for folder OTHER: Since when the map is changed, the player_connect event is not executed, in which all important data is transmitted, because of this, after changing the map, some functions will not work for those players who were at the time of changing the map to the server until they are do reconnect**

## Includes 14 lua plugins for CS2

- Blocker Passes
- Spawn point manager(`dont tested on real players`)
- Mini-admin
- Voting for map
- Ammo and health refill after kill
- Connect/disconnect events announcer
- Team switch announcer
- Advertisement
- Kill announcer with distance print
- Round end/start announcer
- Bomb explode announcer
- Most destructive
- Plant blocker
- Weapon deleter(aka low-leveled `weapon restrictor`)
```diff
- WARNING: WEAPON DELETER NOT REFUND MONEY FOR WEAPON)
```

## Preview
<details> 
	<summary>Blocker passes</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/998b8539-fe2e-4999-bf42-52f0b420606b">
	
	The plugin allows you to block some certain passages by adding your own items
</details>
<details> 
	<summary>Spawn point manager</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/bb3c541b-860f-4cdc-ba32-d1b4549e8e97">
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/2caa187b-674c-449f-b921-bc954ba24fad">

	The plugin allows you to add spawn points up to 64
</details>
<details> 
	<summary>Weapon Deleter(Weapon Restrict)</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/b5e0f174-e15b-48e6-bc6d-2011b68c9703">
	
	The plugin removes prohibited weapons when buying and lifting them
</details>
<details> 
	<summary>Admin message</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/7a1a3172-cbd2-46dd-8b57-a84f0e47f457">
	
	The plugin adds admin functions
</details>
<details> 
	<summary>Voting to map</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/9d107fa1-e816-43ba-8cb6-fd1f5d323fa3">
	
	The plugin adds the ability to vote for the map
</details>
<details> 
	<summary>Bomb explode announcer</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/b8828d36-0c12-4194-969a-642f20feb42c">
	
	The plugin adds a timer in the center of the screen warning of an imminent bomb explosion
</details>
<details> 
	<summary>Round start and player team changing messages</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/d577bdcf-8061-438d-b99a-36e2fb518a63">
	
	The plugin allows you to display your own messages at the beginning and end of the round, and team changing event
</details>
<details> 
	<summary>Connect/disconnect messages</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/c9c87e28-922b-4b4d-8d0c-03767a1556a3">
	
	The plugin displays players who have just connected/disconnect
</details>
<details> 
	<summary>Kill announcer with distance print</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/1b648968-de98-453f-8848-7c514f71a266">
	
	The plugin displays the murder and its distance in the chat
</details>
<details> 
	<summary>Advertisement of your server</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/a64fc621-9969-4fab-bf96-d1c6e2b0fff5">

	Good old advertising for your server. Supports multi-line
</details>
<details> 
	<summary>Extended connect message</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/eda2567b-42f2-4a3e-b9b9-51c67ce18f0f">
	
	The plugin displays players who have just connected, displaying extended information
</details>
<details> 
	<summary>Plant blocker</summary>
	<img src="https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/e961de7f-90eb-46ca-81ab-d91abe405992">
	
	The plugin blocks the selected tape at the beginning of the round
</details>

**Ammo and health refiller:**
> 
> https://github.com/Quake1011/CS2-plugins-lua/assets/58555031/50b5fdc8-c219-4b69-9a0d-c0cf7e02ea92

## Requirements
### Patching
- manual patching vscript.dll:
	- **Windows VSCRIPT LIBRARY** - Counter-Strike Global Offensive\game\bin\win64\vscript.dll
	- **Linux VSCRIPT LIBRARY** - Counter-Strike Global Offensive\game\bin\linuxsteamrt64\libvscript.so
1) Open your **vscript.dll** / **libvscript.so** via any hex editor
2)
	- Replace byte-sequence:
		- **Windows** - 01 00 00 00 2b d6 74 61 3b d6
		- **Linux** - 01 0F 84 0A 02 00 00 83 FE 02
	- to this byte-sequence:
		- **Windows** - 02 00 00 00 2b d6 74 61 3b d6
		- **Linux** - 02 0F 84 0A 02 00 00 83 FE 01
 4) Save the changes
 5) Success!
   	   
You can use one of automation methods below:
- [method-1](https://hlmod.net/threads/source-2-skripting.64842/post-631602)(RU manual patching)
- [method-2](https://github.com/Source2ZE/LuaUnlocker)(Autopatcher via metamod plugin)
- [method-3](https://github.com/bklol/vscriptPatch/tree/main)(Python script patcher)
- [method-4](https://hlmod.net/threads/source-2-skripting.64842/page-6#post-631991)(File replace. Unverified)

## Install
1) Place contains of folder(s) in **game\csgo\scripts**. If **scripts** folder not exist then you should to make it
2) Add to **gamemode_your_gamemode_name.cfg** next lines:
> You can load all script:
```
sv_cheats 1
script_reload_code your_script_name.lua
script_reload_code your_script_name.lua
script_reload_code your_script_name.lua
sv_cheats 0
```

> or 1 one them:
```
sv_cheats 1
script_reload_code your_script_name.lua
sv_cheats 0
```
3) Reload the server

## Blocker Passes commands
- **BPEditor \<secret_key\>** - enable/disable EDITOR mode
	- `@secret_key` - the string required to confirm switching to EDITOR mode
- **BPReload <secret_key>** - reload BlockerPasses.ini config file. Required \"secret_key\" for this action
	- `@secret_key` - the string required to confirm file reloading
- **BPGen** - generates a template from the added entities on the map in EDITOR mode to console formatted already
- **BPDel \<argument\>** - deletes the selected entities.
	- `@argument`:
		- `last` - delete last created entity
		- `all` - delete all created entity
		- `MyNam62eOfEni4tity` - delete entities named as for example: **MyNam62eOfEni4tity**
- **BPTables** - outputs a table of values of current entities to the console
- **BPSpawn** - сreates an entity in front of the player who creates it
- **BPColor \<r\> \<g\> \<b\> \<a\>** - sets the color for the entities that will be created after that
- **BPModel \<path_to_vmdl\>** - sets the model for the entities that will be created after that

## Spawn point manager commands
```diff
+ To unlock the player limit, add this to the exec params:
	-maxplayers 64 -maxplayers_override 64
```

- **SPM \<secret_key\>** - switching the availability of editing
	- `@secret_key` - required key for SPM activate/deactivate
- **SPMDisplay \<team\>** - toggles the display of current spawns
	- `@team`:
		- `ct` - display ct spawns
		- `t` - display ct spawns
		- `if the argument is empty, all existing spawns will be displayed`
- **SPMGen** - generates a template from the added spawns on the map to console formatted already
- **SPMAdd \<team\>** - adding new **\<team\>**-spawn point
	- `@team`:
		- `ct` - CT-spawn point
		- `t` - T-spawn point
<!--
- **SPMDelete \<team\> \<count\>** - deletes selected spawn points
	- `@team`:
		`all` - deletes all spawn points
		`ct` - delete ct point
		`t` - delete t point
	- `@count` - any number of spawn points less then max exists(not default)
-->
## Commands(\"Other\" folder)
For admin:
- **kickit \<uid\> <reason>** - kick player from server
- **setmap \<map\> <changetime>** - change the map after the specified time interval in seconds
- **conexec \<convar\> <newvalue>** - change the value of the server variable
- **asay \<message\>** - write a message from the admin to the chat (all characters up to 127 ascii encoding)
- **hp <uid> \<value\>** - set the number of hp to the player
- **size <uid> \<value\>** - set the player size (any decimal positive number, for example 0.5 or 49.0)
- **clr \<uid\> \<r\> \<g\> \<b\> \<a\>** - set color and transparency to the player (all RGBA numbers within 0 - 255)
- **grav \<uid\> \<value\>** - set gravity to the player (any decimal positive number, for example 0.5 or 49.0)
- **fric \<uid\> \<value\>** - to set the grip on the surface of the player (any decimal positive number, for example 0.5 or 49.0)
- **disarm \<uid\> \<weapon_classname\>** - remove the player's weapon, for example, weapon_ak47. Delete all weapons - instead of <weapon_classname> write - @all
- **killit \<uid\>** - kill the player
- **changeteam \<uid\> \<team\>** - change the player's team (team number or short name. For example ct or 3)
- **hudstatus \<uid\> \<status\>** - turn off or turn off the hood to the player (0 or 1)
  
For all:
- **login \<password\>** - getting administrator rights for a session
- **votemap \<mapname\>** - vote for the map
- **suicide** - kill yourself

## Credits
Thanks to all those who supported me and my work in any way

## About possible problems, please let me know: 
[<img src="https://i.ibb.co/LJz83MH/a681b18dd681f38e599286a07a92225d.png" width="15.3%"/>](https://discordapp.com/users/858709381088935976/)
[<img src="https://i.ibb.co/tJTTmxP/vk-process-mining.png" width="15.3%"/>](https://vk.com/bgtroll)
[<img src="https://i.ibb.co/VjhryGb/png-transparent-brand-logo-steam-gump-s.png" width="15.3%"/>](https://hlmod.ru/members/palonez.92448/)
[<img src="https://i.ibb.co/xHZPN0g/s-l500.png" width="15.3%"/>](https://steamcommunity.com/id/comecamecame)
[<img src="https://i.ibb.co/S0LyzmX/tg-process-mining.png" width="16.3%"/>](https://t.me/ArrayListX)
[<img src="https://i.ibb.co/Tb2gprD/2056021.png" width="15.3%"/>](https://github.com/Quake1011)
