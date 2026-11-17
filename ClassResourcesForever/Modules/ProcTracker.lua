-- ClassResourcesForever: compact, movable proc-aura alerts shared by all classes.
local _, ns = ...
local frame, db, icons = nil, nil, {}
local SIZE, GAP = 36, 4
local function Secret(v) return issecretvalue and issecretvalue(v) end
local function Texture(id)
    if C_Spell and C_Spell.GetSpellTexture then
        local ok, tex = pcall(C_Spell.GetSpellTexture, id)
        if ok and tex then return tex end
    end
    if GetSpellTexture then
        local ok, tex = pcall(GetSpellTexture, id)
        if ok and tex then return tex end
    end
    return 134400
end
local function SpellName(id)
    if C_Spell and C_Spell.GetSpellName then
        local ok, name = pcall(C_Spell.GetSpellName, id)
        if ok and name then return name end
    end
    if GetSpellInfo then
        local ok, name = pcall(GetSpellInfo, id)
        if ok and name then return name end
    end
    return "Proc"
end
local function CreateIcon(parent, entry)
    local b = CreateFrame("Frame", nil, parent)
    b:SetSize(SIZE, SIZE)
    b.texture = b:CreateTexture(nil, "ARTWORK")
    b.texture:SetAllPoints()
    b.texture:SetTexture(Texture(entry.id))
    b.border = b:CreateTexture(nil, "OVERLAY")
    b.border:SetPoint("TOPLEFT", b, "TOPLEFT", -2, 2)
    b.border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
    b.border:SetColorTexture(0.15, 0.75, 1, 0.9)
    b.border:SetDrawLayer("BACKGROUND")
    b.cooldown = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cooldown:SetAllPoints()
    b.count = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    b.count:SetPoint("BOTTOMRIGHT", b, 1, -1)
    b.count:SetTextColor(1, 1, 1)
    b.entry = entry
    b:EnableMouse(true)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(self.entry.label or SpellName(self.entry.id))
        if self.expiration and not Secret(self.expiration) then
            local left = self.expiration - GetTime()
            if left > 0 then GameTooltip:AddLine(string.format("%.1f sec", left), 0.7, 0.9, 1) end
        end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", GameTooltip_Hide)
    b:SetScript("OnMouseDown", function(self, button)
        if db and db.unlocked and button == "LeftButton" then parent:StartMoving() end
    end)
    b:SetScript("OnMouseUp", function(self, button)
        if db and db.unlocked and button == "LeftButton" then
            parent:StopMovingOrSizing()
            local point, _, relativePoint, x, y = parent:GetPoint()
            db.position = { point = point, relativePoint = relativePoint, x = x, y = y }
        end
    end)
    return b
end
local function Update()
    if not (frame and db and ns.ProcAuras and C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then return end
    local active = {}
    for i = 1, 40 do
        local ok, aura = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
        if not ok or not aura then break end
        local id = aura.spellId
        if id and not Secret(id) then active[id] = aura end
    end
    local shown = 0
    for _, icon in ipairs(icons) do
        local aura = active[icon.entry.id]
        local visible = aura ~= nil
        if visible or db.unlocked then
            shown = shown + 1
            icon:ClearAllPoints()
            icon:SetPoint("LEFT", frame, "LEFT", (shown - 1) * (SIZE + GAP), 0)
            if visible then
                icon.expiration = aura.expirationTime
                local count = aura.applications
                icon.count:SetText(count and not Secret(count) and count > 1 and tostring(count) or "")
                local duration, expiration = aura.duration, aura.expirationTime
                if duration and expiration and not Secret(duration) and not Secret(expiration) and duration > 0 then
                    icon.cooldown:SetCooldown(expiration - duration, duration)
                    icon.cooldown:Show()
                else
                    icon.cooldown:Hide()
                end
            else
                icon.expiration = nil
                icon.count:SetText("")
                icon.cooldown:Hide()
            end
        end
        icon:SetShown(visible or db.unlocked)
    end
    frame:SetWidth(math.max(SIZE, shown * SIZE + math.max(0, shown - 1) * GAP))
    frame:SetShown(shown > 0)
end
local function SetUnlocked(unlocked)
    db.unlocked = unlocked and true or false
    if db.unlocked then
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local point, _, relativePoint, x, y = self:GetPoint()
            db.position = { point = point, relativePoint = relativePoint, x = x, y = y }
        end)
        print("|cff00ff88ClassResourcesForever:|r proc icons unlocked; drag them into place.")
    else
        frame:SetScript("OnDragStart", nil)
        frame:SetScript("OnDragStop", nil)
        frame:EnableMouse(false)
        print("|cff00ff88ClassResourcesForever:|r proc icons locked.")
    end
    Update()
end
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("UNIT_AURA")
ev:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_AURA" and unit ~= "player" then return end
    if event == "PLAYER_LOGIN" then
        local _, class = UnitClass("player")
        local entries = ns.ProcAuras and ns.ProcAuras[class]
        if not entries then return end
        ClassResourcesForeverDB = type(ClassResourcesForeverDB) == "table" and ClassResourcesForeverDB or {}
        db = ClassResourcesForeverDB.procAlerts
        if type(db) ~= "table" then db = {}; ClassResourcesForeverDB.procAlerts = db end
        frame = CreateFrame("Frame", "ClassResourcesForeverProcAlerts", UIParent)
        frame:SetSize(SIZE, SIZE)
        frame:SetFrameStrata("HIGH")
        frame:SetMovable(true)
        frame:SetClampedToScreen(true)
        local pos = db.position
        if pos and pos.point then
            frame:SetPoint(pos.point, UIParent, pos.relativePoint or pos.point, pos.x or 0, pos.y or 0)
        else
            frame:SetPoint("TOP", UIParent, "TOP", 0, -205)
        end
        for _, entry in ipairs(entries) do icons[#icons + 1] = CreateIcon(frame, entry) end
        SetUnlocked(db.unlocked)
        Update()
    elseif frame then
        Update()
    end
end)
SLASH_CLASSRESOURCESFOREVERPROCS1 = "/crprocs"
SlashCmdList.CLASSRESOURCESFOREVERPROCS = function(msg)
    if not frame then return end
    msg = (msg or ""):lower()
    if msg:find("unlock", 1, true) then
        SetUnlocked(true)
    elseif msg:find("lock", 1, true) then
        SetUnlocked(false)
    else
        print("|cff00ff88ClassResourcesForever:|r /crprocs unlock | lock")
    end
end
