require('includes/timers')

print('#############################################')
print('\tAdvertisement Loaded')
print('Author:\t\t\t\tPalonez')
print('Version:\t\t\t0.9')
print('Discord:\t\t\tquake1011')
print('Github:\t\t\t\tQuake1011')
print('VK:\t\t\t\tvk.com/bgtroll')
print('If u`ve an idea im ready to listen it')
print('#############################################')

local totalAds = 0
local currentAd = 1

local vkontakte, telegram, discord, c4t, site, instagram, tiktok, youtube, steam, group
local kv = LoadKeyValues("scripts/configs/Advertisement.ini")

function intToIp(int)
	return bit.rshift(bit.band(int, 0xFF000000), 24) .. "." .. bit.rshift(bit.band(int, 0x00FF0000), 16) .. "." .. bit.rshift(bit.band(int, 0x0000FF00), 8) .. "." .. bit.band(int, 0x000000FF)
end

function APrintToAll(str, outType)
	if outType == "chat" then
		if string.find(str, "{NL}") ~= nil then
			local laststr
			local endIndex = string.find(str:reverse(), string.reverse("{NL}"), 1, true)

			if endIndex then
				endIndex = #str - endIndex + 1
				laststr = string.sub(str, endIndex+1)
			end

			for substring in string.gmatch(str, "(.-)" .. "{NL}") do
				ScriptPrintMessageChatAll(" " .. AReplaceTags(substring))
			end
			
			ScriptPrintMessageChatAll(" " .. AReplaceTags(laststr))
		else
			ScriptPrintMessageChatAll(" " .. AReplaceTags(str))
		end
	elseif outType == "center" then
		ScriptPrintMessageCenterAll(AReplaceTags(str))
	end	
end

function AReplaceTags(str)
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
		
		for k,v in pairs(kv["adverts"]) do
			totalAds = totalAds + 1
		end
		
		print("plugins.ini loaded")
		
		if totalAds == 0 then
			return false
		end
		
		return true
	end
	error("Couldn't load config file scripts/configs/Advertisement.ini")
	return false
end

function __GetMapName(map)
	for k,v in pairs(kv["maps"]) do
		if k == map then
			return tostring(v)
		end
	end
	return tostring(map)
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

if loadCFG() then
	Timers:CreateTimer(function()
		local counter = currentAd
		if kv["adverts"][tostring(counter)].Chat ~= nil then
			APrintToAll(kv["adverts"][tostring(counter)].Chat, "chat")
		end

		if kv["adverts"][tostring(counter)].Center ~= nil then
			APrintToAll(kv["adverts"][tostring(counter)].Center, "center")
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