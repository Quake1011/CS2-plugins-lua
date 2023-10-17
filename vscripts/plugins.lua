require('includes/timers')

print('#############################################')
print('\tPlugins Loaded')
print('Author:\t\t\t\tPalonez')
print('Version:\t\t\t0.9')
print('Discord:\t\t\tquake1011')
print('Github:\t\t\t\tQuake1011')
print('VK:\t\t\t\tvk.com/bgtroll')
print('If u`ve an idea im ready to listen it')
print('#############################################')

local vkontakte, telegram, discord, c4t, site, instagram, tiktok, youtube, steam, group

local xxx = ""
local totalAds = 0
local currentAd = 1

local Players = {}
local TotalMapVotes = {}
local OnlineAdmins = {}

local admins = LoadKeyValues("scripts/configs/admins.ini")
local weapons_ammo = LoadKeyValues("scripts/configs/weapons.ini")
local kv = LoadKeyValues("scripts/configs/plugins.ini")
local maplist = LoadKeyValues("scripts/configs/maplist.ini")

function intToIp(int)
	return bit.rshift(bit.band(int, 0xFF000000), 24) .. "." .. bit.rshift(bit.band(int, 0x00FF0000), 16) .. "." .. bit.rshift(bit.band(int, 0x0000FF00), 8) .. "." .. bit.band(int, 0x000000FF)
end

if admins == nil then
	error("Couldn't load config file scripts/configs/admins.ini")
end

if weapons_ammo == nil then
	error("Couldn't load config file scripts/configs/weapons.ini")
end

if maplist ~= nil then
	for _,v in pairs(maplist["maps"]) do
		TotalMapVotes[v] = {}
	end
else
	error("Couldn't load config file scripts/configs/maplist.ini")
end

function PlayerVotedAlready(player_handle)
	for map, votes_table in pairs(TotalMapVotes) do
		for num, player in pairs(votes_table) do
			if player == player_handle then
				return true
			end
		end
	end
	return false 
end

function __GetMapName(map)
	for k,v in pairs(maplist["maps"]) do
		if v == map then
			return tostring(k)
		end
	end
	return tostring(map)
end

function ReplaceTags(str)
	str = string.gsub(str, "{WHITE}", "\x01")
	str = string.gsub(str, "{DARKRED}", "\x02")
	str = string.gsub(str, "{PURPLE}", "\x03")
	str = string.gsub(str, "{DARKGREEN}", "\x04")
	str = string.gsub(str, "{LIGHTGREEN}", "\x05")
	str = string.gsub(str, "{GREEN}", "\x06")
	str = string.gsub(str, "{RED}", "\x07")
	str = string.gsub(str, "{LIGHTGREY}", "\x08")
	str = string.gsub(str, "{YELLOW}", "\x09")
	str = string.gsub(str, "{ORANGE}", "\x10")
	str = string.gsub(str, "{DARKGREY}", "\x0A")
	str = string.gsub(str, "{BLUE}", "\x0B")
	str = string.gsub(str, "{DARKBLUE}", "\x0C")
	str = string.gsub(str, "{GRAY}", "\x0D")
	str = string.gsub(str, "{DARKPURPLE}", "\x0E")
	str = string.gsub(str, "{LIGHTRED}", "\x0F")
	str = string.gsub(str, "{PORT}", tostring(Convars:GetInt("hostport")))
	str = string.gsub(str, "{IP}", intToIp(Convars:GetInt("hostip")))
	str = string.gsub(str, "{MAXPL}", tostring(Convars:GetInt("sv_visiblemaxplayers")))
	str = string.gsub(str, "{PL}", tostring(#Entities:FindAllByClassname("player")))
	str = string.gsub(str, "{MAP}", __GetMapName(GetMapName()))
	
	local nextmap
	if Convars:GetStr("nextlevel") == "" then
		nextmap = "unknown"
	else
		nextmap = Convars:GetStr("nextlevel")
	end
	str = string.gsub(str, "{NEXTMAP}", __GetMapName(nextmap))

	local h = LocalTime().Hours
	if h < 10 then
		h = "0" .. h
	end
	local m = LocalTime().Minutes
	if m < 10 then
		m = "0" .. m
	end
	local s = LocalTime().Seconds
	if s < 10 then
		s = "0" .. s
	end

	str = string.gsub(str, "{TIME}", h .. ":" .. m .. ":" .. s)
	
	if kv["discord_invite_link"] ~= nil then
		str = string.gsub(str, "{DISCORD}", "https://discord.gg/" .. discord)
	end
	
	if kv["vk_link"] ~= nil then
		str = string.gsub(str, "{VK}", vkontakte)
	end
	
	if kv["telegram_link"] ~= nil then
		str = string.gsub(str, "{TG}", telegram)
	end
	
	if kv["site_link"] ~= nil then
		str = string.gsub(str, "{SITE}", site)
	end
	
	if kv["inst_link"] ~= nil then
		str = string.gsub(str, "{INST}", instagram)
	end
	
	if kv["tik_tok_link"] ~= nil then
		str = string.gsub(str, "{TT}", tiktok)
	end
	
	if kv["youtube_link"] ~= nil then
		str = string.gsub(str, "{YT}", youtube)
	end
	
	if kv["steam_link"] ~= nil then
		str = string.gsub(str, "{STEAM}", steam)
	end
	
	if kv["community_link"] ~= nil then
		str = string.gsub(str, "{GROUP}", group)
	end
	return str
end

function PrintToAll(str, outType)
	if outType == "chat" then
		if string.find(str, "{NL}") ~= nil then
			local laststr
			local endIndex = string.find(str:reverse(), string.reverse("{NL}"), 1, true)

			if endIndex then
				endIndex = #str - endIndex + 1
				laststr = string.sub(str, endIndex+1)
			end

			for substring in string.gmatch(str, "(.-)" .. "{NL}") do
				ScriptPrintMessageChatAll(" " .. ReplaceTags(substring))
			end
			
			ScriptPrintMessageChatAll(" " .. ReplaceTags(laststr))
		else
			ScriptPrintMessageChatAll(" " .. ReplaceTags(str))
		end
	elseif outType == "center" then
		ScriptPrintMessageCenterAll(ReplaceTags(str))
	end	
end

function loadCFG()
	if kv ~= nil then
		vkontakte = kv["vk_link"]
		telegram = kv["telegram_link"]
		site = kv["site_link"]
		instagram = kv["inst_link"]
		tiktok = kv["tik_tok_link"]
		youtube = kv["youtube_link"]
		steam = kv["steam_link"]
		group = kv["community_link"] 
		discord = kv["discord_invite_link"]
		timeAds = kv["time"]
		
		for k, v in pairs(kv["adverts"]) do
			totalAds = totalAds + 1
		end
		
		print("plugins.ini loaded")
		
		if totalAds == 0 then
			return false
		end
		
		if timeAds == 0.0 then
			return false
		end
		
		return true
	end
	error("Couldn't load config file scripts/configs/plugins.ini")
	return false
end

function formatAdr(address)
	address = string.gsub(address, string.sub(address, -(#address-string.find(address, ":")+1)), "")
	return address
end

function SteamID3toSteamID2(networkid)
	networkid = string.sub(networkid, 6)
	networkid = string.gsub(networkid, "]", "")
	return "STEAM_0:" .. bit.band(tonumber(networkid), 1) .. ":" .. bit.rshift(tonumber(networkid), 1)
end

function PlayerTeam(event)
	if kv["change_team_announce"] == 1 then
		if event["userid"] ~= nil then
			if event["disconnect"] ~= true then
				if event["isbot"] ~= true then
					if Players[event["userid"]] ~= nil then
						local player = Players[event["userid"]]["name"]
						if player ~= nil then
							if event["team"] ~= nil then
								local team
								if event["team"] == 0 then
									team = "unconnected"
								elseif event["team"] == 1 then
									team = "spec"
								elseif event["team"] == 2 then
									team = "T"
								elseif event["team"] == 3 then
									team = "CT"
								end

								local message = kv["change_team_announce_message"]
								message = string.gsub(message, "{user}", player)
								message = string.gsub(message, "{team}", team)
								PrintToAll(message, "chat")
							end
						end
					end
				end
			end
		end
	end
end

function PlayerDisconnect(event)
	if kv["bot_disconnect_announce"] == 0 and Players[event["userid"]]["networkid"] == "BOT" then
		return
	end
	
	if kv["disconnect_announce"] == 1 then
		local message = kv["disconnect_announce_message"]
		message = string.gsub(message, "{user}", event["name"])
		PrintToAll(message, "chat")
	end

	Players[event["userid"]] = nil
end

function PlayerDeath(event)
	if Players[event["attacker"]] ~= nil and Players[event["userid"]] ~= nil then
		local attacker = Players[event["attacker"]]["name"]
		local user = Players[event["userid"]]["name"]
		
		if attacker ~= nil and user ~= nil then
			if attacker ~= user then
				if event["distance"] ~= nil then 
					if kv["kill_announce"] == 1 then
						local message = kv["kill_announce_message"]
						message = string.gsub(message, "{attacker}", attacker)
						message = string.gsub(message, "{user}", user)
						message = string.gsub(message, "{distance}", tonumber(string.format("%.2f", event["distance"])))
						PrintToAll(message, "chat")
					end
				end
			end
		end
		
		local player = EntIndexToHScript(bit.band(event["attacker_pawn"], 0x3FFF))
		if player ~= nil then
			if player:IsPlayerPawn() == true then
				if event["attacker_pawn"] ~= event["userid_pawn"] then 
					if kv["kill_ammo_refill"] == 1 then
						if kv["health_refill"] == 1 then
							if kv["health_refill_value"] == "all" then
								player:SetHealth(player:GetMaxHealth())
							elseif type(kv["health_refill_value"]) == "number" and kv["health_refill_value"] >= 0 then
								player:SetHealth(player:GetHealth()+tonumber(kv["health_refill_value"]))
								if player:GetHealth()+kv["health_refill_value"] <= player:GetMaxHealth() then
									player:SetHealth(player:GetHealth()+kv["health_refill_value"])
								else 
									player:SetHealth(player:GetHealth()+(player:GetMaxHealth()-player:GetHealth()))
								end
							end
						end
						for k, eqWeapon in pairs(player:GetEquippedWeapons()) do
							local weaponName = eqWeapon:GetClassname()
							weaponName = string.sub(weaponName, 8)
							if kv["all_equiped_weapon"] == 0 then
								if weaponName == event["weapon"] or (event["weapon"] == "m4a1_silencer" and weaponName == "m4a1") then
									SetWeaponAmmo(eqWeapon, event["weapon"])
									break
								end
							else
								if findInTableKey(weapons_ammo, weaponName) == true then
									SetWeaponAmmo(eqWeapon, weaponName)
								end
							end
						end
					end
				end
			end
		end
	end
end

function findInTableKey(tTable, key)
	for k,v in pairs(tTable) do
		if k == key then
			return true
		end
	end
	return false
end

function findWeaponInList(weapon)
	for k,v in pairs(weapons_ammo) do
		if type(v) == "table" then
			if k == weapon then
				return true
			end
		end
	end
	return false
end

function SetWeaponAmmo(instance, class)
	if instance ~= nil then
		if findWeaponInList(class) == true then
			if kv["ammo_type_refill"] == 1 then
				DoEntFireByInstanceHandle(instance, "SetAmmoAmount", tostring(weapons_ammo[class]["clip"]), 0, nil, nil)
			elseif kv["ammo_type_refill"] == 2 then 
				DoEntFireByInstanceHandle(instance, "SetReserveAmmoAmount", tostring(weapons_ammo[class]["reserved"]), 0, nil, nil)
			elseif kv["ammo_type_refill"] == 3 then
				DoEntFireByInstanceHandle(instance, "SetAmmoAmount", tostring(weapons_ammo[class]["clip"]), 0, nil, nil)
				DoEntFireByInstanceHandle(instance, "SetReserveAmmoAmount", tostring(weapons_ammo[class]["reserved"]), 0, nil, nil)
			end
		end	
	end
end

function PlayerConnect(event)
	local ConnectInfo = {
		["name"] = event["name"],
		["userid"] = event["userid"],
		["networkid"] = event["networkid"],
		["address"] = event["address"],
		["userid_pawn"] = nil,
		["xuid"] = event["xuid"]
	}

	Players[event["userid"]] = ConnectInfo
	if kv["bot_connect_announce"] == 0 and event["networkid"] == "BOT" then
		return
	end	
	
	if kv["connect_announce"] == 1 then
		local message = kv["connect_announce_message"]
		
		message = string.gsub(message, "{user}", event["name"])
		
		if event["networkid"] ~= "BOT" then
			message = string.gsub(message, "{botstatus}", "Player")
			message = string.gsub(message, "{steamid2}", SteamID3toSteamID2(event["networkid"]))
			message = string.gsub(message, "{steamid3}", event["networkid"])
			message = string.gsub(message, "{ipclient}", formatAdr(event["address"]))
		else
			message = string.gsub(message, "{botstatus}", "Bot")
			message = string.gsub(message, "{steamid2}", "None")
			message = string.gsub(message, "{steamid3}", "None")
			message = string.gsub(message, "{ipclient}", "None")
		end
		
		PrintToAll(message, "chat")
	end
end

-- takes from https://github.com/NickFox007/LuaHudcoreCS2/blob/e14b7158456f300d25a888382d6ee884f93ec118/hudcore.lua#L55
function HC_ShowPanelInfo(text, duration)
	FireGameEvent("cs_win_panel_round", {["funfact_token"] = text})
	Timers:CreateTimer({
		endTime = duration,
		callback = function()
			HC_ResetPanelInfo()    
		end
	})
end

function HC_ResetPanelInfo()	
	FireGameEvent("round_start", nil)
end

function HC_ShowInstructorHint(text, duration, icon)
	local targetname = UniqueString("instructor")
	local instr_ent = SpawnEntityFromTableSynchronous("env_instructor_hint",{
		targetname = targetname,
        hint_caption = text,
        hint_timeout = duration,
		hint_icon_onscreen = icon
    })
	
	DoEntFire("!self","ShowHint",targetname,0,nil,instr_ent);
	
	Timers:CreateTimer({
		endTime = duration,
		callback = function()
			UTIL_Remove(instr_ent)    
		end
	})
end
-- -- -- -- -- --

function RoundEnd(event)
	if kv["round_end_message_status"] == 1 then
		if kv["round_end_message"].Chat ~= nil then
			PrintToAll(kv["round_end_message"].Chat, "chat")
		end
		
		if kv["round_end_message"].Center ~= nil then
			PrintToAll(kv["round_end_message"].Center, "center")
		end
	end
	
	if c4t ~= nil then	
		Timers:RemoveTimer(c4t)
	end
end

function RoundStart(event)
	cmd = Entities:FindByClassname(nil, "point_clientcommand")

    if cmd == nil then
        cmd = SpawnEntityFromTableSynchronous("point_clientcommand", { targetname = "vscript_clientcommand" })
    end

	if kv["round_start_message_status"] == 1 then
		if kv["round_start_message"].Chat ~= nil then
			PrintToAll(kv["round_start_message"].Chat, "chat")
		end
		
		if kv["round_start_message"].Center ~= nil then
			PrintToAll(kv["round_start_message"].Center, "center")
		end
	end
	
	if c4t ~= nil then	
		Timers:RemoveTimer(c4t)
	end
end

function BombPlanted(event)
	if kv["bomb_time_announce"] == 1 then
	
		local bombBackCounter = Convars:GetInt("mp_c4timer")
		
		c4t = Timers:CreateTimer(1, function()
			if bombBackCounter > 0 then
				bombBackCounter = bombBackCounter - 1
			elseif c4t ~= nil then	
				Timers:RemoveTimer(c4t)
			end
			
			if bombBackCounter == 20 or bombBackCounter == 10 then
				PrintToAll("before the explosion is left: " .. bombBackCounter .. " seconds", "center")
			end
			
			if bombBackCounter <= 5 then
				PrintToAll(bombBackCounter .. "...", "center")
			end
			
			if bombBackCounter ~= 0 then
				return 1.0
			end
		end)
	end
end

function WinPanelEnd(event)
	local nexttime = Convars:GetInt("mp_endmatch_votenextleveltime")+5
	local EndMatchTimer = Timers:CreateTimer(function()
		if nexttime == 0 then
			for userid, _ in pairs(Players) do
				SendToServerConsole("kickid " .. userid .. " \"map changed. Connect to server again\"")
			end
			if EndMatchTimer ~= nil then
				Timers:RemoveTimer(EndMatchTimer)
			end
		end

		if (nexttime > 0 and nexttime < 11) or (nexttime > 10 and nexttime % 5 == 0) then
			local message = kv["endmatch_mapchange_message"]
			message = string.gsub(message, "{seconds}", nexttime)
			PrintToAll(message, "chat")
		end
		nexttime = nexttime - 1
		return 1.0
	end)
end

function PlayerSpawn(event)
    local a = Players[event["userid"]]
    if a then
        a.userid_pawn = EntIndexToHScript(bit.band(event["userid_pawn"], 0x3FFF))
		if a.networkid ~= "BOT" then
			for _,v in pairs(admins) do
				if v == SteamID3toSteamID2(a.networkid) then
					table.insert(OnlineAdmins, a.userid_pawn)
				end
			end
		end
    end
end

if loadCFG() then
	Timers:CreateTimer(function()
		local counter = currentAd
		if kv["adverts"][tostring(counter)].Chat ~= nil then
			PrintToAll(kv["adverts"][tostring(counter)].Chat, "chat")
		end

		if kv["adverts"][tostring(counter)].Center ~= nil then
			PrintToAll(kv["adverts"][tostring(counter)].Center, "center")
		end
		
		if kv["adverts"][tostring(counter)].Panel ~= nil then
			HC_ShowPanelInfo(kv["adverts"][tostring(counter)]["Panel"]["message"], kv["adverts"][tostring(counter)]["Panel"]["time"])
		end
		
		if kv["adverts"][tostring(counter)].Hint ~= nil then
			HC_ShowInstructorHint(kv["adverts"][tostring(counter)]["Hint"]["message"], kv["adverts"][tostring(counter)]["Hint"]["time"], kv["adverts"][tostring(counter)]["Hint"]["icon"])
		end
		
		currentAd = currentAd + 1
		
		if currentAd > totalAds then 
			currentAd = 1
		end 
		
		return timeAds
	end)
end

function IsAdmin(player)
	for _,v in pairs(OnlineAdmins) do
		if v == player then
			return true
		end
	end
	return false
end

-- login <password>
Convars:RegisterCommand("login", function (_, password)
	if kv["admin_password"] == password then
		if IsAdmin(Convars:GetCommandClient()) == false then
			table.insert(OnlineAdmins, Convars:GetCommandClient())
		end
	end
end, nil, 0)

-- asay <message>
Convars:RegisterCommand("asay", function (_, ...)
	for _,v in ipairs({...}) do
		xxx = xxx .. " " .. tostring(v)
	end  
	
	for i = 1, #xxx do
		local v = string.byte(xxx, i, i)
		if v > 127 then
			xxx = ""
			return
		end
	end
	
	if IsAdmin(Convars:GetCommandClient()) == true then
		PrintToAll(kv["admin_message_tag"] .. kv["admin_message_color"] .. xxx, "chat")
	end
	xxx = ""
end, nil, 0)

-- conexec <convar> <newvalue>
Convars:RegisterCommand("conexec", function (_, varname, value)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if varname ~= nil and value ~= nil then
			SendToServerConsole(varname .. " " .. tostring(value))
		end
	end
end, nil, 0)

-- setmap <map> <changetime>
Convars:RegisterCommand("setmap", function (_, map, chtime)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if map ~= nil then
			local nexttime = tonumber(chtime)
			local chmpname = __GetMapName(map)

			if nexttime >= 0 then
				local mapTmr = Timers:CreateTimer(function()
					if nexttime == 0 then
						for userid, _ in pairs(Players) do
							SendToServerConsole("kickid " .. userid .. " \"map changed to " .. chmpname .. ". Connect to server again\"")
						end
						SendToServerConsole("changelevel " .. map)
						if mapTmr ~= nil then
							Timers:RemoveTimer(mapTmr)
						end
					end

					if kv["admin_mapchange_message_counter_status"] == 1 then
						if (nexttime > 0 and nexttime < 11) or (nexttime > 10 and nexttime % 5 == 0) then
							local message = kv["admin_mapchange_message"]
							message = string.gsub(message, "{seconds}", nexttime)
							message = string.gsub(message, "{changemap}", chmpname)
							PrintToAll(message, "chat")
						end
					end
					nexttime = nexttime - 1
					return 1.0
				end)
			end
		end
	end
end, nil, 0)

-- _kick <uid> <reason>
Convars:RegisterCommand("kickit", function (_, userid, reason)
	local client = Convars:GetCommandClient()
	if IsAdmin(client) == true then
		if userid ~= nil and reason ~= nil then
			if userid == "@all" then
				for _,v in pairs(Players) do
					if v["userid_pawn"] ~= client then
						SendToServerConsole("kickid " .. v["userid"] .. " kicked by reason: " .. reason)
						ScriptPrintMessageCenterAll("ALL PLAYER HAS BEEN KICKED")
					end
				end
			else
				SendToServerConsole("kickid " .. userid .. " kicked by reason: " .. reason)
				print(1)
				if kv["admin_kickmessage_enable"] == 1 then
					print(2)
					local messvge = kv["admin_kickall_message"]
					messvge = string.gsub(messvge, "{user}", Players[tonumber(userid)].name)
					messvge = string.gsub(messvge, "{reason}", reason)
					PrintToAll(messvge, "chat")
				end
			end
		end
	end
end, nil, 0)

-- hp <uid> <value>
Convars:RegisterCommand("hp", function (_, userid, value)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and value ~= nil then
				value = tonumber(value)
				if value >= 0 then
					target:SetHealth(value)
				end
			end				
		end				
	end
end, nil, 0)

-- size <uid> <value>
Convars:RegisterCommand("size", function (_, userid, value)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and value ~= nil then
				value = tonumber(value)
				if value >= 0.0 then
					target:SetModelScale(value)
				end
			end
		end
	end
end, nil, 0)

-- clr <uid> <r> <g> <b> <a>
Convars:RegisterCommand("clr", function (_, userid, r, g, b, a)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil then
				r = tonumber(r)
				g = tonumber(g)
				b = tonumber(b)
				a = tonumber(a)
				if r <= 255 and r >= 0 then 
					if g <= 255 and g >= 0 then
						if b <= 255 and b >= 0 then
							if a <= 255 and a >= 0 then
								target:SetRenderColor(r,g,b)
								target:SetRenderAlpha(a)
								local PlayerWeapons = target:GetEquippedWeapons()
								for _, wpn in pairs(PlayerWeapons) do
									wpn:SetRenderColor(r,g,b)
									wpn:SetRenderAlpha(a)
								end
							end
						end
					end
				end
			end
		end
	end
end, nil, 0)

-- grav <uid> <value>
Convars:RegisterCommand("grav", function (_, userid, value)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and value ~= nil then
				value = tonumber(value)
				if value >= 0.0 then
					target:SetGravity(value)
				end
			end
		end
	end
end, nil, 0)

-- fric <uid> <value>
Convars:RegisterCommand("fric", function (_, userid, value)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and value ~= nil then
				value = tonumber(value)
				if value >= 0.0 then
					target:SetFriction(value)
				end
			end
		end
	end
end, nil, 0)

-- disarm <uid> <weapon_classname>
Convars:RegisterCommand("disarm", function (_, userid, weapon)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and weapon ~= nil then
				local weapons = target:GetEquippedWeapons()
				for _, wpn in pairs(weapons) do
					if weapon == "@all" then
						wpn:Kill()
					elseif wpn:GetClassname() == weapon then
						wpn:Kill()
					end
					DoEntFireByInstanceHandle(cmd, "command", "lastinv", 0.1, target, target)
				end
			end
		end
	end
end, nil, 0) 

-- changeteam <uid> <team>
Convars:RegisterCommand("changeteam", function (_, userid, team)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and team ~= nil then	
				local setsteam 
				
				local fHealth = target:GetHealth()
				
				if team == "1" or team == "spec" then
					target:SetTeam(1)
				elseif team == "2" or team == "t" then
					target:SetTeam(2)
				elseif team == "3" or team == "ct" then
					target:SetTeam(3)
				end
				target:SetHealth(fHealth)
			end
		end
	end
end, nil, 0) 

-- killit <uid>
Convars:RegisterCommand("killit", function (_, userid)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil then
				target:TakeDamage(CreateDamageInfo(target, target, Vector(0.0, 0.0, 0.0), Vector(0.0, 0.0, 0.0), 1337, 4))
				target:TakeDamage(CreateDamageInfo(target, target, Vector(0.0, 0.0, 0.0), Vector(0.0, 0.0, 0.0), 1337, 4))
			end
		end
	end
end, nil, 0) 

-- hudstatus <uid> <status>
Convars:RegisterCommand("hudstatus", function (_, userid, status)
	if IsAdmin(Convars:GetCommandClient()) == true then
		if Players[tonumber(userid)] ~= nil then
			local target = Players[tonumber(userid)].userid_pawn
			if target ~= nil and status ~= nil then
				DoEntFireByInstanceHandle(target, "SetHUDVisibility", tostring(status), 0, nil, nil)
			end
		end
	end
end, nil, 0) 

-- suicide
Convars:RegisterCommand("suicide", function ()
	Convars:GetCommandClient():TakeDamage(CreateDamageInfo(Convars:GetCommandClient(), Convars:GetCommandClient(), Vector(0.0, 0.0, 0.0), Vector(0.0, 0.0, 0.0), 1337, 4))
	Convars:GetCommandClient():TakeDamage(CreateDamageInfo(Convars:GetCommandClient(), Convars:GetCommandClient(), Vector(0.0, 0.0, 0.0), Vector(0.0, 0.0, 0.0), 1337, 4))
end, nil, 0) 

-- votemap <mapname>
Convars:RegisterCommand("votemap", function (_, mapname)
	if mapname ~= nil then
		local player = Convars:GetCommandClient()
		if PlayerVotedAlready(player) == true then
			return
		end		
		
		table.insert(TotalMapVotes[mapname], player)
		if (kv["votemap_require_votes"] > 1 and #TotalMapVotes[mapname] >= kv["votemap_require_votes"]) or ((kv["votemap_require_votes"] < 1 and kv["votemap_require_votes"] > 0) and (#TotalMapVotes[mapname] >= math.floor((#Entities:FindAllByClassname("player")*kv["votemap_require_votes"])+0.5))) then
			local nexttime = 10
			local chmpname = __GetMapName(mapname)
			
			if nexttime >= 0 then
				local mapTmr = Timers:CreateTimer(function()
					if nexttime == 0 then
						for userid, _ in pairs(Players) do
							SendToServerConsole("kickid " .. userid .. " \"map changed to " .. chmpname .. ". Connect to server again\"")
						end
						SendToServerConsole("changelevel " .. mapname)
						if mapTmr ~= nil then
							Timers:RemoveTimer(mapTmr)
						end
					end

					if kv["admin_mapchange_message_counter_status"] == 1 then
						if (nexttime > 0 and nexttime < 11) or (nexttime > 10 and nexttime % 5 == 0) then
							local message = kv["admin_mapchange_message"]
							message = string.gsub(message, "{seconds}", nexttime)
							message = string.gsub(message, "{changemap}", chmpname)
							PrintToAll(message, "chat")
						end
					end
					nexttime = nexttime - 1
					return 1.0
				end)
			end
		end
		if kv["votemap_enable_message"] == 1 then	
			local playerName
			for k,v in pairs(Players) do
				if v["userid_pawn"] == player then
					playerName = v["name"]
				end
			end
			
			local mssg = kv["votemap_voted_message"]
			mssg = string.gsub(mssg, "{user}", playerName)
			mssg = string.gsub(mssg, "{namemap}", __GetMapName(mapname))
			mssg = string.gsub(mssg, "{current}", #TotalMapVotes[mapname])
			if kv["votemap_require_votes"] > 1 then
				mssg = string.gsub(mssg, "{need}", kv["votemap_require_votes"])
			elseif kv["votemap_require_votes"] < 1 and kv["votemap_require_votes"] > 0 then
				local needpl = (#Entities:FindAllByClassname("player")*kv["votemap_require_votes"])
				mssg = string.gsub(mssg, "{need}", math.floor(needpl+0.5))
			end
			PrintToAll(mssg, "chat")
		end
	end
end, nil, 0)

ListenToGameEvent("player_connect", PlayerConnect, nil)
ListenToGameEvent("player_disconnect", PlayerDisconnect, nil)
ListenToGameEvent("player_death", PlayerDeath, nil)
ListenToGameEvent("round_start", RoundStart, nil)
ListenToGameEvent("round_end", RoundEnd, nil)
ListenToGameEvent("player_team", PlayerTeam, nil)
ListenToGameEvent("bomb_planted", BombPlanted, nil)
ListenToGameEvent("player_spawn", PlayerSpawn, nil)
ListenToGameEvent("cs_win_panel_match", WinPanelEnd, nil)
