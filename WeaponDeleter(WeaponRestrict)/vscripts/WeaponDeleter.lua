require('includes/timers')
require('includes/utils')

local _VERSION_ = 1.0

local cfg = LoadKeyValues("scripts/configs/WeaponDeleter.ini") ~= nil and LoadKeyValues("scripts/configs/WeaponDeleter.ini") or error("Cant load scripts/configs/WeaponDeleter.ini")

local teams = {
	["2"] = "t",
	["3"] = "ct"
}

local okPrint = false

local players = {}

function End(event)
	if okPrint == true then
		okPrint = false
	end
end

function Start(event)
	cmd = Entities:FindByClassname(nil, "point_clientcommand")

    if cmd == nil then
        cmd = SpawnEntityFromTableSynchronous("point_clientcommand", { targetname = "vscript_clientcommand" })
    end
	
	if okPrint == false then
		okPrint = true
		if cfg["message_status"] == 1 then
			PrintToAll(ReplaceTags("{ORANGE}< === [ {WHITE}Restricted weapons {ORANGE}] === > {WHITE}{NL}" .. RestrictedArrayLikeString(cfg)), "chat")
		end
	end
end

function RestrictedArrayLikeString(restricted_array)
	local outstr = ""
	for k,v in pairs(restricted_array) do
		if string.match(k, "weapon_") ~= nil then
			local mb = k
			mb = string.sub(mb, 8)
			local sep = outstr ~= "" and "{NL}" or ""
			outstr = outstr .. sep .. "{DARKGREEN}" .. mb .. ": {RED}T - " .. cfg[k][teams["2"]] .. " {WHITE}| {BLUE}CT - " .. cfg[k][teams["3"]]
		end
	end
	return outstr
end

function Spawn(event)

	local data = {
		userid = event.userid,
		userid_pawn = EntIndexToHScript(bit.band(event.userid_pawn, 0x3FFF))
	}
	
	players[event["userid"]] = data
end

function Pickup(event)
	local wName = "weapon_" .. event.item
    if wName then
		local hPlayer = players[event["userid"]]["userid_pawn"]
		for _,v in pairs(hPlayer:GetEquippedWeapons()) do
			if wName == v:GetClassname() and CheckRestrictedForPlayer(wName, hPlayer) == true then
				v:Kill()
				if cfg["sound_status"] == 1 then
					DoEntFireByInstanceHandle(cmd, "command", "play " .. cfg["sound_path"], 0.2, hPlayer, hPlayer)
				end
				DoEntFireByInstanceHandle(cmd, "command", "lastinv", 0.1, hPlayer, hPlayer)
			end
		end
    end
end

ListenToGameEvent("item_purchase", Purchase, nil)
ListenToGameEvent("item_pickup", Pickup, nil)
ListenToGameEvent("player_spawn", Spawn, nil)
ListenToGameEvent("round_start", Start, nil)
ListenToGameEvent("round_end", End, nil)

function EntSetPulse(player, weapon)
	weapon:ApplyAbsVelocityImpulse(-((player:GetCenter() - weapon:GetOrigin()):Normalized() * 800))
end

Timers:CreateTimer(0.1, function()
	for _,v in pairs(Entities:FindAllByClassname("player")) do
		local all_ents = Entities:FindAllInSphere(v:GetOrigin(), 100.0)
		for _,r in pairs(all_ents) do
			for _,w in pairs(v:GetEquippedWeapons()) do
				if r ~= w and r:GetOrigin() ~= w:GetOrigin() and string.match(r:GetClassname(), "weapon") ~= nil then
					if CheckRestrictedForPlayer(r:GetClassname(), v) == true then
						EntSetPulse(v, r)
					end
				end
			end
		end
	end
	return 0.1
end)

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x57\x65\x61\x70\x6f\x6e\x44\x65\x6c\x65\x74\x65\x72\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\tPalonez\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

function CheckRestrictedForPlayer(weapon, hPlayer)
	if cfg[weapon] ~= nil then
		local req = cfg[weapon][teams[tostring(hPlayer:GetTeam())]]
		if req ~= nil then
			if req == 0 then return true end
			local exists_weapons = 0
			for _,v in pairs(Entities:FindAllByClassname("player")) do
				if v:GetTeam() == hPlayer:GetTeam() and v:IsAlive() == true then
					for _, wpn in pairs(v:GetEquippedWeapons()) do
						wpn = wpn:GetClassname()
						if wpn == weapon or ((weapon == "m4a1_silencer" and wpn == "m4a1") or (weapon == "usp_silencer" and wpn == "hkp2000")) then
							exists_weapons = exists_weapons + 1
						end
					end			
				end
			end
			if exists_weapons > req then
				return true
			end
		end	
	end
	return false
end
