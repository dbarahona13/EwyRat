local frame, events = CreateFrame("Frame"), {};

frame:RegisterEvent("PLAYER_LOGIN");
frame:SetScript("OnEvent", function(self, event, ...)--self references "frame", event is the name of the event being fired
		events[event](self, ...); -- call one of the functions below

	end
);

function bearSound()--it's what u think it is

	PlaySoundFile("Interface\\Addons\\EwyRat\\mai_bear.ogg", "Master");

end

function aggroDwarfSound()--it's what u think it is

	PlaySoundFile(547901, "Master");

end

function bearMode()

	if (UnitClass("player") == "Druid") then
			--print ("Activating Ewy Rat Bear Mode!");
			nStance = GetShapeshiftForm();
			if (nStance == 1 or nStance ==2) then
				bearSound();
			end
	--else
			--print ("not a druid"); do nothing
	end

end

function UveGotMahAttention(target_event_status)--rework for forever

	
	if (target_event_status == "target" or target_event_status == "player") then
	
		local enemyToPlayer = not UnitIsFriend("target", "player") and not UnitIsPVP("target");
		--print ("enemyToPlayer: " .. tostring(enemyToPlayer));
		if (enemyToPlayer) then
		
			local targetOfTarget = UnitExists("targettarget");
			--print("Target of target: " .. tostring(targetOfTarget));
			if(targetOfTarget) then
			
				local playerEnemyTargeted = UnitGUID("targettarget") == UnitGUID("player");
				--print("player targetd by enemy: " .. tostring(playerEnemyTargeted));
				if (playerEnemyTargeted) then
				
					aggroDwarfSound();
					
				end
			end
		end
	end
	--status = UnitThreatSituation("target", "player");
	--print (status);

	--if (status == 3) then --threatlevel 2, threat not important but target shift
	--	aggroDwarfSound();
	--end

end

function events:UPDATE_SHAPESHIFT_FORM(...)--player changed drood forms

	bearMode();

end

function events:PLAYER_REGEN_DISABLED(...)--player entered combat

	frame:RegisterEvent("UNIT_TARGET");

end

function events:PLAYER_REGEN_ENABLED(...)--player left combat

	frame:UnregisterEvent("UNIT_TARGET");

end

function events:UNIT_TARGET(...)--GLOBAL TARGETTING, AFFECTS ALL PLAYERS/MOBS IN IMMEDIATE AREA TO CLIENT

	local arg1 = ...;--arg1 the mob or person targeting event
	--print ("unit targets you");
	UveGotMahAttention(arg1);

end

function events:PLAYER_LOGIN()

	print("Uve got my attention level " .. UnitLevel("player") .. " " .. UnitFullName("player") .. "! |cFFdc0000E|cFFd28c00w|cFFcebf2cy |cFF008400R|cFF3238bda|cFF712ccet|r initialized...");
	aggroDwarfSound();
	bearMode();

	frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	frame:RegisterEvent("PLAYER_REGEN_ENABLED");
end