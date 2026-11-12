local addonName, ns = ...

local EVENT = CreateFrame("Frame")
local POWER_MANA = (Enum and Enum.PowerType and Enum.PowerType.Mana) or 0
local POWER_RAGE = (Enum and Enum.PowerType and Enum.PowerType.Rage) or 1
local POWER_FOCUS = (Enum and Enum.PowerType and Enum.PowerType.Focus) or 2
local POWER_ENERGY = (Enum and Enum.PowerType and Enum.PowerType.Energy) or 3
local POWER_COMBO = (Enum and Enum.PowerType and Enum.PowerType.ComboPoints) or 4
local POWER_SHARDS = (Enum and Enum.PowerType and Enum.PowerType.SoulShards) or 7

local defaults = {
    locked = true, scale = 1, combatOnly = false, powerHidden = false,
    cooldownsHidden = false,
    position = { point = "CENTER", relativePoint = "CENTER", x = 0, y = -190 },
}
local db, playerClass, profile, root
local bars, cooldowns = {}, {}
local inCombat = false

local function IsSecret(value)
    return type(issecretvalue) == "function" and issecretvalue(value)
end

local function SpellInfo(spellID)
    if C_Spell and type(C_Spell.GetSpellInfo) == "function" then
        local ok, info = pcall(C_Spell.GetSpellInfo, spellID)
        if ok and type(info) == "table" then return info end
    end
    return nil
end

local function SpellTexture(spellID)
    if C_Spell and type(C_Spell.GetSpellTexture) == "function" then
        local ok, texture = pcall(C_Spell.GetSpellTexture, spellID)
        if ok then return texture end
    end
end

local function PlayerKnowsSpell(spellID)
    if C_SpellBook and type(C_SpellBook.IsSpellKnown) == "function" then
        local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
        local ok, known = pcall(C_SpellBook.IsSpellKnown, spellID, bank)
        if ok and known then return true end
    end
    if type(IsSpellKnownOrOverridesKnown) == "function" then
        local ok, known = pcall(IsSpellKnownOrOverridesKnown, spellID)
        if ok and known then return true end
    end
    if type(IsSpellKnown) == "function" then
        local ok, known = pcall(IsSpellKnown, spellID)
        if ok and known then return true end
    end
    if type(IsPlayerSpell) == "function" then
        local ok, known = pcall(IsPlayerSpell, spellID)
        if ok and known then return true end
    end
    return false
end

local function CreateResourceBar(parent, label, color, height)
    local bar = CreateFrame("StatusBar", nil, parent)
    bar:SetSize(280, height or 18)
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(0)
    bar:SetStatusBarColor(color[1], color[2], color[3], 1)
    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(bar)
    bg:SetColorTexture(0.04, 0.05, 0.07, 0.72)
    local edge = bar:CreateTexture(nil, "OVERLAY")
    edge:SetPoint("TOPLEFT", bar, -1, 1); edge:SetPoint("BOTTOMRIGHT", bar, 1, -1)
    edge:SetColorTexture(0.03, 0.03, 0.04, 0.9)
    local gloss = bar:CreateTexture(nil, "ARTWORK")
    gloss:SetPoint("TOPLEFT"); gloss:SetPoint("TOPRIGHT"); gloss:SetHeight(math.max(2, (height or 18) * 0.3))
    gloss:SetColorTexture(1, 1, 1, 0.07)
    bar:SetFrameLevel(parent:GetFrameLevel() + 1)
    local text = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    text:SetPoint("CENTER", bar, "CENTER", 0, 0)
    text:SetText(label)
    text:SetJustifyH("LEFT")
    bar.label = text
    return bar
end

local function SetPowerBar(bar, unit, powerType, label)
    if not bar then return end
    local current = UnitPower(unit, powerType)
    -- Secret resource values may be passed directly to Blizzard's StatusBar sink. Never
    -- compare, format, or do arithmetic on them.
    if IsSecret(current) then
        bar:SetValue(current)
    elseif current ~= nil then
        bar:SetValue(current)
    end
    local maximum = UnitPowerMax(unit, powerType)
    if not IsSecret(maximum) and type(maximum) == "number" and maximum > 0 then
        bar:SetMinMaxValues(0, maximum)
    end
    if label then bar.label:SetText(label) end
end

local function ActivePowerName(powerType)
    if powerType == POWER_MANA then return "Mana", {0.00, 0.44, 0.87} end
    if powerType == POWER_RAGE then return "Rage", {0.85, 0.15, 0.10} end
    if powerType == POWER_ENERGY then return "Energy", {1.00, 0.82, 0.06} end
    if powerType == POWER_FOCUS then return "Focus", {1.00, 0.50, 0.25} end
    return profile.label .. " resource", {0.55, 0.70, 0.90}
end

local function CurrentForm()
    if playerClass ~= "DRUID" or type(GetShapeshiftForm) ~= "function" then return nil end
    local ok, index = pcall(GetShapeshiftForm)
    if not ok or IsSecret(index) or type(index) ~= "number" or index == 0 then return "caster" end
    if type(GetShapeshiftFormInfo) == "function" then
        local good, _, _, _, spellID = pcall(GetShapeshiftFormInfo, index)
        if good and not IsSecret(spellID) then
            if spellID == 768 then return "cat" end
            if spellID == 5487 or spellID == 9634 then return "bear" end
        end
    end
    return "other"
end

local function LayoutBars()
    if not root then return end
    local y=-2; local count=0
    for _,key in ipairs({"primary","mana","combo","class","health"}) do
        local b=bars[key]
        if b and b:IsShown() then
            b:ClearAllPoints(); b:SetPoint("TOPLEFT",root,"TOPLEFT",2,y)
            y=y-(b:GetHeight()+3); count=count+1
        end
    end
    root:SetHeight(math.max(24, math.abs(y)+2))
end

local function UpdateResources()
    if not root then return end
    local currentType = UnitPowerType("player")
    if IsSecret(currentType) or type(currentType) ~= "number" then currentType = POWER_MANA end
    local label, color = ActivePowerName(currentType)
    SetPowerBar(bars.primary, "player", currentType, label)
    bars.primary:SetStatusBarColor(color[1], color[2], color[3], 1)
    bars.primary:SetShown(not db.powerHidden)

    -- Mana remains useful in a Druid's non-caster forms; other classes already use mana
    -- as their primary bar and avoid a duplicate.
    local form = CurrentForm()
    if playerClass == "DRUID" and currentType ~= POWER_MANA then
        SetPowerBar(bars.mana, "player", POWER_MANA, "Mana")
        bars.mana:Show()
    else
        bars.mana:Hide()
    end

    if playerClass == "DRUID" or playerClass == "ROGUE" then
        local showCombo = playerClass == "ROGUE" or form == "cat"
        if showCombo then
            SetPowerBar(bars.combo, "player", POWER_COMBO, "Combo points")
            bars.combo:Show()
        else
            bars.combo:Hide()
        end
    end

    if bars.health then
        local current, maximum = UnitHealth("player"), UnitHealthMax("player")
        if current ~= nil then bars.health:SetValue(current) end
        if not IsSecret(maximum) and type(maximum)=="number" and maximum>0 then bars.health:SetMinMaxValues(0,maximum) end
        bars.health:SetShown(db.showHealth)
    end

    -- Warlock shards are inventory reagents on this client, not assumed to be a power
    -- type. Count the classic soul-shard item without reading protected combat values.
    if playerClass == "WARLOCK" and C_Container and C_Container.GetContainerNumSlots
        and C_Container.GetContainerItemInfo then
        local count = 0
        for bag = 0, 4 do
            local slots = C_Container.GetContainerNumSlots(bag) or 0
            for slot = 1, slots do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                if type(info) == "table" and info.itemID == 6265 then
                    count = count + (info.stackCount or 1)
                end
            end
        end
        bars.class:SetMinMaxValues(0, math.max(1, count, 32))
        bars.class:SetValue(count)
        bars.class.label:SetText("Soul shards: " .. count)
        bars.class:Show()
    elseif playerClass == "HUNTER" and UnitExists("pet") then
        local petType = UnitPowerType("pet")
        if not IsSecret(petType) and type(petType) == "number" and petType ~= POWER_MANA then
            SetPowerBar(bars.class, "pet", petType, "Pet resource")
            bars.class:Show()
        else
            bars.class:Hide()
        end
    else
        bars.class:Hide()
    end
    if db.powerHidden then
        bars.primary:Hide(); bars.mana:Hide(); bars.combo:Hide(); bars.class:Hide()
    end
    LayoutBars()
end

local function StartCooldown(icon, entry)
    local spellID = entry.id
    local cooldown = icon.cooldown
    local durationObject
    if C_Spell and type(C_Spell.GetSpellCooldownDuration) == "function" then
        local ok, value = pcall(C_Spell.GetSpellCooldownDuration, spellID)
        if ok then durationObject = value end
    end
    if durationObject and type(cooldown.SetCooldownFromDurationObject) == "function" then
        pcall(cooldown.SetCooldownFromDurationObject, cooldown, durationObject)
        return
    end

    if C_Spell and type(C_Spell.GetSpellCooldown) == "function" then
        local ok, info = pcall(C_Spell.GetSpellCooldown, spellID)
        if ok and type(info) == "table" then
            local startTime, duration = info.startTime, info.duration
            if not IsSecret(startTime) and not IsSecret(duration)
                and type(startTime) == "number" and type(duration) == "number" and duration > 1.5 then
                cooldown:SetCooldown(startTime, duration)
                return
            end
        end
    end

    -- Local fallback uses only our own known spell constants, never hidden API values.
    if type(entry.cd) == "number" and entry.cd > 1.5 then
        cooldown:SetCooldown(GetTime(), entry.cd)
    end
end

local function CreateCooldownIcon(entry)
    local icon = CreateFrame("Frame", nil, root)
    icon:SetSize(32, 32)
    local texture = icon:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints(icon)
    texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    texture:SetTexture(SpellTexture(entry.id) or "Interface\\Icons\\INV_Misc_QuestionMark")
    local cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
    cd:SetAllPoints(icon)
    cd:SetHideCountdownNumbers(false)
    icon.cooldown, icon.entry = cd, entry
    icon:SetScript("OnEnter", function(self)
        local info = SpellInfo(self.entry.id)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(info and info.name or ("Spell " .. self.entry.id))
        GameTooltip:Show()
    end)
    icon:SetScript("OnLeave", GameTooltip_Hide)
    return icon
end

local function RefreshCooldowns()
    if not root then return end
    for _, icon in ipairs(cooldowns) do icon:Hide() end
    wipe(cooldowns)
    if db.cooldownsHidden then return end
    local entries = {}
    for _, entry in ipairs(profile.spells or {}) do
        if PlayerKnowsSpell(entry.id) then entries[#entries + 1] = entry end
    end
    for _, entry in ipairs(ns.Racials or {}) do
        if PlayerKnowsSpell(entry.id) then entries[#entries + 1] = entry end
    end
    local size, gap = db.iconSize or 32, db.iconSpacing or 4
    local columns = db.iconColumns or 7
    for index, entry in ipairs(entries) do
        local icon = CreateCooldownIcon(entry)
        local row, col = math.floor((index - 1) / columns), (index - 1) % columns
        icon:SetPoint("TOPLEFT", root, "BOTTOMLEFT", col * (size + gap), -6 - row * (size + gap))
        icon:Show()
        cooldowns[#cooldowns + 1] = icon
    end
    for _, icon in ipairs(cooldowns) do StartCooldown(icon, icon.entry) end
end

local function ApplyPosition()
    local p = db.position or defaults.position
    root:ClearAllPoints()
    root:SetPoint(p.point or "CENTER", UIParent, p.relativePoint or "CENTER", p.x or 0, p.y or -190)
end

local function SavePosition()
    local point, _, relativePoint, x, y = root:GetPoint()
    if point then db.position = {point=point, relativePoint=relativePoint, x=x, y=y} end
end

local function SetLocked(locked)
    db.locked = locked and true or false
    root:EnableMouse(not db.locked)
    root:SetMovable(not db.locked)
    if db.locked then root:RegisterForDrag() else root:RegisterForDrag("LeftButton") end
    root:SetAlpha(db.locked and 1 or 0.8)
end

local function UpdateVisibility()
    local shown = not db.combatOnly or inCombat
    root:SetShown(shown)
    for _, icon in ipairs(cooldowns) do icon:SetShown(shown and not db.cooldownsHidden) end
end

local function BuildUI()
    root = CreateFrame("Frame", nil, UIParent)
    root:SetSize(284, 74)
    root:SetFrameStrata("MEDIUM")
    root:SetClampedToScreen(true)
    root:SetScript("OnDragStart", function(self) if not db.locked then self:StartMoving() end end)
    root:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); SavePosition() end)
    root:SetScale(db.scale or 1)

    local classColor = profile.color or {0.7, 0.7, 0.7}
    bars.primary = CreateResourceBar(root, profile.label, classColor, 18)
    bars.primary:SetWidth(280)
    bars.primary:SetPoint("TOPLEFT", root, "TOPLEFT", 0, 0)
    bars.mana = CreateResourceBar(root, "Mana", {0,0.44,0.87}, 14)
    bars.mana:SetWidth(280)
    bars.mana:SetPoint("TOPLEFT", bars.primary, "BOTTOMLEFT", 0, -3)
    bars.combo = CreateResourceBar(root, "Combo points", {1,0.72,0.1}, 14)
    bars.combo:SetWidth(280)
    bars.combo:SetPoint("TOPLEFT", bars.mana, "BOTTOMLEFT", 0, -3)
    bars.class = CreateResourceBar(root, "Class resource", {0.55,0.75,0.9}, 14)
    bars.class:SetWidth(280)
    bars.class:SetPoint("TOPLEFT", bars.mana, "BOTTOMLEFT", 0, -3)
    bars.health = CreateResourceBar(root, "Health", {0.18,0.78,0.22}, 14)
    bars.health:SetWidth(280)
    bars.health:SetMinMaxValues(0, 1)
    bars.health:SetPoint("TOPLEFT", bars.primary, "BOTTOMLEFT", 0, -3)
    bars.mana:Hide(); bars.combo:Hide(); bars.class:Hide(); bars.health:SetShown(db.showHealth)

    ApplyPosition()
    SetLocked(db.locked)
end

local function OpenLayoutEditor()
    if root.layoutEditor then root.layoutEditor:SetShown(not root.layoutEditor:IsShown()); return end
    local w=CreateFrame("Frame",nil,UIParent,"BackdropTemplate"); w:SetSize(330,190); w:SetPoint("CENTER",root,"CENTER",340,0); w:SetFrameStrata("DIALOG")
    w:SetBackdrop({bgFile="Interface\\\\DialogFrame\\\\UI-DialogBox-Background",edgeFile="Interface\\\\DialogFrame\\\\UI-DialogBox-Border",tile=true,tileSize=32,edgeSize=32,insets={left=8,right=8,top=8,bottom=8}})
    local title=w:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOP",0,-18); title:SetText("Cooldown Layout")
    local note=w:CreateFontString(nil,"OVERLAY","GameFontNormal"); note:SetPoint("TOP",title,"BOTTOM",0,-12); note:SetText("Choose icon size and slots per row.")
    local function step(caption,key,delta,x)
        local b=CreateFrame("Button",nil,w,"UIPanelButtonTemplate"); b:SetSize(54,24); b:SetPoint("TOP",w,"TOP",x,-86); b:SetText(caption)
        b:SetScript("OnClick",function()
            db[key]=math.max(key=="iconSize" and 20 or 3,math.min(key=="iconSize" and 64 or 12,(db[key] or (key=="iconSize" and 32 or 7))+delta))
            RefreshCooldowns()
        end)
    end
    local a=w:CreateFontString(nil,"OVERLAY","GameFontNormal"); a:SetPoint("TOP",w,"TOP",-80,-68); a:SetText("Icon size")
    local b=w:CreateFontString(nil,"OVERLAY","GameFontNormal"); b:SetPoint("TOP",w,"TOP",80,-68); b:SetText("Slots per row")
    step("-", "iconSize",-4,-80); step("+","iconSize",4,-30); step("-","iconColumns",-1,70); step("+","iconColumns",1,120)
    local close=CreateFrame("Button",nil,w,"UIPanelButtonTemplate"); close:SetSize(80,24); close:SetPoint("BOTTOM",0,20); close:SetText("Done"); close:SetScript("OnClick",function() w:Hide() end)
    root.layoutEditor=w
end

local function OpenOptions()
    if root.options then root.options:SetShown(not root.options:IsShown()); return end
    local p=CreateFrame("Frame",nil,UIParent,"BackdropTemplate")
    p:SetSize(300,250); p:SetPoint("CENTER"); p:SetFrameStrata("DIALOG")
    p:SetBackdrop({bgFile="Interface\\\\DialogFrame\\\\UI-DialogBox-Background",edgeFile="Interface\\\\DialogFrame\\\\UI-DialogBox-Border",tile=true,tileSize=32,edgeSize=32,insets={left=8,right=8,top=8,bottom=8}})
    local title=p:CreateFontString(nil,"OVERLAY","GameFontNormalLarge"); title:SetPoint("TOP",0,-18); title:SetText(profile.label.." Resources")
    local function checkbox(label,key,y)
        local c=CreateFrame("CheckButton",nil,p,"InterfaceOptionsCheckButtonTemplate"); c:SetPoint("TOPLEFT",p,"TOPLEFT",24,y); c.Text:SetText(label); c:SetChecked(db[key])
        c:SetScript("OnClick",function(self) db[key]=self:GetChecked(); if key=="cooldownsHidden" then RefreshCooldowns() elseif key=="combatOnly" then UpdateVisibility() elseif key=="powerHidden" then UpdateResources() elseif key=="showHealth" and bars.health then bars.health:SetShown(db.showHealth) end; LayoutBars() end)
    end
    checkbox("Show only in combat","combatOnly",-54); checkbox("Hide resource bars","powerHidden",-86); checkbox("Hide cooldown icons","cooldownsHidden",-118); checkbox("Show health bar","showHealth",-150)
    local arrange=CreateFrame("Button",nil,p,"UIPanelButtonTemplate"); arrange:SetSize(220,24); arrange:SetPoint("BOTTOM",p,"BOTTOM",0,52); arrange:SetText("Customize cooldown layout..."); arrange:SetScript("OnClick",OpenLayoutEditor)
    local lock=CreateFrame("Button",nil,p,"UIPanelButtonTemplate"); lock:SetSize(100,24); lock:SetPoint("BOTTOMLEFT",p,"BOTTOMLEFT",24,22); lock:SetText("Unlock / Lock"); lock:SetScript("OnClick",function() SetLocked(not db.locked) end)
    local close=CreateFrame("Button",nil,p,"UIPanelButtonTemplate"); close:SetSize(80,24); close:SetPoint("BOTTOMRIGHT",p,"BOTTOMRIGHT",-24,22); close:SetText("Close"); close:SetScript("OnClick",function() p:Hide() end)
    root.options=p
end

local function ToggleOption(key)
    db[key] = not db[key]
    if key == "powerHidden" then bars.primary:SetShown(not db.powerHidden); bars.mana:SetShown(playerClass == "DRUID" and not db.powerHidden) end
    if key == "cooldownsHidden" then RefreshCooldowns() end
    if key == "combatOnly" then UpdateVisibility() end
    print("|cff80c0ffClassResourcesForever:|r " .. key .. " " .. (db[key] and "enabled" or "disabled"))
end

local function HandleSlash(message)
    message = (message or ""):lower():match("^%s*(.-)%s*$")
    if message == "options" or message == "config" or message == "" then OpenOptions()
    elseif message == "unlock" then SetLocked(false)
    elseif message == "lock" then SetLocked(true); SavePosition()
    elseif message == "combat" then ToggleOption("combatOnly")
    elseif message == "bars" then ToggleOption("powerHidden")
    elseif message == "cooldowns" then ToggleOption("cooldownsHidden")
    elseif message:match("^scale%s+") then
        local scale = tonumber(message:match("^scale%s+([%d%.]+)$"))
        if scale then db.scale=math.max(0.5, math.min(2, scale)); root:SetScale(db.scale) end
    elseif message == "reset" then db.position={point="CENTER",relativePoint="CENTER",x=0,y=-190}; ApplyPosition()
    else
        print("|cff80c0ffClassResourcesForever:|r /cr options | unlock | lock | combat | bars | cooldowns | scale 0.5-2.0 | reset")
    end
end

SLASH_CLASSRESOURCESFOREVER1 = "/cr"
SlashCmdList.CLASSRESOURCESFOREVER = HandleSlash

local function Init()
    local _, class = UnitClass("player")
    playerClass = class
    profile = ns.Classes and ns.Classes[class]
    if not profile or class == "DRUID" or class == "ROGUE" then
        EVENT:UnregisterAllEvents()
        return
    end
    ClassResourcesForeverDB = type(ClassResourcesForeverDB) == "table" and ClassResourcesForeverDB or {}
    db = ClassResourcesForeverDB
    for key, value in pairs(defaults) do if db[key] == nil then db[key] = value end end
    if type(db.position) ~= "table" then db.position = {point="CENTER",relativePoint="CENTER",x=0,y=-190} end
    bars, cooldowns = {}, {}
    BuildUI()
    inCombat = UnitAffectingCombat("player") and true or false
    UpdateResources()
    RefreshCooldowns()
    UpdateVisibility()
end

local function RegisterEventSafe(event)
    pcall(EVENT.RegisterEvent, EVENT, event)
end

RegisterEventSafe("PLAYER_LOGIN")
RegisterEventSafe("PLAYER_LOGOUT")
RegisterEventSafe("PLAYER_REGEN_DISABLED")
RegisterEventSafe("PLAYER_REGEN_ENABLED")
RegisterEventSafe("UNIT_HEALTH")
RegisterEventSafe("UNIT_MAXHEALTH")
RegisterEventSafe("UNIT_POWER_UPDATE")
RegisterEventSafe("UNIT_POWER_FREQUENT")
RegisterEventSafe("UNIT_HEALTH")
RegisterEventSafe("UNIT_MAXHEALTH")
RegisterEventSafe("UNIT_DISPLAYPOWER")
RegisterEventSafe("UPDATE_SHAPESHIFT_FORM")
RegisterEventSafe("PLAYER_TARGET_CHANGED")
RegisterEventSafe("UNIT_SPELLCAST_SUCCEEDED")
RegisterEventSafe("SPELLS_CHANGED")
RegisterEventSafe("SPELL_UPDATE_COOLDOWN")
RegisterEventSafe("PLAYER_EQUIPMENT_CHANGED")
RegisterEventSafe("BAG_UPDATE_DELAYED")

EVENT:SetScript("OnEvent", function(_, event, arg1, arg2, arg3)
    if event == "PLAYER_LOGIN" then Init(); return end
    if event == "PLAYER_LOGOUT" then if root and db then SavePosition() end; return end
    if not root then return end
    if event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
        inCombat = event == "PLAYER_REGEN_DISABLED"
        UpdateVisibility()
    elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
        if bars.health then bars.health:SetMinMaxValues(0, UnitHealthMax("player")); bars.health:SetValue(UnitHealth("player")); bars.health.label:SetText("Health") end
    elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then UpdateResources()
    elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then
        if arg1 == "player" or arg1 == "pet" then UpdateResources() end
    elseif event == "UNIT_DISPLAYPOWER" or event == "UPDATE_SHAPESHIFT_FORM"
        or event == "PLAYER_TARGET_CHANGED" then
        UpdateResources()
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        if arg1 == "player" and arg3 then
            for _, icon in ipairs(cooldowns) do
                if icon.entry.id == arg3 then StartCooldown(icon, icon.entry); break end
            end
        end
    elseif event == "SPELLS_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED" then
        RefreshCooldowns(); UpdateResources()
    elseif event == "BAG_UPDATE_DELAYED" then
        if playerClass == "WARLOCK" then UpdateResources() end
    elseif event == "SPELL_UPDATE_COOLDOWN" then
        for _, icon in ipairs(cooldowns) do StartCooldown(icon, icon.entry) end
    end
end)
