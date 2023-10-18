require('includes/timers')

print('#############################################')
print('\tEvents Loaded')
print('Author:\t\t\t\tPalonez')
print('Version:\t\t\t0.9')
print('Discord:\t\t\tquake1011')
print('Github:\t\t\t\tQuake1011')
print('VK:\t\t\t\tvk.com/bgtroll')
print('If u`ve an idea im ready to listen it')
print('#############################################')

local kv = LoadKeyValues("scripts/configs/Events.ini")

function PlayerDisconnect(event)
	if kv["bot_disconnect_announce"] == 0 and event["networkid"] == "BOT" then
		return
	end
	
	if kv["disconnect_announce"] == 1 then
		local message = kv["disconnect_announce_message"]
		message = string.gsub(message, "{user}", event["name"])
		PrintToAll(message, "chat")
	end
end

function formatAdr(address)
	address = string.gsub(address, string.sub(address, -(#address-string.find(address, ":")+1)), "")
	return address
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

function PlayerConnect(event)

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

ListenToGameEvent("player_connect", PlayerConnect, nil)
ListenToGameEvent("player_disconnect", PlayerDisconnect, nil)
ListenToGameEvent("round_start", RoundStart, nil)
ListenToGameEvent("round_end", RoundEnd, nil)
ListenToGameEvent("bomb_planted", BombPlanted, nil)