local _VERSION_ = 1.0

local kv = LoadKeyValues("scripts/configs/Refiller.ini") ~= nil and LoadKeyValues("scripts/configs/Refiller.ini") or error("Cant load scripts/configs/Refiller.ini")
local weapons_ammo = LoadKeyValues("scripts/configs/weapons.ini") ~= nil and LoadKeyValues("scripts/configs/weapons.ini") or error("Cant load scripts/configs/weapons.ini")

function PlayerDeath(event)
	if event["attacker"] ~= nil and event["userid"] ~= nil then
		local player = EntIndexToHScript(bit.band(event["attacker_pawn"], 0x3FFF))
		if player ~= nil then
			if player:IsPlayerPawn() == true then
				if event["attacker_pawn"] ~= event["userid_pawn"] then 
					if kv["kill_ammo_refill"] == 1 then
						if kv["health_refill"] == 1 then
							if kv["health_refill_value"] == "all" then
								player:SetHealth(player:GetMaxHealth())
							elseif type(kv["health_refill_value"]) == "number" and kv["health_refill_value"] >= 0 then
								if player:GetHealth()+kv["health_refill_value"] <= player:GetMaxHealth() then
									player:SetHealth(player:GetHealth()+kv["health_refill_value"])
								else 
									player:SetHealth(player:GetHealth()+(player:GetMaxHealth()-player:GetHealth()))
								end
							end
						end
						for k, eqWeapon in pairs(player:GetEquippedWeapons()) do
							local weaponName = eqWeapon:GetClassname()
							weaponName = string.sub(weaponName, 8)
							if kv["all_equiped_weapon"] == 0 then
								if (weaponName == event["weapon"] or (event["weapon"] == "m4a1_silencer" and weaponName == "m4a1")) or (weaponName == event["weapon"] or (event["weapon"] == "usp_silencer" and weaponName == "hkp2000")) then
									SetWeaponAmmo(eqWeapon, event["weapon"])
									break
								end
							else
								if findInTableKey(weapons_ammo, weaponName) == true then
									SetWeaponAmmo(eqWeapon, weaponName)
								end
							end
						end
					end
				end
			end
		end
	end
end

function findInTableKey(tTable, key)
	for k,v in pairs(tTable) do
		if k == key then
			return true
		end
	end
	return false
end

function findWeaponInList(weapon)
	for k,v in pairs(weapons_ammo) do
		if type(v) == "table" then
			if k == weapon then
				return true
			end
		end
	end
	return false
end

print("\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\n\t\t\t\t\t\x20\x20\x20\x20\x20\x20\x52\x65\x66\x69\x6c\x6c\x65\x72\x20\x4c\x6f\x61\x64\x65\x64\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\tPalonez\n\t\t\t\t\x41\x75\x74\x68\x6F\x72\x3A\t\t\t\t" .. _VERSION_ .. "\n\t\t\t\t\x44\x69\x73\x63\x6F\x72\x64\x3A\t\t\t\x71\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x47\x69\x74\x68\x75\x62\x3A\t\t\t\t\x51\x75\x61\x6B\x65\x31\x30\x31\x31\n\t\t\t\t\x56\x4B\x3A\t\t\t\t\x76\x6B\x2E\x63\x6F\x6D\x2F\x62\x67\x74\x72\x6F\x6C\x6C\n\t\t\t\t\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\x5F\n\t\t\t\t\x20\x20\x20\x20\x49\x66\x20\x75\x60\x76\x65\x20\x61\x6E\x20\x69\x64\x65\x61\x20\x69\x6D\x20\x72\x65\x61\x64\x79\x20\x74\x6F\x20\x6C\x69\x73\x74\x65\x6E\x20\x69\x74\n\t\t\t\t\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23\x23")

function SetWeaponAmmo(instance, class)
	if instance ~= nil then
		if findWeaponInList(class) == true then
			if kv["ammo_type_refill"] == 1 then
				DoEntFireByInstanceHandle(instance, "SetAmmoAmount", tostring(weapons_ammo[class]["clip"]), 0, nil, nil)
			elseif kv["ammo_type_refill"] == 2 then 
				DoEntFireByInstanceHandle(instance, "SetReserveAmmoAmount", tostring(weapons_ammo[class]["reserved"]), 0, nil, nil)
			elseif kv["ammo_type_refill"] == 3 then
				DoEntFireByInstanceHandle(instance, "SetAmmoAmount", tostring(weapons_ammo[class]["clip"]), 0, nil, nil)
				DoEntFireByInstanceHandle(instance, "SetReserveAmmoAmount", tostring(weapons_ammo[class]["reserved"]), 0, nil, nil)
			end
		end	
	end
end

ListenToGameEvent("player_death", PlayerDeath, nil)
