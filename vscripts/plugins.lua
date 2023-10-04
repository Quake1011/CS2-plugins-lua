require('includes/timers')

print 	('###############')
print 	('Plugins Loaded')
print	('Author: Palonez')
print	('Version: 0.1')
print 	('###############')

local vkontakte, telegram, discord
local totalAds = 0
local currentAd = 1
local names = {}

local kv = LoadKeyValues("scripts/configs/reklama.ini")

function intToIp(int)
	local a = bit.band(int, 0xFF000000)
	local b = bit.band(int, 0x00FF0000)
	local c = bit.band(int, 0x0000FF00)
	local d = bit.band(int, 0x000000FF)

	a = bit.rshift(a, 24)
	b = bit.rshift(b, 16)
	c = bit.rshift(c, 8)

	local ip = a .. "." .. b .. "." .. c .. "." .. d
	return ip
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
	str = string.gsub(str, "{NL}", "\xe2\x80\xa9")
	str = string.gsub(str, "{PORT}", tostring(Convars:GetInt("hostport")))
	str = string.gsub(str, "{IP}", intToIp(Convars:GetInt("hostip")))
	str = string.gsub(str, "{MAXPL}", tostring(Convars:GetInt("sv_visiblemaxplayers")))
	str = string.gsub(str, "{PL}", #names)
	str = string.gsub(str, "{MAP}", GetMapName())
	str = string.gsub(str, "{NEXTMAP}", Convars:GetStr("nextlevel"))
	str = string.gsub(str, "{TIME}", Time())
	str = string.gsub(str, "{DISCORD}", discord)
	str = string.gsub(str, "{VK}", vkontakte)
	str = string.gsub(str, "{TG}", telegram)
	return str
end

function PrintToAll(str, outType)
	if outType == "chat" then
		ScriptPrintMessageChatAll(ReplaceTags(str))
	elseif outType == "center" then
		ScriptPrintMessageCenterAll(ReplaceTags(str))
	end	
end

function loadCFG()
	if kv ~= nil then
		vkontakte = kv["vk"]
		telegram = kv["telegram"]
		discord = kv["discord"]
		timeAds = kv["time"]
		
		for k, v in pairs(kv["adverts"]) do
			totalAds = totalAds + 1
		end
		
		print("reklama.ini loaded")
		return true
	else 
		print("Couldn't load config file scripts/configs/reklama.ini")
		return false
	end
end

function PlayerDeath(event)
	local attacker, user
	
	for k, v in pairs(names) do
		if k == event["attacker"] then
			attacker = v
		elseif k == event["userid"] then
			user = v
		end
	end
	
	if attacker ~= nil and user ~= nil then
		if attacker ~= user then
			if event["distance"] ~= nil then 
				PrintToAll(" {DARKRED}[ KILL ]{WHITE} Игрок {DARKGREEN}" .. attacker .. "{WHITE} убил игрока {DARKGREEN}" .. user .. " {WHITE}с расстояния: {DARKRED}" .. tonumber(string.format("%.2f", event["distance"])) .."м.", "chat")
			end
		end
	end
end

function PlayerConnect(event)
	local bot
	if event["bot"] == true then 
		bot = ""
	else
		bot = "(Бот)" 
	end
	
	PrintToAll(" {DARKRED}[ INFO ]{WHITE} Игрок {DARKGREEN}" .. event["name"] .. " {WHITE}зашел на сервер" .. bot, "chat")
	
	names[event["userid"]] = event["name"]
end

function PlayerDisconnect(event)
	local bot
	if event["bot"] == true then 
		bot = ""
	else
		bot = "(Бот)" 
	end
	
	PrintToAll(" {DARKRED}[ INFO ]{WHITE} Игрок {DARKGREEN}" .. event["name"] .. " {WHITE}вышел с сервера" .. bot, "chat")
	
	names[event["userid"]] = nil
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
		
		currentAd = currentAd + 1
		
		if currentAd > totalAds then 
			currentAd = 1
		end 
		
		return timeAds
		end
	)
end

ListenToGameEvent("player_connect", PlayerConnect, self)
ListenToGameEvent("player_disconnect", PlayerDisconnect, self)
ListenToGameEvent("player_death", PlayerDeath, self)