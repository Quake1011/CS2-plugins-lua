require('includes/utils')

local cfg = LoadKeyValues("scripts/configs/PlantSideLocker.ini") ~= nil and LoadKeyValues("scripts/configs/PlantSideLocker.ini") or error("Cant load scripts/configs/PlantSideLocker.ini")

local _VERSION_ = 1.0

local okBlock = false

if EventsListPSL then
	for k,v in pairs(EventsListPSL) do
		StopListeningToGameEvent(v)
	end
end

function RoundEnd(event)
	if okBlock == true then
		okBlock = false
	end
end

function RoundStart(event)
	if okBlock == false then
		unRestrictAllPlants()
		local plants = {"A", "B"}
		local map = GetMapName()
		if cfg[map] then
			if isRestricted(map) == true then
				local restrictedPlant = cfg[map]["blocked_plant"]
				if restrictedPlant == "RANDOM" then
					restrictedPlant = plants[math.random(1,2)]
				end
				for k,v in pairs(plants) do
					if v == restrictedPlant then
						DoEntFireByInstanceHandle(Entities:FindAllByClassname("func_bomb_target")[tonumber(k)], "Disable", "", 0.01, nil, nil)
						okBlock = true
						if cfg["message_status"] == 1 then
							local mesoj = cfg["round_start_chat_message"]
							mesoj = string.gsub(mesoj, "{side}", restrictedPlant)
							for i = 1, tonumber(cfg["message_repeat"]) do
								ScriptPrintMessageChatAll(ReplaceTags(mesoj))
							end
						end
					end
				end
			else
				ScriptPrintMessageCenterAll("YOU CAN PLAY BOTH SITES NOW")
			end
		end	
	end
end

function isRestricted(map)
	if tonumber(cfg[map]["ct_need_to_unlock"]) > GetCountPlayersInTeam(3) or tonumber(cfg[map]["t_need_to_unlock"]) > GetCountPlayersInTeam(2) then
		return true
	end
	
	return false
end

function unRestrictAllPlants()
	for _,v in pairs(Entities:FindAllByClassname("func_bomb_target")) do
		DoEntFireByInstanceHandle(v, "Enable", "", 0.01, nil, nil)
	end
end

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x50\x6c\x61\x6e\x74\x53\x69\x64\x65\x4c\x6f\x63\x6b\x65\x72\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\tPalonez\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")


function GetCountPlayersInTeam(team)
	local counter = 0
	for _,v in pairs(Entities:FindAllByClassname("player")) do
		if v:GetTeam() == team then
			counter = counter + 1
		end
	end
	return counter
end

EventsListPSL = {
	ListenToGameEvent("round_end", RoundEnd, nil),
	ListenToGameEvent("round_start", RoundStart, nil)
}
