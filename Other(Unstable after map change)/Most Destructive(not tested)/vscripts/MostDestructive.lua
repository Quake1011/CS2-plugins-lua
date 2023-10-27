local PlayersDamageDelt = {}

local _VERSION_ = 1.0

if EvMD then
	for k,v in pairs(EvMD) do
		StopListeningToGameEvent(v)
	end
end

function playerHurt(event)
	attacker = EntIndexToHScript(bit.band(event.attacker_pawn, 0x3FFF))
	if attacker ~= nil then
		if ExistsKeyInTable(attacker) == true then
			PlayersDamageDelt[attacker] = PlayersDamageDelt[attacker] + event.health
		else
			table.insert(PlayersDamageDelt, attacker, event.health)
		end
	end
end

function roundStart(event)
	if PlayersDamageDelt then 
		PlayersDamageDelt = nil
	end
end

function roundEnd(event)
	if PlayersDamageDelt then 
		for k,v in pairs(PlayersDamageDelt) do
			if IsPlayerOnline(k) == false then
				PlayersDamageDelt[k] = nil
			end			
		end
		local tempTable = PlayersDamageDelt
		table.sort(tempTable, compare)
		local abc
		for k,v in pairs(tempTable) do
			abc = k
			break
		end
		ScriptPrintMessageChatAll( "\x02 Most destructive player " .. abc .. " with damage: " .. tempTable[abc] .. "hp")
		
		PlayersDamageDelt = nil
	end
end

local function compare(a, b)
    return a.value < b.value
end

function IsPlayerOnline(pl)
	for k,v in pairs(Entities:FindAllByClassname("player")) do
		if v == pl then
			return true
		end
	end
	return false
end

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x4d\x6f\x73\x74\x20\x44\x65\x73\x74\x72\x75\x63\x74\x69\x76\x65\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\tPalonez\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

function ExistsKeyInTable(key)
	for k,v in pairs(PlayersDamageDelt) do
		if k == key then
			return true
		end
	end
	return false
end

EvMD = {
	ListenToGameEvent("round_end", roundEnd, nil),
	ListenToGameEvent("round_start", roundStart, nil),
	ListenToGameEvent("player_hurt", playerHurt, nil)
}