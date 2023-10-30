require('includes/utils')
require('includes/timers')

local ct_model = "characters/models/ctm_sas/ctm_sas.vmdl"
local t_model = "characters/models/tm_phoenix/tm_phoenix.vmdl"

local _VERSION_ = 1.0

local cfg = LoadKeyValues("scripts/configs/SpawnPointManager.ini") ~= nil and LoadKeyValues("scripts/configs/SpawnPointManager.ini") or error("Cant load scripts/configs/SpawnPointManager.ini")

if ListenerRS then StopListeningToGameEvent(ListenerRS) end

local default_spawns = {}
local started = false
local DISPLAYED = false

local canEdit = false

Convars:RegisterCommand("SPM", function(_, secret_key)
	if secret_key == cfg["secret_key"] then
		canEdit = canEdit == false and true or false
		PrintToAll(ReplaceTags("SPM {PURPLE}TOGGLED"), "chat")
	end
end, nil, 0)

Convars:RegisterCommand("SPMDisplay", function(_, team)
	if canEdit == true then
		if ENABLED == true and team == nil then
			for _,v in pairs(Entities:FindAllByName("tempy_*")) do
				v:Kill()
			end
			ENABLED = false
		else
			local ct_count, t_count = 0, 0
			if team == "t" or team == nil then
				for _,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
					local ent_t = SpawnEntityFromTableSynchronous("prop_dynamic", { model = t_model, origin = v:GetOrigin(), targetname = "tempy_ct" .. ct_count } )
					ent_t:SetRenderAlpha(150)	-- alpha all T points
					if IsDefault(v) == true then
						ent_t:SetRenderColor(0, 255, 0) -- color of default T points(green)
					else
						ent_t:SetRenderColor(255, 0, 0) -- color of created T points(red)
					end
					ct_count = ct_count + 1
				end
			end
			if team == "ct" or team == nil then
				for _,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
					local ent_ct = SpawnEntityFromTableSynchronous("prop_dynamic", { model = ct_model, origin = v:GetOrigin(), targetname = "tempy_t" .. t_count } )
					ent_ct:SetRenderAlpha(150)	-- alpha all CT points
					if IsDefault(v) == true then
						ent_ct:SetRenderColor(0, 255, 0) -- color of default CT points(green)
					else
						ent_ct:SetRenderColor(0, 0, 255) -- color of created CT points(blue)
					end

					t_count = t_count + 1
				end
			end	
			ENABLED = true
			local ct,t = 0,0
			for k,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
				t = t + 1
			end
			
			for k,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
				ct = ct + 1
			end
			PrintToAll(ReplaceTags("Total spawn points:{NL}{BLUE}CT: " .. ct .. "{NL}{RED}T: " .. t) , "chat")
		end
		
		if ENABLED == true then
			PrintToAll(ReplaceTags("SPAWNS SHOWING {DARKGREEN}ENABLED"), "chat")
		else
			PrintToAll(ReplaceTags("SPAWNS SHOWING {RED}DISABLED"), "chat")
		end
	end
end, nil, 0)

Convars:RegisterCommand("SPMAdd", function(_, team)
	if canEdit == true then
		if team == "ct" then
			SpawnEntityFromTableSynchronous("info_player_counterterrorist", { origin = Convars:GetCommandClient():GetOrigin() } )
		elseif team == "t" then                                             
			SpawnEntityFromTableSynchronous("info_player_terrorist", { origin = Convars:GetCommandClient():GetOrigin() } )
		end
		
		local ct,t = 0,0
		for k,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
			t = t + 1
		end
		
		for k,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
			ct = ct + 1
		end
		
		ScriptPrintMessageCenterAll("CT - " .. ct .. "| T - " .. t)
	end
end, nil, 0)

Convars:RegisterCommand("SPMGen", function()
	if canEdit == true then
		print("\"" .. GetMapName() .. "\"")
		print("{")
		print("    \"ct\"")
		print("    {")
		local vsdfsdfw4ef = 1
		for _,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
			if IsDefault(v) == false then
				local ct_orgs = v:GetOrigin()
				
				ct_orgs[3] = ct_orgs[3] + 25.0
				
				ct_orgs[1] = math.floor(ct_orgs[1])
				ct_orgs[2] = math.floor(ct_orgs[2])
				ct_orgs[3] = math.floor(ct_orgs[3])
				print("        \"" .. vsdfsdfw4ef .. "\"		\"" .. vecToString(ct_orgs) ..  "\"")
				vsdfsdfw4ef = vsdfsdfw4ef + 1
			end
		end
		print("    }")
		print("    \"t\"")
		print("    {")
		vsdfsdfw4ef = 1
		for _,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
			if IsDefault(v) == false then
				local t_orgs = v:GetOrigin()
				
				t_orgs[3] = t_orgs[3] + 25.0
				
				t_orgs[1] = math.floor(t_orgs[1])
				t_orgs[2] = math.floor(t_orgs[2])
				t_orgs[3] = math.floor(t_orgs[3])
				print("        \"" .. vsdfsdfw4ef .. "\"		\"" .. vecToString(t_orgs) ..  "\"")
				vsdfsdfw4ef = vsdfsdfw4ef + 1
			end
		end
		print("    }")
		print("}")
	end
end, nil, 0)

function vecToString(vec)
	local str = vec[1] .. " " .. vec[2] .. " " .. vec[3]
	return str 
end

function IsDefault(handlee)
	for jo, pa in pairs(default_spawns) do
		if pa == handlee then
			return true
		end
	end
	return false
end

-- CRASHED SERVER IN NEXT ROUND AFTER DELETES
-- Convars:RegisterCommand("SPMDelete", function(_, team, num)
	-- if canEdit == true then
		-- if team == "all" then
			-- for _,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
				-- if IsDefault(v) == false then
					-- v:Kill()
				-- end
			-- end
			-- for _,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
				-- if IsDefault(v) == false then
					-- v:Kill()
				-- end
			-- end
		-- elseif team == "ct" then
			-- if num ~= nil then
				-- num = tonumber(num)
			-- end
			-- for _,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
				-- if IsDefault(v) == false then
					-- v:Kill()
					-- if num == nil or num == 1 then break end
					-- num = num - 1
				-- end
			-- end
		-- elseif team == "t" then
			-- if num ~= nil then
				-- num = tonumber(num)
			-- end
			-- for _,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
				-- if IsDefault(v) == false then
					-- v:Kill()
					-- if num == nil or num == 1 then break end
					-- num = num - 1
				-- end
			-- end
		-- end
		
		-- local ct,t = 0,0
		-- for k,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
			-- t = t + 1
		-- end
		
		-- for k,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
			-- ct = ct + 1
		-- end
		
		-- ScriptPrintMessageCenterAll("CT - " .. ct .. "| T - " .. t)
	-- end
-- end, nil, 0)

function RoundStartEvent(event)
	if started == false then
		local sps = 1
		for _,v in pairs(Entities:FindAllByClassname("info_player_terrorist")) do
			table.insert(default_spawns, sps, v)
			sps = sps + 1
		end
		
		for _,v in pairs(Entities:FindAllByClassname("info_player_counterterrorist")) do
			table.insert(default_spawns, sps, v)
			sps = sps + 1
		end
		
		if cfg[GetMapName()] ~= nil then
			for _,v in pairs(cfg[GetMapName()]["ct"]) do
				SpawnEntityFromTableSynchronous("info_player_counterterrorist", { origin = StringToVec(v) } )
			end
			
			for _,v in pairs(cfg[GetMapName()]["t"]) do
				SpawnEntityFromTableSynchronous("info_player_terrorist", { origin = StringToVec(v) } )
			end
		end
		started = true
	end
	
	Convars:SetInt("bot_difficulty", 2)	-- ConVar for spawn bots
end

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x53\x70\x61\x77\x6e\x50\x6f\x69\x6e\x74\x4d\x61\x6e\x61\x67\x65\x72\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t\x50\x61\x6c\x6f\x6e\x65\x7a\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

function StringToVec(str)
	local nums = {}
	for i in string.gmatch(str, "%S+") do
		table.insert(nums, tonumber(i))
	end
	return Vector(nums[1], nums[2], nums[3])
end

ListenerRS = ListenToGameEvent("round_start", RoundStartEvent, nil)