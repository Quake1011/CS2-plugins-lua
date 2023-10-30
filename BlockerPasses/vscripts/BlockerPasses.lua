require('includes/utils')
require('includes/timers')

local cfg = LoadKeyValues("scripts/configs/BlockerPasses.ini") ~= nil and LoadKeyValues("scripts/configs/BlockerPasses.ini") or error("Cant load scripts/configs/BlockerPasses.ini")

local _VERSION_ = 1.0

local TotalEnts = {}
local bbCanL = false
local EditorStatus = false

local EditorEnts = {}

if bpEvs then
	for k,v in pairs(bpEvs) do
		StopListeningToGameEvent(v)
	end
end

local g_DefaultColor = "255 255 255 255"
local g_ModelCurDefault = "models/props/de_dust/dust_metal_door.vmdl"

local updr
local editor

Convars:RegisterCommand("BPEditor", function(_, secret_key)
	if cfg["secret_key"] == secret_key then
		if EditorStatus == false then
			editor = Convars:GetCommandClient()
			EditorStatus = true
			ScriptPrintMessageChatAll("EDITOR \x04ENABLED")
			for k,v in pairs(Entities:FindAllByName("BPEnt*")) do
				print(v)
				v:Kill()
			end
			
			for k,v in pairs(EditorEnts) do
				local vara = v["model"]
				local varb = v["angles"]
				local varc = v["origin"]
				local vard = v["color"]
				local vare = v["targetname"]
				
				local ent_handle = SpawnEntityFromTableSynchronous("prop_dynamic_override", {
					model = vara,
					solid = 6,
					angles = varb,
					origin = varc,
					targetname = vare
				})
				
				if ent_handle then
					ent_handle:SetRenderColor(vard[1],vard[2],vard[3])
					ent_handle:SetRenderAlpha(tonumber(vard[4]))
				end
			end
			
			if updr then
				Timers:RemoveTimer(updr)
			end

			updr = Timers:CreateTimer(0.0001, function()
				hPlayer = editor
				
				local angl = hPlayer:GetAnglesAsVector()
				local org = hPlayer:GetOrigin()
				
				GetPointByAnglesOrigin(org, angl)
				
				local entmodel = g_ModelCurDefault
				
				local spned_entf  = SpawnEntityFromTableSynchronous("prop_dynamic_override", {
					model = entmodel,
					solid = 6,
					angles = angl,
					origin = org,
					targetname = "jktghhgHG78hggGH94oop"
				})

				local RGBA = {}
				for i in string.gmatch(g_DefaultColor, "%S+") do
					table.insert(RGBA, tonumber(i))
				end

				if spned_entf then
					spned_entf:SetRenderColor(RGBA[1],RGBA[2],RGBA[3])
					spned_entf:SetRenderAlpha(RGBA[4])
				end
				
				Timers:CreateTimer(0.0001, function()
					for k,v in pairs(Entities:FindAllByName("jktghhgHG78hggGH94oop")) do
						v:Kill()
					end
				end)
				return 0.0001
			end)
		else
			if updr then
				Timers:RemoveTimer(updr)
			end
		
			EditorStatus = false
			
			for k,v in pairs(Entities:FindAllByName("NewEnt*")) do
				EditorEnts[v] = nil
				v:Kill()
			end
			
			SpawnEntsFromCFG()
			
			ScriptPrintMessageChatAll("EDITOR \x04DISABLED")
		end 
	end
end, nil, 0)

function GetPointByAnglesOrigin(orxxxx, anxxxx)
	anxxxx[2] = anxxxx[2] - 26.0	
	local origin = {x = orxxxx[1], y = orxxxx[2], z = orxxxx[3]}
	local angles = {pitch = anxxxx[1], yaw = anxxxx[2], roll = anxxxx[3]}
	local directionX = math.cos(math.rad(angles.pitch)) * math.cos(math.rad(angles.yaw))
	local directionY = math.cos(math.rad(angles.pitch)) * math.sin(math.rad(angles.yaw))
	local directionZ = math.sin(math.rad(angles.pitch))

	orxxxx[1] = origin.x + 5 * directionX + 80 * math.cos(math.rad(angles.yaw))
	orxxxx[2] = origin.y + 5 * directionY + 80 * math.sin(math.rad(angles.yaw))
	orxxxx[3] = origin.z + 5 * directionZ
end

Convars:RegisterCommand("BPModel", function(__, modelpath)
	if string.match(modelpath, ".vmdl") == nil or string.match(modelpath, "models/") == nil then
		ScriptPrintMessageChatAll(" \x02Invalid model path\xe2\x80\xa9Example: \"" .. g_ModelCurDefault .. "\"\xe2\x80\xa9Your: " .. modelpath)
	else
		g_ModelCurDefault = modelpath
	end
end, nil, 0)

Convars:RegisterCommand("BPReload", function(_, secret_key)
	if cfg["secret_key"] == secret_key then
		cfg = LoadKeyValues("scripts/configs/BlockerPasses.ini") ~= nil and LoadKeyValues("scripts/configs/BlockerPasses.ini") or error("Cant load scripts/configs/BlockerPasses.ini")
		SpawnEntsFromCFG()
	end
end, nil, 0)

Convars:RegisterCommand("BPColor", function(__,r,g,b,a)
	if r ~= nil and  g ~= nil and b ~= nil and a ~= nil then
		r = tonumber(r)
		g = tonumber(g)
		b = tonumber(b)
		a = tonumber(a)
		if r <= 255 and r >= 0 then 
			if g <= 255 and g >= 0 then
				if b <= 255 and b >= 0 then
					if a <= 255 and a >= 0 then
						g_DefaultColor = r .. " " .. g .. " " .. b .. " " .. a
						return
					end
				end
			end
		end
		
		ScriptPrintMessageChatAll(" \x04Invalid color! Color format --> \x020-255 0-255 0-255 0-255\xe2\x80\xa9\x04Example: \x02\"BPColor " .. g_DefaultColor .. "\"")
	end
end, nil, 0)

Convars:RegisterCommand("BPSpawn", function()
	if EditorStatus == true then
		hPlayer = Convars:GetCommandClient()
		local angl = hPlayer:GetAnglesAsVector()
		local org = hPlayer:GetOrigin()

		GetPointByAnglesOrigin(org, angl)

		local tgName = "NewEnt" .. GetTblSize(EditorEnts)+1
		
		local entmodel = g_ModelCurDefault
		
		local spned_entf  = SpawnEntityFromTableSynchronous("prop_dynamic_override", {
			model = entmodel,
			solid = 6,
			angles = angl,
			origin = org,
			targetname = tgName
		})

		local RGBA = {}
		for i in string.gmatch(g_DefaultColor, "%S+") do
			table.insert(RGBA, tonumber(i))
		end

		if spned_entf then
			spned_entf:SetRenderColor(RGBA[1],RGBA[2],RGBA[3])
			spned_entf:SetRenderAlpha(RGBA[4])
		end
		
		org[1] = math.floor(org[1])
		org[2] = math.floor(org[2])
		org[3] = math.floor(org[3])
		
		angl[1] = math.floor(angl[1])
		angl[2] = math.floor(angl[2])
		angl[3] = math.floor(angl[3])
		
		EntData = {
			model = entmodel,
			solid = 6,
			angles = angl,
			origin = org,
			targetname = tgName,
			color = RGBA
		}
		
		EditorEnts[spned_entf] = EntData
		
		ScriptPrintMessageChatAll("name: " .. tgName .. "\xe2\x80\xa9origin: \x02[\x01" .. org[1] .. "\x02]    [\x01" .. org[2] .. "\x02]    [\x01" .. org[3] .. "\x02]\x01" .. "\xe2\x80\xa9angles: \x02[\x01" .. angl[1] .. "\x02]    [\x01" .. angl[2] .. "\x02]    [\x01" .. angl[3] .. "\x02]\x01")
	end
end, nil, 0)

function GetTblSize(in_tbl)
	local size = 0
	for _,_ in pairs(in_tbl) do
		size = size + 1
	end
	return size
end

Convars:RegisterCommand("BPTables", function()
	if EditorStatus == true then
		for k,v in pairs(EditorEnts) do
			print(k)
			for a,b in pairs(v) do
				if a == "color" then
					print("\t" .. a)
					for s,z in pairs(b) do
						print("\t\t" .. z)
					end
				else
					print("\t" .. a,b)
				end
			end
		end
	end
end, nil, 0)

Convars:RegisterCommand("BPDel", function(_, name)
	if EditorStatus == true then
		if name == "last" then
			name = "NewEnt" .. GetTblSize(EditorEnts)
		elseif name == "all" then
			name = "NewEnt*"
		end
		for k,v in pairs(Entities:FindAllByName(name)) do
			EditorEnts[k] = nil
			v:Kill()
		end
	end
end, nil, 0)

function vecToString(vec)
	local str = vec[1] .. " " .. vec[2] .. " " .. vec[3]
	return str 
end

function StringToVec(str)
	local nums = {}
	for i in string.gmatch(str, "%S+") do
		table.insert(nums, tonumber(i))
	end
	return Vector(nums[1], nums[2], nums[3])
end

Convars:RegisterCommand("BPGen", function()
	if EditorStatus == true then
		local ctr = 1
		print("\"".. GetMapName() .. "\"")
		print("{")
		for k,v in pairs(EditorEnts) do
			print("\"Message\"             	\"Some passes will {RED}blocked!\" 	// message which prints on round start event")
			print("\"PlayerNum\"			\"10\"	// required number of players for unlock passes")
			print("\"Entities\"")
			print("{")		
				print("\"" .. ctr .. "\"	// any blockname")
				print("{")
					print("\"model\"\"" .. v["model"] .. "\" // path to model")
					print("\"color\"\"" .. v["color"][1] .. " " .. v["color"][2] .. " " .. v["color"][3] .. " " .. v["color"][4] .. "\" // color of spawned model")
					print("\"angles\"\"" .. vecToString(v["angles"]) .. "\" // angel direction of spawned model")
					print("\"origin\"\"" .. vecToString(v["origin"]) .. "\" // origin coords of spawned model")
				print("}")
			print("}")
			ctr = ctr + 1
		end
		print("}")
	end
end, nil, 0)

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x42\x6c\x6f\x63\x6b\x65\x72\x50\x61\x73\x73\x65\x73\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t\x50\x61\x6c\x6f\x6e\x65\x7a\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

function EvRStart(event)
	if EditorStatus == false then
		if bbCanL == false then
			SpawnEntsFromCFG()
			bbCanL = true
		end
	else
		for k,v in pairs(Entities:FindAllByName("BPEnt*")) do
			v:Kill()
		end
		
		for k,v in pairs(EditorEnts) do
			local vara = v["model"]
			local varb = v["angles"]
			local varc = v["origin"]
			local vard = v["color"]
			local vare = v["targetname"]
			
			local ent_handle = SpawnEntityFromTableSynchronous("prop_dynamic_override", {
				model = vara,
				solid = 6,
				angles = varb,
				origin = varc,
				targetname = vare
			})
			
			if ent_handle then
				ent_handle:SetRenderColor(vard[1],vard[2],vard[3])
				ent_handle:SetRenderAlpha(tonumber(vard[4]))
			end
		end
	end
end

function SpawnEntsFromCFG()
	if TotalEnts then
		for k,v in pairs(TotalEnts) do
			TotalEnts[k] = nil
		end
		
		for k,v in pairs(Entities:FindAllByName("BPEnt*")) do
			v:Kill()
		end
	end

	if cfg[GetMapName()] ~= nil then
		if #Entities:FindAllByClassname("player") < cfg[GetMapName()]["PlayerNum"] then
			for k,v in pairs(cfg[GetMapName()]["Entities"]) do
				
				local vara = v["model"]
				local varb = v["angles"]
				local varc = v["origin"]
				local vard = v["color"]
				local vare = "BPEnt" .. GetTblSize(TotalEnts)+1
				
				local ent_handle = SpawnEntityFromTableSynchronous("prop_dynamic_override", {
					model = vara,
					solid = 6,
					angles = varb,
					origin = varc,
					targetname = vare
				})
				
				local RGBA = {}
				for i in string.gmatch(vard, "%S+") do
				   table.insert(RGBA, tonumber(i))
				end
				
				if ent_handle then
					ent_handle:SetRenderColor(RGBA[1],RGBA[2],RGBA[3])
					ent_handle:SetRenderAlpha(tonumber(RGBA[4]))
				end
				
				TotalEnts["ent_handle"] = {
					model = vara,
					solid = 6,
					angles = varb,
					origin = varc,
					color = RGBA,
					targetname = vare
				}
			end
			
			PrintToAll(ReplaceTags(cfg[GetMapName()]["Message"]), "chat")
		end
	end
end

function EvREnd(event)
	if bbCanL == true then
		bbCanL = false
	end
end

bpEvs = {
	ListenToGameEvent("round_start", EvRStart, nil),
	ListenToGameEvent("round_start", EvREnd, nil)
}