-- Safety (hardcore): warnings on dangerous targets (elites, mobs 3+ levels above, skulls) and
-- low health. The guide also tags elite objectives and mobs well above the character.

local _, FG = ...

local fr = GetLocale() == "frFR"

local function Warn(text)
    if UIErrorsFrame then UIErrorsFrame:AddMessage(text, 1, 0.25, 0.25) end
    if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then PlaySound(SOUNDKIT.RAID_WARNING) end
end

FG:On("PLAYER_TARGET_CHANGED", function()
    if
        not FG:Get("safetyAlerts")
        or not UnitExists("target")
        or UnitIsDead("target")
        or not UnitCanAttack("player", "target")
    then
        return
    end
    if UnitIsPlayer("target") then return end
    local level, mine = UnitLevel("target"), UnitLevel("player")
    local kind = UnitClassification("target")
    local name = FG.Readable(UnitName("target")) or ""
    if level == -1 or kind == "worldboss" then
        Warn(string.format(fr and "DANGER : %s (niveau ??)" or "DANGER: %s (level ??)", name))
    elseif kind == "elite" or kind == "rareelite" then
        Warn(string.format(fr and "Élite : %s (niveau %d)" or "Elite: %s (level %d)", name, level))
    elseif level >= mine + 3 then
        Warn(string.format(fr and "%s : niveau %d (+%d)" or "%s: level %d (+%d)", name, level, level - mine))
    end
end)

local warned, secretSeen = false, false
FG:On("UNIT_HEALTH", function(unit)
    if unit ~= "player" or not FG:Get("safetyAlerts") then return end
    -- Forever may keep the health secret (in combat at least): no alert then, the game's own low
    -- health flash remains.
    local hp, hpMax = FG.Readable(UnitHealth("player")), FG.Readable(UnitHealthMax("player"))
    if not hp or not hpMax then
        if not secretSeen then
            secretSeen = true
            FG:Debug("low health alert: the player's health is secret here")
        end
        return
    end
    local share = hp / math.max(1, hpMax)
    if share < 0.35 and not warned and not UnitIsDeadOrGhost("player") then
        warned = true
        Warn(string.format(fr and "Vie basse : %d %%" or "Low health: %d%%", math.floor(share * 100)))
    elseif share > 0.6 then
        warned = false
    end
end)
