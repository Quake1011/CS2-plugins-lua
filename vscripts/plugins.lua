require('includes/timers')

print('#############################################')
print('Plugins Loaded')
print('Author:\t\t\t\tPalonez')
print('Version:\t\t\t0.8')
print('Discord:\t\t\tquake1011')
print('Github:\t\t\t\tQuake1011')
print('If u`ve an idea im ready to listen it')
print('#############################################')

local vkontakte, telegram, discord, c4t, site, instagram, tiktok, youtube, steam, group
local totalAds = 0
local currentAd = 1
local names = {}

local weapons_ammo = LoadKeyValues("scripts/configs/weapons.ini")
local kv = LoadKeyValues("scripts/configs/plugins.ini")

function intToIp(int)
	return bit.rshift(bit.band(int, 0xFF000000), 24) .. "." .. bit.rshift(bit.band(int, 0x00FF0000), 16) .. "." .. bit.rshift(bit.band(int, 0x0000FF00), 8) .. "." .. bit.band(int, 0x000000FF)
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
	str = string.gsub(str, "{MAP}", GetMapName())
	local nextmap
	if Convars:GetStr("nextlevel") == "" then
		nextmap = "unknown"
	else
		nextmap = Convars:GetStr("nextlevel")
	end
	str = string.gsub(str, "{NEXTMAP}", nextmap)
	str = string.gsub(str, "{TIME}", Time())
	str = string.gsub(str, "{DISCORD}", "https://discord.gg/" .. discord)
	str = string.gsub(str, "{VK}", vkontakte)
	str = string.gsub(str, "{TG}", telegram)
	str = string.gsub(str, "{SITE}", site)
	str = string.gsub(str, "{INST}", instagram)
	str = string.gsub(str, "{TT}", tiktok)
	str = string.gsub(str, "{YT}", youtube)
	str = string.gsub(str, "{STEAM}", steam)
	str = string.gsub(str, "{GROUP}", group)
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

			for substring in str:gmatch("(.-)" .. "{NL}") do
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
		if kv["vk_link"] ~= nil then
			vkontakte = kv["vk_link"]
		end
		
		if kv["telegram_link"] ~= nil then
			telegram = kv["telegram_link"]
		end
		
		if kv["site_link"] ~= nil then
			site = kv["site_link"]
		end
		
		if kv["inst_link"] ~= nil then
			instagram = kv["inst_link"]
		end
		
		if kv["tik_tok_link"] ~= nil then
			tiktok = kv["tik_tok_link"]
		end
		
		if kv["youtube_link"] ~= nil then
			youtube = kv["youtube_link"]
		end
		
		if kv["steam_link"] ~= nil then
			steam = kv["steam_link"]
		end
		
		if kv["community_link"] ~= nil then
			group = kv["community_link"] 
		end
		
		if kv["discord_invite_link"] ~= nil then
			discord = kv["discord_invite_link"]
		end
		
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
	
	print("Couldn't load config file scripts/configs/plugins.ini")
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
		if event["disconnect"] ~= true then
			if event["isbot"] ~= true then
				local player = GetNameByID(event["userid"])
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

function GetNameByID(id)
	for k, v in pairs(names) do
		if k == id then
			return v
		end
	end
	return nil
end

function PlayerDisconnect(event)
	if kv["bot_disconnect_announce"] == 0 and event.networkid == "BOT" then
		return
	end
	
	if kv["disconnect_announce"] == 1 then
		local message = kv["disconnect_announce_message"]
		message = string.gsub(message, "{user}", event["name"])
		PrintToAll(message, "chat")
	end

	names[event["userid"]] = nil
end

function PlayerDeath(event)
	local attacker = names[event["attacker"]]
	local user = names[event["userid"]]
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
	if event["attacker_pawn"] ~= nil then
		if attacker ~= user then
			if kv["kill_ammo_refill"] == 1 then
				for k, eqWeapon in pairs(EntIndexToHScript(bit.band(event["attacker_pawn"], 0x3FFF)):GetEquippedWeapons()) do
					local weaponName = eqWeapon:GetClassname()
					weaponName = string.sub(weaponName, 8)
					
					if kv["all_equiped_weapon"] == 0 then
						if weaponName == event["weapon"] then
							SetWeaponAmmo(eqWeapon)
							break
						end
					else
						if findInTableKey(weapons_ammo, weaponName) == true then
							SetWeaponAmmo(eqWeapon)
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

function SetWeaponAmmo(instance)
	if instance ~= nil then
		local class = instance:GetClassname()
		class = string.sub(class, 8)
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

function PlayerConnect(event)
	if kv["bot_connect_announce"] == 0 and event.networkid == "BOT" then
		return
	end
	
	names[event["userid"]] = event["name"]
	
	if kv["connect_announce"] == 1 then
		local message = kv["connect_announce_message"]
		
		message = string.gsub(message, "{user}", event["name"])
		
		if event.networkid ~= "BOT" then
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
	if kv["round_start_message_status"] == 1 then
		if kv["round_start_message"].Chat ~= nil then
			PrintToAll(kv["round_start_message"].Chat, "chat")
		end
		
		if kv["round_start_message"].Center ~= nil then
			PrintToAll(kv["round_start_message"].Center, "center")
		end
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

ListenToGameEvent("player_connect", PlayerConnect, self)
ListenToGameEvent("player_disconnect", PlayerDisconnect, self)
ListenToGameEvent("player_death", PlayerDeath, self)
ListenToGameEvent("round_start", RoundStart, self)
ListenToGameEvent("round_end", RoundEnd, self)
ListenToGameEvent("player_team", PlayerTeam, self)
ListenToGameEvent("bomb_planted", BombPlanted, self)
