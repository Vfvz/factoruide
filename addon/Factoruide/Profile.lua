-- The character's profile, read by the app to plan a guide from where the character stands:
-- level and XP, quests done and in the log (with their objectives), position, hearthstone,
-- flight paths, professions, riding, gear, spells and money. Saved at each logout and reload;
-- `/fg profile` saves it at once (the interface reloads to write it to disk).
--
-- FactoruideDB.profiles["Name-Realm"] = { level, xp, completed = { questID... }, log = {...} ... }

local _, FG = ...
local QuestLog = FG.QuestLog
local Profile = {}
FG.Profile = Profile

local fr = GetLocale() == "frFR"

-- Professions (skill lines) and riding.
local SKILL_LINES = { 171, 164, 333, 202, 182, 165, 186, 393, 197, 185, 356, 129 }
local RIDING = 762
-- C_TaxiMap node state of a flight path the character does not know.
local UNKNOWN_FLIGHT = Enum and Enum.FlightPathState and Enum.FlightPathState.Unreachable or 2

local profile -- this character's saved profile

local function CompletedQuests()
    if QuestLog.GetAllCompletedQuestIDs then return QuestLog.GetAllCompletedQuestIDs() or {} end
    local out = {}
    for id, done in pairs(GetQuestsCompleted and GetQuestsCompleted() or {}) do
        if done then table.insert(out, id) end
    end
    table.sort(out)
    return out
end

--- Quests in the log, with what their objectives have so far.
local function LogQuests()
    local log = {}
    for i = 1, QuestLog.GetNumQuestLogEntries() do
        local info = QuestLog.GetInfo(i)
        local id = info and not info.isHeader and info.questID
        if id and id > 0 then
            local objectives = {}
            for _, o in ipairs(QuestLog.GetQuestObjectives and QuestLog.GetQuestObjectives(id) or {}) do
                table.insert(objectives, {
                    text = o.text or "",
                    done = o.numFulfilled or 0,
                    need = o.numRequired or 0,
                    finished = o.finished and true or false,
                })
            end
            local complete = QuestLog.IsComplete and QuestLog.IsComplete(id)
            table.insert(log, { id = id, complete = complete and true or false, objectives = objectives })
        end
    end
    return log
end

local function Professions()
    local out = {}
    for _, line in ipairs(SKILL_LINES) do
        local rank = FG.ProfessionSkill(line)
        if rank and rank > 0 then table.insert(out, { line = line, rank = rank }) end
    end
    return out
end

local function Gear()
    local out = {}
    for slot = 1, 19 do
        local id = GetInventoryItemID("player", slot)
        if id then table.insert(out, id) end
    end
    return out
end

--- Spells of the spell book (every rank the character learned).
local function Spells()
    local out = {}
    -- Forever reads the spell book through C_SpellBook (skill lines); Classic and TBC through tabs.
    if C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines and Enum and Enum.SpellBookSpellBank then
        local bank, spell = Enum.SpellBookSpellBank.Player, Enum.SpellBookItemType.Spell
        for line = 1, C_SpellBook.GetNumSpellBookSkillLines() do
            local info = C_SpellBook.GetSpellBookSkillLineInfo(line)
            if info and not info.offSpecID then
                for slot = info.itemIndexOffset + 1, info.itemIndexOffset + info.numSpellBookItems do
                    -- The base spell (the rank learned), not what may override it for a while.
                    local kind, actionID, spellID = C_SpellBook.GetSpellBookItemType(slot, bank)
                    local id = actionID or spellID
                    if kind == spell and id then table.insert(out, id) end
                end
            end
        end
        return out
    end
    if not (GetNumSpellTabs and GetSpellTabInfo and GetSpellBookItemInfo) then return out end
    for tab = 1, GetNumSpellTabs() do
        local _, _, offset, count = GetSpellTabInfo(tab)
        for i = offset + 1, offset + count do
            local kind, id = GetSpellBookItemInfo(i, BOOKTYPE_SPELL or "spell")
            if kind == "SPELL" and id then table.insert(out, id) end
        end
    end
    return out
end

--- Keep the hearthstone's place: its name, and where the character stands when `here` (just
--- bound: next to the innkeeper). Returns whether it changed.
local function UpdateBind(here)
    local name = GetBindLocation and GetBindLocation()
    if not name or (profile.bind and profile.bind.name == name) then return false end
    profile.bind = { name = name }
    if here then
        local map, x, y = FG.PlayerPosition()
        if x then profile.bind.position = { map = map, x = x, y = y } end
    end
    return true
end

--- One part of the profile; when the game fails to give it (at logout some data may already be
--- gone), the previous value stays and the error is kept for debugging (`profile.errors`).
local function Part(name, fn)
    local ok, value = pcall(fn)
    if ok then return value end
    profile.errors = profile.errors or {}
    profile.errors[name] = tostring(value)
    return profile[name]
end

--- Record everything the app needs about the character now.
function Profile:Snapshot()
    if not profile then return end
    profile.errors = nil
    profile.name = FG:CharacterKey()
    Part("character", function()
        local _, _, raceID = UnitRace("player")
        local _, classFile = UnitClass("player")
        profile.race = raceID
        profile.class = classFile
        profile.faction = UnitFactionGroup("player")
        profile.edition = FG.Edition
        profile.level = UnitLevel("player")
        profile.xp = UnitXP("player")
        profile.xp_max = UnitXPMax("player")
        profile.rested = GetXPExhaustion() or 0
        profile.resting = IsResting() and true or false
        profile.money = GetMoney()
        profile.instance = IsInInstance() and true or false
    end)
    profile.position = Part("position", function()
        local map, x, y = FG.PlayerPosition()
        return x and { map = map, x = x, y = y } or nil
    end)
    profile.completed = Part("completed", CompletedQuests)
    profile.log = Part("log", LogQuests)
    profile.professions = Part("professions", Professions)
    profile.riding = Part("riding", function() return FG.ProfessionSkill(RIDING) or 0 end)
    profile.gear = Part("gear", Gear)
    profile.spells = Part("spells", Spells)
    profile.flights = profile.flights or {}
    Part("bind", function() UpdateBind(false) end)
    profile.time = time()
end

--- `/fg profile`: save the profile now and reload the interface, which writes it to disk for
--- the app.
function Profile:Save()
    self:Snapshot()
    FG:Print(
        fr and "profil enregistré (niveau %d, %d quêtes faites, %d dans le journal), rechargement de l'interface"
            or "profile saved (level %d, %d quests done, %d in the log), reloading the interface",
        profile.level,
        #profile.completed,
        #profile.log
    )
    ReloadUI()
end

FG:On("PLAYER_LOGIN", function()
    local key = FG:CharacterKey()
    FactoruideDB.profiles = FactoruideDB.profiles or {}
    FactoruideDB.profiles[key] = FactoruideDB.profiles[key] or {}
    profile = FactoruideDB.profiles[key]
    Profile:Snapshot()
    -- Kept up to date while playing: the profile on disk is the one of the last minute even
    -- when the logout one fails.
    C_Timer.NewTicker(60, function() Profile:Snapshot() end)
end)

FG:On("PLAYER_LEAVING_WORLD", function() Profile:Snapshot() end)
FG:On("PLAYER_LOGOUT", function() Profile:Snapshot() end)

-- Binding the hearthstone says so in the chat: the character stands next to the innkeeper.
FG:On("CHAT_MSG_SYSTEM", function()
    if profile then UpdateBind(true) end
end)

-- Flight paths are only known from a flight master's map: remember those seen, for good.
FG:On("TAXIMAP_OPENED", function()
    if not profile or not C_TaxiMap or not C_TaxiMap.GetAllTaxiNodes then return end
    local mapID = GetTaxiMapID and GetTaxiMapID() or C_Map.GetBestMapForUnit("player")
    if not mapID then return end
    profile.flights = profile.flights or {}
    for _, node in ipairs(C_TaxiMap.GetAllTaxiNodes(mapID)) do
        if node.nodeID and node.state ~= UNKNOWN_FLIGHT then profile.flights[node.nodeID] = true end
    end
end)
