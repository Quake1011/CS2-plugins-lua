print('#############################################')
print('\tRefiller Loaded')
print('Author:\t\t\t\tPalonez')
print('Version:\t\t\t0.9')
print('Discord:\t\t\tquake1011')
print('Github:\t\t\t\tQuake1011')
print('VK:\t\t\t\tvk.com/bgtroll')
print('If u`ve an idea im ready to listen it')
print('#############################################')

local kv = LoadKeyValues("scripts/configs/Refiller.ini")
local weapons_ammo = LoadKeyValues("scripts/configs/weapons.ini")

if weapons_ammo == nil then
	error("Couldn't load config file scripts/configs/weapons.ini")
end

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
