require('includes/timers')
require('includes/utils')

local _VERSION_ = 1.0

local totalAds = 0
local currentAd = 1

local vkontakte, telegram, discord, c4t, site, instagram, tiktok, youtube, steam, group

local kv = LoadKeyValues("scripts/configs/Advertisement.ini") ~= nil and LoadKeyValues("scripts/configs/Advertisement.ini") or error("Cant load scripts/configs/Advertisement.ini")

function ReplaceUsefull(str)
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
		str = string.gsub(str, "{DISCORD}", "discord.gg/" .. discord)
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
		
		if totalAds == 0 then
			return false
		end
		
		return true
	end
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

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x41\x64\x76\x65\x72\x74\x69\x73\x65\x6d\x65\x6e\x74\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t\x50\x61\x6c\x6f\x6e\x65\x7a\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

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
			PrintToAll(ReplaceUsefull(kv["adverts"][tostring(counter)].Chat), "chat")
		end

		if kv["adverts"][tostring(counter)].Center ~= nil then
			PrintToAll(ReplaceUsefull(kv["adverts"][tostring(counter)].Center), "center")
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
