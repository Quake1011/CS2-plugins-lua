require('includes/timers')
require('includes/utils')

print('#############################################')
print('\tPlugins Loaded')
print('Author:\t\t\t\tPalonez')
print('Version:\t\t\t0.9')
print('Discord:\t\t\tquake1011')
print('Github:\t\t\t\tQuake1011')
print('VK:\t\t\t\tvk.com/bgtroll')
print('If u`ve an idea im ready to listen it')
print('#############################################')

local xxx = ""

local Players = {}
local TotalMapVotes = {}
local OnlineAdmins = {}

local admins = LoadKeyValues("scripts/configs/admins.ini")
local kv = LoadKeyValues("scripts/configs/plugins.ini")
local maplist = LoadKeyValues("scripts/configs/maplist.ini")

if admins == nil then
	error("Couldn't load config file scripts/configs/admins.ini")
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

function P__GetMapName(map)
	for k,v in pairs(maplist["maps"]) do
		if k == map then
			return tostring(v)
		end
	end
	return tostring(map)
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
end

function RoundStart(event)
	cmd = Entities:FindByClassname(nil, "point_clientcommand")

    if cmd == nil then
        cmd = SpawnEntityFromTableSynchronous("point_clientcommand", { targetname = "vscript_clientcommand" })
    end
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
	if mapExists(mapname) == true then
		if IsAdmin(Convars:GetCommandClient()) == true then
			if map ~= nil then
				local nexttime = tonumber(chtime)
				local chmpname = P__GetMapName(map)

				if nexttime >= 0 then
					local mapTmr = Timers:CreateTimer(function()
						if nexttime == 0 then
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
								if kv["setmap_sound"] == 1 then
									for k,v in pairs(Entities:FindAllByClassname("player")) do
										DoEntFireByInstanceHandle(cmd, "command", "play ui/menu_accept.wav", 0.0, v, v)
									end
								end
								PrintToAll(message, "chat")
							end
						end
						nexttime = nexttime - 1
						return 1.0
					end)
				end
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
						ScriptPrintMessageCenterAll("ALL PLAYERS HAS BEEN KICKED")
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

function mapExists(map)
	for k,v in pairs(maplist["maps"]) do
		if k == map then
			return true
		end
	end
	return false
end

-- votemap <mapname>
Convars:RegisterCommand("votemap", function (_, mapname)
	if mapExists(mapname) == true then
		if mapname ~= nil then
			local player = Convars:GetCommandClient()
			if PlayerVotedAlready(player) == true then
				return
			end		
			
			table.insert(TotalMapVotes[mapname], player)
			if (kv["votemap_require_votes"] > 1 and #TotalMapVotes[mapname] >= kv["votemap_require_votes"]) or ((kv["votemap_require_votes"] < 1 and kv["votemap_require_votes"] > 0) and (#TotalMapVotes[mapname] >= math.floor((#Entities:FindAllByClassname("player")*kv["votemap_require_votes"])+0.5))) then
				local nexttime = 10
				local chmpname = P__GetMapName(mapname)
				
				if nexttime >= 0 then
					local mapTmr = Timers:CreateTimer(function()
						if nexttime == 0 then
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
								if kv["votemap_sound"] == 1 then
									for k,v in pairs(Entities:FindAllByClassname("player")) do
										DoEntFireByInstanceHandle(cmd, "command", "play ui/menu_accept.wav", 0.0, v, v)
									end
								end
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
				mssg = string.gsub(mssg, "{namemap}", P__GetMapName(mapname))
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
	end
end, nil, 0)

ListenToGameEvent("player_connect", PlayerConnect, nil)
ListenToGameEvent("player_disconnect", PlayerDisconnect, nil)
ListenToGameEvent("player_death", PlayerDeath, nil)
ListenToGameEvent("round_start", RoundStart, nil)
ListenToGameEvent("player_team", PlayerTeam, nil)
ListenToGameEvent("player_spawn", PlayerSpawn, nil)
ListenToGameEvent("player_info", PlayerInfo, nil)