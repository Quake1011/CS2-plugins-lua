function PrintToAll(str, outType)
	if outType == "chat" then
		if string.find(str, "{NL}") ~= nil then
			local laststr
			local endIndex = string.find(str:reverse(), string.reverse("{NL}"), 1, true)

			if endIndex then
				endIndex = #str - endIndex + 1
				laststr = string.sub(str, endIndex+1)
			end

			for substring in string.gmatch(str, "(.-)" .. "{NL}") do
				ScriptPrintMessageChatAll(" " .. ReplaceTags(substring))
			end
			
			ScriptPrintMessageChatAll(" " .. ReplaceTags(laststr))
		else
			ScriptPrintMessageChatAll(" " .. ReplaceTags(str))
		end
	elseif outType == "center" then
		ScriptPrintMessageCenterAll(ReplaceTags(str))
	end	
end

function formatAdr(address)
	address = string.gsub(address, string.sub(address, -(#address-string.find(address, ":")+1)), "")
	return address
end

function SteamID3toSteamID2(networkid)
	networkid = string.sub(networkid, 6)
	networkid = string.gsub(networkid, "]", "")
	return "STEAM_0:" .. bit.band(tonumber(networkid), 1) .. ":" .. bit.rshift(tonumber(networkid), 1)
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
	return str
end

function intToIp(int)
	return bit.rshift(bit.band(int, 0xFF000000), 24) .. "." .. bit.rshift(bit.band(int, 0x00FF0000), 16) .. "." .. bit.rshift(bit.band(int, 0x0000FF00), 8) .. "." .. bit.band(int, 0x000000FF)
end
