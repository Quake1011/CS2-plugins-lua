require('includes/timers')
require('includes/utils')

local _VERSION_ = 1.0

local kv = LoadKeyValues("scripts/configs/Events.ini") ~= nil and LoadKeyValues("scripts/configs/Events.ini") or error("Cant load scripts/configs/Events.ini")

if GLEv then
	for k,v in pairs(GLEv) do
		StopListeningToGameEvent(v)
	end
end

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

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x45\x76\x65\x6e\x74\x73\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\tPalonez\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

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

GLEv = {
	ListenToGameEvent("player_connect", PlayerConnect, nil),
	ListenToGameEvent("player_disconnect", PlayerDisconnect, nil),
	ListenToGameEvent("round_start", RoundStart, nil),
	ListenToGameEvent("round_end", RoundEnd, nil),
	ListenToGameEvent("bomb_planted", BombPlanted, nil)
}
