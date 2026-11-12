-- RogueResources.lua
-- Copyright (c) 2026 Konchius. All rights reserved. See LICENSE.
local addonName, rootNS = ...; local RR = rootNS.CRFRogue or {}; rootNS.CRFRogue = RR   -- private namespace shared across the addon's files

-- ---------------------------------------------------------------------------
-- Localization of the addon's own UI text (labels, buttons, tooltips). Spell and
-- poison names come localized from the game already; this table covers the strings
-- WE write. `L` starts as the English defaults; a matching locale table overrides
-- them, and any key with no translation just keeps the English text.
-- ---------------------------------------------------------------------------
local L = {
    scale          = "Scale",
    showPoison     = "Show poison icons",
    showEnergy     = "Show energy bar",
    showCP         = "Show combo points bar",
    showHealth     = "Show health bar",
    showCooldowns  = "Show cooldown icons",
    barOrder       = "Bar order",
    barOrderHint   = "(drag to reorder)",
    barHealth      = "Health",
    barEnergy      = "Energy",
    barCP          = "Combo points",
    combatOnly     = "Show only in combat",
    warnWellFed    = "Warn when Well Fed is missing",
    wellFedMissing = "WELL FED MISSING",
    dismiss        = "Dismiss",
    lock           = "Lock",
    unlock         = "Unlock",
    resetPositions = "Reset positions",
    clickToOpen    = "Click to open options.",
    mhPoison       = "Main-hand poison",
    ohPoison       = "Off-hand poison",
    anyPoison      = "Any (first found)",
    stoneHeader    = "Weapon stone",
    anyStone       = "Best in bags",
    arrangeBtn     = "Customize cooldown layout...",
    done           = "Done",
    layoutTitle    = "Cooldown Layout",
    rowN           = "Row %d",
    addRow         = "+ Add row",
    deleteRow      = "Delete",
    hiddenTray     = "Hidden",
    hiddenHint     = "(right-click or drag icons here to hide them)",
    helpDrag       = "Drag and drop icons to reorder them.",
    ripSize        = "%s icon size",
    helpSlots      = "- / +  :  fewer or more slots in a row (fewer slots = bigger icons).",
    helpDelete     = "Delete  :  removes the row (its icons move to the rows below, or to Hidden).",
    spacing        = "Spacing:",
    tight          = "Tight",
    normal         = "Normal",
    wide           = "Wide",
    keepEmpty      = "Keep empty slots (icons never shift)",
    position       = "Position:",
    belowBars      = "Below bars",
    aboveBars      = "Above bars",
    reset          = "Reset",
    notLearned     = "Not learned yet",
    rcHide         = "Right-click to hide",
    rcShow         = "Right-click to show",
    previewAll     = "Preview unlearned skills",
    customBtn      = "Custom spells & items...",
    customTitle    = "Custom Tracking",
    customHint     = "Drag a spell from your spellbook or an item from your bags onto the box to track its cooldown.",
    customAdded    = "Added: %s",
    customAlready  = "That's already tracked.",
    customNoUse    = "That item has no use effect.",
    customOnly     = "Only spells and items can be added.",
    customFull     = "You can track up to %d custom spells and items.",
    colName        = "Name",
    colBuff        = "Buff (s)",
    buffTip        = "How many seconds its effect lasts. Fill it in to get the red active countdown before the cooldown, like %s. Leave it empty for cooldown only.",
    notCarried     = "Not in your bags",
    panelDesc      = "Energy, combo points, Slice and Dice, cooldowns and weapon poisons. "
        .. "Use |cffffd100/rr unlock|r to drag the bars and poison icons into place, "
        .. "or |cffffd100/rr options|r for the standalone window.",
}

do
    local T = {
        ptBR = {
            scale = "Escala",
            showPoison = "Mostrar �cones de veneno",
            showEnergy = "Mostrar barra de energia", showCP = "Mostrar barra de pontos de combo",
            showHealth = "Mostrar barra de vida", showCooldowns = "Mostrar �cones de recarga", barOrder = "Ordem das barras", barOrderHint = "(arraste para reordenar)",
            barHealth = "Vida", barEnergy = "Energia", barCP = "Pontos de combo",
            combatOnly = "Mostrar apenas em combate",
            warnWellFed = "Avisar quando faltar Bem Alimentado", wellFedMissing = "SEM BEM ALIMENTADO", dismiss = "Dispensar",
            lock = "Travar", unlock = "Destravar", resetPositions = "Redefinir posi�oes",
            clickToOpen = "Clique para abrir as op�oes.",
            mhPoison = "Veneno da mao principal", ohPoison = "Veneno da mao secund�ria",
            anyPoison = "Qualquer (o primeiro)",
            stoneHeader = "Pedra de arma", anyStone = "A melhor na bolsa",
            arrangeBtn = "Personalizar layout de recargas...", done = "Concluir",
            layoutTitle = "Layout de recargas",
            rowN = "Linha %d", addRow = "+ Adicionar linha", deleteRow = "Excluir", hiddenTray = "Ocultos",
            hiddenHint = "(clique direito ou arraste �cones para c� para ocult�-los)",
            helpDrag = "Arraste e solte os �cones para reorganiz�-los.",
            ripSize = "Tamanho do �cone: %s",
            helpSlots = "- / +  :  menos ou mais espa�os na linha (menos espa�os = �cones maiores).",
            helpDelete = "Excluir  :  remove a linha (os �cones vao para as linhas abaixo, ou para Ocultos).", spacing = "Espa�amento:",
            tight = "Justo", normal = "Normal", wide = "Largo",
            keepEmpty = "Manter espa�os vazios (�cones nao se movem)",
            position = "Posi�ao:",
            belowBars = "Abaixo das barras", aboveBars = "Acima das barras", reset = "Redefinir",
            notLearned = "Ainda nao aprendido", rcHide = "Clique direito para ocultar", rcShow = "Clique direito para mostrar", previewAll = "Pr�via de habilidades nao aprendidas",
            customBtn = "Feiti�os e itens personalizados...", customTitle = "Rastreamento personalizado",
            customHint = "Arraste um feiti�o do grim�rio ou um item das bolsas para a caixa para rastrear a recarga.",
            customAdded = "Adicionado: %s", customAlready = "Isso j� � rastreado.", customNoUse = "Esse item nao tem efeito de uso.",
            customOnly = "S� feiti�os e itens podem ser adicionados.", customFull = "Voc� pode rastrear at� %d feiti�os e itens personalizados.",
            colName = "Nome", colBuff = "Efeito (s)", notCarried = "Nao est� nas bolsas",
            buffTip = "Quantos segundos o efeito dura. Preencha para ver a contagem vermelha antes da recarga, como em %s. Deixe vazio para s� a recarga.",
            panelDesc = "Energia, pontos de combo, recargas e venenos de arma para Ladinos. "
                .. "Use |cffffd100/rr unlock|r para posicionar as barras e os �cones de veneno, "
                .. "ou |cffffd100/rr options|r para a janela independente.",
        },
        esES = {
            scale = "Escala",
            showPoison = "Mostrar iconos de veneno",
            showEnergy = "Mostrar barra de energ�a", showCP = "Mostrar barra de puntos de combo",
            showHealth = "Mostrar barra de salud", showCooldowns = "Mostrar iconos de reutilizaci�n", barOrder = "Orden de las barras", barOrderHint = "(arrastra para reordenar)",
            barHealth = "Salud", barEnergy = "Energ�a", barCP = "Puntos de combo",
            combatOnly = "Mostrar solo en combate",
            warnWellFed = "Avisar si falta Bien alimentado", wellFedMissing = "FALTA BIEN ALIMENTADO", dismiss = "Descartar",
            lock = "Bloquear", unlock = "Desbloquear", resetPositions = "Restablecer posiciones",
            clickToOpen = "Clic para abrir las opciones.",
            mhPoison = "Veneno de mano principal", ohPoison = "Veneno de mano secundaria",
            anyPoison = "Cualquiera (el primero)",
            stoneHeader = "Piedra de arma", anyStone = "La mejor de la bolsa",
            arrangeBtn = "Personalizar dise�o de reutilizaciones...", done = "Hecho",
            layoutTitle = "Dise�o de reutilizaciones",
            rowN = "Fila %d", addRow = "+ A�adir fila", deleteRow = "Eliminar", hiddenTray = "Ocultos",
            hiddenHint = "(clic derecho o arrastra iconos aqu� para ocultarlos)",
            helpDrag = "Arrastra y suelta los iconos para reordenarlos.",
            ripSize = "Tama�o del icono: %s",
            helpSlots = "- / +  :  menos o m�s huecos en la fila (menos huecos = iconos m�s grandes).",
            helpDelete = "Eliminar  :  quita la fila (sus iconos pasan a las filas de abajo, o a Ocultos).", spacing = "Espaciado:",
            tight = "Estrecho", normal = "Normal", wide = "Amplio",
            keepEmpty = "Mantener huecos vac�os (los iconos no se mueven)",
            position = "Posici�n:",
            belowBars = "Debajo de las barras", aboveBars = "Encima de las barras", reset = "Restablecer",
            notLearned = "A�n no aprendido", rcHide = "Clic derecho para ocultar", rcShow = "Clic derecho para mostrar", previewAll = "Vista previa de habilidades no aprendidas",
            customBtn = "Hechizos y objetos personalizados...", customTitle = "Seguimiento personalizado",
            customHint = "Arrastra un hechizo del libro de hechizos o un objeto de tus bolsas a la casilla para seguir su reutilizaci�n.",
            customAdded = "A�adido: %s", customAlready = "Eso ya se sigue.", customNoUse = "Ese objeto no tiene efecto de uso.",
            customOnly = "Solo se pueden a�adir hechizos y objetos.", customFull = "Puedes seguir hasta %d hechizos y objetos personalizados.",
            colName = "Nombre", colBuff = "Efecto (s)", notCarried = "No est� en tus bolsas",
            buffTip = "Cu�ntos segundos dura su efecto. Rell�nalo para ver la cuenta atr�s roja antes de la reutilizaci�n, como %s. D�jalo vac�o para solo la reutilizaci�n.",
            panelDesc = "Energ�a, puntos de combo, reutilizaciones y venenos de arma para P�caros. "
                .. "Usa |cffffd100/rr unlock|r para colocar las barras y los iconos de veneno, "
                .. "o |cffffd100/rr options|r para la ventana independiente.",
        },
        frFR = {
            scale = "�chelle",
            showPoison = "Afficher les ic�nes de poison",
            showEnergy = "Afficher la barre d'�nergie", showCP = "Afficher la barre de points de combo",
            showHealth = "Afficher la barre de vie", showCooldowns = "Afficher les ic�nes de recharge", barOrder = "Ordre des barres", barOrderHint = "(glisser pour r�organiser)",
            barHealth = "Vie", barEnergy = "�nergie", barCP = "Points de combo",
            combatOnly = "Afficher uniquement en combat",
            warnWellFed = "Pr�venir si Bien nourri manque", wellFedMissing = "BIEN NOURRI MANQUANT", dismiss = "Ignorer",
            lock = "Verrouiller", unlock = "D�verrouiller", resetPositions = "R�initialiser les positions",
            clickToOpen = "Cliquez pour ouvrir les options.",
            mhPoison = "Poison de la main directrice", ohPoison = "Poison de la main secondaire",
            anyPoison = "N'importe lequel (le premier)",
            stoneHeader = "Pierre d'arme", anyStone = "La meilleure du sac",
            arrangeBtn = "Personnaliser la disposition des recharges...", done = "Termin�",
            layoutTitle = "Disposition des recharges",
            rowN = "Ligne %d", addRow = "+ Ajouter une ligne", deleteRow = "Supprimer", hiddenTray = "Masqu�s",
            hiddenHint = "(clic droit ou glissez des ic�nes ici pour les masquer)",
            helpDrag = "Glissez-d�posez les ic�nes pour les r�organiser.",
            ripSize = "Taille de l'ic�ne : %s",
            helpSlots = "- / +  :  moins ou plus de cases dans la ligne (moins de cases = ic�nes plus grandes).",
            helpDelete = "Supprimer  :  retire la ligne (ses ic�nes passent aux lignes du dessous, ou dans Masqu�s).", spacing = "Espacement :",
            tight = "Serr�", normal = "Normal", wide = "Large",
            keepEmpty = "Garder les cases vides (les ic�nes ne bougent pas)",
            position = "Position :",
            belowBars = "Sous les barres", aboveBars = "Au-dessus des barres", reset = "R�initialiser",
            notLearned = "Pas encore appris", rcHide = "Clic droit pour masquer", rcShow = "Clic droit pour afficher", previewAll = "Aper�u des sorts non appris",
            customBtn = "Sorts et objets personnalis�s...", customTitle = "Suivi personnalis�",
            customHint = "Glissez un sort du grimoire ou un objet de vos sacs dans la case pour suivre son temps de recharge.",
            customAdded = "Ajout� : %s", customAlready = "C'est d�j� suivi.", customNoUse = "Cet objet n'a pas d'effet utilisable.",
            customOnly = "Seuls les sorts et les objets peuvent �tre ajout�s.", customFull = "Vous pouvez suivre jusqu'� %d sorts et objets personnalis�s.",
            colName = "Nom", colBuff = "Effet (s)", notCarried = "Pas dans vos sacs",
            buffTip = "Dur�e de son effet en secondes. Renseignez-la pour afficher le d�compte rouge avant la recharge, comme %s. Laissez vide pour la recharge seule.",
            panelDesc = "�nergie, points de combo, temps de recharge et poisons d'arme pour les Voleurs. "
                .. "Utilisez |cffffd100/rr unlock|r pour placer les barres et les ic�nes de poison, "
                .. "ou |cffffd100/rr options|r pour la fen�tre ind�pendante.",
        },
        deDE = {
            scale = "Skalierung",
            showPoison = "Giftsymbole anzeigen",
            showEnergy = "Energieleiste anzeigen", showCP = "Kombopunkteleiste anzeigen",
            showHealth = "Lebensleiste anzeigen", showCooldowns = "Abklingzeit-Symbole anzeigen", barOrder = "Reihenfolge der Leisten", barOrderHint = "(zum Sortieren ziehen)",
            barHealth = "Gesundheit", barEnergy = "Energie", barCP = "Kombopunkte",
            combatOnly = "Nur im Kampf anzeigen",
            warnWellFed = "Warnen, wenn Satt fehlt", wellFedMissing = "SATT FEHLT", dismiss = "Ausblenden",
            lock = "Sperren", unlock = "Entsperren", resetPositions = "Positionen zur�cksetzen",
            clickToOpen = "Klicken, um die Optionen zu �ffnen.",
            mhPoison = "Gift f�r die Waffenhand", ohPoison = "Gift f�r die Schildhand",
            anyPoison = "Beliebig (erstes gefundenes)",
            stoneHeader = "Waffenstein", anyStone = "Bester in den Taschen",
            arrangeBtn = "Abklingzeit-Layout anpassen...", done = "Fertig",
            layoutTitle = "Abklingzeit-Layout",
            rowN = "Reihe %d", addRow = "+ Reihe hinzuf�gen", deleteRow = "L�schen", hiddenTray = "Ausgeblendet",
            hiddenHint = "(Rechtsklick oder Symbole hierher ziehen, um sie auszublenden)",
            helpDrag = "Symbole per Drag & Drop neu anordnen.",
            ripSize = "Symbolgr��e: %s",
            helpSlots = "- / +  :  weniger oder mehr Pl�tze in der Reihe (weniger Pl�tze = gr��ere Symbole).",
            helpDelete = "L�schen  :  entfernt die Reihe (ihre Symbole r�cken in die Reihen darunter oder nach Ausgeblendet).", spacing = "Abstand:",
            tight = "Eng", normal = "Normal", wide = "Weit",
            keepEmpty = "Leere Pl�tze behalten (Symbole verrutschen nie)",
            position = "Position:",
            belowBars = "Unter den Leisten", aboveBars = "�ber den Leisten", reset = "Zur�cksetzen",
            notLearned = "Noch nicht erlernt", rcHide = "Rechtsklick zum Ausblenden", rcShow = "Rechtsklick zum Anzeigen", previewAll = "Nicht erlernte F�higkeiten zeigen",
            customBtn = "Eigene Zauber und Gegenst�nde...", customTitle = "Eigene Verfolgung",
            customHint = "Zieh einen Zauber aus dem Zauberbuch oder einen Gegenstand aus den Taschen in das Feld, um seine Abklingzeit zu verfolgen.",
            customAdded = "Hinzugef�gt: %s", customAlready = "Das wird schon verfolgt.", customNoUse = "Dieser Gegenstand hat keinen Benutzen-Effekt.",
            customOnly = "Nur Zauber und Gegenst�nde k�nnen hinzugef�gt werden.", customFull = "Du kannst bis zu %d eigene Zauber und Gegenst�nde verfolgen.",
            colName = "Name", colBuff = "Effekt (s)", notCarried = "Nicht in den Taschen",
            buffTip = "Wie viele Sekunden der Effekt anh�lt. Ausf�llen f�r den roten Countdown vor der Abklingzeit, wie bei %s. Leer lassen f�r nur die Abklingzeit.",
            panelDesc = "Energie, Kombopunkte, Abklingzeiten und Waffengifte f�r Schurken. "
                .. "Mit |cffffd100/rr unlock|r die Leisten und Giftsymbole platzieren, "
                .. "oder |cffffd100/rr options|r f�r das eigenst�ndige Fenster.",
        },
    }
    T.esMX = T.esES
    local loc = (GetLocale and GetLocale()) or "enUS"
    if T[loc] then for k, v in pairs(T[loc]) do L[k] = v end end
end

-- ---------------------------------------------------------------------------
-- Resource reads, tolerant of the client's API surface.
--
-- This is an Anniversary client running on the modern ("retail") engine, so it
-- can expose BOTH the classic and the retail resource APIs at once, and they can
-- briefly disagree during a combo-point spend. Each getter below prefers the API
-- that actually returns data on this client, mirroring the dual-API style the
-- ShadowRotation addon uses for spell lookups.
-- ---------------------------------------------------------------------------

-- Enum.PowerType may not exist on older API surfaces; fall back to the numeric
-- constants (Energy = 3, ComboPoints = 4) that those clients expect.
local POWER_ENERGY = (Enum and Enum.PowerType and Enum.PowerType.Energy) or 3
local POWER_COMBO  = (Enum and Enum.PowerType and Enum.PowerType.ComboPoints) or 4

local function GetEnergy()
    local cur = UnitPower("player", POWER_ENERGY)
    local max = UnitPowerMax("player", POWER_ENERGY)
    if not max or max == 0 then max = 100 end   -- guard against a 0 max during load
    return cur or 0, max
end

-- Combo points are a SECRET value on this client (WoW: Forever / patch 12 "Secret
-- Values"). Tainted addon code may STORE and PASS the value, but must never compare
-- it, do arithmetic on it, or boolean-test it -- any of those throw an immediate Lua
-- error. So GetCP reads the value and returns it completely untouched, for a
-- whitelisted widget "sink" (StatusBar:SetValue) to render without ever revealing it.
-- Note we can't even write `a or b` here: `or` boolean-tests the secret and errors.
-- GetComboPoints is the read (combo points are target-attached on this client); we
-- only nil-check the FUNCTION, never its returned value.
local function GetCP()
    if GetComboPoints then return GetComboPoints("player", "target") end
    return UnitPower("player", POWER_COMBO)
end

local MAX_CP = 5   -- base rogue; talents/anticipation handled later if needed

-- Combo point count for Slice and Dice (cpReal; nil -> builder-count fallback).
local CP_METER_W = 100
local cpMeter, cpMeterFill
local cpReal                            -- current combo points, or nil if unavailable
local cpBeforeDrop, cpDropTime = 0, 0   -- CP just before the last decrease, and when

-- `retarget`: the change came from switching targets, not from spending points, so it
-- must not count as a spend (casting SnD on the new target would otherwise use the old
-- target's points).
local function ReadCPMeter(retarget)
    local w = cpMeterFill:GetWidth()
    if issecretvalue and issecretvalue(w) then cpReal = nil return end
    local n = math.floor((w or 0) / CP_METER_W * MAX_CP + 0.5)
    if retarget then
        cpDropTime = 0
    elseif cpReal and n < cpReal then
        cpBeforeDrop, cpDropTime = cpReal, GetTime()
    end
    cpReal = n
end

local function MeasureCP(v, retarget)
    if not cpMeter then
        cpMeter = CreateFrame("StatusBar", nil, WorldFrame)
        cpMeter:SetSize(CP_METER_W, 1)
        cpMeter:SetPoint("TOPLEFT", WorldFrame, "BOTTOMLEFT", 0, -20)
        cpMeter:SetStatusBarTexture("Interface/Buttons/WHITE8x8")
        cpMeter:SetMinMaxValues(0, MAX_CP)
        cpMeter:SetAlpha(0)
        cpMeterFill = cpMeter:GetStatusBarTexture()
    end
    cpMeter:SetValue(v)
    ReadCPMeter(retarget)
    cpMeter:SetScript("OnUpdate", function(self)
        self:SetScript("OnUpdate", nil)
        ReadCPMeter(retarget)
    end)
end

-- Slice and Dice tracking.
--
-- IMPORTANT: on WoW: Forever, addon (tainted) code CANNOT read auras at all. Both
-- C_UnitAuras.GetPlayerAuraBySpellID and GetAuraDataBySpellName return nil for us
-- even while SnD is clearly up (confirmed via /rr snd) -- the same secret-value
-- lockdown that hides combo points, extended to buffs. Only Blizzard's secure UI can
-- read them. So we can't know SnD's real remaining time.
--
-- Instead we time it LOCALLY from the (non-secret) cast spellID, with the duration from
-- the combo points spent (cpReal), or, if that's unavailable, a COUNT of combo-point
-- builders since the last finisher. SnD length
-- by CP is the rank-1 tooltip: 1->9s, 2->12, 3->15, 4->18, 5->21 (i.e. 6 + 3*CP). The
-- Cooldown widget is driven by OUR OWN numbers (GetTime, duration) so the swipe +
-- countdown text work without touching any secret value.
local SND_CAST_IDS = { [5171] = true, [6774] = true }   -- SnD ranks 1/2 (cast spellIDs)
local SND_FALLBACK_ICON = 132306                        -- ability_rogue_slicedice
local CP_DURATION = { 9, 12, 15, 18, 21 }               -- SnD seconds by combo points 1..5
local SND_WARN = 5                                      -- seconds left when the yellow cue starts
local cpEstimate = 0                                    -- fallback: builders counted since the last finisher

-- Combo points spent by the Slice and Dice just cast. The spend may already have landed
-- (CP dropped to 0 a moment ago), so a drop in the last half second means "use the count
-- from just before it" -- the GCD rules out an earlier finisher being that recent.
local function SndComboPoints()
    local cp
    if cpReal then
        cp = (GetTime() - cpDropTime < 0.5) and cpBeforeDrop or cpReal
    else
        cp = cpEstimate
    end
    if cp < 1 then cp = 1 elseif cp > MAX_CP then cp = MAX_CP end
    return cp
end

local function SpellTex(id)
    if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
    return GetSpellTexture and GetSpellTexture(id)
end

local function SpellName(id)
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(id)
        if info and info.name then return info.name end
    end
    return GetSpellInfo and GetSpellInfo(id) or nil
end

-- Combo-point builders / finishers, keyed by localized name so EVERY rank matches by
-- its shared name. Resolved from representative spell IDs at load and again at login.
local BUILDERS, FINISHERS = {}, {}
local function RefreshSpellSets()
    wipe(BUILDERS); wipe(FINISHERS)
    -- spell ID -> combo points awarded
    local builders = {
        [1752] = 1, [53] = 1, [1776] = 1, [14278] = 1, [16511] = 1,  -- Sinister Strike, Backstab, Gouge, Ghostly Strike, Hemorrhage
        [8676] = 1, [703] = 1,                                      -- Ambush, Garrote
        [1833] = 2, [14183] = 2,                                    -- Cheap Shot, Premeditation
    }
    for id, points in pairs(builders) do
        local n = SpellName(id); if n then BUILDERS[n] = points end
    end
    for _, id in ipairs({ 2098, 408, 1943, 8647 }) do          -- Eviscerate, Kidney Shot, Rupture, Expose Armor
        local n = SpellName(id); if n then FINISHERS[n] = true end
    end
end
RefreshSpellSets()

-- Cooldown-tracked abilities. Each lists candidate spell IDs (ranks); we track the one
-- the player actually knows. Evasion is single-rank; Vanish has two.
local EVASION_IDS = { 5277 }
local VANISH_IDS  = { 1856, 1857 }
local KICK_IDS    = { 1766, 1767, 1768, 1769 }   -- Kick ranks 1-4
local SPRINT_IDS  = { 2983, 8696, 11305 }       -- Sprint ranks 1-3
local BLADEFLURRY_IDS = { 13877 }                -- Blade Flurry
local ADRENALINE_IDS  = { 13750 }                -- Adrenaline Rush
local BLIND_IDS   = { 2094 }                     -- Blind
local KIDNEY_IDS  = { 408, 8643 }                -- Kidney Shot ranks 1-2
local GOUGE_IDS   = { 1776, 1777, 8629, 11285, 11286 }   -- Gouge ranks 1-5
local SND_LIST    = { 5171, 6774 }               -- Slice and Dice ranks (for the known-check)
-- Talent-granted cooldowns (only shown once the talent is taken, via the known-check).
local COLDBLOOD_IDS     = { 14177 }              -- Cold Blood (Assassination)
local PREPARATION_IDS   = { 14185 }              -- Preparation (Subtlety)
local PREMEDITATION_IDS = { 14183 }              -- Premeditation (Subtlety)
local GHOSTSTRIKE_IDS   = { 14278 }              -- Ghostly Strike (Subtlety)

-- Racial abilities (WoW: Forever), tracked like the other cooldowns. `dur` = the buff's
-- length, for the red "active" phase; nil = cooldown only (instant effects). Identified
-- by spell ID, so they work in every client language; only the racials your character
-- actually has get an icon.
local RACIALS = {
    { key = "willtosurvive", id = 1259718 },              -- Human: Will to Survive
    { key = "perception",    id = 20600,   dur = 20 },    -- Human: Perception
    { key = "stoneform",     id = 20594,   dur = 8 },     -- Dwarf: Stoneform
    { key = "eluneslight",   id = 1259799, dur = 15 },    -- Night Elf: Elune's Light
    { key = "escapeartist",  id = 20589 },                -- Gnome: Escape Artist
    { key = "eureka",        id = 1259812 },              -- Gnome: Eureka!
    { key = "bloodfury",     id = 20572,   dur = 15 },    -- Orc: Blood Fury
    { key = "shattercurse",  id = 1299026, dur = 8 },     -- Orc: Shatter Curse
    { key = "willforsaken",  id = 7744 },                 -- Undead: Will of the Forsaken
    { key = "berserking",    id = 20554,   dur = 10 },    -- Troll: Berserking
    { key = "rapidregen",    id = 1260270 },              -- Troll: Rapid Regeneration
}

-- Pick the known rank from a candidate list (its cooldown reflects the shared CD).
local function KnownID(ids)
    for _, id in ipairs(ids) do
        if IsSpellKnown and IsSpellKnown(id) then return id end
        if IsPlayerSpell and IsPlayerSpell(id) then return id end
    end
    return ids[1]
end

-- Read a spell's cooldown start/duration, tolerant of the API surface. Values may be
-- plain numbers OR secret (we find out live); the caller handles both.
local function GetCooldown(spellID)
    if C_Spell and C_Spell.GetSpellCooldown then
        local info = C_Spell.GetSpellCooldown(spellID)
        if info then return info.startTime, info.duration end
    end
    if GetSpellCooldown then
        local start, dur = GetSpellCooldown(spellID)
        return start, dur
    end
end

local function IsSecret(v) return issecretvalue and issecretvalue(v) end

-- An item's cooldown (start, duration), tolerant of the API surface.
local function GetItemCD(itemID)
    if C_Container and C_Container.GetItemCooldown then return C_Container.GetItemCooldown(itemID) end
    if C_Item and C_Item.GetItemCooldown then return C_Item.GetItemCooldown(itemID) end
    if GetItemCooldown then return GetItemCooldown(itemID) end
end

-- Poisons and stones apply as temporary WEAPON ENCHANTS, not auras, and a weapon can hold
-- one of each.
local MAINHAND_SLOT, OFFHAND_SLOT = 16, 17
local FALLBACK_WEAPON_TEX = "Interface\\Icons\\INV_Sword_04"

local function HasWeapon(slot) return GetInventoryItemID and GetInventoryItemID("player", slot) ~= nil end
local function WeaponTex(slot) return GetInventoryItemTexture and GetInventoryItemTexture("player", slot) end

-- Rogues train Poisons at level 20, so there's nothing to track before then -- keep the
-- poison frame hidden until the player can actually use poisons.
local POISON_MIN_LEVEL = 20
local function PoisonsAvailable() return (UnitLevel and UnitLevel("player") or 0) >= POISON_MIN_LEVEL end

-- Poison types by internal key + rank-1 item id + English fallback (used only for the
-- menu when a type isn't carried and can't be resolved yet).
local POISON_DEFS = {
    { key = "instant",   id = 6947,  en = "Instant Poison" },
    { key = "deadly",    id = 2892,  en = "Deadly Poison" },
    { key = "wound",     id = 10918, en = "Wound Poison" },
    { key = "mindnumb",  id = 5237,  en = "Mind-numbing Poison" },
    { key = "crippling", id = 3775,  en = "Crippling Poison" },
}

-- Every poison rank's item id -> type key. We identify poisons in bags by ID (identical
-- in every language) rather than by name, which is what makes this locale-independent.
local POISON_ID_TO_KEY = {}
do
    local ranks = {
        instant   = { 6947, 6949, 6950, 8926, 8927, 8928 },
        deadly    = { 2892, 2893, 8984, 8985, 20844, 22053, 22054 },
        wound     = { 10918, 10920, 10921, 10922 },
        mindnumb  = { 5237, 6951, 9186 },
        crippling = { 3775, 3776 },
    }
    for key, ids in pairs(ranks) do for _, id in ipairs(ids) do POISON_ID_TO_KEY[id] = key end end
end

-- Strip a trailing rank numeral (" VI") so "Sofortgift VI" -> "Sofortgift" for matching.
local function PoisonBase(name) return (name:gsub("%s+[IVXLCDM]+$", "")) end

local poisonName = {}   -- key -> localized base name
local function RefreshPoisonNames()
    wipe(poisonName)
    -- Primary source: read localized names straight off the poison items you carry.
    for bag = 0, 4 do
        local slots = (C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag))
            or (GetContainerNumSlots and GetContainerNumSlots(bag)) or 0
        for s = 1, slots do
            local id, nm
            if C_Container and C_Container.GetContainerItemInfo then
                local info = C_Container.GetContainerItemInfo(bag, s)
                if info then id = info.itemID; nm = info.itemName or (info.hyperlink and info.hyperlink:match("%[(.-)%]")) end
            end
            local key = id and POISON_ID_TO_KEY[id]
            if key and nm then poisonName[key] = PoisonBase(nm) end
        end
    end
    -- Fallback (menu display for types you aren't carrying): resolve rank 1 by id.
    for _, d in ipairs(POISON_DEFS) do
        if not poisonName[d.key] then
            local n = GetItemInfo and GetItemInfo(d.id)
            poisonName[d.key] = n and PoisonBase(n) or d.en
            if not n and C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(d.id) end
        end
    end
end
RefreshPoisonNames()

-- Find a poison in the bags for the /use macro, identified by item id (locale-free). With
-- a type key it returns that type's highest-rank item name; with none, any poison.
local function FindBagPoison(typeKey)
    local bestName, bestID
    for bag = 0, 4 do
        local slots = (C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag))
            or (GetContainerNumSlots and GetContainerNumSlots(bag)) or 0
        for s = 1, slots do
            local id, name
            if C_Container and C_Container.GetContainerItemInfo then
                local info = C_Container.GetContainerItemInfo(bag, s)
                if info then id = info.itemID; name = info.itemName or (info.hyperlink and info.hyperlink:match("%[(.-)%]")) end
            end
            if not name and GetContainerItemLink then
                local link = GetContainerItemLink(bag, s)
                name = link and link:match("%[(.-)%]")
                id = link and tonumber(link:match("item:(%d+)"))
            end
            local key = id and POISON_ID_TO_KEY[id]
            if key and name and (not typeKey or key == typeKey) then
                if not bestName or id > (bestID or -1) then bestName, bestID = name, id end
            end
        end
    end
    return bestName
end

-- Weapon stones. Blunt weapons take weightstones, everything else sharpening stones. Each
-- list runs weakest to strongest.
do
    local STONES = {
        sharp  = { 2862, 2863, 2871, 7964, 12404, 18262 },
        weight = { 3239, 3240, 3241, 7965, 12643 },
    }
    local BLUNT = { [4] = true, [5] = true, [10] = true, [13] = true }   -- maces, staves, fist weapons
    RR.stoneIcon = {
        sharp  = "Interface\\Icons\\INV_Stone_SharpeningStone_01",
        weight = "Interface\\Icons\\INV_Stone_WeightStone_01",
    }

    function RR.StoneGroup(slot)
        local id = GetInventoryItemID and GetInventoryItemID("player", slot)
        local classID, subID, _
        if id and C_Item and C_Item.GetItemInfoInstant then
            _, _, _, _, _, classID, subID = C_Item.GetItemInfoInstant(id)
        end
        return (classID == 2 and BLUNT[subID]) and "weight" or "sharp"
    end

    -- The stones in your bags that fit this weapon, strongest first.
    function RR.BagStones(slot)
        local carried = {}
        if C_Container and C_Container.GetContainerItemInfo then
            for bag = 0, 4 do
                for s = 1, C_Container.GetContainerNumSlots(bag) or 0 do
                    local info = C_Container.GetContainerItemInfo(bag, s)
                    if info and info.itemID then
                        carried[info.itemID] = info.itemName or (info.hyperlink and info.hyperlink:match("%[(.-)%]"))
                    end
                end
            end
        end
        local list, ids = {}, STONES[RR.StoneGroup(slot)]
        for i = #ids, 1, -1 do
            local name = carried[ids[i]]
            if name then list[#list + 1] = { id = ids[i], name = name } end
        end
        return list
    end
end

-- Scan a weapon's tooltip for its temporary enchants. Returns the poison line and the
-- other enchant's line (a stone or oil): green, with a time in brackets, and no colon,
-- which rules out green "Use:" and "Equip:" lines.
local function WeaponEnchantText(slot)
    local poison, other
    if C_TooltipInfo and C_TooltipInfo.GetInventoryItem then
        local data = C_TooltipInfo.GetInventoryItem("player", slot)
        if data and data.lines then
            for _, line in ipairs(data.lines) do
                local t = line.leftText
                if t then
                    local isPoison = false
                    for _, d in ipairs(POISON_DEFS) do
                        local bn = poisonName[d.key]
                        if bn and t:find(bn, 1, true) then isPoison = true break end
                    end
                    local c = line.leftColor
                    if isPoison then
                        poison = poison or t
                    elseif not other and c and c.g > 0.9 and c.r < 0.1 and t:find("%(%s*%d")
                        and not t:find(":", 1, true) and not t:find("\239\188\154", 1, true) then
                        other = t
                    end
                end
            end
        end
    end
    return poison, other
end

local function PoisonKey(b) return (b.slot == MAINHAND_SLOT) and "mh" or "oh" end

-- (Re)arm a weapon button's apply macro. Left-click applies what the weapon needs most: a
-- missing or wrong poison, then a missing stone, then whichever runs out first. Shift +
-- left-click always applies the stone. Only armed while LOCKED (so an unlocked click just
-- repositions, never applies) and out of combat (secure attrs are locked in combat). Uses
-- the per-weapon choices, or any poison and the best fitting stone if unset.
local function ArmPoisonButton(b)
    if InCombatLockdown and InCombatLockdown() then return end
    RogueResourcesDB.poisonChoice = RogueResourcesDB.poisonChoice or {}
    RogueResourcesDB.stoneChoice = RogueResourcesDB.stoneChoice or {}
    local key = PoisonKey(b)
    local poison, stone
    if RogueResourcesDB.locked then
        poison = FindBagPoison(RogueResourcesDB.poisonChoice[key])   -- stable key like "instant"
        local list = RR.BagStones(b.slot)
        stone = list[1] and list[1].name
        for _, s in ipairs(list) do
            if s.id == RogueResourcesDB.stoneChoice[key] then stone = s.name end
        end
    end
    local macro
    if poison and stone then
        local tip, stoneTip = WeaponEnchantText(b.slot)
        local chosen = poisonName[RogueResourcesDB.poisonChoice[key]]
        local item = poison
        if tip and not (chosen and not tip:find(chosen, 1, true)) then
            local function Secs(t)
                local n, isMin = RR.EnchantTime(t)
                return n and (isMin and n * 60 or n) or 0
            end
            if not stoneTip or Secs(stoneTip) < Secs(tip) then item = stone end
        end
        macro = "/use [mod:shift] " .. stone .. "; " .. item .. "\n/use " .. b.slot
    elseif stone then
        macro = "/use " .. stone .. "\n/use " .. b.slot
    elseif poison then
        macro = "/use [nomod:shift] " .. poison .. "\n/use [nomod:shift] " .. b.slot
    end
    if macro then
        b:SetAttribute("type1", "macro")
        b:SetAttribute("macrotext", macro)
    else
        b:SetAttribute("type1", nil)
    end
end

-- Right-click a weapon button to choose which poison it applies. Saved per weapon by a
-- stable key; the menu shows the client's localized poison names.
local function OpenPoisonMenu(b)
    RogueResourcesDB.poisonChoice = RogueResourcesDB.poisonChoice or {}
    RogueResourcesDB.stoneChoice = RogueResourcesDB.stoneChoice or {}
    local key = PoisonKey(b)
    local label = (key == "mh") and L.mhPoison or L.ohPoison
    if MenuUtil and MenuUtil.CreateContextMenu then
        local menu = MenuUtil.CreateContextMenu(b, function(_, root)
            root:CreateTitle(label)
            for _, d in ipairs(POISON_DEFS) do
                local mark = (RogueResourcesDB.poisonChoice[key] == d.key) and "|cff40ff40> |r" or ""
                root:CreateButton(mark .. (poisonName[d.key] or d.en), function()
                    RogueResourcesDB.poisonChoice[key] = d.key
                    ArmPoisonButton(b)
                end)
            end
            root:CreateDivider()
            root:CreateButton(L.anyPoison, function()
                RogueResourcesDB.poisonChoice[key] = nil
                ArmPoisonButton(b)
            end)
            root:CreateDivider()
            root:CreateTitle(L.stoneHeader)
            for _, s in ipairs(RR.BagStones(b.slot)) do
                local mark = (RogueResourcesDB.stoneChoice[key] == s.id) and "|cff40ff40> |r" or ""
                root:CreateButton(mark .. s.name, function()
                    RogueResourcesDB.stoneChoice[key] = s.id
                    ArmPoisonButton(b)
                end)
            end
            root:CreateButton(L.anyStone, function()
                RogueResourcesDB.stoneChoice[key] = nil
                ArmPoisonButton(b)
            end)
        end)
        -- A context menu opens at the cursor; pin it just below the weapon icon instead,
        -- so it always appears in the same place.
        if menu and menu.ClearAllPoints then
            pcall(function()
                menu:ClearAllPoints()
                menu:SetPoint("TOPLEFT", b, "BOTTOMLEFT", 0, -4)
            end)
        end
    else   -- fallback: cycle through the types
        local cur, idx = RogueResourcesDB.poisonChoice[key], 0
        for i, d in ipairs(POISON_DEFS) do if d.key == cur then idx = i break end end
        local nextDef = POISON_DEFS[(idx % #POISON_DEFS) + 1]
        RogueResourcesDB.poisonChoice[key] = nextDef.key
        ArmPoisonButton(b)
        print("|cff00ff88RogueResources:|r " .. label .. ": " .. (poisonName[nextDef.key] or nextDef.en))
    end
end


-- ---------------------------------------------------------------------------
-- Saved settings
-- ---------------------------------------------------------------------------
RR.defaults = {
    locked      = true,
    position    = { point = "CENTER", relativePoint = "CENTER", x = 0, y = -179 },
    poisonPos   = { point = "CENTER", relativePoint = "CENTER", x = 144, y = -179 },
    sndMult     = 1.0,  -- Improved SnD multiplier, used only if the talent can't be read (/rr sndmult)
    scale       = 1.0,  -- UI scale for the bars + poison frame (0.5 .. 2.0)
    energyHidden  = false, -- hide the energy bar
    cpHidden      = false, -- hide the combo-point bar
    healthShown   = false, -- show the (optional) health bar
    cooldownsHidden = false, -- hide the whole cooldown icon row
    barOrder      = { "cp", "energy", "health" },   -- bar stacking order, top to bottom
    combatOnly    = false, -- show the bars + icons only while in combat
    wellFedWarn   = false, -- show a warning when the Well Fed food buff is missing
    minimapAngle  = 200,   -- minimap button position, degrees around the ring
}

-- Fill only MISSING keys from defaults (recursively), so a saved position/duration is
-- never clobbered on load, and default sub-tables aren't shared by reference.
local function ApplyDefaults(src, dst)
    dst = dst or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = ApplyDefaults(v, dst[k])
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
    return dst
end

-- ---------------------------------------------------------------------------
-- Display: an energy StatusBar with a segmented combo-point bar above it.
-- CP can't drive discrete pips (that needs a comparison on a secret value), so it's
-- a 0..MAX_CP StatusBar split by dividers to still read as segments.
-- ---------------------------------------------------------------------------
local BAR_W, BAR_H = 200, 16
local CP_H, GAP = 14, 5
-- The bar frame always has room for all three bars (health, energy, combo), so its
-- height never changes. OLD_FRAME_H is the two-bar height of versions before the
-- health bar, used once to move older saved positions (see PLAYER_LOGIN).
local FRAME_H     = BAR_H * 2 + CP_H + GAP * 2
local OLD_FRAME_H = BAR_H + CP_H + GAP
local BAR_TEX = "Interface\\TargetingFrame\\UI-StatusBar"

-- A crisp 1px dark outline just outside a region, drawn on `host` behind the bars.
local function Outline(region, host, thick)
    thick = thick or 1
    local t = host:CreateTexture(nil, "BACKGROUND", nil, -6)
    t:SetColorTexture(0, 0, 0, 1)
    t:SetPoint("TOPLEFT", region, "TOPLEFT", -thick, thick)
    t:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", thick, -thick)
    return t
end

-- Subtle sheen on a bar: a faint additive block over the top plus a 1px highlight
-- line, giving the fill some depth without needing any gradient API.
local function Gloss(bar)
    local g = bar:CreateTexture(nil, "ARTWORK", nil, 2)
    g:SetColorTexture(1, 1, 1, 0.06)
    g:SetBlendMode("ADD")
    g:SetPoint("TOPLEFT", bar, "TOPLEFT", 1, -1)
    g:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", -1, -math.max(2, bar:GetHeight() * 0.5))
    local hl = bar:CreateTexture(nil, "ARTWORK", nil, 3)
    hl:SetColorTexture(1, 1, 1, 0.20)
    hl:SetHeight(1)
    hl:SetPoint("TOPLEFT", bar, "TOPLEFT", 1, -1)
    hl:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -1, -1)
end

local ICON_SIZE, ICON_GAP = 32, 5

-- A bordered spell icon with a Cooldown swipe overlay. Used for the SnD timer and the
-- Evasion/Vanish cooldown trackers.
local function MakeIcon(parent, tex)
    local o = CreateFrame("Frame", nil, parent)
    o:SetSize(ICON_SIZE, ICON_SIZE)

    local border = o:CreateTexture(nil, "BACKGROUND")
    border:SetPoint("TOPLEFT", o, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", o, "BOTTOMRIGHT", 1, -1)
    border:SetColorTexture(0, 0, 0, 1)

    local icon = o:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(o)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)   -- trim the default icon border
    if tex then icon:SetTexture(tex) end

    local cd = CreateFrame("Cooldown", nil, o, "CooldownFrameTemplate")
    cd:SetAllPoints(o)
    cd:SetHideCountdownNumbers(false)
    cd:SetDrawEdge(true)

    -- One-shot "ready" flash: a white overlay that pulses up then fades. Played when a
    -- tracked cooldown finishes (wired per-icon in BuildUI).
    local flash = o:CreateTexture(nil, "OVERLAY")
    flash:SetAllPoints(o)
    flash:SetColorTexture(1, 1, 1, 1)
    flash:SetBlendMode("ADD")
    flash:SetAlpha(0)
    local ag = flash:CreateAnimationGroup()
    local up = ag:CreateAnimation("Alpha")
    up:SetFromAlpha(0); up:SetToAlpha(0.85); up:SetDuration(0.12); up:SetOrder(1)
    local down = ag:CreateAnimation("Alpha")
    down:SetFromAlpha(0.85); down:SetToAlpha(0); down:SetDuration(0.40); down:SetOrder(2)

    o.icon, o.cd, o.flash, o.border = icon, cd, ag, border
    return o
end

-- "Active" look for buff cooldowns (Blade Flurry, Adrenaline Rush): a red spark with a
-- fading tail that runs around the icon's border, plus a soft red halo, shown only while
-- the buff is up. The buff can't be read on this client (auras are secret), so its fixed
-- duration is timed locally from the cast.
local SPARK_LAP, SPARK_GAP = 1.6, 4          -- seconds per lap, px between tail sparks
local SPARK_ALPHA = { 1, 0.6, 0.35, 0.18 }   -- head first, then the fading tail
local SPARK_HEADS = 2                        -- comets per icon, evenly spaced round the border

-- Clock-driven pulses: every registered region's alpha follows the same triangle wave
-- off GetTime() (up for half a period, down for the other half -- like an AnimationGroup
-- BOUNCE), so all pulsing effects (both poison icons, the max-CP flash) stay in sync no
-- matter when each one started. Replaces per-texture AnimationGroups.
local PULSE_PERIOD = 1.0                     -- seconds for one full up-and-down
local pulseRegions = {}
local function RegisterPulse(region, lo, hi)
    pulseRegions[#pulseRegions + 1] = { region, lo, hi }
end
local pulseDriver = CreateFrame("Frame")
pulseDriver:SetScript("OnUpdate", function()
    local p = (GetTime() / PULSE_PERIOD) % 1
    local tri = (p < 0.5) and (p * 2) or ((1 - p) * 2)
    for _, e in ipairs(pulseRegions) do
        if e[1]:IsVisible() then e[1]:SetAlpha(e[2] + (e[3] - e[2]) * tri) end
    end
end)
local EDGE_RING_ALPHA = { 1, 0.5, 0.2 }      -- "ring" style: solid edge line, fading outward

-- A countdown number for a BUFF's remaining time, rounded DOWN like the game's own buff
-- timers. The cooldown frame's built-in numbers round UP (4.2s shows "5"), which read a
-- second high next to the buff. Sits on a frame above the cooldown swipe, in the
-- countdown's own font when available. Used for Slice and Dice and the active phase of
-- the buff cooldowns (Blade Flurry, Adrenaline Rush).
local function MakeBuffNumber(o)
    local tf = CreateFrame("Frame", nil, o)
    tf:SetAllPoints(o)
    tf:SetFrameLevel(o.cd:GetFrameLevel() + 2)
    local num = tf:CreateFontString(nil, "OVERLAY")
    local cdText = o.cd.GetCountdownFontString and o.cd:GetCountdownFontString()
    local font, size, flags
    if cdText then font, size, flags = cdText:GetFont() end
    if font then num:SetFont(font, size, flags) else num:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE") end
    num:SetPoint("CENTER", o, "CENTER", 0, 0)
    o.buffText = num
    return num
end

-- Show `rem` seconds (rounded down) on an icon's buff number; the text is only touched
-- when the whole second changes.
local function SetBuffNumber(o, rem)
    local secs = (rem and rem > 0) and math.floor(rem) or nil
    if secs ~= o.shownSecs then
        o.shownSecs = secs
        o.buffText:SetText(secs and tostring(secs) or "")
    end
end

-- Build the border comet + an edge glow on an icon, in the given colour (hidden until
-- SetBorderFX turns it on). Used red for the buff cooldowns, yellow for Slice and Dice.
-- style "halo" (default): the soft action-button proc-glow ring over the icon.
-- style "ring": a crisp 1px line on the icon's edge (over its black border) with two
--   fainter 1px rings outside it -- a clear edge line that softens outward, no tint on
--   the icon itself.
local function AddBorderFX(o, r, g, b, style)
    if style == "ring" then
        o.rings = {}
        for k, a in ipairs(EDGE_RING_ALPHA) do   -- ring k sits k px outside the icon
            local function edge(horiz)
                local t = o:CreateTexture(nil, "OVERLAY", nil, 1)
                t:SetColorTexture(r, g, b, a)
                t:Hide()
                t.horiz = horiz   -- which way it's thin (see PlaceIcon: kept 1 screen px)
                o.rings[#o.rings + 1] = t
                return t
            end
            local top, bottom, left, right = edge(true), edge(true), edge(false), edge(false)
            top:SetPoint("TOPLEFT", o, "TOPLEFT", -k, k)
            top:SetPoint("TOPRIGHT", o, "TOPRIGHT", k, k)
            top:SetHeight(1)
            bottom:SetPoint("BOTTOMLEFT", o, "BOTTOMLEFT", -k, -k)
            bottom:SetPoint("BOTTOMRIGHT", o, "BOTTOMRIGHT", k, -k)
            bottom:SetHeight(1)
            left:SetPoint("TOPLEFT", o, "TOPLEFT", -k, k - 1)       -- between top/bottom rows
            left:SetPoint("BOTTOMLEFT", o, "BOTTOMLEFT", -k, -(k - 1))
            left:SetWidth(1)
            right:SetPoint("TOPRIGHT", o, "TOPRIGHT", k, k - 1)
            right:SetPoint("BOTTOMRIGHT", o, "BOTTOMRIGHT", k, -(k - 1))
            right:SetWidth(1)
        end
    else
        -- Soft halo instead of a hard border: the action-button proc-glow ring, sized in
        -- Blizzard's proportion (62px glow on a 36px button), tinted.
        local halo = o:CreateTexture(nil, "OVERLAY", nil, 1)
        halo:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        halo:SetBlendMode("ADD")
        halo:SetVertexColor(r, g, b)
        halo:SetPoint("CENTER")
        halo:SetSize(ICON_SIZE * 1.72, ICON_SIZE * 1.72)
        halo:Hide()
        o.halo = halo
    end
    -- SPARK_HEADS comets, each a head plus its fading tail.
    o.sparks = {}
    for h = 0, SPARK_HEADS - 1 do
        for i, a in ipairs(SPARK_ALPHA) do
            local s = o:CreateTexture(nil, "OVERLAY", nil, 3)
            s:SetTexture("Interface\\Cooldown\\star4")
            s:SetBlendMode("ADD")
            s:SetVertexColor(r, g, b)
            s:SetAlpha(a)
            s:SetSize(14, 14)
            s:Hide()
            s.head, s.tail = h, i - 1
            o.sparks[#o.sparks + 1] = s
        end
    end
end

local function AddActiveFX(o, activeDur)
    o.activeDur = activeDur
    AddBorderFX(o, 1, 0.2, 0.1)   -- red
    MakeBuffNumber(o):Hide()      -- shown only during the active phase
end

-- OnUpdate while active: place each comet head (spaced evenly round the border) and its
-- tail (SPARK_GAP px behind per step) on the icon's perimeter, clockwise from top-left.
-- The lap position comes from the shared game clock (not per-icon start times), so every
-- icon's comets stay in sync no matter when each effect turned on.
local function PlaceSparks(o)
    local S = o:GetWidth()
    local P = 4 * S
    local head = (GetTime() / SPARK_LAP % 1) * P
    for _, s in ipairs(o.sparks) do
        local d = (head + s.head * P / SPARK_HEADS - s.tail * SPARK_GAP) % P
        local x, y
        if d < S then          x, y = d, 0                   -- top edge, left -> right
        elseif d < 2 * S then  x, y = S, d - S               -- right edge, downward
        elseif d < 3 * S then  x, y = 3 * S - d, S           -- bottom edge, right -> left
        else                   x, y = 0, 4 * S - d           -- left edge, upward
        end
        s:ClearAllPoints()
        s:SetPoint("CENTER", o, "TOPLEFT", x, -y)
    end
end

-- Show/hide the comet + halo (visuals only; the caller drives PlaceSparks each frame).
local function SetBorderFX(o, on)
    if not o.sparks then return end
    o.fxOn = on
    if o.halo then o.halo:SetShown(on) end
    if o.rings then for _, t in ipairs(o.rings) do t:SetShown(on) end end
    for _, s in ipairs(o.sparks) do s:SetShown(on) end
end

-- Per-frame while a buff cooldown is active: move the comets and tick the buff number.
local function ActiveOnUpdate(o)
    PlaceSparks(o)
    SetBuffNumber(o, o.activeUntil and (o.activeUntil - GetTime()))
end

local function SetActiveFX(o, on)
    if not o.sparks then return end
    SetBorderFX(o, on)
    o:SetScript("OnUpdate", on and ActiveOnUpdate or nil)
    -- The buff's countdown is our own rounded-down number (matches the buff timer); the
    -- built-in cooldown numbers come back for the cooldown phase (they match the bars).
    o.cd:SetHideCountdownNumbers(on and true or false)
    if o.buffText then
        o.shownSecs = nil
        o.buffText:SetText("")
        o.buffText:SetShown(on and true or false)
    end
    -- The active phase shows only the buff's countdown number: no swipe, edge, or bling
    -- (the finish bling would otherwise fire when the buff ends, mid-cooldown).
    o.cd:SetDrawSwipe(not on)
    o.cd:SetDrawEdge(not on)
    if o.cd.SetDrawBling then o.cd:SetDrawBling(not on) end
end

-- Start the active phase: red comets + a countdown of the buff's duration. When it ends,
-- the icon's OnCooldownDone (see BuildUI) switches to the ability's remaining cooldown,
-- read from the spell.
local function StartActive(o, castID)
    o.running = true
    o.phase = "active"
    o.castID = castID
    o.activeUntil = GetTime() + o.activeDur
    SetActiveFX(o, true)
    o.cd:SetCooldown(GetTime(), o.activeDur)
end

-- True if the player knows any rank of this icon's ability (so we only show learned
-- skills). IsSpellKnown/IsPlayerSpell are both tried since neither is fully reliable.
local function IconKnown(o)
    if o.available then return o.available() end   -- custom check (e.g. poisons)
    if not o.ids then return true end
    for _, id in ipairs(o.ids) do
        if (IsSpellKnown and IsSpellKnown(id)) or (IsPlayerSpell and IsPlayerSpell(id)) then
            return true
        end
    end
    return false
end

-- User's show/hide preference for an icon (default shown). Independent of "known".
local function IsEnabled(o)
    local e = RogueResourcesDB.iconEnabled
    return not (e and e[o.key] == false)
end

-- The default left-to-right icon order (by key). The user can reorder via /rr options;
-- the chosen order is saved and reconciled against the real icon set on load.
local DEFAULT_ORDER = {
    "snd", "evasion", "vanish", "kick", "shank", "sprint", "bladeflurry", "adrenaline", "blind", "kidney", "gouge",
    "coldblood", "ghostlystrike", "premeditation", "preparation",
    -- Racials (only your own race's exist; see RACIALS)
    "willtosurvive", "perception", "stoneform", "eluneslight", "escapeartist",
    "eureka", "bloodfury", "shattercurse", "willforsaken", "berserking", "rapidregen",
}

-- Make RogueResourcesDB.iconOrder a clean list of every existing icon key: kept in the
-- saved order, dropping stale keys and appending any new abilities (in default order).
local function ReconcileOrder(f)
    if type(RogueResourcesDB.iconEnabled) ~= "table" then RogueResourcesDB.iconEnabled = {} end
    if type(RogueResourcesDB.poisonChoice) ~= "table" then RogueResourcesDB.poisonChoice = {} end
    if type(RogueResourcesDB.stoneChoice) ~= "table" then RogueResourcesDB.stoneChoice = {} end
    local saved = type(RogueResourcesDB.iconOrder) == "table" and RogueResourcesDB.iconOrder or {}
    local seen, clean = {}, {}
    for _, key in ipairs(saved) do
        if f.iconByKey[key] and not seen[key] then clean[#clean + 1] = key; seen[key] = true end
    end
    for _, key in ipairs(DEFAULT_ORDER) do
        if f.iconByKey[key] and not seen[key] then clean[#clean + 1] = key; seen[key] = true end
    end
    for _, o in ipairs(f.icons) do   -- anything else (custom spells / items) at the end
        if not seen[o.key] then clean[#clean + 1] = o.key; seen[o.key] = true end
    end
    RogueResourcesDB.iconOrder = clean
end

-- ---------------------------------------------------------------------------
-- Cooldown layout. With no saved layout the icons use the "Classic" look: one size,
-- wrapped under the bars in iconOrder (iconEnabled hides). Once the layout editor is
-- used, RogueResourcesDB.layout holds rows of slots instead:
--   layout = { rows = { { slots = 4, keys = { "snd", "kick", false, ... } }, ... },
--              hidden = { keys... }, spacing = "normal", keepEmpty = false,
--              above = false }
-- Each row's icon size is chosen so a full row exactly spans the bar width. Icons are
-- always BUILT at ICON_SIZE and just scaled, so their swipe, numbers and effects all
-- resize together.
-- ---------------------------------------------------------------------------
local MAX_ROWS, SLOTS_MIN, SLOTS_MAX = 4, 4, 10
local SPACING = { tight = 2, normal = ICON_GAP, wide = 8 }

local function LayGap(lay) return SPACING[lay.spacing] or ICON_GAP end
local function RowSize(row, gap) return (BAR_W - (row.slots - 1) * gap) / row.slots end

local function NewRow(slots)
    local row = { slots = slots, keys = {} }
    for s = 1, slots do row.keys[s] = false end
    return row
end

-- Where a key is: row index + slot, or "hidden" + its index in the tray.
local function FindKey(lay, key)
    for r, row in ipairs(lay.rows) do
        for s = 1, row.slots do
            if row.keys[s] == key then return r, s end
        end
    end
    for i, k in ipairs(lay.hidden) do
        if k == key then return "hidden", i end
    end
end

-- Put a key in the first empty slot from row `from` onward. If every row is full, add a
-- row the size of the last one; with all rows in use, widen the last row by a slot. Only
-- when that's not allowed (noGrow, or the last row is already at its widest) is it hidden.
-- (A `from` past the last row never widens it: shrinking that row mustn't grow it back.)
local function PlaceKey(lay, key, from, noGrow)
    from = from or 1
    for r = from, #lay.rows do
        local row = lay.rows[r]
        for s = 1, row.slots do
            if not row.keys[s] then row.keys[s] = key; return end
        end
    end
    local last = lay.rows[#lay.rows]
    if not noGrow and #lay.rows < MAX_ROWS then
        local row = NewRow(last and last.slots or 7)
        row.keys[1] = key
        lay.rows[#lay.rows + 1] = row
    elseif not noGrow and last and from <= #lay.rows and last.slots < SLOTS_MAX then
        last.slots = last.slots + 1
        last.keys[last.slots] = key
    else
        lay.hidden[#lay.hidden + 1] = key
    end
end

-- The Classic look expressed as rows (as many per row as fit at the classic size, more
-- when there are too many icons for four such rows), so the editor can start from what's
-- on screen without pushing anything into Hidden.
local function ClassicLayout()
    local enabled = RogueResourcesDB.iconEnabled or {}
    local shown = 0
    for _, key in ipairs(RogueResourcesDB.iconOrder) do
        if enabled[key] ~= false then shown = shown + 1 end
    end
    local perRow = math.max(1, math.floor((BAR_W + ICON_GAP) / (ICON_SIZE + ICON_GAP)))
    perRow = math.min(SLOTS_MAX, math.max(perRow, math.ceil(shown / MAX_ROWS)))
    local lay = { rows = { NewRow(perRow) }, hidden = {}, spacing = "normal",
                  keepEmpty = false, above = false }
    for _, key in ipairs(RogueResourcesDB.iconOrder) do
        if enabled[key] == false then
            lay.hidden[#lay.hidden + 1] = key
        else
            PlaceKey(lay, key)
        end
    end
    return lay
end

-- Make the saved layout consistent with the icons that exist: drop unknown keys, keep
-- every row's slot list the right length, and put new abilities at the end of the last
-- row (wrapping onto a new row when it's full).
local function ReconcileLayout(f)
    local lay = RogueResourcesDB.layout
    if type(lay) ~= "table" then RogueResourcesDB.layout = nil return end
    lay.rows = type(lay.rows) == "table" and lay.rows or {}
    lay.hidden = type(lay.hidden) == "table" and lay.hidden or {}
    local seen = {}
    for _, row in ipairs(lay.rows) do
        row.slots = math.max(SLOTS_MIN, math.min(SLOTS_MAX, tonumber(row.slots) or 7))
        row.keys = type(row.keys) == "table" and row.keys or {}
        for s = 1, row.slots do
            local k = row.keys[s]
            if not (k and f.iconByKey[k]) or seen[k] then row.keys[s] = false else seen[k] = true end
        end
        for s = #row.keys, row.slots + 1, -1 do row.keys[s] = nil end
    end
    local hidden = {}
    for _, k in ipairs(lay.hidden) do
        if f.iconByKey[k] and not seen[k] then hidden[#hidden + 1] = k; seen[k] = true end
    end
    lay.hidden = hidden
    if #lay.rows == 0 then lay.rows[1] = NewRow(5) end
    for _, key in ipairs(RogueResourcesDB.iconOrder) do
        if not seen[key] then PlaceKey(lay, key, #lay.rows) end
    end
end

-- Place one icon at (x, y) in the anchor's coordinates, at the given size. Offsets are
-- in the icon's own (scaled) units, hence the division.
local function PlaceIcon(o, anchor, point, x, y, size)
    local scale = size / ICON_SIZE
    o:SetScale(scale)
    o:ClearAllPoints()
    o:SetPoint("TOPLEFT", anchor, point, x / scale, y / scale)
    -- Edge-line rings (Slice and Dice's warning) are 1px lines that would scale with the
    -- icon and turn sub-pixel (flickering) on small icons: keep them one screen pixel.
    if o.rings then
        for _, t in ipairs(o.rings) do
            if t.horiz then t:SetHeight(1 / scale) else t:SetWidth(1 / scale) end
        end
    end
    -- A custom item you've run out of stays on the bar, greyed out.
    o.icon:SetDesaturated((o.itemID and not IconKnown(o)) and true or false)
    if o.UpdateCount then o:UpdateCount() end   -- custom stackable items: how many are left
    o:Show()
end

-- Whether an icon belongs on the bar: learned abilities, and custom items always (greyed
-- out while you have none), or everything with "Preview unlearned skills" on.
local function OnBar(o)
    return RR.showAll or o.itemID ~= nil or IconKnown(o)
end

-- Show the known icons in their layout under (or above) the bars. Re-run on spell,
-- layout and option changes.
local function LayoutIcons(f)
    for _, o in ipairs(f.icons) do o:Hide() end
    if RogueResourcesDB.cooldownsHidden then return end
    local lay = RogueResourcesDB.layout

    if not lay then
        -- Classic: known + enabled icons in iconOrder, wrapped and centered under the bars.
        local visible = {}
        for _, key in ipairs(RogueResourcesDB.iconOrder) do
            local o = f.iconByKey[key]
            if o and OnBar(o) and IsEnabled(o) then visible[#visible + 1] = o end
        end
        local perRow = math.max(1, math.floor((BAR_W + ICON_GAP) / (ICON_SIZE + ICON_GAP)))
        for i, o in ipairs(visible) do
            local row = math.floor((i - 1) / perRow)
            local col = (i - 1) % perRow
            local rowCount = math.min(perRow, #visible - row * perRow)   -- icons in this row
            local rowW = rowCount * ICON_SIZE + (rowCount - 1) * ICON_GAP
            local x0 = (BAR_W - rowW) / 2
            PlaceIcon(o, f, "BOTTOMLEFT", x0 + col * (ICON_SIZE + ICON_GAP),
                -GAP - row * (ICON_SIZE + ICON_GAP), ICON_SIZE)
        end
        return
    end

    -- Rows of slots: collect each row's known icons; rows with none take no space.
    local gap = LayGap(lay)
    local rows = {}
    for _, row in ipairs(lay.rows) do
        local cells = {}
        for s = 1, row.slots do
            local o = row.keys[s] and f.iconByKey[row.keys[s]]
            if o and OnBar(o) then cells[#cells + 1] = { o = o, slot = s } end
        end
        if #cells > 0 then rows[#rows + 1] = { size = RowSize(row, gap), slots = row.slots, cells = cells } end
    end

    -- Below the bars: hang from the frame's bottom edge. Above: sit on the topmost shown
    -- bar (so hidden bars leave no gap), first row on top.
    local anchor, point, y = f, "BOTTOMLEFT", -GAP
    if lay.above then
        anchor, point, y = f.topBar or f, "TOPLEFT", GAP - gap
        for _, r in ipairs(rows) do y = y + r.size + gap end
    end
    for _, r in ipairs(rows) do
        local n = #r.cells
        local rowW = n * r.size + (n - 1) * gap
        for i, c in ipairs(r.cells) do
            -- Keep empty slots: every icon stays in its own slot. Otherwise the row's
            -- icons are packed together and centered.
            local x = lay.keepEmpty and (c.slot - 1) * (r.size + gap)
                or (BAR_W - rowW) / 2 + (i - 1) * (r.size + gap)
            PlaceIcon(c.o, anchor, point, x, y, r.size)
        end
        y = y - r.size - gap
    end
end

-- ---------------------------------------------------------------------------
-- Options: a canvas panel registered under Options -> AddOns (the built-in
-- Settings UI). Holds a UI-scale slider and the drag-to-reorder / show-hide
-- ability list. Built once at login so it always appears in the AddOns list.
-- ---------------------------------------------------------------------------
local OPT_W = 340
local SCALE_MIN, SCALE_MAX, SCALE_STEP = 0.5, 2.0, 0.05

-- Improved Slice and Dice: each talent rank adds 15% duration (max 45% at rank 3). The
-- rank is read straight off the talent (see DetectSndRank); /rr sndmult sets a fallback
-- multiplier used only if the talent can't be read.
local SND_MULT_PER_RANK = 0.15
local function MultText(v) return string.format("x%.2f", v or 1) end

-- Read the Improved Slice and Dice talent rank. Returns rank (0 = not taken) or nil when
-- no talent API could be read. Everything is pcall-guarded.
-- This client uses the retail trait system (C_ClassTalents / C_Traits): the talent is ONE
-- spell (14165) at every rank, and the rank lives on its talent-tree node. We read the
-- node's rank, finding the node by its spell (the known node ID is just a fast first try).
local IMP_SND_RANK_IDS = { 14165, 14166, 14167 }   -- Improved Slice and Dice ranks 1-3
local IMP_SND_SPELL    = 14165
local impSndNodeID     = 105739                    -- found on this client; re-scanned if wrong

local function NodeRank(info)
    if type(info) ~= "table" then return nil end
    return info.activeRank or info.ranksPurchased or info.currentRank
end

-- Does this trait node's entry grant the given spell?
local function NodeHasSpell(configID, info, spellID)
    if type(info) ~= "table" or type(info.entryIDs) ~= "table" then return false end
    for _, entryID in ipairs(info.entryIDs) do
        local entry = C_Traits.GetEntryInfo(configID, entryID)
        local def = entry and entry.definitionID and C_Traits.GetDefinitionInfo(entry.definitionID)
        if def and def.spellID == spellID then return true end
    end
    return false
end

-- Rank of Improved Slice and Dice from the trait tree, or nil if that API isn't usable.
local function TraitSndRank()
    if not (C_ClassTalents and C_ClassTalents.GetActiveConfigID and C_Traits
            and C_Traits.GetNodeInfo and C_Traits.GetConfigInfo and C_Traits.GetTreeNodes) then
        return nil
    end
    local ok, rank = pcall(function()
        local configID = C_ClassTalents.GetActiveConfigID()
        if not configID then return nil end
        -- Fast path: the known node, checked to really be this talent.
        local info = C_Traits.GetNodeInfo(configID, impSndNodeID)
        if NodeHasSpell(configID, info, IMP_SND_SPELL) then return NodeRank(info) end
        -- Otherwise search every node of the class tree for the talent's spell.
        local config = C_Traits.GetConfigInfo(configID)
        for _, treeID in ipairs(config and config.treeIDs or {}) do
            for _, nodeID in ipairs(C_Traits.GetTreeNodes(treeID) or {}) do
                info = C_Traits.GetNodeInfo(configID, nodeID)
                if NodeHasSpell(configID, info, IMP_SND_SPELL) then
                    impSndNodeID = nodeID
                    return NodeRank(info)
                end
            end
        end
        return nil
    end)
    return ok and rank or nil
end

local function DetectSndRank()
    local traitRank = TraitSndRank()
    if traitRank then return traitRank end
    -- Classic-style fallbacks: rank spells, then the old talent tables (matched by the
    -- talent's name containing the ability name, or by sharing its icon).
    for rank = #IMP_SND_RANK_IDS, 1, -1 do
        local id = IMP_SND_RANK_IDS[rank]
        if (IsPlayerSpell and IsPlayerSpell(id)) or (IsSpellKnown and IsSpellKnown(id)) then
            return rank
        end
    end
    if type(GetNumTalentTabs) ~= "function" or type(GetTalentInfo) ~= "function" then return nil end
    local sndName = SpellName(5171)
    local sndTex  = SpellTex(5171)
    local numTabs = GetNumTalentTabs() or 0
    for tab = 1, numTabs do
        local numT = (type(GetNumTalents) == "function" and GetNumTalents(tab)) or 0
        for i = 1, numT do
            local ok, name, icon, _, _, rank = pcall(GetTalentInfo, tab, i)
            if ok and name then
                local iconStr = (type(icon) == "string") and icon:lower() or nil
                local match =
                    (sndName and name ~= sndName and name:find(sndName, 1, true) ~= nil) or
                    (iconStr and iconStr:find("slicedice", 1, true) ~= nil) or
                    (type(icon) == "number" and sndTex and icon == sndTex)
                if match then return rank or 0 end
            end
        end
    end
    return nil
end

-- Cache the detected multiplier on RR (recomputed at login and on talent changes).
local function UpdateAutoSndMult()
    local rank = DetectSndRank()
    RR.autoSndMult = rank and (1 + SND_MULT_PER_RANK * rank) or nil
end

-- The multiplier applied to a Slice and Dice cast: the detected one, else the fallback.
local function EffectiveSndMult()
    return RR.autoSndMult or RogueResourcesDB.sndMult or 1
end

-- Forward declarations: these are defined later in the file but referenced by the
-- options controls above them (the Lock/Reset buttons and the drag-reorder callbacks).
local CRFRogue_RefreshOptions, CRFRogue_SetLocked, CRFRogue_ApplyPosition, CRFRogue_ApplyPoisonPosition, CRFRogue_SetCooldownSwipe, CRFRogue_ToggleLayoutEditor
local CRFRogue_ApplyBarVisibility, CRFRogue_UpdateCombatVisibility, CRFRogue_UpdatePoisons, CRFRogue_UpdateHealth, CRFRogue_PlaceRiposte, CRFRogue_UpdateWellFed

-- The stacked bars (health is optional and off by default). BarOrder returns the saved
-- top-to-bottom order, repaired so every bar appears exactly once.
local BAR_LABEL = { cp = L.barCP, energy = L.barEnergy, health = L.barHealth }
local function BarOrder()
    local order, seen = {}, {}
    for _, k in ipairs(RogueResourcesDB.barOrder or {}) do
        if BAR_LABEL[k] and not seen[k] then seen[k] = true; order[#order + 1] = k end
    end
    for _, k in ipairs(RR.defaults.barOrder) do
        if not seen[k] then seen[k] = true; order[#order + 1] = k end
    end
    RogueResourcesDB.barOrder = order
    return order
end

local function BarShown(k)
    if k == "health" then return RogueResourcesDB.healthShown and true or false end
    if k == "energy" then return not RogueResourcesDB.energyHidden end
    return not RogueResourcesDB.cpHidden
end

-- Move bar `key` to position `to` in the order (the others shift to make room).
local function MoveBarTo(f, key, to)
    local order = BarOrder()
    for i, k in ipairs(order) do
        if k == key then
            if i == to then return end
            table.remove(order, i)
            break
        end
    end
    table.insert(order, to, key)
    CRFRogue_ApplyBarVisibility(f)
    CRFRogue_RefreshOptions(f)
end

-- Apply the saved UI scale to the bars and the (separate) poison frame together.
local function ApplyScale(f)
    local s = RogueResourcesDB.scale or 1.0
    f:SetScale(s)
    if f.poisonFrame then f.poisonFrame:SetScale(s) end
    if f.ripFrame then f.ripFrame:SetScale(s) end
end

-- Reset the bars and poison frame to their default positions (fresh copies so the saved
-- tables never alias RR.defaults), then re-anchor both. The Riposte proc spot goes back
-- above the bars.
local function ResetPositions(f)
    local dp, dpp = RR.defaults.position, RR.defaults.poisonPos
    RogueResourcesDB.position  = { point = dp.point,  relativePoint = dp.relativePoint,  x = dp.x,  y = dp.y }
    RogueResourcesDB.poisonPos = { point = dpp.point, relativePoint = dpp.relativePoint, x = dpp.x, y = dpp.y }
    RogueResourcesDB.ripPos = nil
    CRFRogue_ApplyPosition(f)
    CRFRogue_ApplyPoisonPosition(f)
    CRFRogue_PlaceRiposte(f)
    print("|cff00ff88RogueResources:|r positions reset to default.")
end

-- Show/hide poison icons from the options checkbox. Toggling visibility of a frame that
-- parents secure buttons is blocked in combat, so guard and revert the check if locked.
local function TogglePoisonFromOptions(f, check)
    if InCombatLockdown and InCombatLockdown() then
        print("|cff00ff88RogueResources:|r can't toggle poison icons in combat.")
        check:SetChecked(not RogueResourcesDB.poisonHidden)   -- revert to the real state
        return
    end
    RogueResourcesDB.poisonHidden = not check:GetChecked()
    if f.poisonFrame then f.poisonFrame:SetShown(PoisonsAvailable() and not RogueResourcesDB.poisonHidden) end
end

-- Build the shared options body (scale, toggles, buttons) into `body`.
-- Registers a "view" so CRFRogue_RefreshOptions can keep every open copy (the floating window
-- AND the Settings page) in sync. Returns the body height.
local function PopulateOptions(f, body)
    local view = {}
    local y = -4   -- vertical cursor (from body top); advanced as each control is placed

    -- Scale slider.
    local scaleLabel = body:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scaleLabel:SetPoint("TOPLEFT", 0, y); scaleLabel:SetText(L.scale)
    y = y - 20

    local slider = CreateFrame("Slider", nil, body, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 6, y)
    slider:SetWidth(240)
    slider:SetMinMaxValues(SCALE_MIN, SCALE_MAX)
    slider:SetValueStep(SCALE_STEP)
    slider:SetObeyStepOnDrag(true)
    if slider.Low  then slider.Low:SetText(math.floor(SCALE_MIN * 100) .. "%") end
    if slider.High then slider.High:SetText(math.floor(SCALE_MAX * 100) .. "%") end
    if slider.Text then slider.Text:SetText("") end
    local scaleVal = body:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    scaleVal:SetPoint("LEFT", slider, "RIGHT", 12, 0)
    slider:SetScript("OnValueChanged", function(_, value)
        if f._syncing then return end               -- ignore programmatic sync SetValue
        value = math.floor(value / SCALE_STEP + 0.5) * SCALE_STEP
        RogueResourcesDB.scale = value
        ApplyScale(f)
        CRFRogue_RefreshOptions(f)                            -- update value text + the other view
    end)
    view.slider, view.scaleVal = slider, scaleVal
    y = y - 40

    -- Riposte icon size (on top of the scale above).
    local RIP_SIZE_MIN, RIP_SIZE_MAX, RIP_SIZE_STEP = 1.0, 3.0, 0.1
    local ripLabel = body:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ripLabel:SetPoint("TOPLEFT", 0, y); ripLabel:SetText(L.ripSize:format(SpellName(14251) or "Riposte"))
    y = y - 20
    local ripSlider = CreateFrame("Slider", nil, body, "OptionsSliderTemplate")
    ripSlider:SetPoint("TOPLEFT", 6, y)
    ripSlider:SetWidth(240)
    ripSlider:SetMinMaxValues(RIP_SIZE_MIN, RIP_SIZE_MAX)
    ripSlider:SetValueStep(RIP_SIZE_STEP)
    ripSlider:SetObeyStepOnDrag(true)
    if ripSlider.Low  then ripSlider.Low:SetText(math.floor(RIP_SIZE_MIN * 100) .. "%") end
    if ripSlider.High then ripSlider.High:SetText(math.floor(RIP_SIZE_MAX * 100) .. "%") end
    if ripSlider.Text then ripSlider.Text:SetText("") end
    local ripVal = body:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    ripVal:SetPoint("LEFT", ripSlider, "RIGHT", 12, 0)
    ripSlider:SetScript("OnValueChanged", function(_, value)
        if f._syncing then return end
        RogueResourcesDB.ripSize = math.floor(value / RIP_SIZE_STEP + 0.5) * RIP_SIZE_STEP
        RR.SizeRiposte(f)
        RR.ripPreviewUntil = GetTime() + 3   -- show the icon while you're sizing it, even when locked
        CRFRogue_RefreshOptions(f)
    end)
    view.ripSlider, view.ripVal = ripSlider, ripVal
    y = y - 40

    -- A labelled checkbox at the cursor; `onClick` runs on toggle, then every options view
    -- is re-synced (the floating window and the Settings page share these settings).
    local function AddCheck(text, onClick)
        local c = CreateFrame("CheckButton", nil, body, "UICheckButtonTemplate")
        c:SetPoint("TOPLEFT", -2, y); c:SetSize(26, 26)
        local t = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        t:SetPoint("LEFT", c, "RIGHT", 2, 0); t:SetText(text)
        c:SetScript("OnClick", function(self) onClick(self); CRFRogue_RefreshOptions(f) end)
        y = y - 30
        return c
    end

    -- Show the energy / combo-point bars.
    view.energyCheck = AddCheck(L.showEnergy, function(self)
        RogueResourcesDB.energyHidden = not self:GetChecked()
        CRFRogue_ApplyBarVisibility(f)
    end)
    view.cpCheck = AddCheck(L.showCP, function(self)
        RogueResourcesDB.cpHidden = not self:GetChecked()
        CRFRogue_ApplyBarVisibility(f)
    end)
    view.healthCheck = AddCheck(L.showHealth, function(self)
        RogueResourcesDB.healthShown = self:GetChecked() and true or false
        CRFRogue_ApplyBarVisibility(f)
        CRFRogue_UpdateHealth(f)
    end)
    view.cooldownsCheck = AddCheck(L.showCooldowns, function(self)
        RogueResourcesDB.cooldownsHidden = not self:GetChecked()
        LayoutIcons(f)
    end)

    -- Bar order: press a row and move the mouse up or down; the bar swaps places with
    -- each row it passes over (the list and the bars on screen update as you go).
    -- Labels are filled in CRFRogue_RefreshOptions.
    local orderLabel = body:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    orderLabel:SetPoint("TOPLEFT", 0, y - 4); orderLabel:SetText(L.barOrder)
    local orderHint = body:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    orderHint:SetPoint("LEFT", orderLabel, "RIGHT", 8, 0); orderHint:SetText(L.barOrderHint)
    y = y - 24
    view.orderRows = {}
    local rows = view.orderRows

    -- Which row the cursor is over (clamped to the first/last row).
    local function RowUnderCursor()
        local cy = select(2, GetCursorPosition()) / body:GetEffectiveScale()
        for i, r in ipairs(rows) do
            if cy >= (r:GetBottom() or 0) then return i end
        end
        return #rows
    end

    local dragKey
    local function EndDrag()
        body:SetScript("OnUpdate", nil)
        dragKey = nil
    end

    for i = 1, #RR.defaults.barOrder do
        local row = CreateFrame("Button", nil, body)
        row:SetPoint("TOPLEFT", 4, y); row:SetSize(220, 22)
        local bg = row:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(1, 1, 1, 0.05)
        row:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
        row:GetHighlightTexture():SetAlpha(0.35)
        for g = 0, 2 do   -- three short lines on the left, the usual "drag me" handle
            local line = row:CreateTexture(nil, "ARTWORK")
            line:SetColorTexture(0.8, 0.8, 0.8, 0.6)
            line:SetSize(10, 1)
            line:SetPoint("LEFT", 6, 3 - g * 3)
        end
        row.label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        row.label:SetPoint("LEFT", 24, 0)
        -- Track from the press itself (no drag threshold), so rows swap the moment the
        -- cursor crosses into the next one.
        row:SetScript("OnMouseDown", function()
            dragKey = BarOrder()[i]
            body:SetScript("OnUpdate", function()
                if not IsMouseButtonDown("LeftButton") then EndDrag() return end
                MoveBarTo(f, dragKey, RowUnderCursor())
            end)
        end)
        row:SetScript("OnMouseUp", EndDrag)
        rows[i] = row
        y = y - 24
    end
    y = y - 6

    -- Show poison icons.
    local poisonCheck = CreateFrame("CheckButton", nil, body, "UICheckButtonTemplate")
    poisonCheck:SetPoint("TOPLEFT", -2, y); poisonCheck:SetSize(26, 26)
    local pcl = poisonCheck:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    pcl:SetPoint("LEFT", poisonCheck, "RIGHT", 2, 0); pcl:SetText(L.showPoison)
    poisonCheck:SetScript("OnClick", function(self) TogglePoisonFromOptions(f, self) end)
    view.poisonCheck = poisonCheck
    y = y - 30

    -- Show the bars + icons only while in combat (poison icons unaffected).
    view.combatCheck = AddCheck(L.combatOnly, function(self)
        RogueResourcesDB.combatOnly = self:GetChecked() and true or false
        CRFRogue_UpdateCombatVisibility(f)
    end)

    -- Warn at the top of the screen when the Well Fed food buff is missing.
    view.wellFedCheck = AddCheck(L.warnWellFed, function(self)
        RogueResourcesDB.wellFedWarn = self:GetChecked() and true or false
        CRFRogue_UpdateWellFed(f)
    end)

    -- Lock / Reset positions.
    local lockBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
    lockBtn:SetPoint("TOPLEFT", 2, y); lockBtn:SetSize(110, 22)
    lockBtn:SetScript("OnClick", function()
        CRFRogue_SetLocked(f, not RogueResourcesDB.locked)
        CRFRogue_RefreshOptions(f)
    end)
    view.lockBtn = lockBtn
    local resetBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
    resetBtn:SetPoint("LEFT", lockBtn, "RIGHT", 8, 0); resetBtn:SetSize(130, 22)
    resetBtn:SetText(L.resetPositions)
    resetBtn:SetScript("OnClick", function() ResetPositions(f) end)
    y = y - 36

    -- Open the cooldown layout editor.
    local arrangeBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
    arrangeBtn:SetPoint("TOPLEFT", 2, y); arrangeBtn:SetSize(248, 22)
    arrangeBtn:SetText(L.arrangeBtn)
    arrangeBtn:SetScript("OnClick", function() CRFRogue_ToggleLayoutEditor(f) end)
    y = y - 26

    f.optionViews = f.optionViews or {}
    f.optionViews[#f.optionViews + 1] = view

    local bodyH = -y + 8
    body:SetSize(OPT_W, bodyH)
    return bodyH, view
end

-- The embedded copy under Options -> AddOns (built at login so it always appears).
local function BuildSettingsPanel(f)
    if f.settingsPanel then return f.settingsPanel end
    local panel = CreateFrame("Frame", nil, UIParent)
    panel.name = "Class Resources Forever - Rogue"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Class Resources Forever - Rogue")

    local sub = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    sub:SetPoint("RIGHT", panel, "RIGHT", -24, 0)
    sub:SetJustifyH("LEFT")
    sub:SetText(L.panelDesc)

    local body = CreateFrame("Frame", nil, panel)
    body:SetPoint("TOPLEFT", sub, "BOTTOMLEFT", 0, -22)
    PopulateOptions(f, body)

    -- Refresh the rows/slider each time the page is shown (Blizzard opens it, not us).
    panel:SetScript("OnShow", function() CRFRogue_RefreshOptions(f) end)

    -- Register under Options -> AddOns. Prefer the modern Settings API; fall back to the
    -- legacy InterfaceOptions registration on older API surfaces.
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, "Class Resources Forever - Rogue")
        Settings.RegisterAddOnCategory(category)
        RR.settingsCategory = category
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end

    f.settingsPanel = panel
    CRFRogue_RefreshOptions(f)   -- populate the just-built rows
    return panel
end

-- A movable Blizzard-style window: title bar, close button, framed edges and a darker
-- inset for the content. If this client lacks the template, fall back to the classic
-- dialog-box border. Named so ESC closes it. Returns the window, the content's top
-- offset, and the extra height the frame adds around its content.
local function CreateWindow(name, titleText)
    local ok, win = pcall(CreateFrame, "Frame", name, UIParent, "BasicFrameTemplateWithInset")
    -- Some clients create the frame without the template instead of erroring, so check
    -- that the template's pieces actually exist.
    local templated = ok and win and (win.TitleBg or win.CloseButton) and true or false
    if not templated then
        if ok and win then win:Hide() end   -- discard the bare frame
        win = CreateFrame("Frame", name, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
        if win.SetBackdrop then
            win:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = true, tileSize = 32, edgeSize = 32,
                insets = { left = 11, right = 12, top = 12, bottom = 11 },
            })
        end
        local close = CreateFrame("Button", nil, win, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", -4, -4)
    end
    win:SetFrameStrata("DIALOG")
    win:SetMovable(true); win:EnableMouse(true)
    win:SetClampedToScreen(true)
    -- Moved only by its title bar, so dragging things inside the window (or just missing
    -- them) never drags the whole window.
    local handle = CreateFrame("Frame", nil, win)
    handle:SetPoint("TOPLEFT", 0, 0)
    handle:SetPoint("TOPRIGHT", -28, 0)   -- leave the close button clickable
    handle:SetHeight(templated and 24 or 32)
    handle:EnableMouse(true)
    handle:RegisterForDrag("LeftButton")
    -- win.OnMoved (optional): called every frame while the window is dragged, so windows
    -- docked to it can follow / switch sides live.
    handle:SetScript("OnDragStart", function()
        win:StartMoving()
        if win.OnMoved then handle:SetScript("OnUpdate", function() win.OnMoved() end) end
    end)
    -- Remember where the window was left (per window, in the saved settings), and open it
    -- there next time; centered until it's first moved.
    function win.SavePos()
        local p, _, rp, x, y = win:GetPoint()
        if not p then return end
        RogueResourcesDB.windowPos = RogueResourcesDB.windowPos or {}
        RogueResourcesDB.windowPos[name] = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 }
    end
    handle:SetScript("OnDragStop", function()
        win:StopMovingOrSizing()
        handle:SetScript("OnUpdate", nil)
        if win.OnMoved then win.OnMoved() end
        -- We save the position ourselves; stop the client also caching it for this named
        -- frame, which could fight ours on login.
        if win.SetUserPlaced then win:SetUserPlaced(false) end
        win.SavePos()
    end)
    local saved = RogueResourcesDB.windowPos and RogueResourcesDB.windowPos[name]
    if saved then
        win:SetPoint(saved.point, UIParent, saved.relativePoint, saved.x, saved.y)
    else
        win:SetPoint("CENTER")
    end
    -- ESC closes it. Handled here rather than via UISpecialFrames: opening some game panels
    -- (the spellbook, for one) closes every window on that list, and the layout editor has
    -- to stay open while spells are dragged out of the spellbook. Keys always pass through
    -- to the game except the ESC that closes us. Keyboard pass-through can't be changed in
    -- combat, so there it's left on (ESC then also opens the game menu, as it normally would).
    local function SetupKeys()
        win:EnableKeyboard(true)
        win:SetPropagateKeyboardInput(true)
        win:SetScript("OnKeyDown", function(self, key)
            if InCombatLockdown() then
                -- Pass-through can't be changed in combat: close anyway, and the ESC also
                -- reaches the game (opening its menu, as ESC normally would).
                if key == "ESCAPE" then self:Hide() end
                return
            end
            if key == "ESCAPE" then
                self:SetPropagateKeyboardInput(false)   -- swallow this ESC
                self:Hide()
                C_Timer.After(0, function()
                    if not InCombatLockdown() then self:SetPropagateKeyboardInput(true) end
                end)
            end
        end)
    end
    -- Never take the keyboard without pass-through: if built mid-combat, wait for it to end.
    if InCombatLockdown() then
        local waiter = CreateFrame("Frame")
        waiter:RegisterEvent("PLAYER_REGEN_ENABLED")
        waiter:SetScript("OnEvent", function(self)
            self:UnregisterAllEvents()
            SetupKeys()
        end)
    else
        SetupKeys()
    end

    -- Title: the template's own title bar text when present, else our own heading.
    if templated and win.TitleText then
        win.TitleText:SetText(titleText)
    else
        local title = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, templated and -5 or -16)
        title:SetText(titleText)
    end
    win:Hide()   -- new frames start shown; callers open it themselves
    return win, (templated and -36 or -42), (templated and 50 or 58)
end

-- The standalone, draggable options window that /rr options opens. Shows the same
-- controls as the Settings -> AddOns page (both are kept in sync via CRFRogue_RefreshOptions).
local function BuildOptions(f)
    if f.optWindow then return f.optWindow end
    local opt, top, extraH = CreateWindow("RogueResourcesOptionsFrame", "Class Resources Forever - Rogue")
    local body = CreateFrame("Frame", nil, opt)
    body:SetPoint("TOPLEFT", 18, top)
    local bodyH = PopulateOptions(f, body)
    opt:SetSize(OPT_W + 36, bodyH + extraH)

    opt:SetScript("OnShow", function() CRFRogue_RefreshOptions(f) end)
    opt:Hide()   -- new frames start shown; hide so the first /rr options opens it
    f.optWindow = opt
    return opt
end

-- Refresh EVERY built options view (floating window + Settings page) from saved state:
-- the scale slider/value, buttons and checkboxes. `f._syncing` guards the slider so the
-- programmatic SetValue below doesn't re-fire OnValueChanged.
function CRFRogue_RefreshOptions(f)
    if not f.optionViews then return end
    local s = RogueResourcesDB.scale or 1.0
    f._syncing = true
    for _, view in ipairs(f.optionViews) do
        -- Only push a value that actually differs, so we don't fight the thumb of the
        -- slider currently being dragged (its value already equals s after snapping).
        if view.slider and math.abs((view.slider:GetValue() or 0) - s) > 1e-4 then
            view.slider:SetValue(s)
        end
        if view.scaleVal then view.scaleVal:SetText(math.floor(s * 100 + 0.5) .. "%") end
        local rs = RogueResourcesDB.ripSize or 1
        if view.ripSlider and math.abs((view.ripSlider:GetValue() or 0) - rs) > 1e-4 then
            view.ripSlider:SetValue(rs)
        end
        if view.ripVal then view.ripVal:SetText(math.floor(rs * 100 + 0.5) .. "%") end
        if view.lockBtn then view.lockBtn:SetText(RogueResourcesDB.locked and L.unlock or L.lock) end
        if view.poisonCheck then view.poisonCheck:SetChecked(not RogueResourcesDB.poisonHidden) end
        if view.energyCheck then view.energyCheck:SetChecked(not RogueResourcesDB.energyHidden) end
        if view.cpCheck then view.cpCheck:SetChecked(not RogueResourcesDB.cpHidden) end
        if view.healthCheck then view.healthCheck:SetChecked(RogueResourcesDB.healthShown and true or false) end
        if view.cooldownsCheck then view.cooldownsCheck:SetChecked(not RogueResourcesDB.cooldownsHidden) end
        if view.orderRows then
            local order = BarOrder()
            for i, row in ipairs(view.orderRows) do
                local k = order[i]
                row.label:SetText(i .. ".  " .. BAR_LABEL[k])
                row.label:SetAlpha(BarShown(k) and 1 or 0.45)   -- dim bars that are turned off
            end
        end
        if view.combatCheck then view.combatCheck:SetChecked(RogueResourcesDB.combatOnly and true or false) end
        if view.wellFedCheck then view.wellFedCheck:SetChecked(RogueResourcesDB.wellFedWarn and true or false) end
    end
    f._syncing = false
end

-- /rr options: toggle the standalone floating window.
local function ToggleOptions(f)
    local opt = BuildOptions(f)
    if opt:IsShown() then opt:Hide() else CRFRogue_RefreshOptions(f); opt:Show() end
end

-- The two blocks below (custom tracking, layout editor) keep their helpers private in
-- do ... end scopes: Lua allows only 200 locals per scope, and the file's top level is
-- close to that. Only what the rest of the file needs is exported.
local CRFRogue_WireIconDrag, CRFRogue_WireCooldownDone, CRFRogue_BuildCustomIcons, CRFRogue_ToggleCustomWindow, CRFRogue_RefreshCustomItems
do   -- custom tracking block
-- ---------------------------------------------------------------------------
-- Icon wiring shared by the built-in and custom cooldown icons.
-- ---------------------------------------------------------------------------

-- While unlocked, dragging any icon moves the whole tracker, exactly like dragging the
-- bars -- so it stays movable even with every bar hidden. Reuses the frame's own drag
-- handlers (incl. position save). Icons are arranged in the layout editor instead.
function CRFRogue_WireIconDrag(f, o)
    o:RegisterForDrag("LeftButton")
    o:SetScript("OnDragStart", function()
        if not RogueResourcesDB.locked then
            f.movingViaIcon = true
            f:GetScript("OnDragStart")(f)
        end
    end)
    o:SetScript("OnDragStop", function()
        if f.movingViaIcon then
            f.movingViaIcon = nil
            f:GetScript("OnDragStop")(f)   -- stop moving + save the position
        end
    end)
end

-- When a cooldown icon's swipe ends: a buff's active phase hands over to the real
-- cooldown; a finished cooldown flashes once ("ready").
function CRFRogue_WireCooldownDone(o)
    o.cd:SetScript("OnCooldownDone", function()
        -- Buff cooldowns: the active phase just ended -> drop the red comets and show
        -- the ability's remaining cooldown, with no ready flash yet.
        if o.phase == "active" then
            o.phase = "cd"
            SetActiveFX(o, false)
            CRFRogue_SetCooldownSwipe(o, o.castID)
            return
        end
        -- Flash once when the swipe completes (the ability is ready again).
        o.phase = nil
        o.running = false
        if o.flash then o.flash:Play() end
    end)
end

-- ---------------------------------------------------------------------------
-- Custom spells and items: anything the player drags in from the spellbook or bags.
-- Saved as RogueResourcesDB.custom = { { kind = "spell"|"item", id = N, dur = secs }, ... }
-- Each becomes a normal cooldown icon (key "c:spell:N" / "c:item:N") that the layout
-- editor places like any other. A spell shows once known; an item always shows, greyed
-- out while you have none in your bags or equipped. `dur` (optional) gives it the red
-- "active" countdown first, like Blade Flurry. An item's cast is matched by its use spell.
-- ---------------------------------------------------------------------------
local MAX_CUSTOM = 8

local function CustomKey(e) return "c:" .. e.kind .. ":" .. e.id end

local function ItemCount(itemID)
    if C_Item and C_Item.GetItemCount then return C_Item.GetItemCount(itemID) or 0 end
    return GetItemCount and GetItemCount(itemID) or 0
end
local function ItemEquipped(itemID)
    if C_Item and C_Item.IsEquippedItem then return C_Item.IsEquippedItem(itemID) end
    return IsEquippedItem and IsEquippedItem(itemID)
end
local function ItemName(itemID)
    if C_Item and C_Item.GetItemNameByID then
        local n = C_Item.GetItemNameByID(itemID)
        if n then return n end
    end
    return GetItemInfo and GetItemInfo(itemID) or nil
end
local function ItemIcon(itemID)
    if C_Item and C_Item.GetItemIconByID then return C_Item.GetItemIconByID(itemID) end
    return GetItemIcon and GetItemIcon(itemID)
end
-- The spell an item casts when used (nil if it has no use effect, or isn't cached yet).
local function ItemUseSpell(itemID)
    local getter = (C_Item and C_Item.GetItemSpell) or GetItemSpell
    if not getter then return nil end
    local _, spellID = getter(itemID)
    return spellID
end

-- Give an icon the buff countdown (seconds), or remove it (nil / 0).
local function SetCustomBuff(o, dur)
    dur = tonumber(dur)
    if dur and dur > 0 then
        if o.sparks then o.activeDur = dur else AddActiveFX(o, dur) end
    else
        o.activeDur = nil
    end
end

-- Fill in an item icon's name, texture and use spell (item data can arrive late, so
-- this re-runs on GET_ITEM_INFO_RECEIVED).
-- How many of an item fit in one stack (1 = not stackable; nil while not cached yet).
local function ItemStackSize(itemID)
    if C_Item and C_Item.GetItemMaxStackSizeByID then return C_Item.GetItemMaxStackSizeByID(itemID) end
    return GetItemInfo and select(8, GetItemInfo(itemID)) or nil
end

-- Stack count in the icon's corner, like action bars: only for stackable items (potions,
-- Thistle Tea, ...), never for trinkets. Hidden at zero, where the icon is greyed out.
local function MakeItemCount(o)
    local tf = CreateFrame("Frame", nil, o)
    tf:SetAllPoints(o)
    tf:SetFrameLevel(o.cd:GetFrameLevel() + 3)   -- above the swipe
    local fs = tf:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    fs:SetPoint("BOTTOMRIGHT", o, "BOTTOMRIGHT", -2, 2)
    o.countText = fs
    function o:UpdateCount()
        local n = self.stackable and ItemCount(self.itemID) or 0
        self.countText:SetText(n > 0 and n or "")
    end
end

local function RefreshCustomItem(f, o)
    local name = ItemName(o.itemID)
    if name then o.label = name end
    local stack = ItemStackSize(o.itemID)
    if stack then o.stackable = stack > 1 end
    local tex = ItemIcon(o.itemID)
    if tex then o.icon:SetTexture(tex) end
    local useSpell = ItemUseSpell(o.itemID)
    if useSpell and o.ids[1] ~= useSpell then
        o.ids = { useSpell }
        f.cdByCast[useSpell] = o
    end
end

-- Build the icon for one custom entry and hook it into every lookup the built-in icons
-- use (cast matching, layout, unlocked dragging).
local function MakeCustomIcon(f, e)
    local o = MakeIcon(f, e.kind == "spell" and SpellTex(e.id) or ItemIcon(e.id))
    o.key, o.custom = CustomKey(e), e
    if e.kind == "spell" then
        o.ids = { e.id }
        o.label = SpellName(e.id) or ("spell " .. e.id)
        f.cdByCast[e.id] = o
        f.cdByName[o.label] = o   -- other ranks of the same spell, by name
    else
        o.itemID = e.id
        o.ids = {}
        o.label = "item " .. e.id
        o.available = function() return ItemCount(e.id) > 0 or ItemEquipped(e.id) end
        MakeItemCount(o)
        RefreshCustomItem(f, o)
        o:UpdateCount()
    end
    SetCustomBuff(o, e.dur)
    CRFRogue_WireIconDrag(f, o)
    CRFRogue_WireCooldownDone(o)
    o:EnableMouse(not RogueResourcesDB.locked)
    f.icons[#f.icons + 1] = o
    f.cooldowns[#f.cooldowns + 1] = o
    f.iconByKey[o.key] = o
    return o
end

function CRFRogue_BuildCustomIcons(f)
    if type(RogueResourcesDB.custom) ~= "table" then RogueResourcesDB.custom = {} end
    for _, e in ipairs(RogueResourcesDB.custom) do MakeCustomIcon(f, e) end
end

-- Is this spell / item already on the bar (built in or custom)?
local function AlreadyTracked(f, kind, id)
    if kind == "item" then return f.iconByKey["c:item:" .. id] ~= nil end
    if f.cdByCast[id] or SND_CAST_IDS[id] then return true end
    local name = SpellName(id)
    return name and f.cdByName[name] ~= nil
end

-- Add a custom spell / item. Returns the new icon, or nil plus a message.
local function AddCustom(f, kind, id)
    local list = RogueResourcesDB.custom
    if #list >= MAX_CUSTOM then return nil, L.customFull:format(MAX_CUSTOM) end
    if AlreadyTracked(f, kind, id) then return nil, L.customAlready end
    if kind == "item" and not ItemUseSpell(id) then return nil, L.customNoUse end
    local e = { kind = kind, id = id }
    list[#list + 1] = e
    local o = MakeCustomIcon(f, e)
    -- New icons go in the first free slot (or the end of the Classic order).
    if RogueResourcesDB.layout then
        PlaceKey(RogueResourcesDB.layout, o.key, 1)
    else
        table.insert(RogueResourcesDB.iconOrder, o.key)
    end
    LayoutIcons(f)
    return o
end

-- Remove a custom entry and its icon everywhere.
local function RemoveCustom(f, e)
    local key = CustomKey(e)
    local o = f.iconByKey[key]
    for i, x in ipairs(RogueResourcesDB.custom) do
        if x == e then table.remove(RogueResourcesDB.custom, i) break end
    end
    local function Drop(list, item)
        for i, x in ipairs(list) do
            if x == item then table.remove(list, i) return end
        end
    end
    if o then
        o:Hide()
        Drop(f.icons, o)
        Drop(f.cooldowns, o)
        f.iconByKey[key] = nil
        for id, x in pairs(f.cdByCast) do if x == o then f.cdByCast[id] = nil end end
        for n, x in pairs(f.cdByName) do if x == o then f.cdByName[n] = nil end end
    end
    Drop(RogueResourcesDB.iconOrder, key)
    local lay = RogueResourcesDB.layout
    if lay then
        local r, s = FindKey(lay, key)
        if r == "hidden" then table.remove(lay.hidden, s) elseif r then lay.rows[r].keys[s] = false end
    end
    LayoutIcons(f)
end

-- What's on the cursor, as a spell or item id: "spell", id / "item", id / nil.
local function CursorSpellOrItem()
    local kind, a, b, c = GetCursorInfo()
    if kind == "item" then return "item", a end
    if kind == "spell" then
        local id = c
        if not id and C_SpellBook and C_SpellBook.GetSpellBookItemInfo then
            local info = C_SpellBook.GetSpellBookItemInfo(a, b)
            id = info and info.spellID
        end
        if id then return "spell", id end
    end
    return nil
end

-- The Custom Tracking window, docked beside the layout editor.
local CUSTOM_W = 350
local function BuildCustomWindow(f)
    if f.customWindow then return f.customWindow end
    local win, top, extraH = CreateWindow("RogueResourcesCustomFrame", L.customTitle)
    win:SetFrameStrata("FULLSCREEN_DIALOG")
    win:SetWidth(CUSTOM_W)
    local body = CreateFrame("Frame", nil, win)
    body:SetPoint("TOPLEFT", 18, top)
    body:SetSize(CUSTOM_W - 36, 10)
    local BODY_W = CUSTOM_W - 36
    local Refresh

    local hint = body:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    hint:SetPoint("TOPLEFT", 0, 0)
    hint:SetWidth(BODY_W)
    hint:SetJustifyH("LEFT")
    hint:SetText(L.customHint)

    -- The drop box: an empty slot that accepts a spell or item dropped (or clicked) onto it.
    local drop = CreateFrame("Button", nil, body)
    drop:SetSize(40, 40)
    drop:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -10)
    local dbg = drop:CreateTexture(nil, "BACKGROUND")
    dbg:SetAllPoints(); dbg:SetColorTexture(0, 0, 0, 0.45)
    local plus = drop:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    plus:SetPoint("CENTER", 0, 1); plus:SetText("+")
    for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
        local e = drop:CreateTexture(nil, "BORDER")
        e:SetColorTexture(1, 0.82, 0, 0.7)
        if side == "TOP" or side == "BOTTOM" then
            e:SetPoint(side .. "LEFT"); e:SetPoint(side .. "RIGHT"); e:SetHeight(1)
        else
            e:SetPoint("TOP" .. side); e:SetPoint("BOTTOM" .. side); e:SetWidth(1)
        end
    end
    drop:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    local status = body:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    status:SetPoint("LEFT", drop, "RIGHT", 12, 0)
    status:SetWidth(BODY_W - 56)
    status:SetJustifyH("LEFT")
    local function Say(text, ok)
        status:SetText(text or "")
        if ok then status:SetTextColor(0.3, 1, 0.3) else status:SetTextColor(1, 0.3, 0.3) end
    end

    local function TakeCursor()
        local kind, id = CursorSpellOrItem()
        if not GetCursorInfo() then return end   -- nothing held: a plain click
        ClearCursor()
        if not kind then Say(L.customOnly) return end
        local o, err = AddCustom(f, kind, id)
        if o then Say(L.customAdded:format(o.label), true) else Say(err) end
        Refresh()
        if f.layoutEditor and f.layoutEditor:IsShown() then f.layoutEditor.Refresh() end
    end
    drop:SetScript("OnReceiveDrag", TakeCursor)
    drop:SetScript("OnClick", TakeCursor)

    -- The list: icon, name, buff seconds, Delete.
    local colName = body:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    colName:SetPoint("TOPLEFT", drop, "BOTTOMLEFT", 0, -12); colName:SetText(L.colName)
    local colBuff = body:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    colBuff:SetPoint("TOPLEFT", drop, "BOTTOMLEFT", 174, -12); colBuff:SetText(L.colBuff)
    local buffHelp = CreateFrame("Frame", nil, body)   -- tooltip on the column title
    buffHelp:SetAllPoints(colBuff)
    buffHelp:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(L.colBuff)
        GameTooltip:AddLine(L.buffTip:format(SpellName(13877) or "Blade Flurry"), 1, 1, 1, true)
        GameTooltip:Show()
    end)
    buffHelp:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local ROW_H = 28
    local rows = {}
    for i = 1, MAX_CUSTOM do
        local r = CreateFrame("Frame", nil, body)
        r:SetSize(BODY_W, ROW_H)
        r:SetPoint("TOPLEFT", colName, "BOTTOMLEFT", 0, -4 - (i - 1) * ROW_H)
        r.icon = r:CreateTexture(nil, "ARTWORK")
        r.icon:SetSize(22, 22); r.icon:SetPoint("LEFT", 0, 0)
        r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        r.name = r:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        r.name:SetPoint("LEFT", 30, 0); r.name:SetWidth(140)
        r.name:SetJustifyH("LEFT"); r.name:SetWordWrap(false)
        r.buff = CreateFrame("EditBox", nil, r, "InputBoxTemplate")
        r.buff:SetSize(34, 20); r.buff:SetPoint("LEFT", 180, 0)
        r.buff:SetAutoFocus(false); r.buff:SetNumeric(true); r.buff:SetMaxLetters(3)
        local function SaveBuff(self)
            local e = r.entry
            if not e then return end
            local v = tonumber(self:GetText())
            e.dur = (v and v > 0) and v or nil
            local o = f.iconByKey[CustomKey(e)]
            if o then SetCustomBuff(o, e.dur) end
            self:ClearFocus()
        end
        r.buff:SetScript("OnEnterPressed", SaveBuff)
        r.buff:SetScript("OnEditFocusLost", SaveBuff)
        r.buff:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        r.del = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
        r.del:SetSize(70, 22); r.del:SetPoint("RIGHT", 0, 0)
        r.del:SetText(L.deleteRow)
        r.del:SetScript("OnClick", function()
            if r.entry then
                RemoveCustom(f, r.entry)
                Say("")
                Refresh()
                if f.layoutEditor and f.layoutEditor:IsShown() then f.layoutEditor.Refresh() end
            end
        end)
        rows[i] = r
    end

    function Refresh()
        local list = RogueResourcesDB.custom
        for i, r in ipairs(rows) do
            local e = list[i]
            r.entry = e
            if e then
                local o = f.iconByKey[CustomKey(e)]
                r.icon:SetTexture(o and o.icon:GetTexture())
                r.name:SetText(o and o.label or e.id)
                if not r.buff:HasFocus() then r.buff:SetText(e.dur and tostring(e.dur) or "") end
                r:Show()
            else
                r:Hide()
            end
        end
    end
    win.Refresh = Refresh

    local bodyH = (hint:GetStringHeight() or 24) + 10 + 40 + 12 + 14 + 4 + MAX_CUSTOM * ROW_H + 4
    body:SetHeight(bodyH)
    win:SetHeight(bodyH + extraH)
    -- Docked beside the layout editor, following it: on the right when there's room on
    -- screen, otherwise on the left, so it never ends up pushed on top of the editor at
    -- the screen edge. (Dragged on its own it stays put until it's next opened.)
    function win.Dock()
        local ed = f.layoutEditor
        if not ed then return end
        local edLeft, edRight, screenRight = ed:GetLeft(), ed:GetRight(), UIParent:GetRight()
        if edLeft and edRight and screenRight then
            -- Stay on the current side while it fits; switch only when the other side
            -- does fit. When neither does, keep whichever side has more room.
            local need = win:GetWidth() + 4
            local fitsR, fitsL = screenRight - edRight >= need, edLeft >= need
            local side = win.dockSide or "right"
            if side == "right" and not fitsR and (fitsL or edLeft > screenRight - edRight) then
                side = "left"
            elseif side == "left" and not fitsL and (fitsR or screenRight - edRight > edLeft) then
                side = "right"
            end
            win.dockSide = side
        end
        win:ClearAllPoints()
        if win.dockSide == "left" then
            win:SetPoint("TOPRIGHT", ed, "TOPLEFT", -4, 0)
        else
            win:SetPoint("TOPLEFT", ed, "TOPRIGHT", 4, 0)
        end
    end
    win:SetScript("OnShow", function()
        win.Dock()
        Say("")
        Refresh()
    end)
    f.customWindow = win
    return win
end

function CRFRogue_ToggleCustomWindow(f)
    local win = BuildCustomWindow(f)
    win:SetShown(not win:IsShown())
end

-- Item data (names, icons, use spells) arriving late: refresh the custom item icons.
function CRFRogue_RefreshCustomItems(f)
    if not f.icons then return end
    for _, o in ipairs(f.icons) do
        if o.itemID then
            RefreshCustomItem(f, o)
            o:UpdateCount()   -- the stack size may only be known now
        end
    end
    if f.customWindow and f.customWindow:IsShown() then f.customWindow.Refresh() end
end
end   -- custom tracking block

do   -- layout editor block (its helpers stay private; see the note above the custom block)
-- ---------------------------------------------------------------------------
-- Cooldown layout editor (/rr layout, or "Customize cooldown layout..." in options).
-- Rows of slots shown at 1.5x their in-game size: drag icons between slots (onto an
-- icon swaps, onto an empty slot moves) or into the Hidden tray; +/- set a row's slot
-- count, which sets its icon size. Every change applies to the bar straight away.
-- ---------------------------------------------------------------------------
local ED_W = 560        -- window width
local PV = 1.5          -- preview scale (in-game size x1.5)
local PV_X = 64         -- left edge of the preview column (row labels sit left of it)
local TRAY_CELL, TRAY_GAP = 28, 4
local ROWS_H = 250      -- fixed height of the rows area (the preview shrinks to fit)

-- Thin outline on a frame (the empty-slot look).
local function AddEdges(frame, r, g, b, a)
    local edges = {}
    for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
        local e = frame:CreateTexture(nil, "BORDER")
        e:SetColorTexture(r, g, b, a)
        if side == "TOP" or side == "BOTTOM" then
            e:SetPoint(side .. "LEFT"); e:SetPoint(side .. "RIGHT"); e:SetHeight(1)
        else
            e:SetPoint("TOP" .. side); e:SetPoint("BOTTOM" .. side); e:SetWidth(1)
        end
        edges[#edges + 1] = e
    end
    return edges
end

local function IconLabel(o)
    return o.label or (o.ids and SpellName(o.ids[1])) or o.key
end

local function BuildLayoutEditor(f)
    if f.layoutEditor then return f.layoutEditor end
    local win, top, extraH = CreateWindow("RogueResourcesLayoutFrame", L.layoutTitle)
    -- Keep the Custom Tracking window docked on the side with room while this one moves.
    win.OnMoved = function()
        if f.customWindow and f.customWindow:IsShown() then f.customWindow.Dock() end
    end
    win:SetFrameStrata("FULLSCREEN_DIALOG")   -- above the Options panel it can be opened from
    win:SetWidth(ED_W)
    local body = CreateFrame("Frame", nil, win)
    body:SetPoint("TOPLEFT", 18, top)
    body:SetSize(ED_W - 36, 10)
    local BODY_W = ED_W - 36

    local Refresh   -- defined below; every edit ends with it

    -- The layout on screen: the saved one, or Classic shown as rows. Edit() makes the
    -- saved copy on the first change.
    local function Lay() return RogueResourcesDB.layout or ClassicLayout() end
    local function Edit()
        if not RogueResourcesDB.layout then RogueResourcesDB.layout = ClassicLayout() end
        return RogueResourcesDB.layout
    end
    local function Changed()
        LayoutIcons(f)
        Refresh()
    end

    -- Move a key onto row r / slot s (swapping with whatever is there), or into the
    -- Hidden tray (r == "hidden").
    local function MoveKey(key, r, s)
        local lay = Edit()
        local sr, ss = FindKey(lay, key)
        if r == "hidden" then
            if sr == "hidden" then return end
            if sr then lay.rows[sr].keys[ss] = false end
            lay.hidden[#lay.hidden + 1] = key
        else
            local other = lay.rows[r].keys[s]
            if other == key then return end
            if sr == "hidden" then
                table.remove(lay.hidden, ss)
                if other then table.insert(lay.hidden, ss, other) end
            elseif sr then
                lay.rows[sr].keys[ss] = other or false
            end
            lay.rows[r].keys[s] = key
        end
        Changed()
    end

    local function ShowKey(key)   -- out of the tray, into the first free slot
        local lay = Edit()
        local _, i = FindKey(lay, key)
        if i then table.remove(lay.hidden, i) end
        PlaceKey(lay, key, 1)
        Changed()
    end

    -- Slot count: the icon removed from a shrinking row moves to a free slot in the same
    -- row, else on to the next rows (or a new row, or Hidden).
    local function ChangeSlots(i, d)
        local lay = Edit()
        local row = lay.rows[i]
        local n = row.slots + d
        if n < SLOTS_MIN or n > SLOTS_MAX then return end
        if d > 0 then
            row.slots = n
            row.keys[n] = false
        else
            local k = row.keys[row.slots]
            row.keys[row.slots] = nil
            row.slots = n
            if k then
                local placed
                for s = 1, n do
                    if not row.keys[s] then row.keys[s] = k; placed = true; break end
                end
                if not placed then PlaceKey(lay, k, i + 1) end
            end
        end
        Changed()
    end

    -- Removing a row sends its icons to free slots in the rows below, else Hidden.
    local function RemoveRow(i)
        local lay = Edit()
        if #lay.rows <= 1 then return end
        local row = table.remove(lay.rows, i)
        for s = 1, row.slots do
            if row.keys[s] then PlaceKey(lay, row.keys[s], i, true) end
        end
        Changed()
    end

    local function AddRow()
        local lay = Edit()
        if #lay.rows >= MAX_ROWS then return end
        lay.rows[#lay.rows + 1] = NewRow(lay.rows[#lay.rows].slots)
        Changed()
    end

    local function ResetLayout()
        RogueResourcesDB.layout = nil
        RogueResourcesDB.iconOrder = nil
        RogueResourcesDB.iconEnabled = {}
        ReconcileOrder(f)
        Changed()
    end

    -- ----- dragging -----
    local dragKey
    local ghost = CreateFrame("Frame", nil, UIParent)
    ghost:SetFrameStrata("TOOLTIP")
    ghost:SetSize(34, 34)
    ghost.tex = ghost:CreateTexture(nil, "ARTWORK")
    ghost.tex:SetAllPoints()
    ghost.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    ghost:SetAlpha(0.85)
    ghost:Hide()
    ghost:SetScript("OnUpdate", function(self)
        local x, y = GetCursorPosition()
        local s = self:GetEffectiveScale()
        self:ClearAllPoints()
        self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / s, y / s)
    end)

    local rowUI, trayCells = {}, {}
    local tray   -- the Hidden tray frame (built below)

    local function StartDrag(key)
        dragKey = key
        ghost.tex:SetTexture(f.iconByKey[key].icon:GetTexture())
        ghost:Show()
    end

    -- Drop on whatever is under the cursor: a row slot, or the Hidden tray.
    local function EndDrag()
        local key = dragKey
        dragKey = nil
        ghost:Hide()
        if not key then return end
        local lay = Lay()
        for r = 1, #lay.rows do
            local u = rowUI[r]
            for s = 1, lay.rows[r].slots do
                local c = u and u.cells[s]
                if c and c:IsShown() and c:IsMouseOver() then MoveKey(key, r, s) return end
            end
        end
        if tray:IsMouseOver() then MoveKey(key, "hidden") end
    end

    -- Right-click: a placed icon goes to the Hidden tray; a hidden one comes back into the
    -- first free slot (a new row is added when every row is full).
    local function ToggleHidden(key)
        if FindKey(Lay(), key) == "hidden" then ShowKey(key) else MoveKey(key, "hidden") end
    end

    -- One icon cell (row slot or tray icon): the spell icon, or an empty outline.
    local function MakeCell()
        local c = CreateFrame("Button", nil, body)
        c.bg = c:CreateTexture(nil, "BACKGROUND")
        c.bg:SetAllPoints()
        c.bg:SetColorTexture(0, 0, 0, 0.45)
        c.icon = c:CreateTexture(nil, "ARTWORK")
        c.icon:SetPoint("TOPLEFT", 1, -1)
        c.icon:SetPoint("BOTTOMRIGHT", -1, 1)
        c.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        c.edges = AddEdges(c, 0.6, 0.6, 0.6, 0.6)
        c:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        c:RegisterForDrag("LeftButton")
        c:RegisterForClicks("RightButtonUp")
        c:SetScript("OnDragStart", function(self) if self.key then StartDrag(self.key) end end)
        c:SetScript("OnDragStop", EndDrag)
        c:SetScript("OnClick", function(self, button)
            if self.key and button == "RightButton" then ToggleHidden(self.key) end
        end)
        c:SetScript("OnEnter", function(self)
            local o = self.key and f.iconByKey[self.key]
            if not o then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(IconLabel(o))
            if not IconKnown(o) then GameTooltip:AddLine(o.itemID and L.notCarried or L.notLearned, 0.6, 0.6, 0.6) end
            GameTooltip:AddLine(FindKey(Lay(), self.key) == "hidden" and L.rcShow or L.rcHide, 0.5, 0.8, 1)
            GameTooltip:Show()
        end)
        c:SetScript("OnLeave", function() GameTooltip:Hide() end)
        return c
    end

    local function SetCell(c, key)
        local o = key and f.iconByKey[key]
        c.key = o and key or nil
        if o then
            c.icon:SetTexture(o.icon:GetTexture())
            c.icon:SetDesaturated(not IconKnown(o))   -- unlearned: greyed, still placeable
            c.icon:Show()
        else
            c.icon:Hide()
        end
        for _, e in ipairs(c.edges) do e:SetShown(not o) end
    end

    local function TextButton(text, width, onClick)
        local b = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
        b:SetSize(width, 22)
        b:SetText(text)
        b:SetScript("OnClick", onClick)
        return b
    end

    local function SmallButton(text, onClick) return TextButton(text, 22, onClick) end

    local function GetRowUI(i)
        if rowUI[i] then return rowUI[i] end
        local u = { cells = {} }
        u.label = body:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        u.size = body:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
        u.minus = SmallButton("-", function() ChangeSlots(i, -1) end)
        u.count = body:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        u.plus = SmallButton("+", function() ChangeSlots(i, 1) end)
        u.remove = TextButton(L.deleteRow, 70, function() RemoveRow(i) end)
        rowUI[i] = u
        return u
    end

    local function Label(text, template)
        local fs = body:CreateFontString(nil, "ARTWORK", template or "GameFontNormal")
        fs:SetText(text)
        return fs
    end

    local function Check(text, onClick)
        local c = CreateFrame("CheckButton", nil, body, "UICheckButtonTemplate")
        c:SetSize(26, 26)
        local t = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        t:SetPoint("LEFT", c, "RIGHT", 2, 0)
        t:SetText(text)
        c:SetScript("OnClick", onClick)
        return c
    end

    -- ----- static controls (positioned in Refresh) -----
    -- How-to lines at the top of the window.
    local help = body:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    help:SetWidth(BODY_W)
    help:SetJustifyH("LEFT")
    help:SetSpacing(3)
    help:SetText(L.helpDrag .. "\n" .. L.helpSlots .. "\n" .. L.helpDelete)

    local addRowBtn = TextButton(L.addRow, 110, AddRow)
    local customBtn = TextButton(L.customBtn, 210, function() CRFRogue_ToggleCustomWindow(f) end)

    local trayLabel = Label(L.hiddenTray)
    local trayHint = Label(L.hiddenHint, "GameFontDisableSmall")
    tray = CreateFrame("Frame", nil, body)
    tray.bg = tray:CreateTexture(nil, "BACKGROUND")
    tray.bg:SetAllPoints()
    tray.bg:SetColorTexture(0, 0, 0, 0.3)
    AddEdges(tray, 0.4, 0.4, 0.4, 0.6)

    local spacingLabel = Label(L.spacing)
    local spacingBtns = {}
    for i, sp in ipairs({ { "tight", L.tight }, { "normal", L.normal }, { "wide", L.wide } }) do
        spacingBtns[i] = TextButton(sp[2], 78, function() Edit().spacing = sp[1]; Changed() end)
        spacingBtns[i].value = sp[1]
    end

    local keepCheck = Check(L.keepEmpty, function(self) Edit().keepEmpty = self:GetChecked() and true or false; Changed() end)

    local posLabel = Label(L.position)
    local posBtns = {
        TextButton(L.belowBars, 120, function() Edit().above = false; Changed() end),
        TextButton(L.aboveBars, 120, function() Edit().above = true; Changed() end),
    }

    local resetBtn = TextButton(L.reset, 90, ResetLayout)
    local doneBtn = TextButton(L.done, 90, function() win:Hide() end)
    -- Show every icon on the bar as if all abilities were learned (same as /rr showall;
    -- not saved, so a /reload turns it off). Stays lit while on.
    local previewBtn = TextButton(L.previewAll, 230, function()
        RR.showAll = not RR.showAll or nil
        Changed()
    end)

    local function Put(region, x, y)
        region:ClearAllPoints()
        region:SetPoint("TOPLEFT", body, "TOPLEFT", x, y)
        region:Show()
    end
    local function Select(btn, on) if on then btn:LockHighlight() else btn:UnlockHighlight() end end

    -- Lay out the whole window from the current layout (rows vary in height).
    function Refresh()
        local lay = Lay()
        local gap = LayGap(lay)
        local y = 0

        Put(help, 0, y)
        y = y - math.max(42, help:GetStringHeight() or 0) - 12   -- room for wrapped translations

        -- Rows: label + size, the slots, then the slot stepper and Delete. The rows area
        -- has a FIXED height, so adding rows, slot counts and spacing never resize the window:
        -- when the rows need more room than that, the preview just shrinks to fit.
        for _, u in pairs(rowUI) do
            u.label:Hide(); u.size:Hide(); u.minus:Hide(); u.count:Hide(); u.plus:Hide(); u.remove:Hide()
            for _, c in ipairs(u.cells) do c:Hide() end
        end
        local function RowH(row, pv)   -- from tight spacing, the largest this row can be
            return math.max(RowSize(row, SPACING.tight) * pv, 30)
        end
        local pv = PV
        for _ = 1, 3 do
            local need = (#lay.rows - 1) * 8
            for _, row in ipairs(lay.rows) do need = need + RowH(row, pv) end
            if need <= ROWS_H then break end
            pv = pv * ROWS_H / need
        end
        local ctlX = PV_X + BAR_W * PV + 12   -- fixed, whatever the preview scale
        local rowsTop = y
        for i, row in ipairs(lay.rows) do
            local u = GetRowUI(i)
            local size = RowSize(row, gap)
            local cs, cg = size * pv, gap * pv
            local h = RowH(row, pv)
            local mid = y - h / 2
            u.label:SetText(L.rowN:format(i))
            Put(u.label, 0, mid + 13)
            u.size:SetText(math.floor(size + 0.5) .. "px")
            Put(u.size, 0, mid - 2)
            for s = 1, row.slots do
                local c = u.cells[s]
                if not c then c = MakeCell(); u.cells[s] = c end
                c:SetSize(cs, cs)
                Put(c, PV_X + (s - 1) * (cs + cg), mid + cs / 2)
                SetCell(c, row.keys[s])
            end
            Put(u.minus, ctlX, mid + 11)
            u.count:SetText(row.slots)
            u.count:ClearAllPoints()
            u.count:SetPoint("CENTER", body, "TOPLEFT", ctlX + 34, mid)
            u.count:Show()
            Put(u.plus, ctlX + 46, mid + 11)
            if #lay.rows > 1 then Put(u.remove, ctlX + 76, mid + 11) end
            u.minus:SetEnabled(row.slots > SLOTS_MIN)
            u.plus:SetEnabled(row.slots < SLOTS_MAX)
            y = y - h - 8
        end
        y = rowsTop - ROWS_H - 6
        Put(addRowBtn, PV_X, y)
        Put(customBtn, PV_X + 120, y)
        addRowBtn:SetEnabled(#lay.rows < MAX_ROWS)
        y = y - 38

        -- Hidden tray: wraps its icons across the window width (fixed two-row height).
        Put(trayLabel, 0, y)
        trayHint:ClearAllPoints()
        trayHint:SetPoint("LEFT", trayLabel, "RIGHT", 8, 0)
        trayHint:Show()
        y = y - 18
        for _, c in ipairs(trayCells) do c:Hide() end
        local perRow = math.floor((BODY_W - 8 + TRAY_GAP) / (TRAY_CELL + TRAY_GAP))
        local trayRows = math.max(2, math.ceil(#lay.hidden / perRow))
        local trayH = trayRows * (TRAY_CELL + TRAY_GAP) + 4
        tray:SetSize(BODY_W, trayH)
        Put(tray, 0, y)
        for i, k in ipairs(lay.hidden) do
            local c = trayCells[i]
            if not c then c = MakeCell(); trayCells[i] = c end
            c:SetSize(TRAY_CELL, TRAY_CELL)
            c:SetFrameLevel(tray:GetFrameLevel() + 2)
            local col, row = (i - 1) % perRow, math.floor((i - 1) / perRow)
            Put(c, 4 + col * (TRAY_CELL + TRAY_GAP), y - 4 - row * (TRAY_CELL + TRAY_GAP))
            SetCell(c, k)
        end
        y = y - trayH - 14

        -- Options.
        Put(spacingLabel, 0, y - 5)
        for i, b in ipairs(spacingBtns) do
            Put(b, PV_X + (i - 1) * 84, y)
            Select(b, (lay.spacing or "normal") == b.value)
        end
        y = y - 30
        Put(keepCheck, -2, y); keepCheck:SetChecked(lay.keepEmpty and true or false)
        y = y - 32
        Put(posLabel, 0, y - 5)
        Put(posBtns[1], PV_X, y); Select(posBtns[1], not lay.above)
        Put(posBtns[2], PV_X + 126, y); Select(posBtns[2], lay.above and true or false)
        y = y - 40

        Put(resetBtn, 0, y)
        Put(doneBtn, BODY_W - doneBtn:GetWidth(), y)
        Put(previewBtn, (BODY_W - previewBtn:GetWidth()) / 2, y)
        Select(previewBtn, RR.showAll and true or false)
        y = y - 24

        body:SetHeight(-y)
        -- Keep the window's top edge where it is when its height changes (adding a row,
        -- changing a slot count), so it grows and shrinks downward instead of jumping.
        -- (The very first sizing keeps the centered opening position.)
        local left, topEdge = win:GetLeft(), win:GetTop()
        win:SetHeight(-y + extraH)
        if win.sized and left and topEdge then
            win:ClearAllPoints()
            win:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, topEdge)
            win.SavePos()
        end
        win.sized = true
    end
    win.Refresh = Refresh

    -- While open, keep the bars visible (even with "Show only in combat") so changes can be
    -- seen live.
    win:SetScript("OnShow", function()
        RR.editing = true
        CRFRogue_UpdateCombatVisibility(f)
        Refresh()
    end)
    win:SetScript("OnHide", function()
        RR.editing = nil
        dragKey = nil
        ghost:Hide()
        if f.customWindow then f.customWindow:Hide() end   -- it belongs to the editor
        -- "Preview unlearned skills" is only for laying things out: closing ends it.
        if RR.showAll then
            RR.showAll = nil
            LayoutIcons(f)
        end
        CRFRogue_UpdateCombatVisibility(f)
    end)

    f.layoutEditor = win
    return win
end

function CRFRogue_ToggleLayoutEditor(f)   -- forward-declared above (the options button uses it)
    local win = BuildLayoutEditor(f)
    win:SetShown(not win:IsShown())
end
end   -- layout editor block

-- A draggable minimap button (parented to the Minimap, positioned by angle on the ring)
-- that opens the options window. Uses the Slice and Dice icon. Position is saved.
local function BuildMinimapButton(f)
    if f.minimapButton or not Minimap then return f and f.minimapButton end
    local b = CreateFrame("Button", "RogueResourcesMinimapButton", Minimap)
    b:SetSize(31, 31); b:SetFrameStrata("MEDIUM"); b:SetFrameLevel(8)
    b:RegisterForClicks("AnyUp")
    b:RegisterForDrag("LeftButton")

    -- Standard LibDBIcon-style layout: a small icon inset inside the tracking-border ring,
    -- so the button reads as a round minimap button rather than a bare square.
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20); bg:SetPoint("TOPLEFT", 7, -5)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    local icon = b:CreateTexture(nil, "ARTWORK")
    icon:SetSize(17, 17); icon:SetPoint("TOPLEFT", 7, -6)
    icon:SetTexture(SpellTex(5171) or SND_FALLBACK_ICON)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53); border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    -- Sit on the minimap ring: radius from the minimap's own size (works whatever its
    -- scale/shape), not a hardcoded value that overlaps a larger minimap.
    local function place()
        local a = math.rad(RogueResourcesDB.minimapAngle or 200)
        local r = (Minimap:GetWidth() / 2) + 5
        b:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
    end
    place()

    b:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local sc = Minimap:GetEffectiveScale()
            RogueResourcesDB.minimapAngle = math.deg(math.atan2(cy / sc - my, cx / sc - mx))
            place()
        end)
    end)
    b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    b:SetScript("OnClick", function() ToggleOptions(f) end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Class Resources Forever - Rogue")
        GameTooltip:AddLine(L.clickToOpen, 1, 1, 1)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)

    f.minimapButton = b
    return b
end

-- Register with the Addon Compartment (the button list on the minimap) if the client
-- supports it. Clicking the entry opens the options window. Registered once.
local function RegisterAddonCompartment(f)
    if RR.compartmentRegistered then return end
    if not (AddonCompartmentFrame and AddonCompartmentFrame.RegisterAddon) then return end
    AddonCompartmentFrame:RegisterAddon({
        text = "Class Resources Forever - Rogue",
        icon = SpellTex(5171) or SND_FALLBACK_ICON,
        notCheckable = true,
        registerForAnyClick = true,
        func = function() ToggleOptions(f) end,
    })
    RR.compartmentRegistered = true
end

local function BuildUI()
    -- Anonymous (no global name) ON PURPOSE: a NAMED movable UIParent child gets
    -- captured by the client's frame-position/Edit-Mode manager (it appears in
    -- layout-local.txt) and forced back to its cached anchor on every login,
    -- overriding our own saved position. Staying nameless keeps position fully ours.
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetSize(BAR_W, FRAME_H)
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:EnableMouse(false)   -- only interactive while unlocked
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, rp, x, y = self:GetPoint()
        if p then
            RogueResourcesDB.position = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 }
            print(("|cff00ff88RogueResources:|r position saved (%d, %d)."):format(x or 0, y or 0))
        end
    end)

    -- Energy bar
    local bar = CreateFrame("StatusBar", nil, f)
    bar:SetSize(BAR_W, BAR_H)
    bar:SetPoint("BOTTOM", f, "BOTTOM", 0, 0)
    bar:SetStatusBarTexture(BAR_TEX)
    bar:SetStatusBarColor(1.0, 0.82, 0.06)   -- energy yellow
    bar:SetMinMaxValues(0, 100)

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(bar)
    bg:SetColorTexture(0.12, 0.10, 0.02, 0.55)   -- dark warm backing

    Gloss(bar)

    local text = bar:CreateFontString(nil, "OVERLAY")
    text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    text:SetPoint("CENTER", bar, "CENTER", 0, 0)
    text:SetTextColor(1, 1, 1, 1)

    -- Health bar (optional, off by default). Positions for all three bars are set by
    -- CRFRogue_ApplyBarVisibility from the saved order.
    local health = CreateFrame("StatusBar", nil, f)
    health:SetSize(BAR_W, BAR_H)
    health:SetStatusBarTexture(BAR_TEX)
    health:SetStatusBarColor(0.18, 0.78, 0.22)   -- health green
    health:SetMinMaxValues(0, 1)
    health:SetValue(1)
    local hbg = health:CreateTexture(nil, "BACKGROUND")
    hbg:SetAllPoints(health)
    hbg:SetColorTexture(0.03, 0.12, 0.03, 0.55)
    Gloss(health)
    -- Incoming heals, Blizzard style: a light green strip right after your current health.
    -- It's its own bar (same width and max as the health bar) hung off the end of the
    -- health fill, so no maths is done on the (possibly hidden) numbers; a clip frame the
    -- size of the health bar cuts off any part past full health.
    local clip = CreateFrame("Frame", nil, health)
    clip:SetAllPoints(health)
    clip:SetClipsChildren(true)
    local heal = CreateFrame("StatusBar", nil, clip)
    heal:SetPoint("TOPLEFT", health:GetStatusBarTexture(), "TOPRIGHT")
    heal:SetPoint("BOTTOMLEFT", health:GetStatusBarTexture(), "BOTTOMRIGHT")
    heal:SetWidth(BAR_W)
    heal:SetStatusBarTexture(BAR_TEX)
    heal:SetStatusBarColor(0.45, 1.0, 0.45, 0.55)
    heal:SetMinMaxValues(0, 1)
    heal:SetValue(0)
    -- The number sits above the incoming-heal strip.
    local htf = CreateFrame("Frame", nil, health)
    htf:SetAllPoints(health)
    htf:SetFrameLevel(clip:GetFrameLevel() + 2)
    local htext = htf:CreateFontString(nil, "OVERLAY")
    htext:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    htext:SetPoint("CENTER", health, "CENTER", 0, 0)
    htext:SetTextColor(1, 1, 1, 1)
    health.incoming = heal
    health:Hide()

    -- Combo-point bar. CP is a secret value, so we feed it straight into a StatusBar
    -- (a whitelisted sink that accepts secrets) instead of comparing it to light pips.
    -- Dividers split the fill into MAX_CP segments so it still reads as combo points.
    local cp = CreateFrame("StatusBar", nil, f)
    cp:SetSize(BAR_W, CP_H)
    cp:SetPoint("TOP", f, "TOP", 0, 0)
    cp:SetStatusBarTexture(BAR_TEX)
    cp:SetStatusBarColor(0.92, 0.20, 0.16)   -- combo red
    cp:SetMinMaxValues(0, MAX_CP)
    cp:SetValue(0)

    local cpbg = cp:CreateTexture(nil, "BACKGROUND")
    cpbg:SetAllPoints(cp)
    cpbg:SetColorTexture(0.16, 0.03, 0.03, 0.55)

    Gloss(cp)

    -- Gap-style dividers, colored like the panel so the fill reads as clean segments.
    for i = 1, MAX_CP - 1 do
        local div = cp:CreateTexture(nil, "OVERLAY")
        div:SetColorTexture(0.05, 0.05, 0.06, 1)
        div:SetSize(2, CP_H)
        div:SetPoint("CENTER", cp, "LEFT", (BAR_W / MAX_CP) * i, 0)
    end

    -- "Combo points maxed" cue on the LAST segment: a brighter fill plus thin red edges.
    -- Each piece is its own StatusBar with range (MAX_CP-1)..MAX_CP, fed the REAL secret
    -- CP in UpdateCP. Below max the value clamps to empty; at max it fills -- so the cue
    -- lights up exactly on the 5th point without ever comparing the secret value.
    local x0 = (BAR_W / MAX_CP) * (MAX_CP - 1) + 1   -- just right of the 4th divider
    local WHITE = "Interface\\Buttons\\WHITE8X8"
    local function MaxBar(parent, tex, r, g, b, a)
        local s = CreateFrame("StatusBar", nil, parent)
        s:SetStatusBarTexture(tex)
        s:SetStatusBarColor(r, g, b, a or 1)
        s:SetMinMaxValues(MAX_CP - 1, MAX_CP)
        s:SetValue(0)
        return s
    end
    -- Steady brighter fill on the last segment.
    local hi = MaxBar(cp, BAR_TEX, 1.0, 0.45, 0.35)
    hi:SetPoint("TOPLEFT", cp, "TOPLEFT", x0, 0)
    hi:SetPoint("BOTTOMRIGHT", cp, "BOTTOMRIGHT", 0, 0)

    -- Pulsing flash, same feel as the unpoisoned-weapon flash: an additive red flash over
    -- the segment, fading in and out. The loop always runs, but its bar is empty below
    -- max, so it's only visible at 5 points.
    local pulse = CreateFrame("Frame", nil, cp)
    pulse:SetPoint("TOPLEFT", cp, "TOPLEFT", x0, 0)
    pulse:SetPoint("BOTTOMRIGHT", cp, "BOTTOMRIGHT", 0, 0)
    local flash = MaxBar(pulse, WHITE, 1.0, 0.25, 0.15)
    flash:GetStatusBarTexture():SetBlendMode("ADD")
    flash:SetAllPoints(pulse)
    RegisterPulse(pulse, 0.15, 0.8)   -- shared-clock pulse (in sync with the poison flash)

    f.cpMax = { hi, flash }

    -- Framed backing behind both bars for a cohesive, "fits the UI" look.
    local panel = f:CreateTexture(nil, "BACKGROUND", nil, -7)
    panel:SetColorTexture(0.05, 0.05, 0.06, 0.9)
    panel:SetPoint("TOPLEFT", cp, "TOPLEFT", -1, 1)
    panel:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
    -- Keep handles so CRFRogue_ApplyBarVisibility can hide a bar's outline and refit the backing
    -- panel when the energy or combo bar is turned off.
    f.panel = panel
    f.panelOutline = Outline(panel, f)   -- outer frame
    f.barOutline = Outline(bar, f)       -- crisp edge around each bar
    f.cpOutline = Outline(cp, f)
    f.health, f.healthText = health, htext
    f.healthOutline = Outline(health, f)
    f.healthOutline:Hide()

    -- Icon row below the bars, centered, showing only abilities you've learned:
    -- [Slice and Dice] [Evasion] [Vanish] [Kick] [Sprint] [Blade Flurry] [Adrenaline Rush].
    -- SnD shows an estimated buff timer; the rest show real cooldown swipes.
    local snd = MakeIcon(f, SpellTex(5171) or SND_FALLBACK_ICON)
    snd.key, snd.ids, snd.label = "snd", SND_LIST, SpellName(5171) or "Slice and Dice"
    -- Yellow border comet + halo for the last SND_WARN seconds, as a "refresh me" cue.
    AddBorderFX(snd, 1, 0.85, 0.1, "ring")   -- yellow edge line, fading outward
    -- Our own rounded-down countdown instead of the cooldown's built-in one (which rounds
    -- up and read a second high next to the buff timer) -- see MakeBuffNumber.
    snd.cd:SetHideCountdownNumbers(true)
    MakeBuffNumber(snd)
    -- Drive everything from our own (non-secret) expiry each frame: the countdown number,
    -- the comet while 0 < remaining <= SND_WARN, and the dim when the duration runs out.
    snd:SetScript("OnUpdate", function(self)
        local rem = self.expires and (self.expires - GetTime())
        SetBuffNumber(self, rem)
        if rem and rem > 0 and rem <= SND_WARN then
            if not self.fxOn then SetBorderFX(self, true) end
            PlaceSparks(self)
        elseif self.fxOn then
            SetBorderFX(self, false)
        end
        if rem and rem <= 0 then
            self.expires = nil
            self:SetAlpha(0.35)
        end
    end)

    -- Helper: a cooldown-tracked ability icon with key/ids/label.
    local function AddCD(key, ids)
        local o = MakeIcon(f, SpellTex(ids[1]))
        o.key, o.ids, o.label = key, ids, (SpellName(ids[1]) or key)
        return o
    end
    local evasion    = AddCD("evasion", EVASION_IDS)
    local vanish     = AddCD("vanish", VANISH_IDS)
    local kick       = AddCD("kick", KICK_IDS)
    local shank      = AddCD("shank", { 1329283, 1329549 })   -- Shank ranks 1-2
    local sprint     = AddCD("sprint", SPRINT_IDS)
    local bladeflurry= AddCD("bladeflurry", BLADEFLURRY_IDS)
    local adrenaline = AddCD("adrenaline", ADRENALINE_IDS)
    local blind      = AddCD("blind", BLIND_IDS)
    local kidney     = AddCD("kidney", KIDNEY_IDS)
    local gouge      = AddCD("gouge", GOUGE_IDS)
    local coldblood     = AddCD("coldblood", COLDBLOOD_IDS)         -- Assassination talent
    local ghostlystrike = AddCD("ghostlystrike", GHOSTSTRIKE_IDS)  -- Subtlety talent
    local premeditation = AddCD("premeditation", PREMEDITATION_IDS)-- Subtlety talent
    local preparation   = AddCD("preparation", PREPARATION_IDS)    -- Subtlety talent
    -- Buff cooldowns: show a red spinning "active" phase for the buff's duration first.
    AddActiveFX(evasion, 15)       -- Evasion: 15s buff
    AddActiveFX(sprint, 15)        -- Sprint: 15s buff (all ranks)
    AddActiveFX(bladeflurry, 15)   -- Blade Flurry: 15s buff, 2 min cooldown
    AddActiveFX(adrenaline, 15)    -- Adrenaline Rush: 15s buff, 5 min cooldown

    -- Racial abilities (see RACIALS): only the ones this character actually has get an
    -- icon (your race never changes), so other races' racials don't clutter arrange mode.
    -- Buff racials get the red "active" phase; the rest are cooldown-only.
    local racials = {}
    for _, r in ipairs(RACIALS) do
        local id = r.id
        if (IsPlayerSpell and IsPlayerSpell(id)) or (IsSpellKnown and IsSpellKnown(id)) then
            local o = AddCD(r.key, { id })
            if r.dur then AddActiveFX(o, r.dur) end
            racials[#racials + 1] = o
        end
    end
    f.bar, f.text, f.cp, f.snd = bar, text, cp, snd
    f.icons = { snd, evasion, vanish, kick, shank, sprint, bladeflurry, adrenaline, blind, kidney, gouge,
                coldblood, ghostlystrike, premeditation, preparation }
    f.cooldowns = { evasion, vanish, kick, shank, sprint, bladeflurry, adrenaline, blind, kidney, gouge,
                    coldblood, ghostlystrike, premeditation, preparation }
    for _, o in ipairs(racials) do
        f.icons[#f.icons + 1] = o
        f.cooldowns[#f.cooldowns + 1] = o
    end
    f.iconByKey = {}
    for _, o in ipairs(f.icons) do f.iconByKey[o.key] = o end

    for _, o in ipairs(f.icons) do CRFRogue_WireIconDrag(f, o) end
    -- Map every rank of each tracked ability to its icon, so a cast of ANY rank triggers
    -- the right swipe (sidesteps the unreliable IsSpellKnown rank guessing).
    f.cdByCast = {}
    -- A racial's cast can report a different spell ID than its spellbook entry, so racials
    -- are also matched by (localized) spell name as a fallback.
    f.cdByName = {}
    for _, o in ipairs(racials) do
        if o.label then f.cdByName[o.label] = o end
    end
    for _, o in ipairs(f.cooldowns) do
        for _, id in ipairs(o.ids) do f.cdByCast[id] = o end
        CRFRogue_WireCooldownDone(o)
    end
    CRFRogue_BuildCustomIcons(f)   -- the player's own spells / items (wired as they're made)
    ReconcileOrder(f)
    ReconcileLayout(f)
    LayoutIcons(f)   -- position only the learned abilities, in the saved order
    return f
end

-- A SEPARATE, independently movable pair of weapon buttons for poisons. Each shows the
-- equipped weapon's icon, red-pulses when that weapon is unpoisoned, and (via a secure
-- button) one-click applies a poison from your bags to that weapon.
local function BuildPoisonFrame(f)
    local pf = CreateFrame("Frame", nil, UIParent)
    pf:SetSize(ICON_SIZE * 2 + ICON_GAP, ICON_SIZE)
    pf:SetMovable(true)
    pf:SetClampedToScreen(true)

    -- A poison running out sends no reliable event, so normally it's caught by the 2s
    -- poll (up to 2s late). In a poison's last minutes (RR.poisonFastUntil, kept alive by
    -- UpdatePoisonIcon while the tooltip reads <= 2 min or seconds) re-check every 0.25s
    -- instead, so the seconds match the game and the icon turns red right away.
    pf:SetScript("OnUpdate", function(self, elapsed)
        if not RR.poisonFastUntil or GetTime() > RR.poisonFastUntil then return end
        self._acc = (self._acc or 0) + elapsed
        if self._acc < 0.25 then return end
        self._acc = 0
        CRFRogue_UpdatePoisons(f)
    end)

    local function MakeWeaponBtn(slot)
        local b = CreateFrame("Button", nil, pf, "SecureActionButtonTemplate")
        b:SetSize(ICON_SIZE, ICON_SIZE)
        b:RegisterForClicks("AnyDown")   -- fire once on press (both up+down = double-apply)
        b.slot = slot

        local border = b:CreateTexture(nil, "BACKGROUND")
        border:SetPoint("TOPLEFT", -1, 1); border:SetPoint("BOTTOMRIGHT", 1, -1)
        border:SetColorTexture(0, 0, 0, 1)
        local icon = b:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(b); icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        local red = b:CreateTexture(nil, "OVERLAY", nil, 4)
        red:SetAllPoints(b); red:SetColorTexture(1, 0, 0, 1); red:SetBlendMode("ADD"); red:Hide()
        RegisterPulse(red, 0.15, 0.55)   -- shared-clock pulse: MH/OH (and max-CP) stay in sync
        local mins = b:CreateFontString(nil, "OVERLAY")
        mins:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE"); mins:SetPoint("BOTTOM", 0, 1)

        b.icon, b.red, b.mins = icon, red, mins

        -- Stone badge: a small stone in the top corner with its own time. Sits above the
        -- red pulse, so a stone stays readable on a weapon with no poison.
        local stoneBorder = b:CreateTexture(nil, "OVERLAY", nil, 5)
        stoneBorder:SetSize(15, 15); stoneBorder:SetPoint("TOPRIGHT", 0, 0)
        stoneBorder:SetColorTexture(0, 0, 0, 1); stoneBorder:Hide()
        local stoneIcon = b:CreateTexture(nil, "OVERLAY", nil, 6)
        stoneIcon:SetSize(13, 13); stoneIcon:SetPoint("TOPRIGHT", -1, -1)
        stoneIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92); stoneIcon:Hide()
        local stoneMins = b:CreateFontString(nil, "OVERLAY")
        stoneMins:SetDrawLayer("OVERLAY", 6)
        stoneMins:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE"); stoneMins:SetPoint("TOPLEFT", 1, -1)
        b.stone = { icon = stoneIcon, border = stoneBorder, mins = stoneMins }

        -- Live countdown: when b.expiry (absolute GetTime) is set, tick the label down
        -- smoothly (minutes above 60s, seconds below), so it stays in sync with the buff
        -- instead of only refreshing on the 2s poll. Throttled to ~0.1s.
        b:SetScript("OnUpdate", function(self, elapsed)
            if not self.expiry then return end
            self._acc = (self._acc or 0) + elapsed
            if self._acc < 0.1 then return end
            self._acc = 0
            local rem = self.expiry - GetTime()
            -- Timed countdown (precise API expiry) in its last minute: keep the fast
            -- re-check running until a few seconds past the expected expiry, so the red
            -- "unpoisoned" state appears as soon as the enchant actually drops.
            if rem <= 60 then
                RR.poisonFastUntil = math.max(RR.poisonFastUntil or 0, self.expiry + 4)
            end
            if rem <= 0 then
                self.expiry = nil
                self.settleUntil = GetTime() + 3   -- brief window: ignore stale expiry-time blips
                self.mins:SetText("")
            else
                self.mins:SetText(rem >= 60 and (math.ceil(rem / 60) .. "m") or (math.floor(rem) .. "s"))
                if rem <= 120 then self.mins:SetTextColor(1, 0.5, 0.2) else self.mins:SetTextColor(1, 1, 1) end
            end
        end)

        -- Right-click opens the poison-choice menu (down only, once).
        b:SetScript("PostClick", function(self, button, down)
            if button == "RightButton" and down then OpenPoisonMenu(self) end
        end)

        -- Left-drag the pair to move it while unlocked; left-click (armed only when
        -- locked) applies the poison.
        b:RegisterForDrag("LeftButton")
        b:SetScript("OnDragStart", function() if not RogueResourcesDB.locked then pf:StartMoving() end end)
        b:SetScript("OnDragStop", function()
            pf:StopMovingOrSizing()
            local p, _, rp, x, y = pf:GetPoint()
            if p then RogueResourcesDB.poisonPos = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 } end
        end)
        return b
    end

    local mh = MakeWeaponBtn(MAINHAND_SLOT)
    mh:SetPoint("LEFT", pf, "LEFT", 0, 0)
    local oh = MakeWeaponBtn(OFFHAND_SLOT)
    oh:SetPoint("LEFT", mh, "RIGHT", ICON_GAP, 0)

    f.poisonFrame, f.mhPoison, f.ohPoison = pf, mh, oh
    return pf
end

function CRFRogue_ApplyPoisonPosition(f)   -- forward-declared above (options reset button uses it)
    local pos = RogueResourcesDB.poisonPos or RR.defaults.poisonPos
    if not f.poisonFrame then return end   -- not built yet (loaded mid-combat)
    f.poisonFrame:ClearAllPoints()
    f.poisonFrame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or 0)
end

local CRFRogue_BuildRiposte, CRFRogue_UpdateRiposte, CRFRogue_RiposteCast
do   -- Riposte proc block
-- ---------------------------------------------------------------------------
-- Riposte (Combat talent) can only be used for a few seconds after you parry, so
-- "Riposte is usable" is the proc. Its icon gets its own small movable spot (just above
-- the bars until you drag it), shown only while the proc is up, with blue comets and a
-- countdown of the window -- the same look as Clearcasting in Druid Resources. While
-- unlocked it stays visible so it can be dragged into place. Its size is set in the options.
-- ---------------------------------------------------------------------------
local RIPOSTE_ID = 14251
local RIPOSTE_WINDOW = 5   -- seconds Riposte stays usable after a parry

-- Only the icon grows, around the spot's centre, so resizing never moves it.
local function SizeRiposte(f)
    if not f.ripFrame then return end
    local size = RogueResourcesDB.ripSize or 1
    f.ripFrame:SetSize(ICON_SIZE * size, ICON_SIZE * size)
    f.ripIcon:SetScale(size)
end
RR.SizeRiposte = SizeRiposte   -- the options slider

local function RiposteKnown()
    return ((IsPlayerSpell and IsPlayerSpell(RIPOSTE_ID)) or (IsSpellKnown and IsSpellKnown(RIPOSTE_ID))) and true or false
end

-- Usable = you've just parried. Lacking the energy still counts (the parry happened).
local function RiposteUp()
    local ok, usable, noPower
    if C_Spell and C_Spell.IsSpellUsable then
        ok, usable, noPower = pcall(C_Spell.IsSpellUsable, RIPOSTE_ID)
    elseif IsUsableSpell then
        ok, usable, noPower = pcall(IsUsableSpell, RIPOSTE_ID)
    end
    if not ok or IsSecret(usable) or IsSecret(noPower) then return false end
    return (usable or noPower) and true or false
end

function CRFRogue_BuildRiposte(f)
    local rf = CreateFrame("Frame", nil, UIParent)
    rf:SetSize(ICON_SIZE, ICON_SIZE)
    rf:SetMovable(true)
    rf:SetClampedToScreen(true)
    rf:EnableMouse(false)   -- only interactive while unlocked
    rf:RegisterForDrag("LeftButton")
    rf:SetScript("OnDragStart", function(self) self:StartMoving() end)
    rf:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, rp, x, y = self:GetPoint()
        if p then RogueResourcesDB.ripPos = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 } end
    end)
    local o = MakeIcon(rf, SpellTex(RIPOSTE_ID))
    o:SetPoint("CENTER", rf, "CENTER")
    AddBorderFX(o, 0.35, 0.65, 1.0)   -- blue
    MakeBuffNumber(o)
    o:Hide()
    f.ripFrame, f.ripIcon = rf, o
    SizeRiposte(f)
end

-- The game keeps Riposte "usable" for the whole window, even after you've used it. So
-- the proc counts as spent once Riposte is cast, or once its window has run out, and stays
-- spent until Riposte stops being usable (the window really over). The next parry then
-- shows it again.
function CRFRogue_RiposteCast(f, spellID)
    local o = f.ripIcon
    if not (o and spellID == RIPOSTE_ID) then return end
    o.spent = true
    CRFRogue_UpdateRiposte(f)
end

function CRFRogue_UpdateRiposte(f)
    local o = f.ripIcon
    if not o then return end
    local known = RiposteKnown()
    local usable = known and RiposteUp()
    if not usable then
        o.spent = nil   -- window over: ready for the next parry
    elseif o.procOn and o.activeUntil and GetTime() > o.activeUntil + 0.5 then
        o.spent = true  -- safety: never past the window, whatever the game reports
    end
    local up = usable and not o.spent
    if up ~= (o.procOn or false) then
        o.procOn = up
        if up then o.activeUntil = GetTime() + RIPOSTE_WINDOW end
        o.shownSecs = nil
        if not up and o.buffText then o.buffText:SetText("") end
        SetBorderFX(o, up)
        o:SetScript("OnUpdate", up and ActiveOnUpdate or nil)
    end
    local preview = RR.ripPreviewUntil and GetTime() < RR.ripPreviewUntil
    o:SetShown(up or (known and not RogueResourcesDB.locked) or preview)
end

-- Place the Riposte spot: where you dragged it, or (the first time, and after "Reset
-- positions") just above the bars. Draggable while unlocked.
function CRFRogue_PlaceRiposte(f)   -- forward-declared above (lock / reset)
    local rf, db = f.ripFrame, RogueResourcesDB
    if not rf then return end
    if not db.ripPos then
        local x, top = f:GetCenter(), f:GetTop()   -- both frames share the UI scale
        if x and top then
            db.ripPos = { point = "CENTER", relativePoint = "BOTTOMLEFT", x = x,
                          y = top + 8 + ICON_SIZE * (db.ripSize or 1) / 2 }
        end
    end
    local pos = db.ripPos or { point = "CENTER", relativePoint = "CENTER", x = 0, y = -100 }
    rf:ClearAllPoints()
    rf:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    rf:EnableMouse(not db.locked)
    CRFRogue_UpdateRiposte(f)
end
end   -- Riposte proc block

local CRFRogue_BuildWellFed
do   -- Well Fed warning block
-- ---------------------------------------------------------------------------
-- Optional "WELL FED MISSING" warning at the top of the screen. Buffs can only be read
-- out of combat on this client and you can't eat in combat, so the warning hides when a
-- fight starts and the check runs again once it ends. "Dismiss" hides it until you're Well
-- Fed again (saved, so it survives a reload); the next time the buff is gone, it warns again.
-- ---------------------------------------------------------------------------
-- Food buffs: most are called "Well Fed" (matched by the game's own name and icon); a
-- few foods give a differently named buff, matched by spell ID.
local WELL_FED_ID = 19705
local WF_CONFIRM = 5   -- seconds the buff must stay missing before warning, so one bad read can't
local FOOD_BUFF_IDS = {
    [19705] = true, [19706] = true, [19708] = true, [19709] = true, [19710] = true,
    [19711] = true, [24799] = true, [24870] = true, [25694] = true,
    [18192] = true,   -- Grilled Squid (Agility)
    [18193] = true,   -- Spirit
    [18194] = true,   -- Nightfin Soup (mana regeneration)
    [18222] = true,   -- Poached Sunscale Salmon (health regeneration)
    [22730] = true,   -- Runn Tum Tuber Surprise (Intellect)
    [25661] = true,   -- Dirge's Kickin' Chimaerok Chops (Stamina)
}

-- One of the player's buffs: name, icon, spell ID (nil when there are no more).
local function BuffAt(i)
    if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        local a = C_UnitAuras.GetAuraDataByIndex("player", i, "HELPFUL")
        if a then return a.name, a.icon, a.spellId end
        return nil
    end
    if UnitAura then
        local name, icon, _, _, _, _, _, _, _, spellId = UnitAura("player", i, "HELPFUL")
        return name, icon, spellId
    end
end

-- true / false, or nil when it can't be told right now (in combat, or the food buff
-- could be one of the buffs whose details are hidden). A buff with hidden details is
-- skipped, not a reason to give up: a readable Well Fed further down still counts.
local function HasWellFed()
    if InCombatLockdown() or UnitAffectingCombat("player") then return nil end
    local wfName, wfIcon = SpellName(WELL_FED_ID), SpellTex(WELL_FED_ID)
    local unsure = false
    for i = 1, 40 do
        local ok, name, icon, spellId = pcall(BuffAt, i)
        if not ok then return nil end
        if not IsSecret(name) and name == nil then             -- no more buffs
            -- In instances the list can come back empty, which says nothing about the buff.
            if i == 1 and IsInInstance() then return nil end
            break
        end
        -- Check whichever details are readable; any that aren't leave us unsure.
        if not IsSecret(spellId) and spellId and FOOD_BUFF_IDS[spellId] then return true end
        if not IsSecret(name) and wfName and name == wfName then return true end
        if not IsSecret(icon) and wfIcon and icon == wfIcon then return true end
        if IsSecret(name) or IsSecret(icon) or IsSecret(spellId) then unsure = true end
    end
    if unsure then return nil end
    return false
end

function CRFRogue_BuildWellFed(f)
    local w = CreateFrame("Frame", nil, UIParent)
    w:SetSize(400, 70)
    w:SetPoint("TOP", UIParent, "TOP", 0, -150)
    w:SetFrameStrata("HIGH")
    w.text = w:CreateFontString(nil, "OVERLAY")
    w.text:SetFont("Fonts\\FRIZQT__.TTF", 26, "THICKOUTLINE")
    w.text:SetPoint("TOP", w, "TOP", 0, 0)
    w.text:SetTextColor(1, 0.45, 0.1)
    w.text:SetText(L.wellFedMissing)
    RegisterPulse(w.text, 0.55, 1)   -- gentle pulse, in sync with the other effects
    local b = CreateFrame("Button", nil, w, "UIPanelButtonTemplate")
    b:SetSize(90, 20)
    b:SetPoint("TOP", w.text, "BOTTOM", 0, -6)
    b:SetText(L.dismiss)
    b:SetScript("OnClick", function()
        RogueResourcesDB.wellFedDismissed = true
        w:Hide()
    end)
    w:Hide()
    f.wellFed = w
end

-- Is this spell one that gives a food buff ("Well Fed" by name, or a known food buff)?
local function IsFoodBuff(spellID)
    if FOOD_BUFF_IDS[spellID] then return true end
    local name, wfName = SpellName(spellID), SpellName(WELL_FED_ID)
    return (name and wfName and name == wfName) and true or false
end

-- `castID` (optional): a spell you just cast. Buffs can't be read in combat, but casts
-- can, so getting a food buff mid-fight clears the warning straight away instead of
-- only when the fight ends.
function CRFRogue_UpdateWellFed(f, castID)   -- forward-declared above (the options checkbox uses it)
    local w = f.wellFed
    if not w then return end
    local db = RogueResourcesDB
    if not db.wellFedWarn then w:Hide() return end
    local has
    if castID then
        if not IsFoodBuff(castID) then return end   -- some other spell: nothing to do
        has = true
    else
        has = HasWellFed()
    end
    if has == nil then w.missingSince = nil return end   -- can't tell right now: keep the current state
    if has then
        w.missingSince = nil
        db.wellFedDismissed = nil   -- fed again: the next drop warns again
    else
        local now = GetTime()
        w.missingSince = w.missingSince or now
        if not w:IsShown() and now - w.missingSince < WF_CONFIRM then return end
    end
    w:SetShown(not has and not db.wellFedDismissed and not UnitIsDeadOrGhost("player"))
end
end   -- Well Fed warning block

local function UpdateEnergy(f)
    local cur, max = GetEnergy()
    f.bar:SetMinMaxValues(0, max)
    f.bar:SetValue(cur)
    f.text:SetText(cur)
end

-- Health bar colour by health left: green when healthy, fading through orange at 50%
-- to full red at 20% and below.
local HP_GREEN  = { 0.18, 0.78, 0.22 }
local HP_ORANGE = { 1.00, 0.50, 0.08 }
local HP_RED    = { 0.90, 0.15, 0.12 }
local HP_LOW, HP_MID = 0.20, 0.50

local function Blend(a, b, t)
    return a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, a[3] + (b[3] - a[3]) * t
end

local function HealthColor(p)
    if p <= HP_LOW then return HP_RED[1], HP_RED[2], HP_RED[3] end
    if p < HP_MID then return Blend(HP_RED, HP_ORANGE, (p - HP_LOW) / (HP_MID - HP_LOW)) end
    return Blend(HP_ORANGE, HP_GREEN, math.min(1, (p - HP_MID) / (1 - HP_MID)))
end

-- The same green -> orange -> red scale as a colour curve, for the game's own
-- UnitHealthPercent to evaluate when health is hidden from addons. Built once; false if
-- this client has no colour curves.
local hpCurve
local function HealthCurve()
    if hpCurve == nil then
        hpCurve = false
        if C_CurveUtil and C_CurveUtil.CreateColorCurve and CreateColor then
            local ok, c = pcall(function()
                local c = C_CurveUtil.CreateColorCurve()
                if c.SetType and Enum and Enum.LuaCurveType then c:SetType(Enum.LuaCurveType.Linear) end
                c:AddPoint(0,      CreateColor(HP_RED[1], HP_RED[2], HP_RED[3]))
                c:AddPoint(HP_LOW, CreateColor(HP_RED[1], HP_RED[2], HP_RED[3]))
                c:AddPoint(HP_MID, CreateColor(HP_ORANGE[1], HP_ORANGE[2], HP_ORANGE[3]))
                c:AddPoint(1,      CreateColor(HP_GREEN[1], HP_GREEN[2], HP_GREEN[3]))
                return c
            end)
            if ok and c then hpCurve = c end
        end
    end
    return hpCurve or nil
end

local function SetHealthRGB(f, r, g, b)
    f.health:GetStatusBarTexture():SetVertexColor(r, g, b)
end

-- Colour the health bar by health left, by whichever route this client allows:
-- plain numbers -> our own maths; hidden health -> the game evaluates our colour curve;
-- failing that, the bar's fill width.
local function ColorHealth(f, hp, maxHp)
    if not (issecretvalue and (issecretvalue(hp) or issecretvalue(maxHp))) then
        if maxHp and maxHp > 0 then
            SetHealthRGB(f, HealthColor(math.max(0, math.min(1, hp / maxHp))))
        end
        return
    end
    local curve = UnitHealthPercent and HealthCurve()
    if curve then
        local ok = pcall(function()
            local color = UnitHealthPercent("player", false, curve)
            SetHealthRGB(f, color:GetRGB())
        end)
        if ok then return end
    end
    local w = f.health:GetStatusBarTexture():GetWidth()
    if issecretvalue(w) then return end
    SetHealthRGB(f, HealthColor(math.max(0, math.min(1, w / f.health:GetWidth()))))
end

-- Health values are handed to the bar and text untouched, so this stays safe even when
-- the client makes them secret.
function CRFRogue_UpdateHealth(f)   -- forward-declared above (the options checkbox uses it)
    if not f.health:IsShown() then return end
    local maxHp = UnitHealthMax("player")
    f.health:SetMinMaxValues(0, maxHp)
    local hp = UnitHealth("player")
    f.health:SetValue(hp)
    f.healthText:SetText(hp)
    -- Incoming heals (see BuildUI). Handed straight to the bar; a plain "none" (nil) is
    -- shown as 0, a hidden value is passed on untouched.
    local inc = f.health.incoming
    if inc then
        inc:SetMinMaxValues(0, maxHp)
        local amount = UnitGetIncomingHeals and UnitGetIncomingHeals("player")
        if IsSecret(amount) then
            inc:SetValue(amount)
        else
            inc:SetValue(amount or 0)
        end
    end
    ColorHealth(f, hp, maxHp)
    -- Re-check once on the next frame, after the bar has settled.
    f.health:SetScript("OnUpdate", function(self)
        self:SetScript("OnUpdate", nil)
        ColorHealth(f, hp, maxHp)
    end)
end

local function UpdateCP(f, retarget)
    -- SetValue is whitelisted to accept a secret value; we pass GetCP() through with
    -- no comparison, arithmetic, or boolean test, so this stays taint-safe. The same value
    -- drives the max-CP cue bars (they only fill at MAX_CP).
    local v = GetCP()
    f.cp:SetValue(v)
    MeasureCP(v, retarget)
    if f.cpMax then
        for _, s in ipairs(f.cpMax) do s:SetValue(v) end
    end
end

-- Format a remaining time (seconds) as "Nm" above a minute, "Ns" below it. Under two
-- minutes it's tinted orange as a low warning.
local function SetPoisonTime(o, sec)
    if sec and sec > 0 then
        -- Same rounding as the game's buff timers: minutes up, seconds down.
        if sec >= 60 then
            o.mins:SetText(math.ceil(sec / 60) .. "m")
        else
            o.mins:SetText(math.floor(sec) .. "s")
        end
        if sec <= 120 then o.mins:SetTextColor(1, 0.5, 0.2) else o.mins:SetTextColor(1, 1, 1) end
    else
        o.mins:SetText("")
    end
end

-- Set the countdown target (absolute GetTime) from a fresh remaining-seconds reading, but
-- keep it smooth and blip-proof: while a timer is already running we ignore any SHORT
-- (< 5 min) reading that isn't a clean decrease -- that covers the per-poll jitter AND the
-- stale "~60s" value the client emits right at expiry. Only a full reapplication (which
-- restores minutes of duration) restarts the timer. The per-frame OnUpdate does the ticking.
local POISON_REFRESH_MIN = 300   -- seconds; a reading at/above this is treated as a reapply
local function SetPoisonExpiry(o, cand)
    if cand < POISON_REFRESH_MIN then
        if o.expiry then
            local cur = o.expiry - GetTime()
            if cand > cur - 1 then return end          -- not a genuine tick-down: keep the timer
        elseif o.settleUntil and GetTime() < o.settleUntil then
            return                                      -- just expired: ignore stale short readings
        end
    end
    o.expiry = GetTime() + cand
    o.settleUntil = nil
    SetPoisonTime(o, cand)
end

-- The time in an enchant's tooltip line: the number, and whether it's in minutes. Read from
-- the bracket that holds it, e.g. "(45 sec)" / "(12 min)", never from the enchant's name
-- ("Mind-numbing" contains "min", "Sharpened +2" a number).
function RR.EnchantTime(tip)
    local timeText
    for inner in tip:gmatch("%(([^%)]*)%)") do
        if inner:find("%d") then timeText = inner break end
    end
    timeText = timeText or tip
    return tonumber(timeText:match("(%d+)")), timeText:find("[Mm]in") ~= nil
end

function RR.UpdateStoneBadge(o, tip, secs)
    if not o then return end
    local s = o.stone
    local shown = (tip or secs) and true or false
    s.icon:SetShown(shown); s.border:SetShown(shown)
    if not shown then s.lastSecs = nil; s.mins:SetText("") return end
    s.icon:SetTexture(RR.stoneIcon[RR.StoneGroup(o.slot)])
    if secs then                                       -- exact, from the enchant API
        s.lastSecs = nil
        SetPoisonTime(s, secs)
        if secs <= 120 then RR.poisonFastUntil = GetTime() + 3 end
        return
    end
    local n, isMin = RR.EnchantTime(tip)
    if n and not isMin then
        -- As with poisons: the tooltip's seconds round up, the buff timer's down, and a jump
        -- up is a stale blip right at expiry.
        if not (s.lastSecs and n > s.lastSecs + 1) then
            s.lastSecs = n
            s.mins:SetText(math.max(n - 1, 0) .. "s")
            s.mins:SetTextColor(1, 0.5, 0.2)
        end
        RR.poisonFastUntil = GetTime() + 3
    elseif n then
        if not (s.lastSecs and n <= 2) then            -- a small value after seconds is stale
            s.lastSecs = nil
            SetPoisonTime(s, n * 60)
        end
        if n <= 2 then RR.poisonFastUntil = GetTime() + 3 end
    else
        s.lastSecs = nil
        s.mins:SetText("")
    end
end

local function UpdatePoisonIcon(o, on, exp, tip)
    if not o then return end
    o.icon:SetTexture(WeaponTex(o.slot) or FALLBACK_WEAPON_TEX)
    if on then
        o.red:Hide()   -- the shared pulse driver only animates it while shown
        o.icon:SetVertexColor(1, 1, 1)
        if exp and not IsSecret(exp) and exp > 0 then
            o.lastSecs = nil
            SetPoisonExpiry(o, exp / 1000)            -- precise remaining from the enchant API (ms)
        elseif tip then
            local n, isMin = RR.EnchantTime(tip)
            if n and not isMin then
                -- Last minute ("N sec", or a bare number): show the tooltip's own number.
                -- It's re-read every 0.25s in this phase (the fast re-check), so it tracks
                -- the game's timer exactly. Seconds only ever count DOWN until the poison
                -- ends (a reapplication reads minutes), so a jump up is a stale blip right
                -- at expiry -- ignore it.
                if not (o.lastSecs and n > o.lastSecs + 1) then
                    o.lastSecs = n
                    o.expiry = nil
                    -- The tooltip rounds its seconds UP while the game's buff-area timer
                    -- rounds DOWN, so it reads one second high; show one less to match
                    -- the buff timer (0s in the final second, like Slice and Dice).
                    o.mins:SetText(math.max(n - 1, 0) .. "s")
                    o.mins:SetTextColor(1, 0.5, 0.2)
                end
                RR.poisonFastUntil = GetTime() + 3
            elseif n then
                -- Minutes, straight from the tooltip. Coming out of the seconds phase, a
                -- small minute value is a stale reading (a real reapplication reads many
                -- minutes); likewise during the settle window after a timed expiry.
                local stale = (o.lastSecs and n <= 2)
                    or (o.settleUntil and GetTime() < o.settleUntil and n < 5)
                if not stale then
                    o.lastSecs = nil
                    o.expiry = nil
                    SetPoisonTime(o, n * 60)
                end
                -- In the last couple of minutes, re-check fast so the switch to seconds
                -- (and everything after it) shows up right away.
                if n <= 2 then RR.poisonFastUntil = GetTime() + 3 end
            else
                o.expiry = nil
                o.mins:SetText("")
            end
        else
            o.expiry = nil
            o.mins:SetText("")
        end
    else
        o.expiry = nil
        o.settleUntil = nil
        o.lastSecs = nil
        o.icon:SetVertexColor(1, 0.35, 0.35)
        o.mins:SetText("")
        o.red:Show()
    end
end

function CRFRogue_UpdatePoisons(f)   -- forward-declared above (the poison icons' fast re-check uses it)
    if not f.poisonFrame then return end
    -- Below level 20 (no Poisons skill) there's nothing to track: keep the frame hidden.
    -- Secure-frame Show/Hide is only allowed out of combat, so gate on that.
    local inCombat = InCombatLockdown and InCombatLockdown()
    if not PoisonsAvailable() then
        if not inCombat then f.poisonFrame:Hide() end
        return
    end
    local res = { pcall(GetWeaponEnchantInfo) }   -- ok, hasMH, mhExp, mhChg, mhID, hasOH, ohExp, ...
    -- The API reports only one enchant per weapon, so the tooltip, which lists both, says
    -- what's on it. Charges prove a poison, but no charges prove nothing: not every poison
    -- has them. The API's exact time is used only when it can't belong to the other enchant.
    local function ShowWeapon(o, slot, has, exp, chg)
        local tip, stoneTip = WeaponEnchantText(slot)
        local charged = has and not IsSecret(chg) and (chg or 0) > 0
        if charged and not tip then tip, stoneTip = stoneTip, nil end   -- a poison we couldn't name
        local stoneSecs
        if stoneTip and not tip and has and exp and not IsSecret(exp) and exp > 0 then
            stoneSecs = exp / 1000
        end
        UpdatePoisonIcon(o, (tip ~= nil) or (has and not stoneTip), (charged or not stoneTip) and exp or nil, tip)
        RR.UpdateStoneBadge(o, stoneTip, stoneSecs)
    end
    ShowWeapon(f.mhPoison, MAINHAND_SLOT, res[1] and res[2], res[3], res[4])
    ShowWeapon(f.ohPoison, OFFHAND_SLOT, res[1] and res[6], res[7], res[8])
    -- Secure-frame changes (Show/Hide, attributes) are only allowed out of combat.
    if not inCombat then
        f.poisonFrame:SetShown(not RogueResourcesDB.poisonHidden)   -- respect the user's toggle
        f.ohPoison:SetShown(HasWeapon(OFFHAND_SLOT))   -- hide OH when not dual-wielding
        ArmPoisonButton(f.mhPoison)
        ArmPoisonButton(f.ohPoison)
    end
end

-- Cooldowns are tracked by the ability's CAST, not by polling: polling GetSpellCooldown
-- picks up the 1.5s global cooldown too (which is SECRET in combat, so it can't be
-- filtered out), making on-GCD abilities like Kick misbehave. Instead, when a tracked
-- spell is cast we read ITS cooldown once and start the swipe. The value may be plain or
-- secret; SetCooldown accepts both. The swipe runs to completion so OnCooldownDone fires
-- the ready-flash (we never Clear() it mid-run, which would preempt the flash).
-- Display a spell's cooldown on the icon. In-combat cooldown values are SECRET and plain
-- SetCooldown rejects them, so we use the sanctioned secret-safe path:
-- C_Spell.GetSpellCooldownDuration -> a Duration object -> SetCooldownFromDurationObject.
-- Falls back to plain SetCooldown only when that API is missing (readable values).
function CRFRogue_SetCooldownSwipe(o, id)   -- forward-declared above (BuildUI's cooldown-done uses it)
    -- Custom items: the item's own cooldown (SetCooldown takes it plain or secret); if
    -- that can't be shown, fall back to the item's use spell below.
    if o.itemID then
        local start, dur = GetItemCD(o.itemID)
        if start and pcall(o.cd.SetCooldown, o.cd, start, dur) then return true end
        id = o.ids and o.ids[1]
        if not id then return false end
    end
    if C_Spell and C_Spell.GetSpellCooldownDuration and o.cd.SetCooldownFromDurationObject then
        local d = C_Spell.GetSpellCooldownDuration(id)
        if d then
            local ok = pcall(o.cd.SetCooldownFromDurationObject, o.cd, d)
            if ok then return true end
        end
    end
    local start, dur = GetCooldown(id)
    return pcall(o.cd.SetCooldown, o.cd, start, dur)
end

-- A spell's cooldown as plain values: duration, and whether it's actually ticking
-- (false while it waits, e.g. Stealth's while you're stealthed). nil if secret/unknown.
local function PlainCooldown(id)
    local dur, enabled
    if C_Spell and C_Spell.GetSpellCooldown then
        local info = C_Spell.GetSpellCooldown(id)
        if info then dur, enabled = info.duration, info.isEnabled end
    elseif GetSpellCooldown then
        local _, d, e = GetSpellCooldown(id)
        dur, enabled = d, (e ~= 0 and e ~= false)
    end
    if dur == nil or IsSecret(dur) or IsSecret(enabled) then return nil end
    return dur, enabled ~= false
end

-- Has this spell's real cooldown started (ticking, and longer than a global cooldown)?
-- nil when it can't be told (secret values).
local function CooldownStarted(id)
    local dur, ticking = PlainCooldown(id)
    if dur == nil then return nil end
    return ticking and dur > 1.5
end

local function StartCooldownSwipe(o, castID)
    -- Defer a frame so the cooldown is registered after the cast succeeds.
    C_Timer.After(0.05, function()
        -- When the cooldown can be read (plain values; items show their own cooldown):
        if not o.itemID then
            local dur, ticking = PlainCooldown(castID)
            if dur and not ticking then
                -- Paused until something ends, e.g. Stealth's starts when stealth breaks:
                -- wait for it (see CheckPendingCooldowns).
                o.pendingCD, o.running = castID, false
                if o.cd.Clear then o.cd:Clear() end
                return
            end
            -- No real cooldown at all (just the global one, e.g. a custom Sinister
            -- Strike): nothing to show, and no "ready" flash.
            if dur and dur <= 1.5 then return end
        end
        o.running = true
        CRFRogue_SetCooldownSwipe(o, castID)
    end)
end

-- Start the swipe on icons whose cooldown began after the cast. Called when stealth
-- breaks (the cooldown starts then, so no reading is needed) and on cooldown updates
-- (once it's actually ticking and longer than a global cooldown).
local function CheckPendingCooldowns(f, stealthEnded)
    if not f.cooldowns then return end
    for _, o in ipairs(f.cooldowns) do
        local id = o.pendingCD
        if id then
            if stealthEnded or CooldownStarted(id) then
                o.pendingCD = nil
                o.running = true
                CRFRogue_SetCooldownSwipe(o, id)
            end
        end
    end
end

-- At login, catch any tracked ability ALREADY on cooldown. Uses the Duration object's
-- IsZero() to tell whether it's on cooldown (gated by HasSecretValues so a secret can't
-- throw); a secret value means we can't tell, so assume it's running and show it.
local function PollCooldown(o)
    if o.running then return end
    if o.itemID then
        -- Items: on cooldown if its duration is longer than a global cooldown (a secret
        -- value means we can't tell, so show it).
        local ok, onCD = pcall(function()
            local _, dur = GetItemCD(o.itemID)
            if IsSecret(dur) then return true end
            return (dur or 0) > 1.5
        end)
        if ok and onCD then
            o.running = true
            CRFRogue_SetCooldownSwipe(o)
        end
        return
    end
    if not o.ids then return end
    if not (C_Spell and C_Spell.GetSpellCooldownDuration) then return end
    for _, id in ipairs(o.ids) do
        local d = C_Spell.GetSpellCooldownDuration(id)
        if d then
            local ok, onCD = pcall(function()
                if d.HasSecretValues and d:HasSecretValues() then return true end
                if d.IsZero then return not d:IsZero() end
                return false
            end)
            if ok and onCD then
                o.running = true
                CRFRogue_SetCooldownSwipe(o, id)
                return
            end
        end
    end
end

local function PollCooldowns(f)
    if not f.cooldowns then return end
    for _, o in ipairs(f.cooldowns) do PollCooldown(o) end
end

-- Start the SnD countdown from an estimated (non-secret) duration.
local function StartSnD(f, dur)
    f.snd:SetAlpha(1)
    f.snd.expires = GetTime() + dur   -- OnUpdate dims at this time
    f.snd.cd:SetCooldown(GetTime(), dur)
end

-- Reset to the inactive (dim) state; used at login before any cast.
local function StopSnD(f)
    f.snd:SetAlpha(0.35)
    f.snd.expires = nil
    if f.snd.cd.Clear then f.snd.cd:Clear() end
end

function CRFRogue_ApplyPosition(f)   -- forward-declared above (options reset button uses it)
    local pos = RogueResourcesDB.position or RR.defaults.position
    f:ClearAllPoints()
    f:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or 0)
end

-- Show/hide the health, energy and combo-point bars per the options and stack the shown
-- ones in the saved order. The frame keeps a FIXED height (room for all three bars) and
-- the stack sits on its bottom edge, so the cooldown icons below never move when a bar is
-- turned on or off; the bars just grow or shrink upward. The backing panel refits around
-- the shown bars.
function CRFRogue_ApplyBarVisibility(f)   -- forward-declared above (the options checkboxes use it)
    local bars     = { cp = f.cp, energy = f.bar, health = f.health }
    local outlines = { cp = f.cpOutline, energy = f.barOutline, health = f.healthOutline }
    local order = BarOrder()
    local top, below   -- topmost shown bar, and the bar placed just before (beneath) it
    local bottom
    for idx = #order, 1, -1 do   -- bottom-up
        local k = order[idx]
        local b, show = bars[k], BarShown(k)
        b:SetShown(show); outlines[k]:SetShown(show)
        if show then
            b:ClearAllPoints()
            if below then
                b:SetPoint("BOTTOM", below, "TOP", 0, GAP)
            else
                b:SetPoint("BOTTOM", f, "BOTTOM", 0, 0)
                bottom = b
            end
            below, top = b, b
        end
    end
    -- Icons placed above the bars sit on the topmost shown bar, so re-place them.
    f.topBar = top
    if RogueResourcesDB.layout and RogueResourcesDB.layout.above then LayoutIcons(f) end
    f.panel:SetShown(top ~= nil); f.panelOutline:SetShown(top ~= nil)
    if top then
        f.panel:ClearAllPoints()
        f.panel:SetPoint("TOPLEFT", top, "TOPLEFT", -1, 1)
        f.panel:SetPoint("BOTTOMRIGHT", bottom, "BOTTOMRIGHT", 1, -1)
    end
end

-- "Show only in combat": hide the bars + icons outside combat. They still show while
-- unlocked or while the layout editor is open, so they can be positioned and previewed. The poison icons are NOT affected
-- (poisons are applied out of combat; they keep their own toggle).
local inCombat = false
function CRFRogue_UpdateCombatVisibility(f)   -- forward-declared above
    local show = not RogueResourcesDB.combatOnly or inCombat
        or not RogueResourcesDB.locked or RR.editing
    f:SetShown(show and true or false)
end

function CRFRogue_SetLocked(f, locked)   -- forward-declared above (options Lock button uses it)
    RogueResourcesDB.locked = locked
    f:EnableMouse(not locked)
    -- Icons take the mouse while unlocked (dragging one moves the tracker); locked, clicks
    -- pass straight through them.
    for _, o in ipairs(f.icons) do o:EnableMouse(not locked) end
    if locked then
        f.bar:SetStatusBarColor(1.0, 0.85, 0.10)
    else
        f.bar:SetStatusBarColor(0.10, 0.60, 1.00)   -- blue tint = "movable"
        print("|cff00ff88RogueResources:|r unlocked - drag the bars or cooldown icons to move the tracker, and the poison icons; /rr lock when done.")
    end
    CRFRogue_UpdatePoisons(f)   -- (dis)arm the click-to-apply macros for the new lock state
    CRFRogue_PlaceRiposte(f)             -- its own spot shows (and drags) while unlocked
    CRFRogue_UpdateCombatVisibility(f)   -- unlocked always shows (so it can be moved)
end

-- ---------------------------------------------------------------------------
-- Wiring
-- ---------------------------------------------------------------------------
local frame
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")   -- DB is seeded here; SVs aren't ready at ADDON_LOADED
-- This client runs the retail engine: energy AND combo points are both player
-- powers delivered through UNIT_POWER_UPDATE (the classic UNIT_COMBO_POINTS event
-- doesn't exist here and errors on registration). UNIT_POWER_FREQUENT carries the
-- smooth energy-regen ticks. PLAYER_TARGET_CHANGED is kept only to redraw on
-- retarget, since CP now lives on the player, not the target.
ev:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
ev:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
ev:RegisterUnitEvent("UNIT_HEALTH", "player")      -- optional health bar
ev:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
pcall(ev.RegisterUnitEvent, ev, "UNIT_HEAL_PREDICTION", "player")   -- incoming heals
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
-- UNIT_SPELLCAST_SUCCEEDED reports the non-secret cast spellID -- the trigger for BOTH
-- the SnD estimate and the cooldown swipes.
ev:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
-- Cooldowns that start after their cast (Stealth starts when stealth breaks).
pcall(ev.RegisterEvent, ev, "UPDATE_STEALTH")
ev:RegisterEvent("SPELL_UPDATE_COOLDOWN")
-- Re-lay-out the icon row when spells are learned/leveled, so newly-learned abilities
-- (Vanish, Blade Flurry, Adrenaline Rush, ...) appear and unknown ones stay hidden.
ev:RegisterEvent("SPELLS_CHANGED")
-- Reveal the poison tracker when the rogue reaches the level that unlocks Poisons.
ev:RegisterEvent("PLAYER_LEVEL_UP")
-- Entering / leaving combat, for the "Show only in combat" option.
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
-- Buff changes, death and coming back to life: the optional Well Fed warning.
ev:RegisterUnitEvent("UNIT_AURA", "player")
ev:RegisterEvent("PLAYER_DEAD")
ev:RegisterEvent("PLAYER_ALIVE")
ev:RegisterEvent("PLAYER_UNGHOST")
-- Weapon poison changes: applying/removing a poison and swapping weapons.
ev:RegisterEvent("UNIT_INVENTORY_CHANGED")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
-- Localized poison names resolve from item ids as those items get cached.
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
pcall(ev.RegisterEvent, ev, "BAG_UPDATE_DELAYED")   -- custom items entering / leaving the bags
-- Talent changes (re-detect Improved Slice and Dice). Not every client has all of these,
-- and registering an unknown event errors, so each is pcall-guarded.
local TALENT_EVENTS = { "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED",
                        "TRAIT_CONFIG_UPDATED", "TRAIT_NODE_CHANGED" }
local isTalentEvent = {}
for _, e in ipairs(TALENT_EVENTS) do
    isTalentEvent[e] = true
    pcall(ev.RegisterEvent, ev, e)
end
-- Belt-and-suspenders: persist the frame position on logout/reload too, so it never
-- reverts even if an OnDragStop was somehow missed.
ev:RegisterEvent("PLAYER_LOGOUT")

ev:SetScript("OnEvent", function(self, event, arg1, arg2, arg3)
    if event == "PLAYER_LOGIN" then
        -- Rogue-only: this addon tracks rogue resources, so on any other class we build
        -- nothing and drop all events (the folder can sit installed on an alt harmlessly).
        local _, class = UnitClass("player")
        if class ~= "ROGUE" then
            self:UnregisterAllEvents()
            return
        end
        -- Seed the DB HERE, not at ADDON_LOADED: on this client SavedVariables aren't
        -- loaded until after ADDON_LOADED, so touching the global that early would
        -- replace it with defaults and make the client skip loading the real saved
        -- data. By PLAYER_LOGIN the saved values are present.
        local freshInstall = (RogueResourcesDB == nil)
        RogueResourcesDB = ApplyDefaults(RR.defaults, RogueResourcesDB)
        -- One time only: the bar frame grew taller (room for the health bar). Move an older
        -- saved position so the frame's bottom edge, and the icon row under it, stays where
        -- it was. Fresh installs start on the new layout and skip this.
        if not RogueResourcesDB.tallFrame then
            local pos = RogueResourcesDB.position
            if not freshInstall and pos and pos.point then
                local d = FRAME_H - OLD_FRAME_H
                if pos.point:find("TOP") then
                    pos.y = (pos.y or 0) + d
                elseif not pos.point:find("BOTTOM") then
                    pos.y = (pos.y or 0) + d / 2
                end
            end
            RogueResourcesDB.tallFrame = true
        end
        RogueResourcesDB.sndAuto = nil         -- retired settings: the talent rank is always
        RogueResourcesDB.minimapHidden = nil   -- read now, and the minimap button always shows
        RefreshSpellSets()      -- re-resolve spell names now that the spellbook is loaded
        RefreshPoisonNames()    -- re-resolve localized poison names
        UpdateAutoSndMult()     -- detect the Improved Slice and Dice talent rank
        frame = BuildUI()
        CRFRogue_BuildRiposte(frame)         -- the Riposte proc's own spot (placed by CRFRogue_SetLocked below)
        CRFRogue_BuildWellFed(frame)         -- the optional "Well Fed missing" warning
        BuildSettingsPanel(frame)   -- register the Options -> AddOns panel up front
        BuildMinimapButton(frame)
        RegisterAddonCompartment(frame)
        ApplyScale(frame)
        CRFRogue_ApplyPosition(frame)
        -- The poison buttons are secure frames, which the game won't let addons create or
        -- place mid-combat (a /reload in a fight): then build them once combat ends.
        local function SetupPoisonFrame()
            BuildPoisonFrame(frame)
            ApplyScale(frame)
            CRFRogue_ApplyPoisonPosition(frame)
            frame.poisonFrame:SetShown(PoisonsAvailable() and not RogueResourcesDB.poisonHidden)
            CRFRogue_UpdatePoisons(frame)
        end
        if InCombatLockdown and InCombatLockdown() then
            local waiter = CreateFrame("Frame")
            waiter:RegisterEvent("PLAYER_REGEN_ENABLED")
            waiter:SetScript("OnEvent", function(w)
                w:UnregisterAllEvents()
                SetupPoisonFrame()
            end)
        else
            SetupPoisonFrame()
        end
        CRFRogue_ApplyBarVisibility(frame)   -- health / energy / combo bar toggles and order
        CRFRogue_UpdateHealth(frame)
        inCombat = UnitAffectingCombat("player") and true or false   -- e.g. /reload mid-fight
        CRFRogue_SetLocked(frame, RogueResourcesDB.locked)   -- also applies "only in combat"
        UpdateEnergy(frame)
        UpdateCP(frame)
        StopSnD(frame)   -- start inactive until the first SnD cast
        PollCooldowns(frame)   -- catch anything already on cooldown at login
        CRFRogue_UpdatePoisons(frame)
        CRFRogue_UpdateWellFed(frame)
        -- Poll poisons periodically: expiry has no event, so keep the timer/state fresh.
        if C_Timer and C_Timer.NewTicker then
            C_Timer.NewTicker(2, function()
                if frame then CRFRogue_UpdatePoisons(frame); CRFRogue_UpdateWellFed(frame); CRFRogue_UpdateHealth(frame) end
            end)
            -- A parry sends no event addons can use, so check for the Riposte proc often.
            C_Timer.NewTicker(0.1, function() if frame then CRFRogue_UpdateRiposte(frame) end end)
        end
        return
    end

    if event == "PLAYER_LOGOUT" then
        if frame then
            local p, _, rp, x, y = frame:GetPoint()
            if p then RogueResourcesDB.position = { point = p, relativePoint = rp, x = x, y = y } end
        end
        return
    end

    if not frame then return end
    if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_HEAL_PREDICTION" then
        CRFRogue_UpdateHealth(frame)
    elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then
        UpdateEnergy(frame)
        UpdateCP(frame)   -- retail carries CP as a player power, so refresh both
    elseif event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
        inCombat = (event == "PLAYER_REGEN_DISABLED")
        if not inCombat then
            CRFRogue_UpdateWellFed(frame)   -- buffs readable again
            -- Health is readable again too: re-colour the health bar now, or a colour from
            -- mid-fight could stick when you're already at full health (no change, no event).
            CRFRogue_UpdateHealth(frame)
        elseif frame.wellFed then
            frame.wellFed:Hide()   -- nothing to do about it mid-fight
        end
        CRFRogue_UpdateCombatVisibility(frame)
    elseif event == "UNIT_AURA" or event == "PLAYER_DEAD" or event == "PLAYER_ALIVE"
        or event == "PLAYER_UNGHOST" then
        CRFRogue_UpdateWellFed(frame)
    elseif event == "SPELLS_CHANGED" then
        LayoutIcons(frame)      -- show/hide icons as abilities are learned
        if frame.layoutEditor and frame.layoutEditor:IsShown() then frame.layoutEditor.Refresh() end
        PollCooldowns(frame)    -- catch any newly-known ability already on cooldown
        UpdateAutoSndMult()     -- talents change spells too; re-detect the SnD rank
        CRFRogue_RefreshOptions(frame)   -- keep the options button caption current
    elseif isTalentEvent[event] then
        LayoutIcons(frame)      -- talent abilities (Cold Blood, ...) may have appeared
        UpdateAutoSndMult()
        CRFRogue_RefreshOptions(frame)
    elseif event == "UNIT_INVENTORY_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED"
        or event == "PLAYER_LEVEL_UP" then
        CRFRogue_UpdatePoisons(frame)   -- poison applied/removed, weapon swapped, or hit level 20
        if event == "PLAYER_EQUIPMENT_CHANGED" then LayoutIcons(frame) end   -- custom trinkets etc.
    elseif event == "BAG_UPDATE_DELAYED" then
        LayoutIcons(frame)     -- custom items gained / used up
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        RefreshPoisonNames()   -- a poison item cached; localized names are now available
        CRFRogue_UpdatePoisons(frame)
        CRFRogue_RefreshCustomItems(frame)   -- custom item names / icons / use spells
    elseif event == "UPDATE_STEALTH" then
        -- Leaving stealth starts Stealth's cooldown; give the game a moment to register it.
        if not (IsStealthed and IsStealthed()) then
            C_Timer.After(0.1, function() CheckPendingCooldowns(frame, true) end)
        end
    elseif event == "SPELL_UPDATE_COOLDOWN" then
        CheckPendingCooldowns(frame)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdateCP(frame, true)   -- reads the new target's points; not a spend
        cpEstimate = 0   -- combo points are per-target on this build; reset the count
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        -- arg3=spellID for SUCCEEDED (unit, castGUID, spellID); safe to index.
        if arg3 then
            CRFRogue_RiposteCast(frame, arg3)   -- using Riposte ends its proc icon
            CRFRogue_UpdateWellFed(frame, arg3) -- a food buff landing mid-fight clears the warning
            -- Cooldown swipe and combo-point logic are independent -- Kidney Shot, for
            -- example, is both a tracked cooldown AND a finisher, so run both.
            local cdIcon = frame.cdByCast and frame.cdByCast[arg3]
            if not cdIcon and frame.cdByName and next(frame.cdByName) then
                cdIcon = frame.cdByName[SpellName(arg3) or ""]   -- racial fallback (see BuildUI)
            end
            if cdIcon then
                if cdIcon.activeDur then
                    StartActive(cdIcon, arg3)         -- buff first, then the cooldown
                else
                    StartCooldownSwipe(cdIcon, arg3)
                end
            end
            if SND_CAST_IDS[arg3] then
                StartSnD(frame, CP_DURATION[SndComboPoints()] * EffectiveSndMult())
                cpEstimate = 0   -- finisher spent the combo points
            else
                local name = SpellName(arg3)
                if name then
                    if BUILDERS[name] then
                        cpEstimate = cpEstimate + BUILDERS[name]
                        if cpEstimate > 5 then cpEstimate = 5 end
                    elseif FINISHERS[name] then
                        cpEstimate = 0
                    end
                end
            end
        end
    end
end)

-- ---------------------------------------------------------------------------
-- Slash command: /rr lock | unlock
-- ---------------------------------------------------------------------------
SLASH_ROGUERESOURCES1 = "/rr"
SlashCmdList.ROGUERESOURCES = function(msg)
    if not frame then return end
    msg = (msg or ""):lower():gsub("%s+", "")
    if msg == "lock" then
        CRFRogue_SetLocked(frame, true)
        CRFRogue_RefreshOptions(frame)
    elseif msg == "unlock" then
        CRFRogue_SetLocked(frame, false)
        CRFRogue_RefreshOptions(frame)
    elseif msg == "options" or msg == "config" or msg == "" then
        ToggleOptions(frame)
    elseif msg == "layout" or msg == "arrange" then
        CRFRogue_ToggleLayoutEditor(frame)
    elseif msg == "showall" then
        -- Testing aid: lay out every icon as if all abilities were learned. Not saved, so
        -- a /reload turns it off.
        RR.showAll = not RR.showAll or nil
        LayoutIcons(frame)
        if frame.layoutEditor and frame.layoutEditor:IsShown() then frame.layoutEditor.Refresh() end
        print("|cff00ff88RogueResources:|r show all icons " ..
            (RR.showAll and "ON (testing; /rr showall or /reload to turn off)." or "OFF."))
    elseif msg == "poison" or msg == "poisons" then
        if InCombatLockdown and InCombatLockdown() then
            print("|cff00ff88RogueResources:|r can't toggle poison icons in combat.")
        else
            RogueResourcesDB.poisonHidden = not RogueResourcesDB.poisonHidden
            if frame.poisonFrame then
                frame.poisonFrame:SetShown(PoisonsAvailable() and not RogueResourcesDB.poisonHidden)
            end
            CRFRogue_RefreshOptions(frame)
            if not PoisonsAvailable() then
                print(("|cff00ff88RogueResources:|r poison preference saved; the tracker appears at level %d.")
                    :format(POISON_MIN_LEVEL))
            else
                print("|cff00ff88RogueResources:|r poison icons " ..
                    (RogueResourcesDB.poisonHidden and "hidden." or "shown."))
            end
        end
    elseif msg:match("^scale") then
        local n = tonumber(msg:match("scale(%d+%.?%d*)"))
        if n then
            n = math.max(SCALE_MIN, math.min(SCALE_MAX, n))
            RogueResourcesDB.scale = n
            ApplyScale(frame)
            CRFRogue_RefreshOptions(frame)   -- reflect the new value in any open options view
            print(("|cff00ff88RogueResources:|r scale set to %d%%."):format(math.floor(n * 100 + 0.5)))
        else
            print(("|cff00ff88RogueResources:|r current scale %d%%. Usage: /rr scale 1.25 (%d-%d%%)."):format(
                math.floor((RogueResourcesDB.scale or 1) * 100 + 0.5),
                math.floor(SCALE_MIN * 100), math.floor(SCALE_MAX * 100)))
        end
    elseif msg:match("^sndmult") then
        -- Fallback only: the detected talent rank always wins when it can be read.
        local n = tonumber(msg:match("sndmult(%d+%.?%d*)"))
        if n and n > 0 then
            RogueResourcesDB.sndMult = n
            print("|cff00ff88RogueResources:|r fallback Improved SnD multiplier set to " .. MultText(n) .. ".")
        end
        UpdateAutoSndMult()
        print("|cff00ff88RogueResources:|r Slice and Dice multiplier " .. MultText(EffectiveSndMult()) ..
            (RR.autoSndMult and " (from talent)." or " (talent not readable, using fallback). Usage: /rr sndmult 1.30"))
    else
        print("|cff00ff88RogueResources:|r /rr options | layout | unlock | lock | poison | scale <0.5-2.0>")
    end
end
