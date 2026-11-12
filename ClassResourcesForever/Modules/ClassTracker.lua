-- ClassResourcesForever.lua
-- Copyright (c) 2026 Konchius. All rights reserved. See LICENSE.
--
-- A form-aware resource and cooldown tracker for classes on the WoW: Forever client:
--   * a mana bar that stays in the same place in every form, with its value;
--   * a rage / energy bar in Bear / Cat Form;
--   * a combo-point bar in Cat Form (with the 5th-point highlight);
--   * cooldown icons per form, each form with its own arrangement.
local addonName, rootNS = ...; local RR = rootNS.CRFClass or {}; rootNS.CRFClass = RR -- repurposed Class tracker for remaining classes
local _, ns = ...
local db, currentClass, profile

-- ---------------------------------------------------------------------------
-- Localization of the addon's own UI text (labels, buttons, tooltips). Spell names come
-- localized from the game already; this table covers the strings WE write. `L` starts
-- as the English defaults; a matching locale table overrides them, and any key with no
-- translation just keeps the English text.
-- ---------------------------------------------------------------------------
local L = {
    scale          = "Scale",
    showPower      = "Show rage / energy bar (Bear / Cat)",
    showCP         = "Show combo points bar (Cat Form)",
    showMana2      = "Show mana bar",
    showHealth     = "Show health bar",
    showBuffs      = "Show %s / %s",   -- Mark of the Wild / Thorns (game names)
    barOrder       = "Bar order",
    barOrderHint   = "(drag to reorder)",
    barCP          = "Combo points",
    barPower       = "Rage / energy",
    barMana        = "Mana",
    barHealth      = "Health",
    casterForm     = "Caster form",
    combatOnly     = "Show only in combat",
    warnWellFed    = "Warn when Well Fed is missing",
    wellFedMissing = "WELL FED MISSING",
    dismiss        = "Dismiss",
    lock           = "Lock",
    unlock         = "Unlock",
    resetPositions = "Reset positions",
    clickToOpen    = "Click to open options.",
    arrangeBtn     = "Customize cooldown layout...",
    done           = "Done",
    layoutTitle    = "Cooldown Layout",
    helpForm       = "Pick a form above to place its icons. Rows, spacing and the options below are the same for every form.",
    rowN           = "Row %d",
    addRow         = "+ Add row",
    deleteRow      = "Delete",
    hiddenTray     = "Hidden",
    hiddenHint     = "(right-click or drag icons here to hide them)",
    helpDrag       = "Drag and drop icons to reorder them.",
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
    panelDesc      = "Mana, rage, energy, combo points and cooldowns for classes, following "
        .. "your form. Use |cffffd100/cr unlock|r to drag the bars into place, "
        .. "or |cffffd100/cr options|r for the standalone window.",
}

do
    local T = {
        ptBR = {
            scale = "Escala",
            showPower = "Mostrar barra de raiva / energia (Urso / Felino)",
            showCP = "Mostrar barra de pontos de combo (Forma de Felino)",
            showMana2 = "Mostrar barra de mana", showHealth = "Mostrar barra de vida", showBuffs = "Mostrar %s / %s", casterForm = "Forma normal",
            barOrder = "Ordem das barras", barOrderHint = "(arraste para reordenar)",
            barCP = "Pontos de combo", barPower = "Raiva / energia", barMana = "Mana", barHealth = "Vida",
            combatOnly = "Mostrar apenas em combate",
            warnWellFed = "Avisar quando faltar Bem Alimentado", wellFedMissing = "SEM BEM ALIMENTADO", dismiss = "Dispensar",
            lock = "Travar", unlock = "Destravar", resetPositions = "Redefinir posi�oes",
            clickToOpen = "Clique para abrir as op�oes.",
            arrangeBtn = "Personalizar layout de recargas...", done = "Concluir",
            layoutTitle = "Layout de recargas",
            helpForm = "Escolha uma forma acima para posicionar seus �cones. Linhas, espa�amento e as op�oes abaixo sao iguais para todas as formas.",
            rowN = "Linha %d", addRow = "+ Adicionar linha", deleteRow = "Excluir", hiddenTray = "Ocultos",
            hiddenHint = "(clique direito ou arraste �cones para c� para ocult�-los)",
            helpDrag = "Arraste e solte os �cones para reorganiz�-los.",
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
            panelDesc = "Mana, raiva, energia, pontos de combo e recargas para Classas, "
                .. "conforme a forma. Use |cffffd100/cr unlock|r para posicionar as barras, "
                .. "ou |cffffd100/cr options|r para a janela independente.",
        },
        esES = {
            scale = "Escala",
            showPower = "Mostrar barra de ira / energ�a (oso / felino)",
            showCP = "Mostrar barra de puntos de combo (forma felina)",
            showMana2 = "Mostrar barra de man�", showHealth = "Mostrar barra de salud", showBuffs = "Mostrar %s / %s", casterForm = "Forma normal",
            barOrder = "Orden de las barras", barOrderHint = "(arrastra para reordenar)",
            barCP = "Puntos de combo", barPower = "Ira / energ�a", barMana = "Man�", barHealth = "Salud",
            combatOnly = "Mostrar solo en combate",
            warnWellFed = "Avisar si falta Bien alimentado", wellFedMissing = "FALTA BIEN ALIMENTADO", dismiss = "Descartar",
            lock = "Bloquear", unlock = "Desbloquear", resetPositions = "Restablecer posiciones",
            clickToOpen = "Clic para abrir las opciones.",
            arrangeBtn = "Personalizar dise�o de reutilizaciones...", done = "Hecho",
            layoutTitle = "Dise�o de reutilizaciones",
            helpForm = "Elige una forma arriba para colocar sus iconos. Las filas, el espaciado y las opciones de abajo son iguales para todas las formas.",
            rowN = "Fila %d", addRow = "+ A�adir fila", deleteRow = "Eliminar", hiddenTray = "Ocultos",
            hiddenHint = "(clic derecho o arrastra iconos aqu� para ocultarlos)",
            helpDrag = "Arrastra y suelta los iconos para reordenarlos.",
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
            panelDesc = "Man�, ira, energ�a, puntos de combo y reutilizaciones para Classas, "
                .. "seg�n la forma. Usa |cffffd100/cr unlock|r para colocar las barras, "
                .. "o |cffffd100/cr options|r para la ventana independiente.",
        },
        frFR = {
            scale = "�chelle",
            showPower = "Afficher la barre de rage / �nergie (ours / f�lin)",
            showCP = "Afficher la barre de points de combo (forme de f�lin)",
            showMana2 = "Afficher la barre de mana", showHealth = "Afficher la barre de vie", showBuffs = "Afficher %s / %s", casterForm = "Forme normale",
            barOrder = "Ordre des barres", barOrderHint = "(glisser pour r�organiser)",
            barCP = "Points de combo", barPower = "Rage / �nergie", barMana = "Mana", barHealth = "Vie",
            combatOnly = "Afficher uniquement en combat",
            warnWellFed = "Pr�venir si Bien nourri manque", wellFedMissing = "BIEN NOURRI MANQUANT", dismiss = "Ignorer",
            lock = "Verrouiller", unlock = "D�verrouiller", resetPositions = "R�initialiser les positions",
            clickToOpen = "Cliquez pour ouvrir les options.",
            arrangeBtn = "Personnaliser la disposition des recharges...", done = "Termin�",
            layoutTitle = "Disposition des recharges",
            helpForm = "Choisissez une forme ci-dessus pour placer ses ic�nes. Les lignes, l'espacement et les options ci-dessous sont les m�mes pour toutes les formes.",
            rowN = "Ligne %d", addRow = "+ Ajouter une ligne", deleteRow = "Supprimer", hiddenTray = "Masqu�s",
            hiddenHint = "(clic droit ou glissez des ic�nes ici pour les masquer)",
            helpDrag = "Glissez-d�posez les ic�nes pour les r�organiser.",
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
            panelDesc = "Mana, rage, �nergie, points de combo et temps de recharge pour les "
                .. "Classes, selon la forme. Utilisez |cffffd100/cr unlock|r pour placer les "
                .. "barres, ou |cffffd100/cr options|r pour la fen�tre ind�pendante.",
        },
        deDE = {
            scale = "Skalierung",
            showPower = "Wut- / Energieleiste anzeigen (B�r / Katze)",
            showCP = "Kombopunkteleiste anzeigen (Katzengestalt)",
            showMana2 = "Manaleiste anzeigen", showHealth = "Lebensleiste anzeigen", showBuffs = "%s / %s anzeigen", casterForm = "Normale Gestalt",
            barOrder = "Reihenfolge der Leisten", barOrderHint = "(zum Sortieren ziehen)",
            barCP = "Kombopunkte", barPower = "Wut / Energie", barMana = "Mana", barHealth = "Gesundheit",
            combatOnly = "Nur im Kampf anzeigen",
            warnWellFed = "Warnen, wenn Satt fehlt", wellFedMissing = "SATT FEHLT", dismiss = "Ausblenden",
            lock = "Sperren", unlock = "Entsperren", resetPositions = "Positionen zur�cksetzen",
            clickToOpen = "Klicken, um die Optionen zu �ffnen.",
            arrangeBtn = "Abklingzeit-Layout anpassen...", done = "Fertig",
            layoutTitle = "Abklingzeit-Layout",
            helpForm = "W�hle oben eine Gestalt, um ihre Symbole zu platzieren. Reihen, Abstand und die Optionen unten gelten f�r alle Gestalten.",
            rowN = "Reihe %d", addRow = "+ Reihe hinzuf�gen", deleteRow = "L�schen", hiddenTray = "Ausgeblendet",
            hiddenHint = "(Rechtsklick oder Symbole hierher ziehen, um sie auszublenden)",
            helpDrag = "Symbole per Drag & Drop neu anordnen.",
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
            panelDesc = "Mana, Wut, Energie, Kombopunkte und Abklingzeiten f�r Classen, je "
                .. "nach Gestalt. Mit |cffffd100/cr unlock|r die Leisten platzieren, oder "
                .. "|cffffd100/cr options|r f�r das eigenst�ndige Fenster.",
        },
    }
    T.esMX = T.esES
    local loc = (GetLocale and GetLocale()) or "enUS"
    if T[loc] then for k, v in pairs(T[loc]) do L[k] = v end end
end

-- ---------------------------------------------------------------------------
-- Resources and forms.
-- ---------------------------------------------------------------------------
local POWER_MANA   = (Enum and Enum.PowerType and Enum.PowerType.Mana) or 0
local POWER_RAGE   = (Enum and Enum.PowerType and Enum.PowerType.Rage) or 1
local POWER_ENERGY = (Enum and Enum.PowerType and Enum.PowerType.Energy) or 3
local POWER_COMBO  = (Enum and Enum.PowerType and Enum.PowerType.ComboPoints) or 4

-- Bar colours per power type (Blizzard's standard mana / rage / energy hues).
local POWER_COLOR = {
    [POWER_MANA]   = { 0.00, 0.44, 0.87 },
    [POWER_RAGE]   = { 0.85, 0.15, 0.10 },
    [POWER_ENERGY] = { 1.00, 0.82, 0.06 },
    [(Enum and Enum.PowerType and Enum.PowerType.Focus) or 2] = { 1.00, 0.50, 0.25 },
}

local function IsSecretV(v) return issecretvalue and issecretvalue(v) end

-- Max for a power (a plain number on this client); 100 while it isn't available yet.
local function PowerMax(ptype)
    local max = UnitPowerMax("player", ptype)
    if IsSecretV(max) or not max or max == 0 then return 100 end
    return max
end

-- The power the main bar shows right now: your active power type -- mana in caster /
-- travel / moonkin, rage in bear, energy in cat. Mana if it can't be read.
local function ActivePowerType()
    local pt = UnitPowerType("player")
    if IsSecretV(pt) or not POWER_COLOR[pt] then return POWER_MANA end
    return pt
end

-- Combo points, passed straight through to the bar (see above).
local function GetCP()
    if GetComboPoints then return GetComboPoints("player", "target") end
    return UnitPower("player", POWER_COMBO)
end

local MAX_CP = 5
local CAT_FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"   -- minimap/compartment icon

-- Shapeshift forms, identified by their spell ID (locale-free). The form INDEX depends on
-- which forms you've learned, so it's only used to look the spell up. Verified on this
-- client: Cat 768, Bear 5487. Dire Bear (9634) replaces Bear once trained.
local FORM_SPELLS = {
    [768]  = "cat",
    [5487] = "bear",
    [9634] = "bear",
}
-- "cat", "bear" or "caster" (caster also covers Travel, Aquatic and Moonkin forms).
local function CurrentForm()
    if currentClass ~= "DRUID" then return "caster" end
    if not GetShapeshiftForm then return "caster" end
    local idx = GetShapeshiftForm()
    if IsSecretV(idx) or not idx or idx == 0 then return "caster" end
    local _, _, _, spellID = GetShapeshiftFormInfo(idx)
    if IsSecretV(spellID) then return "caster" end
    return FORM_SPELLS[spellID] or "caster"
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

-- Cooldown-tracked abilities, in their default left-to-right order. Each lists every
-- rank's spell ID (a cast of any rank starts the icon), the form(s) it's shown in by
-- default, and `dur` = the buff's length for the red "active" phase (nil = cooldown
-- only). `forms`: nil = every form. Any spell can still be shown in any form's layout
-- via the layout editor. IDs are the Classic ones unless noted (confirmed in game so
-- far: Enrage, Bash, Growl, Rebirth, Faerie Fire, Feral Charge, Shifting Power). Only
-- the ones this character knows get shown.
local CAT, BEAR, CASTER = { cat = true }, { bear = true }, { caster = true }
local FERAL = { cat = true, bear = true }
-- Feral Charge: one talent, two spells -- the Bear charge (16979) and the Cat leap
-- (414924) -- each of which only exists while you're in its form. The usual "is it
-- learned?" checks say no for both, so they're checked as a group (see GroupKnown).
local FERAL_CHARGE = { 16979, 414924 }
local SPELLS = {}

-- Combat racials for the races that can be classes (WoW: Forever), by spell ID; only the
-- one your character actually has gets an icon. Shown in every form.
local RACIALS = {}

-- True if this character has the spell. IsSpellKnown / IsPlayerSpell are both tried
-- since neither is fully reliable, plus the override-aware check where it exists.
local function SpellKnown(id)
    if C_SpellBook and C_SpellBook.IsSpellKnown then
        local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
        local ok, known = pcall(C_SpellBook.IsSpellKnown, id, bank)
        if ok and known then return true end
    end
    if IsSpellKnownOrOverridesKnown then local ok, known = pcall(IsSpellKnownOrOverridesKnown, id); if ok and known then return true end end
    if IsSpellKnown then local ok, known = pcall(IsSpellKnown, id); if ok and known then return true end end
    if IsPlayerSpell then local ok, known = pcall(IsPlayerSpell, id); if ok and known then return true end end
    return false
end

-- True if any spell of a form-bound group (e.g. FERAL_CHARGE) is learned. Once seen, the
-- group counts as learned until your talents change, so it also shows in your other forms.
local groupSeen = {}
local function GroupKnown(group)
    if groupSeen[group] then return true end
    for _, id in ipairs(group) do
        local known = SpellKnown(id)
        if not known then
            local name = SpellName(id)
            local info = name and C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(name)
            local sid = info and info.spellID
            if sid and not IsSecretV(sid) then
                for _, gid in ipairs(group) do
                    if sid == gid then known = true end
                end
            end
        end
        if known then
            groupSeen[group] = true
            return true
        end
    end
    return false
end

-- An item's cooldown (start, duration), tolerant of the API surface.
local function GetItemCD(itemID)
    if C_Container and C_Container.GetItemCooldown then return C_Container.GetItemCooldown(itemID) end
    if C_Item and C_Item.GetItemCooldown then return C_Item.GetItemCooldown(itemID) end
    if GetItemCooldown then return GetItemCooldown(itemID) end
end

-- Read a spell's cooldown start/duration, tolerant of the API surface.
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

-- ---------------------------------------------------------------------------
-- Saved settings
-- ---------------------------------------------------------------------------
RR.defaults = {
    locked      = true,
    position    = { point = "CENTER", relativePoint = "CENTER", x = 0, y = -179 },
    scale       = 1.0,  -- UI scale (0.5 .. 2.0)
    powerHidden   = false, -- hide the rage / energy bar (Bear / Cat)
    cpHidden      = false, -- hide the combo-point bar (Cat Form)
    mana2Hidden   = false, -- hide the mana bar
    healthShown   = false, -- show the (optional) health bar
    buffsHidden   = false, -- hide the Mark of the Wild / Thorns icons
    buffPos       = { point = "CENTER", relativePoint = "CENTER", x = -150, y = -170 },
    barOrder      = { "cp", "power", "mana", "health" },   -- bar stacking order, top to bottom
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
-- Display: up to four stacked bars, in the order set in the options: combo points (Cat
-- Form), rage / energy (Bear / Cat), mana and health (optional). Bars that don't apply
-- to your form take no space (see CRFClass_ApplyBarVisibility).
-- ---------------------------------------------------------------------------
local BAR_W, BAR_H = 200, 16
local CP_H, GAP = 14, 5
local MANA2_H = 12   -- the mana bar (tall enough for its value text)
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

-- A bordered spell icon with a Cooldown swipe overlay. Used for every tracked ability.
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

-- "Active" look for buff abilities (Dash, Barkskin, ...): a red spark with a
-- fading tail that runs around the icon's border, plus a soft red halo, shown only while
-- the buff is up, timed from the cast.
local SPARK_LAP, SPARK_GAP = 1.6, 4          -- seconds per lap, px between tail sparks
local SPARK_ALPHA = { 1, 0.6, 0.35, 0.18 }   -- head first, then the fading tail
local SPARK_HEADS = 2                        -- comets per icon, evenly spaced round the border

-- Clock-driven pulses: every registered region's alpha follows the same triangle wave
-- off GetTime() (up for half a period, down for the other half -- like an AnimationGroup
-- BOUNCE), so all pulsing effects (e.g. the max-CP flash) stay in sync no
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

-- A countdown number for a BUFF's remaining time, rounded DOWN like the game's own buff
-- timers. The cooldown frame's built-in numbers round UP (4.2s shows "5"), which read a
-- second high next to the buff. Sits on a frame above the cooldown swipe, in the
-- countdown's own font when available. Used for the active phase of the buff abilities
-- (Dash, Barkskin, ...) and for Clearcasting.
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

-- Build the border comet + a soft glow on an icon, in the given colour (hidden until
-- SetBorderFX turns it on). Used red for the buff abilities, blue for Clearcasting.
local function AddBorderFX(o, r, g, b)
    -- The action-button proc-glow ring, sized in Blizzard's proportion (62px glow on a
    -- 36px button), tinted.
    local halo = o:CreateTexture(nil, "OVERLAY", nil, 1)
    halo:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    halo:SetBlendMode("ADD")
    halo:SetVertexColor(r, g, b)
    halo:SetPoint("CENTER")
    halo:SetSize(ICON_SIZE * 1.72, ICON_SIZE * 1.72)
    halo:Hide()
    o.halo = halo
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
-- skills). Form-bound groups like Feral Charge use GroupKnown instead.
local function IconKnown(o)
    if o.available then return o.available() end   -- custom check
    if o.group then return GroupKnown(o.group) end
    if not o.ids then return true end
    for _, id in ipairs(o.ids) do
        if SpellKnown(id) then return true end
    end
    return false
end

-- The three icon layouts: each form has its own order and show/hide settings, so the
-- tracker can be arranged separately for Cat, Bear and caster.
local FORMS = { "caster" }

-- True if an icon belongs to a form (icons without `forms` -- the racials -- belong to all).
local function InForm(o, form)
    return (not o.forms) or (o.forms[form] and true) or false
end

-- Display name of a form, for the arrange hint (the game's own localized form names).
local function FormLabel(form)
    if form == "cat" then return SpellName(768) or "Cat Form" end
    if form == "bear" then return SpellName(5487) or "Bear Form" end
    return L.casterForm
end

-- The saved left-to-right icon order for a form (defaults to the one you're in).
local function FormOrder(form)
    return db.iconOrderByForm[form or CurrentForm()]
end

-- The default left-to-right icon order (by key): SPELLS in table order, then racials.
local DEFAULT_ORDER = {}
for _, s in ipairs(SPELLS) do DEFAULT_ORDER[#DEFAULT_ORDER + 1] = s.key end
for _, r in ipairs(RACIALS) do DEFAULT_ORDER[#DEFAULT_ORDER + 1] = r.key end

-- Make each form's saved order a clean list of EVERY icon key (any spell can be placed in
-- any form's layout): kept in the saved order, dropping stale keys, then appending the
-- rest -- that form's own spells first, then the other forms' -- in default order.
local function ReconcileOrder(f)
    local db = db
    if type(db.iconOrderByForm) ~= "table" then db.iconOrderByForm = {} end
    for _, form in ipairs(FORMS) do
        local saved = type(db.iconOrderByForm[form]) == "table" and db.iconOrderByForm[form] or {}
        local seen, clean = {}, {}
        local function add(key, onlyOwn)
            local o = f.iconByKey[key]
            if o and not seen[key] and (not onlyOwn or InForm(o, form)) then
                clean[#clean + 1] = key
                seen[key] = true
            end
        end
        for _, key in ipairs(saved) do add(key) end
        for _, key in ipairs(DEFAULT_ORDER) do add(key, true) end   -- this form's own first
        for _, key in ipairs(DEFAULT_ORDER) do add(key) end         -- then everything else
        for _, o in ipairs(f.icons) do add(o.key) end               -- custom spells / items last
        db.iconOrderByForm[form] = clean
    end
end

-- Clearcasting (Omen of Clarity proc). Its icon appears above the bars only while the
-- proc is up, with blue comets and a countdown of the buff's length.
local CC_ICON_SPELL = 16870   -- Clearcasting (icon)
local CC_PROBE      = 5185
local CC_DUR        = 15      -- Clearcasting's length (seconds)

local function ClearcastingUp()
    if not (C_Spell and C_Spell.GetSpellPowerCost) then return false end
    local ok, costs = pcall(C_Spell.GetSpellPowerCost, CC_PROBE)
    local c = ok and type(costs) == "table" and costs[1]
    if not c or IsSecretV(c.cost) then return false end
    return c.cost == 0
end

local function UpdateClearcasting(f)
    local o = f.ccIcon
    if currentClass ~= "DRUID" then if o then o:Hide() end; if f.ccFrame then f.ccFrame:Hide() end; return end
    if not o then return end
    local up = ClearcastingUp()
    if up == (o.ccOn or false) then return end
    o.ccOn = up
    if up then o.activeUntil = GetTime() + CC_DUR end
    o.shownSecs = nil
    if not up and o.buffText then o.buffText:SetText("") end
    SetBorderFX(o, up)
    o:SetScript("OnUpdate", up and ActiveOnUpdate or nil)
    -- While unlocked the icon stays visible, so it can be dragged into place.
    o:SetShown(up or not db.locked)
end

-- Clearcasting can be used up and proc again on the same hit; it then never looks gone,
-- so its countdown wouldn't restart. A cast sent while the proc is up, and free because
-- of it (so it uses the proc up), is remembered; if the proc is still up just after that
-- cast lands, it's a new one and the countdown restarts from the cast.
local function ClearcastingCastSent(f, castGUID, spellID)
    local o = f.ccIcon
    if not (o and o.ccOn and spellID) or IsSecretV(castGUID) then return end
    if not (C_Spell and C_Spell.GetSpellPowerCost) then return end
    local ok, costs = pcall(C_Spell.GetSpellPowerCost, spellID)
    local c = ok and type(costs) == "table" and costs[1]
    if c and not IsSecretV(c.cost) and c.cost == 0 then o.consumeGUID = castGUID end
end

local function ClearcastingCastSucceeded(f, castGUID)
    local o = f.ccIcon
    if not (o and o.consumeGUID) or IsSecretV(castGUID) or castGUID ~= o.consumeGUID then return end
    o.consumeGUID = nil
    local castAt = GetTime()
    C_Timer.After(0.3, function()
        if o.ccOn and ClearcastingUp() then
            o.activeUntil = castAt + CC_DUR
            o.shownSecs = nil
        end
    end)
end

-- "Not enough rage / energy / mana": tint the icon blue like Blizzard's action buttons.
local NO_POWER_COLOR = { 0.5, 0.5, 1.0 }   -- Blizzard's out-of-power tint
local noPowerC, normalC
local function UpdateUsable(f)
    if not (f.icons and C_Spell and C_Spell.IsSpellUsable) then return end
    if CreateColor and not noPowerC then
        noPowerC = CreateColor(NO_POWER_COLOR[1], NO_POWER_COLOR[2], NO_POWER_COLOR[3], 1)
        normalC = CreateColor(1, 1, 1, 1)
    end
    for _, o in ipairs(f.icons) do
        local id = not o.itemID and (o.useID or (o.ids and o.ids[1]))   -- spells only
        if o:IsShown() and id then
            local _, noPower = C_Spell.IsSpellUsable(id)
            if IsSecretV(noPower) then
                if o.icon.SetVertexColorFromBoolean and noPowerC then
                    pcall(o.icon.SetVertexColorFromBoolean, o.icon, noPower, noPowerC, normalC)
                end
            elseif noPower then
                o.icon:SetVertexColor(NO_POWER_COLOR[1], NO_POWER_COLOR[2], NO_POWER_COLOR[3])
            else
                o.icon:SetVertexColor(1, 1, 1)
            end
        end
    end
end

-- ---------------------------------------------------------------------------
-- Cooldown layout, one per form. With no saved layout a form uses the "Classic" look:
-- one size, wrapped under the bars in that form's icon order (hidden ones left out).
-- Once the layout editor is used, db.layoutByForm[form] holds rows of
-- slots instead:
--   { rows = { { slots = 4, keys = { "bash", "growl", false, ... } }, ... },
--     hidden = { keys... }, spacing = "normal", keepEmpty = false, above = false }
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
-- row the size of the last one (when allowed and there's room), otherwise hide it.
local function PlaceKey(lay, key, from, noGrow)
    for r = from or 1, #lay.rows do
        local row = lay.rows[r]
        for s = 1, row.slots do
            if not row.keys[s] then row.keys[s] = key; return end
        end
    end
    if not noGrow and #lay.rows < MAX_ROWS then
        local last = lay.rows[#lay.rows]
        local row = NewRow(last and last.slots or 7)
        row.keys[1] = key
        lay.rows[#lay.rows + 1] = row
    else
        lay.hidden[#lay.hidden + 1] = key
    end
end

-- A form's Classic look expressed as rows (as many per row as fit at the classic size),
-- so the editor can start from what's on screen.
local function ClassicLayout(f, form)
    local perRow = math.max(1, math.floor((BAR_W + ICON_GAP) / (ICON_SIZE + ICON_GAP)))
    local lay = { rows = { NewRow(perRow) }, hidden = {}, spacing = "normal",
                  keepEmpty = false, above = false }
    for _, key in ipairs(FormOrder(form)) do
        local o = f.iconByKey[key]
        if o and InForm(o, form) then PlaceKey(lay, key) else lay.hidden[#lay.hidden + 1] = key end
    end
    return lay
end

-- Every form shares one layout "shape": the rows and their slot counts, spacing, keep
-- empty slots and above / below the bars. Only which icon sits where differs per form.
-- MatchShape gives `lay` the shape of `src`: icons from removed slots or rows move to
-- free slots, else to Hidden.
local function MatchShape(lay, src)
    lay.spacing, lay.keepEmpty, lay.above = src.spacing, src.keepEmpty, src.above
    local spill = {}
    while #lay.rows > #src.rows do
        local row = table.remove(lay.rows)
        for s = 1, row.slots do
            if row.keys[s] then spill[#spill + 1] = row.keys[s] end
        end
    end
    for i, srow in ipairs(src.rows) do
        local row = lay.rows[i]
        if not row then
            lay.rows[i] = NewRow(srow.slots)
        elseif row.slots < srow.slots then
            for s = row.slots + 1, srow.slots do row.keys[s] = false end
            row.slots = srow.slots
        elseif row.slots > srow.slots then
            for s = srow.slots + 1, row.slots do
                local k = row.keys[s]
                row.keys[s] = nil
                if k then
                    local placed
                    for t = 1, srow.slots do
                        if not row.keys[t] then row.keys[t] = k; placed = true; break end
                    end
                    if not placed then spill[#spill + 1] = k end
                end
            end
            row.slots = srow.slots
        end
    end
    for _, k in ipairs(spill) do PlaceKey(lay, k, 1, true) end
    return lay
end

-- Copy form `src`'s layout shape to the other forms (saving a layout for any form that
-- still uses the Classic look).
local function SyncShapes(f, src)
    local db = db
    local srcLay = db.layoutByForm[src]
    if not srcLay then return end
    for _, form in ipairs(FORMS) do
        if form ~= src then
            db.layoutByForm[form] = MatchShape(db.layoutByForm[form] or ClassicLayout(f, form), srcLay)
        end
    end
end

-- Make every saved form layout consistent with the icons that exist: drop unknown keys,
-- keep every row's slot list the right length, and add new abilities (in the first free
-- slot if they belong to that form, otherwise -- or when the rows are full -- to Hidden;
-- never a new row, so every form keeps the shared shape).
local function ReconcileLayout(f)
    local db = db
    if type(db.layoutByForm) ~= "table" then db.layoutByForm = {} end
    for _, form in ipairs(FORMS) do
        local lay = db.layoutByForm[form]
        if type(lay) ~= "table" then
            db.layoutByForm[form] = nil
        else
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
            for _, key in ipairs(FormOrder(form)) do
                if not seen[key] then
                    if InForm(f.iconByKey[key], form) then
                        PlaceKey(lay, key, 1, true)
                    else
                        lay.hidden[#lay.hidden + 1] = key
                    end
                end
            end
        end
    end
end

-- Place one icon at (x, y) in the anchor's coordinates, at the given size. Offsets are
-- in the icon's own (scaled) units, hence the division.
local function PlaceIcon(o, anchor, point, x, y, size)
    local scale = size / ICON_SIZE
    o:SetScale(scale)
    o:ClearAllPoints()
    o:SetPoint("TOPLEFT", anchor, point, x / scale, y / scale)
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

-- Show your CURRENT FORM's layout under (or above) the bars. Re-run on spell, form,
-- layout and option changes.
local function LayoutIcons(f)
    for _, o in ipairs(f.icons) do
        o:Hide()
        -- Highest known rank (ranks are listed low to high), for the "no power" tint.
        -- Worked out here (on learning spells / shifting) rather than on every power tick.
        if o.ids then
            o.useID = o.ids[1]
            for _, rid in ipairs(o.ids) do
                if SpellKnown(rid) then o.useID = rid end
            end
        end
    end
    local form = CurrentForm()
    local lay = db.layoutByForm and db.layoutByForm[form]

    if not lay then
        -- Classic: known + enabled icons in this form's order, wrapped and centered.
        local visible = {}
        for _, key in ipairs(FormOrder(form)) do
            local o = f.iconByKey[key]
            if o and OnBar(o) and InForm(o, form) then visible[#visible + 1] = o end
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
    else
        -- Rows of slots: collect each row's icons; rows with none take no space.
        local gap = LayGap(lay)
        local rows = {}
        for _, row in ipairs(lay.rows) do
            local cells = {}
            for s = 1, row.slots do
                local o = row.keys[s] and f.iconByKey[row.keys[s]]
                if o and OnBar(o) then cells[#cells + 1] = { o = o, slot = s } end
            end
            if #cells > 0 then rows[#rows + 1] = { size = RowSize(row, gap), cells = cells } end
        end

        -- Below the bars: hang from the frame's bottom edge. Above: sit on the topmost
        -- shown bar (so hidden bars leave no gap), first row on top.
        local anchor, point, y = f, "BOTTOMLEFT", -GAP
        if lay.above and #rows > 0 then
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
    UpdateUsable(f)   -- tint the icons just shown
end

-- ---------------------------------------------------------------------------
-- Options: a canvas panel registered under Options -> AddOns (the built-in
-- Settings UI). Holds a UI-scale slider and the drag-to-reorder / show-hide
-- ability list. Built once at login so it always appears in the AddOns list.
-- ---------------------------------------------------------------------------
local OPT_W = 340
local SCALE_MIN, SCALE_MAX, SCALE_STEP = 0.5, 2.0, 0.05

-- Forward declarations: these are defined later in the file but referenced by the
-- options controls above them (the Lock/Reset buttons and the drag-reorder callbacks).
local CRFClass_RefreshOptions, CRFClass_SetLocked, CRFClass_ApplyPosition, CRFClass_SetCooldownSwipe, CRFClass_ToggleLayoutEditor
local CRFClass_ApplyBarVisibility, CRFClass_UpdateCombatVisibility, CRFClass_UpdatePower, CRFClass_UpdateHealth
local CRFClass_UpdateBuffs, CRFClass_ApplyBuffPosition, CRFClass_ToggleBuffs, CRFClass_PlaceClearcasting, CRFClass_UpdateWellFed

-- The stacked bars (health is optional and off by default). BarOrder returns the saved
-- top-to-bottom order, repaired so every bar appears exactly once.
local BAR_LABEL = { cp = L.barCP, power = L.barPower, mana = L.barMana, health = L.barHealth }
local function BarOrder()
    local order, seen = {}, {}
    for _, k in ipairs(db.barOrder or {}) do
        if BAR_LABEL[k] and not seen[k] then seen[k] = true; order[#order + 1] = k end
    end
    for _, k in ipairs(RR.defaults.barOrder) do
        if not seen[k] then seen[k] = true; order[#order + 1] = k end
    end
    db.barOrder = order
    return order
end

-- Whether a bar is turned on in the options (it may still be hidden by your form).
local function BarShown(k)
    if currentClass ~= "DRUID" and k == "cp" then return false end
    if k == "health" then return db.healthShown and true or false end
    if k == "power" then return not db.powerHidden end
    if k == "mana" then if currentClass == "HUNTER" or currentClass == "WARLOCK" then return true end; return currentClass == "DRUID" and not db.mana2Hidden end
    return not db.cpHidden
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
    CRFClass_ApplyBarVisibility(f)
    CRFClass_RefreshOptions(f)
end

-- Re-anchor the tracker by its BOTTOM edge (where the bars meet the cooldown icons), at
-- the spot it's at now, and save that. The bar stack's height changes when you shift
-- and as bars are turned on / off; anchored by the bottom, the icons below never move
-- and the bars just grow or shrink upward. Offsets are from UIParent's bottom-left (0,0
-- at any scale). `k` converts the frame's coordinates when its scale has just changed.
-- No-op before the frame has a position.
local function PinBottom(f, k)
    local x, bottom = f:GetCenter(), f:GetBottom()
    if not (x and bottom) then return end
    k = k or 1
    f:ClearAllPoints()
    f:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", x * k, bottom * k)
    db.position = { point = "BOTTOM", relativePoint = "BOTTOMLEFT", x = x * k, y = bottom * k }
end

-- Apply the saved UI scale, keeping the tracker's bottom edge in place.
local function ApplyScale(f)
    local before = f:GetEffectiveScale()
    local x, bottom = f:GetCenter(), f:GetBottom()
    f:SetScale(db.scale or 1.0)
    if x and bottom then PinBottom(f, before / f:GetEffectiveScale()) end
    -- The buff icons scale with it (not in combat: they hold click-to-cast buttons).
    if f.buffFrame and not InCombatLockdown() then f.buffFrame:SetScale(db.scale or 1.0) end
    -- So does the Clearcasting icon's own spot, keeping its centre in place.
    local cf = f.ccFrame
    if cf then
        local cb = cf:GetEffectiveScale()
        local cx, cy = cf:GetCenter()
        cf:SetScale(db.scale or 1.0)
        if cx and cy and db.ccPos then
            local k = cb / cf:GetEffectiveScale()
            cf:ClearAllPoints()
            cf:SetPoint("CENTER", UIParent, "BOTTOMLEFT", cx * k, cy * k)
            db.ccPos = { point = "CENTER", relativePoint = "BOTTOMLEFT", x = cx * k, y = cy * k }
        end
    end
end

-- Reset the tracker and the buff icons to their default positions (fresh copies so the
-- saved tables never alias RR.defaults), then re-anchor them.
local function ResetPositions(f)
    local dp = RR.defaults.position
    db.position = { point = dp.point, relativePoint = dp.relativePoint, x = dp.x, y = dp.y }
    CRFClass_ApplyPosition(f)
    if f.buffFrame and not InCombatLockdown() then
        local bp = RR.defaults.buffPos
        db.buffPos = { point = bp.point, relativePoint = bp.relativePoint, x = bp.x, y = bp.y }
        CRFClass_ApplyBuffPosition(f)
    end
    db.ccPos = nil   -- the Clearcasting spot goes back above the bars
    CRFClass_PlaceClearcasting(f)
    print("|cff00ff88ClassResourcesForever:|r positions reset to default.")
end

-- Build the shared options body (scale, toggles, buttons) into `body`.
-- Registers a "view" so CRFClass_RefreshOptions can keep every open copy (the floating window
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
        db.scale = value
        ApplyScale(f)
        CRFClass_RefreshOptions(f)                            -- update value text + the other view
    end)
    view.slider, view.scaleVal = slider, scaleVal
    y = y - 40

    -- A labelled checkbox at the cursor; `onClick` runs on toggle, then every options view
    -- is re-synced (the floating window and the Settings page share these settings).
    local function AddCheck(text, onClick)
        local c = CreateFrame("CheckButton", nil, body, "UICheckButtonTemplate")
        c:SetPoint("TOPLEFT", -2, y); c:SetSize(26, 26)
        local t = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        t:SetPoint("LEFT", c, "RIGHT", 2, 0); t:SetText(text)
        c:SetScript("OnClick", function(self) onClick(self); CRFClass_RefreshOptions(f) end)
        y = y - 30
        return c
    end

    -- Show the combo-point / rage-energy / mana bars.
    view.cpCheck = AddCheck(L.showCP, function(self)
        db.cpHidden = not self:GetChecked()
        CRFClass_ApplyBarVisibility(f)
    end)
    view.powerCheck = AddCheck(L.showPower, function(self)
        db.powerHidden = not self:GetChecked()
        CRFClass_ApplyBarVisibility(f)
    end)
    view.mana2Check = AddCheck(L.showMana2, function(self)
        db.mana2Hidden = not self:GetChecked()
        CRFClass_ApplyBarVisibility(f)
    end)
    view.healthCheck = AddCheck(L.showHealth, function(self)
        db.healthShown = self:GetChecked() and true or false
        CRFClass_ApplyBarVisibility(f)
        CRFClass_UpdateHealth(f)
    end)

    -- Bar order: press a row and move the mouse up or down; the bar swaps places with
    -- each row it passes over (the list and the bars on screen update as you go).
    -- Labels are filled in CRFClass_RefreshOptions.
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

    -- Show the Mark of the Wild / Thorns icons (named by the game's own spell names).
    view.buffsCheck = AddCheck(L.showBuffs:format(SpellName(1126) or "Mark of the Wild",
        SpellName(467) or "Thorns"), function(self) CRFClass_ToggleBuffs(f, self) end)
    if currentClass ~= "DRUID" then view.buffsCheck:Hide() end

    -- Show the bars + icons only while in combat.
    view.combatCheck = AddCheck(L.combatOnly, function(self)
        db.combatOnly = self:GetChecked() and true or false
        CRFClass_UpdateCombatVisibility(f)
    end)

    -- Warn at the top of the screen when the Well Fed food buff is missing.
    view.wellFedCheck = AddCheck(L.warnWellFed, function(self)
        db.wellFedWarn = self:GetChecked() and true or false
        CRFClass_UpdateWellFed(f)
    end)

    -- Lock / Reset positions.
    local lockBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
    lockBtn:SetPoint("TOPLEFT", 2, y); lockBtn:SetSize(110, 22)
    lockBtn:SetScript("OnClick", function()
        CRFClass_SetLocked(f, not db.locked)
        CRFClass_RefreshOptions(f)
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
    arrangeBtn:SetScript("OnClick", function() CRFClass_ToggleLayoutEditor(f) end)
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
    panel.name = "Class Resources Forever - " .. (profile and profile.label or "Class")

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Class Resources Forever - " .. (profile and profile.label or "Class"))

    local sub = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    sub:SetPoint("RIGHT", panel, "RIGHT", -24, 0)
    sub:SetJustifyH("LEFT")
    sub:SetText(L.panelDesc)

    local body = CreateFrame("Frame", nil, panel)
    body:SetPoint("TOPLEFT", sub, "BOTTOMLEFT", 0, -22)
    PopulateOptions(f, body)

    -- Refresh the rows/slider each time the page is shown (Blizzard opens it, not us).
    panel:SetScript("OnShow", function() CRFClass_RefreshOptions(f) end)

    -- Register under Options -> AddOns. Prefer the modern Settings API; fall back to the
    -- legacy InterfaceOptions registration on older API surfaces.
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, "Class Resources Forever - " .. (profile and profile.label or "Class"))
        Settings.RegisterAddOnCategory(category)
        RR.settingsCategory = category
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end

    f.settingsPanel = panel
    CRFClass_RefreshOptions(f)   -- populate the just-built rows
    return panel
end

-- A movable Blizzard-style window: title bar, close button, framed edges and a darker
-- inset for the content. If this client lacks the template, fall back to the classic
-- dialog-box border. Returns the window, the content's top offset, and the extra height
-- the frame adds around its content.
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
    -- Moved only by its title bar, so clicking or dragging inside the window never moves it.
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
        db.windowPos = db.windowPos or {}
        db.windowPos[name] = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 }
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
    local saved = db.windowPos and db.windowPos[name]
    if saved then
        win:SetPoint(saved.point, UIParent, saved.relativePoint, saved.x, saved.y)
    else
        win:SetPoint("CENTER")
    end
    -- ESC closes it. Handled here rather than via UISpecialFrames, because opening some
    -- game panels (the spellbook, for one) closes every window on that list. Keys always
    -- pass through to the game except the ESC that closes us. Keyboard pass-through can't
    -- be changed in combat, so there it's left on (ESC then also opens the game menu).
    local function SetupKeys()
        win:EnableKeyboard(true)
        win:SetPropagateKeyboardInput(true)
        win:SetScript("OnKeyDown", function(self, key)
            if InCombatLockdown() then return end
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

-- The standalone options window that /cr options opens. Shows the same controls as the
-- Settings -> AddOns page (both are kept in sync via CRFClass_RefreshOptions).
local function BuildOptions(f)
    if f.optWindow then return f.optWindow end
    local opt, top, extraH = CreateWindow("ClassResourcesForeverOptionsFrame", "Class Resources Forever - " .. (profile and profile.label or "Class"))
    local body = CreateFrame("Frame", nil, opt)
    body:SetPoint("TOPLEFT", 18, top)
    local bodyH = PopulateOptions(f, body)
    opt:SetSize(OPT_W + 36, bodyH + extraH)

    opt:SetScript("OnShow", function() CRFClass_RefreshOptions(f) end)
    opt:Hide()   -- new frames start shown; hide so the first /cr options opens it
    f.optWindow = opt
    return opt
end

-- Refresh EVERY built options view (floating window + Settings page) from saved state:
-- the scale slider/value, buttons and checkboxes. `f._syncing` guards the slider so the
-- programmatic SetValue below doesn't re-fire OnValueChanged.
function CRFClass_RefreshOptions(f)
    if not f.optionViews then return end
    local s = db.scale or 1.0
    f._syncing = true
    for _, view in ipairs(f.optionViews) do
        -- Only push a value that actually differs, so we don't fight the thumb of the
        -- slider currently being dragged (its value already equals s after snapping).
        if view.slider and math.abs((view.slider:GetValue() or 0) - s) > 1e-4 then
            view.slider:SetValue(s)
        end
        if view.scaleVal then view.scaleVal:SetText(math.floor(s * 100 + 0.5) .. "%") end
        if view.lockBtn then view.lockBtn:SetText(db.locked and L.unlock or L.lock) end
        if view.cpCheck then view.cpCheck:SetChecked(not db.cpHidden) end
        if view.powerCheck then view.powerCheck:SetChecked(not db.powerHidden) end
        if view.mana2Check then view.mana2Check:SetChecked(not db.mana2Hidden) end
        if view.healthCheck then view.healthCheck:SetChecked(db.healthShown and true or false) end
        if view.buffsCheck then view.buffsCheck:SetChecked(not db.buffsHidden) end
        if view.orderRows then
            local order = BarOrder()
            for i, row in ipairs(view.orderRows) do
                local k = order[i]
                row.label:SetText(i .. ".  " .. BAR_LABEL[k])
                row.label:SetAlpha(BarShown(k) and 1 or 0.45)   -- dim bars that are turned off
            end
        end
        if view.combatCheck then view.combatCheck:SetChecked(db.combatOnly and true or false) end
        if view.wellFedCheck then view.wellFedCheck:SetChecked(db.wellFedWarn and true or false) end
    end
    f._syncing = false
end

-- /cr options: toggle the standalone floating window.
local function ToggleOptions(f)
    local opt = BuildOptions(f)
    if opt:IsShown() then opt:Hide() else CRFClass_RefreshOptions(f); opt:Show() end
end

-- The two blocks below (custom tracking, layout editor) keep their helpers private in
-- do ... end scopes: Lua allows only 200 locals per scope. Only what the rest of the file
-- needs is exported.
local CRFClass_WireIconDrag, CRFClass_WireCooldownDone, CRFClass_BuildCustomIcons, CRFClass_ToggleCustomWindow, CRFClass_RefreshCustomItems
do   -- custom tracking block
-- ---------------------------------------------------------------------------
-- Icon wiring shared by the built-in and custom cooldown icons.
-- ---------------------------------------------------------------------------

-- While unlocked, dragging any icon moves the whole tracker, exactly like dragging the
-- bars -- so it stays movable even with every bar hidden. Reuses the frame's own drag
-- handlers (incl. position save). Icons are arranged in the layout editor instead.
function CRFClass_WireIconDrag(f, o)
    o:RegisterForDrag("LeftButton")
    o:SetScript("OnDragStart", function()
        if not db.locked then
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
function CRFClass_WireCooldownDone(o)
    o.cd:SetScript("OnCooldownDone", function()
        -- Buff cooldowns: the active phase just ended -> drop the red comets and show
        -- the ability's remaining cooldown, with no ready flash yet.
        if o.phase == "active" then
            o.phase = "cd"
            SetActiveFX(o, false)
            CRFClass_SetCooldownSwipe(o, o.castID)
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
-- Saved as db.custom = { { kind = "spell"|"item", id = N, dur = secs }, ... }
-- Each becomes a normal cooldown icon (key "c:spell:N" / "c:item:N"), shown in every
-- form, that the layout editor places like any other. A spell shows once known; an item
-- always shows, greyed out while you have none in your bags or equipped. `dur`
-- (optional) gives it the red "active" countdown first, like Dash. An item's
-- cast is matched by its use spell.
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

-- How many of an item fit in one stack (1 = not stackable; nil while not cached yet).
local function ItemStackSize(itemID)
    if C_Item and C_Item.GetItemMaxStackSizeByID then return C_Item.GetItemMaxStackSizeByID(itemID) end
    return GetItemInfo and select(8, GetItemInfo(itemID)) or nil
end

-- Stack count in the icon's corner, like action bars: only for stackable items
-- (potions, ...), never for trinkets. Hidden at zero, where the icon is greyed out.
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

-- Fill in an item icon's name, texture and use spell (item data can arrive late, so
-- this re-runs on GET_ITEM_INFO_RECEIVED).
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
    CRFClass_WireIconDrag(f, o)
    CRFClass_WireCooldownDone(o)
    o:EnableMouse(not db.locked)
    f.icons[#f.icons + 1] = o
    f.cooldowns[#f.cooldowns + 1] = o
    f.iconByKey[o.key] = o
    return o
end

function CRFClass_BuildCustomIcons(f)
    if type(db.custom) ~= "table" then db.custom = {} end
    for _, e in ipairs(db.custom) do MakeCustomIcon(f, e) end
end

-- Is this spell / item already on the bar (built in or custom)?
local function AlreadyTracked(f, kind, id)
    if kind == "item" then return f.iconByKey["c:item:" .. id] ~= nil end
    if f.cdByCast[id] then return true end
    local name = SpellName(id)
    if not name then return false end
    if f.cdByName[name] then return true end
    for _, o in ipairs(f.icons) do   -- another rank of a built-in ability
        if o.label == name then return true end
    end
    return false
end

-- Add a custom spell / item. Returns the new icon, or nil plus a message. It's added
-- to every form: into the first free slot of an edited layout, else at the end.
local function AddCustom(f, kind, id)
    local list = db.custom
    if #list >= MAX_CUSTOM then return nil, L.customFull:format(MAX_CUSTOM) end
    if AlreadyTracked(f, kind, id) then return nil, L.customAlready end
    if kind == "item" and not ItemUseSpell(id) then return nil, L.customNoUse end
    local e = { kind = kind, id = id }
    list[#list + 1] = e
    local o = MakeCustomIcon(f, e)
    for _, form in ipairs(FORMS) do
        local lay = db.layoutByForm[form]
        if lay then
            PlaceKey(lay, o.key, 1, true)
        else
            table.insert(db.iconOrderByForm[form], o.key)
        end
    end
    LayoutIcons(f)
    return o
end

-- Remove a custom entry and its icon everywhere.
local function RemoveCustom(f, e)
    local key = CustomKey(e)
    local o = f.iconByKey[key]
    for i, x in ipairs(db.custom) do
        if x == e then table.remove(db.custom, i) break end
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
    for _, form in ipairs(FORMS) do
        Drop(db.iconOrderByForm[form], key)
        local lay = db.layoutByForm[form]
        if lay then
            local r, s = FindKey(lay, key)
            if r == "hidden" then table.remove(lay.hidden, s) elseif r then lay.rows[r].keys[s] = false end
        end
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
    local win, top, extraH = CreateWindow("ClassResourcesForeverCustomFrame", L.customTitle)
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
        GameTooltip:AddLine(L.buffTip:format(SpellName(1850) or "Dash"), 1, 1, 1, true)
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
        local list = db.custom
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

function CRFClass_ToggleCustomWindow(f)
    local win = BuildCustomWindow(f)
    win:SetShown(not win:IsShown())
end

-- Item data (names, icons, use spells) arriving late: refresh the custom item icons.
function CRFClass_RefreshCustomItems(f)
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

do   -- layout editor block (its helpers stay private)
-- ---------------------------------------------------------------------------
-- Cooldown layout editor (/cr layout, or "Customize cooldown layout..." in options).
-- One layout per form, picked with the tabs at the top (it opens on the form you're in).
-- Rows of slots shown at 1.5x their in-game size: drag icons between slots (onto an
-- icon swaps, onto an empty slot moves) or into the Hidden tray; +/- set a row's slot
-- count, which sets its icon size. Every change applies to the bar straight away (the
-- bar shows the form you're in).
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
    local win, top, extraH = CreateWindow("ClassResourcesForeverLayoutFrame", L.layoutTitle)
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
    local editForm = CurrentForm()   -- the form whose layout is being edited

    -- The layout on screen: the form's saved one, or its Classic look shown as rows.
    -- Edit() makes the saved copy on the first change.
    local function Lay() return db.layoutByForm[editForm] or ClassicLayout(f, editForm) end
    local function Edit()
        if not db.layoutByForm[editForm] then
            db.layoutByForm[editForm] = ClassicLayout(f, editForm)
        end
        return db.layoutByForm[editForm]
    end
    local function Changed()
        LayoutIcons(f)
        Refresh()
    end
    -- A change to the layout's shape (rows, slots, spacing, options): copy it to the
    -- other forms too, so every form looks the same (see MatchShape).
    local function ShapeChanged()
        SyncShapes(f, editForm)
        Changed()
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
        PlaceKey(lay, key, 1)   -- may add a row, which the other forms then get too
        ShapeChanged()
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
        ShapeChanged()
    end

    -- Removing a row (in every form) sends its icons to free slots in the rows below,
    -- else Hidden.
    local function RemoveRow(i)
        if #Edit().rows <= 1 then return end
        for _, form in ipairs(FORMS) do
            local db = db
            local lay = db.layoutByForm[form] or ClassicLayout(f, form)
            db.layoutByForm[form] = lay
            if lay.rows[i] and #lay.rows > 1 then
                local row = table.remove(lay.rows, i)
                for s = 1, row.slots do
                    if row.keys[s] then PlaceKey(lay, row.keys[s], i, true) end
                end
            end
        end
        ShapeChanged()
    end

    local function AddRow()
        local lay = Edit()
        if #lay.rows >= MAX_ROWS then return end
        lay.rows[#lay.rows + 1] = NewRow(lay.rows[#lay.rows].slots)
        ShapeChanged()
    end

    -- Back to this form's default icons, keeping the shape the other forms share.
    local function ResetLayout()
        local db = db
        db.iconOrderByForm[editForm] = nil
        ReconcileOrder(f)
        local shape
        for _, form in ipairs(FORMS) do
            if form ~= editForm and db.layoutByForm[form] then shape = db.layoutByForm[form] break end
        end
        db.layoutByForm[editForm] = shape and MatchShape(ClassicLayout(f, editForm), shape) or nil
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
    -- Form tabs: which form's layout is being edited.
    local formBtns = {}
    for i, form in ipairs(FORMS) do
        formBtns[i] = TextButton(FormLabel(form), 160, function() editForm = form; Refresh() end)
        formBtns[i].value = form
    end

    -- How-to lines.
    local help = body:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    help:SetWidth(BODY_W)
    help:SetJustifyH("LEFT")
    help:SetSpacing(3)
    help:SetText(L.helpForm .. "\n" .. L.helpDrag .. "\n" .. L.helpSlots .. "\n" .. L.helpDelete)

    local addRowBtn = TextButton(L.addRow, 110, AddRow)
    local customBtn = TextButton(L.customBtn, 210, function() CRFClass_ToggleCustomWindow(f) end)

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
        spacingBtns[i] = TextButton(sp[2], 78, function() Edit().spacing = sp[1]; ShapeChanged() end)
        spacingBtns[i].value = sp[1]
    end

    local keepCheck = Check(L.keepEmpty, function(self) Edit().keepEmpty = self:GetChecked() and true or false; ShapeChanged() end)

    local posLabel = Label(L.position)
    local posBtns = {
        TextButton(L.belowBars, 120, function() Edit().above = false; ShapeChanged() end),
        TextButton(L.aboveBars, 120, function() Edit().above = true; ShapeChanged() end),
    }

    local resetBtn = TextButton(L.reset, 90, ResetLayout)
    local doneBtn = TextButton(L.done, 90, function() win:Hide() end)
    -- Show every icon on the bar as if all abilities were learned (not saved; closing the
    -- editor turns it off). Stays lit while on.
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

        for i, b in ipairs(formBtns) do
            Put(b, (i - 1) * 172, y)
            Select(b, b.value == editForm)
        end
        y = y - 34

        Put(help, 0, y)
        y = y - math.max(56, help:GetStringHeight() or 0) - 12   -- room for wrapped translations

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
    -- seen live. Opens on the form you're in.
    win:SetScript("OnShow", function()
        RR.editing = true
        editForm = CurrentForm()
        CRFClass_UpdateCombatVisibility(f)
        Refresh()
    end)
    win:SetScript("OnHide", function()
        RR.editing = nil
        dragKey = nil
        if f.customWindow then f.customWindow:Hide() end   -- it belongs to the editor
        ghost:Hide()
        -- "Preview unlearned skills" is only for laying things out: closing ends it.
        if RR.showAll then
            RR.showAll = nil
            LayoutIcons(f)
        end
        CRFClass_UpdateCombatVisibility(f)
    end)

    f.layoutEditor = win
    return win
end

function CRFClass_ToggleLayoutEditor(f)   -- forward-declared above (the options button uses it)
    local win = BuildLayoutEditor(f)
    win:SetShown(not win:IsShown())
end
end   -- layout editor block

-- A draggable minimap button (parented to the Minimap, positioned by angle on the ring)
-- that opens the options window. Uses the Cat Form icon. Position is saved.
local function BuildMinimapButton(f)
    if f.minimapButton or not Minimap then return f and f.minimapButton end
    local b = CreateFrame("Button", "ClassResourcesForeverMinimapButton", Minimap)
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
    icon:SetTexture(SpellTex(768) or CAT_FALLBACK_ICON)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53); border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    -- Sit on the minimap ring: radius from the minimap's own size (works whatever its
    -- scale/shape), not a hardcoded value that overlaps a larger minimap.
    local function place()
        local a = math.rad(db.minimapAngle or 200)
        local r = (Minimap:GetWidth() / 2) + 5
        b:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
    end
    place()

    b:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local sc = Minimap:GetEffectiveScale()
            db.minimapAngle = math.deg(math.atan2(cy / sc - my, cx / sc - mx))
            place()
        end)
    end)
    b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    b:SetScript("OnClick", function() ToggleOptions(f) end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Class Resources Forever - " .. (profile and profile.label or "Class"))
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
        text = "Class Resources Forever - " .. (profile and profile.label or "Class"),
        icon = SpellTex(768) or CAT_FALLBACK_ICON,
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
    f:SetSize(BAR_W, BAR_H + CP_H + GAP)
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:EnableMouse(false)   -- only interactive while unlocked
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        PinBottom(self)   -- saved by its bottom edge (see PinBottom)
        local pos = db.position
        print(("|cff00ff88ClassResourcesForever:|r position saved (%d, %d)."):format(pos.x or 0, pos.y or 0))
    end)

    -- One bar: a StatusBar with a dark backing, a subtle gloss and a crisp dark border.
    -- The backing and border are drawn ON the bar (below its fill), so hiding the bar
    -- hides its frame too. Slots are positioned by CRFClass_ApplyBarVisibility.
    local function MakeBar(h, r, g, b, bgR, bgG, bgB)
        local s = CreateFrame("StatusBar", nil, f)
        s:SetSize(BAR_W, h)
        s:SetStatusBarTexture(BAR_TEX)
        s:SetStatusBarColor(r, g, b)
        s:SetMinMaxValues(0, 100)
        s:SetValue(0)
        local bg = s:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(s)
        bg:SetColorTexture(bgR, bgG, bgB, 0.55)
        Outline(s, s, 2)   -- dark border just outside the bar
        Gloss(s)
        return s
    end

    -- Combo-point bar (Cat Form). Combo points are fed straight into the StatusBar;
    -- dividers split the fill into MAX_CP segments so it reads as combo points.
    local cp = MakeBar(CP_H, 0.92, 0.20, 0.16, 0.16, 0.03, 0.03)
    cp:SetMinMaxValues(0, MAX_CP)
    for i = 1, MAX_CP - 1 do
        local div = cp:CreateTexture(nil, "OVERLAY")
        div:SetColorTexture(0.05, 0.05, 0.06, 1)
        div:SetSize(2, CP_H)
        div:SetPoint("CENTER", cp, "LEFT", (BAR_W / MAX_CP) * i, 0)
    end

    -- "Combo points maxed" cue on the LAST segment: a brighter fill plus a pulsing red
    -- flash. Each piece is its own StatusBar with range (MAX_CP-1)..MAX_CP, fed the same
    -- value as the combo bar in UpdateCP: below max it clamps to empty, at max it fills.
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
    local hi = MaxBar(cp, BAR_TEX, 1.0, 0.45, 0.35)
    hi:SetPoint("TOPLEFT", cp, "TOPLEFT", x0, 0)
    hi:SetPoint("BOTTOMRIGHT", cp, "BOTTOMRIGHT", 0, 0)
    local pulse = CreateFrame("Frame", nil, cp)
    pulse:SetPoint("TOPLEFT", cp, "TOPLEFT", x0, 0)
    pulse:SetPoint("BOTTOMRIGHT", cp, "BOTTOMRIGHT", 0, 0)
    local flash = MaxBar(pulse, WHITE, 1.0, 0.25, 0.15)
    flash:GetStatusBarTexture():SetBlendMode("ADD")
    flash:SetAllPoints(pulse)
    RegisterPulse(pulse, 0.15, 0.8)   -- shared-clock pulse
    f.cpMax = { hi, flash }

    -- Rage / energy bar (Bear / Cat; hidden in mana forms), recoloured per form in
    -- CRFClass_UpdatePower, with the current value as text.
    local power = MakeBar(BAR_H, 0.00, 0.44, 0.87, 0.04, 0.06, 0.12)
    local powerText = power:CreateFontString(nil, "OVERLAY")
    powerText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    powerText:SetPoint("CENTER", power, "CENTER", 0, 0)
    powerText:SetTextColor(1, 1, 1, 1)

    -- Mana bar, shown in every form, with the exact value on it, so you can see when you
    -- have the mana to shift back out.
    local mana2 = MakeBar(MANA2_H, 0.00, 0.44, 0.87, 0.04, 0.06, 0.12)

    -- Mana cost of the spell being cast: a light blue segment over the end of the fill
    -- (the part that will be spent), like the default player frame. Kept inside the bar.
    local costClip = CreateFrame("Frame", nil, mana2)
    costClip:SetAllPoints(mana2)
    costClip:SetClipsChildren(true)
    local costLayer = CreateFrame("Frame", nil, costClip)
    costLayer:SetAllPoints(costClip)
    local manaCost = costLayer:CreateTexture(nil, "OVERLAY")
    manaCost:SetTexture(BAR_TEX)
    manaCost:SetVertexColor(0.55, 0.80, 1.00, 0.85)
    manaCost:SetPoint("TOPRIGHT", mana2:GetStatusBarTexture(), "TOPRIGHT")
    manaCost:SetPoint("BOTTOMRIGHT", mana2:GetStatusBarTexture(), "BOTTOMRIGHT")
    manaCost:Hide()
    f.manaCost = manaCost

    -- The value text, above the cost segment.
    local mana2TextLayer = CreateFrame("Frame", nil, mana2)
    mana2TextLayer:SetAllPoints(mana2)
    mana2TextLayer:SetFrameLevel(costLayer:GetFrameLevel() + 1)
    local mana2Text = mana2TextLayer:CreateFontString(nil, "OVERLAY")
    mana2Text:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    mana2Text:SetPoint("CENTER", mana2, "CENTER", 0, 0)
    mana2Text:SetTextColor(1, 1, 1, 1)

    -- Health bar (optional, off by default), with its value. Coloured green -> orange ->
    -- red by health left (see CRFClass_UpdateHealth).
    local health = MakeBar(BAR_H, 0.18, 0.78, 0.22, 0.03, 0.12, 0.03)
    health:SetMinMaxValues(0, 1)
    health:SetValue(1)
    -- Incoming heals, Blizzard style: a light green strip right after your current health
    -- (your own heal being cast included). Its own bar, same width and max as the health
    -- bar, hung off the end of the health fill; anything past full health is cut off.
    local healClip = CreateFrame("Frame", nil, health)
    healClip:SetAllPoints(health)
    healClip:SetClipsChildren(true)
    local heal = CreateFrame("StatusBar", nil, healClip)
    heal:SetPoint("TOPLEFT", health:GetStatusBarTexture(), "TOPRIGHT")
    heal:SetPoint("BOTTOMLEFT", health:GetStatusBarTexture(), "BOTTOMRIGHT")
    heal:SetWidth(BAR_W)
    heal:SetStatusBarTexture(BAR_TEX)
    heal:SetStatusBarColor(0.45, 1.0, 0.45, 0.55)
    heal:SetMinMaxValues(0, 1)
    heal:SetValue(0)
    health.incoming = heal
    -- The value text, above the incoming-heal strip.
    local healthTextLayer = CreateFrame("Frame", nil, health)
    healthTextLayer:SetAllPoints(health)
    healthTextLayer:SetFrameLevel(healClip:GetFrameLevel() + 2)
    local healthText = healthTextLayer:CreateFontString(nil, "OVERLAY")
    healthText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    healthText:SetPoint("CENTER", health, "CENTER", 0, 0)
    healthText:SetTextColor(1, 1, 1, 1)
    health:Hide()
    f.health, f.healthText = health, healthText

    -- Helper: a cooldown-tracked ability icon with key/ids/label.
    local function AddCD(key, ids)
        local o = MakeIcon(f, SpellTex(ids[1]))
        o.key, o.ids, o.label = key, ids, (SpellName(ids[1]) or key)
        return o
    end

    -- Class abilities (see SPELLS): every one gets an icon; the known-spell check shows
    -- the ones you've learned, and LayoutIcons shows only your current form's. Buff
    -- abilities get the red "active" phase; the rest are cooldown-only.
    f.icons, f.cooldowns = {}, {}

    -- Clearcasting proc (see ClearcastingUp): not part of the cooldown row but its own
    -- icon in its own small movable spot (just above the bars until you drag it; see
    -- CRFClass_PlaceClearcasting) -- shown only while the proc is up, with blue comets and the
    -- buff's countdown, or while unlocked so it can be dragged.
    do
        local cf = CreateFrame("Frame", nil, UIParent)
        cf:SetSize(ICON_SIZE, ICON_SIZE)
        cf:SetMovable(true)
        cf:SetClampedToScreen(true)
        cf:EnableMouse(false)   -- only interactive while unlocked
        cf:RegisterForDrag("LeftButton")
        cf:SetScript("OnDragStart", function(self) self:StartMoving() end)
        cf:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            local p, _, rp, x, y = self:GetPoint()
            if p then db.ccPos = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 } end
        end)
        f.ccFrame = cf

        local o = MakeIcon(cf, SpellTex(CC_ICON_SPELL))
        o:SetPoint("CENTER", cf, "CENTER")
        AddBorderFX(o, 0.35, 0.65, 1.0)   -- blue
        MakeBuffNumber(o)
        o:Hide()
        f.ccIcon = o
    end

    for _, s in ipairs(SPELLS) do
        local o = AddCD(s.key, s.ids)
        o.forms, o.group = s.forms, s.group
        if s.dur then AddActiveFX(o, s.dur) end
        f.icons[#f.icons + 1] = o
        f.cooldowns[#f.cooldowns + 1] = o
    end

    -- Racial abilities (see RACIALS): only the one this character actually has gets an
    -- icon (your race never changes), so the other race's doesn't clutter arrange mode.
    local racials = {}
    for _, r in ipairs(RACIALS) do
        if SpellKnown(r.id) then
            local o = AddCD(r.key, { r.id })
            if r.dur then AddActiveFX(o, r.dur) end
            racials[#racials + 1] = o
            f.icons[#f.icons + 1] = o
            f.cooldowns[#f.cooldowns + 1] = o
        end
    end

    f.cp, f.power, f.powerText, f.mana2, f.mana2Text = cp, power, powerText, mana2, mana2Text
    f.iconByKey = {}
    for _, o in ipairs(f.icons) do f.iconByKey[o.key] = o end

    for _, o in ipairs(f.icons) do CRFClass_WireIconDrag(f, o) end
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
        CRFClass_WireCooldownDone(o)
    end
    CRFClass_BuildCustomIcons(f)   -- the player's own spells / items (wired as they're made)
    ReconcileOrder(f)
    ReconcileLayout(f)
    LayoutIcons(f)   -- position only the learned abilities, in the saved order
    return f
end

do   -- health bar block
-- Health colours: green when healthy, orange from half health, red below 20%.
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

-- The same scale as a colour curve. Built once; false if this client has none.
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

-- Colour the health bar by health left.
local function ColorHealth(f, hp, maxHp)
    if not (IsSecretV(hp) or IsSecretV(maxHp)) then
        if maxHp and maxHp > 0 then
            SetHealthRGB(f, HealthColor(math.max(0, math.min(1, hp / maxHp))))
        end
        return
    end
    local curve = UnitHealthPercent and HealthCurve()
    if curve then
        pcall(function()
            local color = UnitHealthPercent("player", false, curve)
            SetHealthRGB(f, color:GetRGB())
        end)
    end
end

function CRFClass_UpdateHealth(f)   -- forward-declared above (the options checkbox uses it)
    if not f.health:IsShown() then return end
    local maxHp = UnitHealthMax("player")
    f.health:SetMinMaxValues(0, maxHp)
    local hp = UnitHealth("player")
    f.health:SetValue(hp)
    f.healthText:SetText(hp)
    -- Incoming heals (see BuildUI); none shows as 0.
    local inc = f.health.incoming
    if inc then
        inc:SetMinMaxValues(0, maxHp)
        local amount = UnitGetIncomingHeals and UnitGetIncomingHeals("player")
        if IsSecretV(amount) then
            inc:SetValue(amount)
        else
            inc:SetValue(amount or 0)
        end
    end
    ColorHealth(f, hp, maxHp)
end
end   -- health bar block

-- The rage/energy bar + the mana bar. While unlocked both are tinted green ("movable").
local UNLOCK_COLOR = { 0.20, 0.85, 0.30 }
function CRFClass_UpdatePower(f)   -- forward-declared above (CRFClass_SetLocked uses it)
    local locked = db.locked
    local pt = ActivePowerType()
    local c = locked and POWER_COLOR[pt] or UNLOCK_COLOR
    f.power:SetStatusBarColor(c[1], c[2], c[3])
    f.power:SetMinMaxValues(0, PowerMax(pt))
    local cur = UnitPower("player", pt)
    f.power:SetValue(cur)
    f.powerText:SetText(profile and profile.label or "Resource")
    local m = locked and POWER_COLOR[POWER_MANA] or UNLOCK_COLOR
    f.mana2:SetStatusBarColor(m[1], m[2], m[3])
    f.mana2:SetMinMaxValues(0, PowerMax(POWER_MANA))
    local mana = UnitPower("player", POWER_MANA)
    f.mana2:SetValue(mana)
    f.mana2Text:SetText("Mana")
    if currentClass == "HUNTER" and UnitExists("pet") then
        local focus = (Enum and Enum.PowerType and Enum.PowerType.Focus) or 2
        local petMax = UnitPowerMax("pet", focus)
        if not IsSecretV(petMax) and type(petMax) == "number" and petMax > 0 then f.mana2:SetMinMaxValues(0, petMax) end
        f.mana2:SetValue(UnitPower("pet", focus))
        f.mana2Text:SetText("Pet Focus")
    elseif currentClass == "HUNTER" then
        f.mana2:Hide()
    elseif currentClass == "WARLOCK" and C_Container and C_Container.GetContainerNumSlots then
        local count = 0
        for bag = 0, 4 do for slot = 1, (C_Container.GetContainerNumSlots(bag) or 0) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID == 6265 then count = count + (info.stackCount or 1) end
        end end
        f.mana2:SetMinMaxValues(0, 32); f.mana2:SetValue(count)
        f.mana2Text:SetText("Soul Shards: " .. count)
    end
end

-- Mana cost of a spell (0 if it costs no mana, or can't be read).
local function ManaCost(spellID)
    if not (C_Spell and C_Spell.GetSpellPowerCost) then return 0 end
    local ok, costs = pcall(C_Spell.GetSpellPowerCost, spellID)
    if not ok or type(costs) ~= "table" then return 0 end
    for _, c in ipairs(costs) do
        if not IsSecretV(c.type) and c.type == POWER_MANA and not IsSecretV(c.cost) then
            return c.cost or 0
        end
    end
    return 0
end

-- Show the light blue "about to be spent" segment for a spell being cast, sized by its
-- mana cost; nil hides it.
local function ShowManaCost(f, spellID)
    local cost = spellID and ManaCost(spellID) or 0
    if cost <= 0 or not f.mana2:IsShown() then f.manaCost:Hide() return end
    local w = math.min(1, cost / PowerMax(POWER_MANA)) * f.mana2:GetWidth()
    f.manaCost:SetWidth(math.max(1, w))
    f.manaCost:Show()
end

local function UpdateCP(f)
    if currentClass ~= "DRUID" then return end
    -- The same value drives the max-CP cue bars (they only fill at MAX_CP).
    local v = GetCP()
    f.cp:SetValue(v)
    if f.cpMax then
        for _, s in ipairs(f.cpMax) do s:SetValue(v) end
    end
end

-- Cooldowns start when a tracked spell is cast. The swipe runs to completion so
-- OnCooldownDone fires the ready-flash (we never Clear() it mid-run).
function CRFClass_SetCooldownSwipe(o, id)   -- forward-declared above (BuildUI's cooldown-done uses it)
    -- Custom items: the item's own cooldown; if that can't be shown, fall back to the
    -- item's use spell below.
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

local function StartCooldownSwipe(o, castID)
    -- Defer a frame so the cooldown is registered after the cast succeeds.
    C_Timer.After(0.05, function()
        o.running = true
        CRFClass_SetCooldownSwipe(o, castID)
    end)
end

-- At login, catch any tracked ability ALREADY on cooldown.
local function PollCooldown(o)
    if o.running then return end
    if o.itemID then
        -- Items: on cooldown if its duration is longer than a global cooldown.
        local ok, onCD = pcall(function()
            local _, dur = GetItemCD(o.itemID)
            if IsSecretV(dur) then return true end
            return (dur or 0) > 1.5
        end)
        if ok and onCD then
            o.running = true
            CRFClass_SetCooldownSwipe(o)
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
                CRFClass_SetCooldownSwipe(o, id)
                return
            end
        end
    end
end

local function PollCooldowns(f)
    if not f.cooldowns then return end
    for _, o in ipairs(f.cooldowns) do PollCooldown(o) end
end

function CRFClass_ApplyPosition(f)   -- forward-declared above (options reset button uses it)
    local pos = db.position or RR.defaults.position
    f:ClearAllPoints()
    f:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or 0)
end

-- Stack the bars top to bottom in the saved bar order, showing each only where it
-- applies: combo points in Cat Form, the rage/energy bar whenever your active power
-- isn't mana (Bear, Cat), mana always, health when turned on (and each only if it's
-- turned on in the options). Hidden bars take no space, so there are no gaps in any
-- form. Re-run on every form change.
local BAR_GAP = 4   -- space between stacked bars
function CRFClass_ApplyBarVisibility(f)   -- forward-declared above (the options checkboxes use it)
    local bars = { cp = f.cp, power = f.power, mana = f.mana2, health = f.health }
    local applies = {
        cp = CurrentForm() == "cat",
        power = currentClass ~= "DRUID" or ActivePowerType() ~= POWER_MANA,
        mana = true,
        health = true,
    }
    local slots = {}
    for _, k in ipairs(BarOrder()) do
        local show = BarShown(k) and applies[k]
        bars[k]:SetShown(show)
        if show then slots[#slots + 1] = bars[k] end
    end
    -- Stacked up from the frame's bottom edge (the last bar in the order sits on it), so
    -- the cooldown icons hanging below never move.
    local y = 0
    for i = #slots, 1, -1 do
        local b = slots[i]
        b:ClearAllPoints()
        b:SetPoint("BOTTOM", f, "BOTTOM", 0, y)
        y = y + b:GetHeight() + (i > 1 and BAR_GAP or 0)
    end
    -- With every bar off, keep an invisible bar-height strip above the icons so the
    -- frame can still be grabbed and dragged when unlocked. Pinned by its bottom first,
    -- so the height change doesn't move the icons (see PinBottom).
    local h = y > 0 and y or BAR_H
    if math.abs(f:GetHeight() - h) > 0.01 then PinBottom(f) end
    f:SetHeight(h)
    -- The topmost bar shown, for icons placed above the bars.
    f.topBar = slots[1]
    LayoutIcons(f)
end

-- "Show only in combat": hide the bars + icons outside combat. They still show while
-- unlocked or while the layout editor is open, so they can be positioned.
local inCombat = false
function CRFClass_UpdateCombatVisibility(f)   -- forward-declared above
    local show = not db.combatOnly or inCombat
        or not db.locked or RR.editing
    f:SetShown(show and true or false)
end

function CRFClass_SetLocked(f, locked)   -- forward-declared above (options Lock button uses it)
    db.locked = locked
    f:EnableMouse(not locked)
    -- Icons take the mouse while unlocked (dragging one moves the tracker);
    -- locked, clicks pass straight through them.
    for _, o in ipairs(f.icons) do o:EnableMouse(not locked) end
    if not locked then
        print("|cff00ff88ClassResourcesForever:|r unlocked - drag the bars or cooldown icons to move the tracker; /cr lock when done.")
    end
    CRFClass_UpdatePower(f)              -- unlocked tints the power bar green ("movable")
    CRFClass_UpdateBuffs(f)              -- buff icons cast on click only while locked
    CRFClass_PlaceClearcasting(f)        -- its own spot shows (and drags) while unlocked
    CRFClass_UpdateCombatVisibility(f)   -- unlocked always shows (so it can be moved)
end

-- Place the Clearcasting icon's own spot: where you dragged it, or -- the first time, and
-- after "Reset positions" -- just above the bars. While unlocked the icon stays visible
-- and can be dragged; locked, it only shows while the proc is up.
function CRFClass_PlaceClearcasting(f)   -- forward-declared above (lock / reset)
    local o, cf, db = f.ccIcon, f.ccFrame, db
    if not (o and cf) then return end
    if not db.ccPos then
        -- Start just above the bars (both frames share the UI scale).
        local x, top = f:GetCenter(), f:GetTop()
        if x and top then
            db.ccPos = { point = "CENTER", relativePoint = "BOTTOMLEFT", x = x, y = top + 8 + ICON_SIZE / 2 }
        end
    end
    local pos = db.ccPos or { point = "CENTER", relativePoint = "CENTER", x = 0, y = -100 }
    cf:ClearAllPoints()
    cf:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    cf:EnableMouse(not db.locked)
    o:SetShown(o.ccOn or not db.locked)
end

local CRFClass_BuildBuffFrame, CRFClass_BuffCastSucceeded
do   -- buff icons block (Mark of the Wild / Thorns)
-- ---------------------------------------------------------------------------
-- A SEPARATE, independently movable pair of icons for your own Mark of the Wild and
-- Thorns: the time left on the buff, a red pulse when it's missing, and left-click to
-- cast it on yourself (a secure button, armed while the bars are locked). Out of combat
-- the buff's real time is read; in combat the last known time keeps counting down, and
-- a cast from the icon restarts it.
-- ---------------------------------------------------------------------------
local BUFFS = {
    {   -- Mark of the Wild (ranks 1-7) + Gift of the Wild (ranks 1-2, counts as the buff)
        key = "motw", dur = 3600,   -- 60 min on WoW: Forever (seen in game)
        ids = { 1126, 5232, 6756, 5234, 8907, 9884, 9885 },
        also = { 21849, 21850 },
    },
    {   -- Thorns (ranks 1-6)
        key = "thorns", dur = 600,
        ids = { 467, 782, 1075, 8914, 9756, 9910 },
    },
}
for _, d in ipairs(BUFFS) do
    d.set = {}
    for _, id in ipairs(d.ids) do d.set[id] = true end
    for _, id in ipairs(d.also or {}) do d.set[id] = true end
end

-- Highest known rank of a buff spell (ranks are listed low to high), or nil.
local function HighestKnown(ids)
    local best
    for _, id in ipairs(ids) do
        if SpellKnown(id) then best = id end
    end
    return best
end

-- Read your buffs: each button's expiry, or nil if the buff is missing. Permanent buffs
-- count as never expiring. A read can only be trusted when the game shows your buffs:
-- not in combat (which starts a moment BEFORE the combat lockdown does), and not when
-- they come back hidden or as an empty list (as in some instances, even out of combat).
-- Then the last known times are kept and keep counting down; with none known yet, the
-- icons stay neutral (see RefreshBuffIcon) rather than claiming the buffs are missing.
local function ScanBuffs(bf)
    if UnitAffectingCombat("player") then return end
    if UnitIsDeadOrGhost("player") then   -- dying clears your buffs
        for _, b in ipairs(bf.buttons) do b.expiry, b.known = nil, true end
        return
    end
    if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then return end
    local found, count = {}, 0
    for i = 1, 40 do
        local ok, a = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
        if not ok then return end   -- couldn't read: keep the last known times
        if not a then break end
        local sid, exp = a.spellId, a.expirationTime
        if IsSecretV(sid) or IsSecretV(exp) then return end   -- hidden: keep them too
        count = count + 1
        for _, b in ipairs(bf.buttons) do
            if b.def.set[sid] then
                found[b] = (exp and exp > 0) and exp or math.huge
                -- The buff's real length, for a recast in combat (see CRFClass_BuffCastSucceeded).
                local dur = a.duration
                if not IsSecretV(dur) and dur and dur > 0 then b.realDur = dur end
            end
        end
    end
    if count == 0 then return end   -- an empty list can mean "hidden": keep them
    for _, b in ipairs(bf.buttons) do b.expiry, b.known = found[b], true end
end

-- Show a button's state: the time left, or the red pulse when the buff is known to be
-- missing. Before your buffs could be read at all, it shows neither.
local function RefreshBuffIcon(b)
    local missing = b.known and (not b.expiry or b.expiry <= GetTime())
    b.red:SetShown(missing and true or false)
    if not b.expiry or b.expiry <= GetTime() then b.timer:SetText("") end
end

function CRFClass_BuildBuffFrame(f)
    if currentClass ~= "DRUID" then return end
    local bf = CreateFrame("Frame", nil, UIParent)
    bf:SetSize(ICON_SIZE * 2 + ICON_GAP, ICON_SIZE)
    bf:SetMovable(true)
    bf:SetClampedToScreen(true)
    bf.buttons = {}

    for _, def in ipairs(BUFFS) do
        local b = CreateFrame("Button", nil, bf, "SecureActionButtonTemplate")
        b:SetSize(ICON_SIZE, ICON_SIZE)
        b:RegisterForClicks("AnyDown")   -- fire once on press
        b.def = def

        local border = b:CreateTexture(nil, "BACKGROUND")
        border:SetPoint("TOPLEFT", -1, 1); border:SetPoint("BOTTOMRIGHT", 1, -1)
        border:SetColorTexture(0, 0, 0, 1)
        local icon = b:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(b); icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        icon:SetTexture(SpellTex(def.ids[1]))
        local red = b:CreateTexture(nil, "OVERLAY", nil, 4)
        red:SetAllPoints(b); red:SetColorTexture(1, 0, 0, 1); red:SetBlendMode("ADD"); red:Hide()
        RegisterPulse(red, 0.15, 0.55)   -- shared-clock pulse, in sync with the max-CP flash
        local timer = b:CreateFontString(nil, "OVERLAY")
        timer:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE"); timer:SetPoint("BOTTOM", 0, 1)
        b.icon, b.red, b.timer = icon, red, timer

        -- Countdown: minutes, then seconds in the last minute (orange from 2 minutes);
        -- turns red when it runs out. Rounded like the game's own buff timers: minutes UP
        -- (a fresh 30-minute buff reads 30m), seconds DOWN (0s in the final second).
        -- Throttled to ~0.1s.
        b:SetScript("OnUpdate", function(self, elapsed)
            self._acc = (self._acc or 0) + elapsed
            if self._acc < 0.1 then return end
            self._acc = 0
            local rem = self.expiry and (self.expiry - GetTime())
            if not rem or rem <= 0 or rem == math.huge then
                if rem and rem <= 0 then self.expiry = nil end
                RefreshBuffIcon(self)
                return
            end
            self.timer:SetText(rem >= 60 and (math.ceil(rem / 60) .. "m") or (math.floor(rem) .. "s"))
            if rem <= 120 then self.timer:SetTextColor(1, 0.5, 0.2) else self.timer:SetTextColor(1, 1, 1) end
            RefreshBuffIcon(self)
        end)

        -- Remember a click, so a cast in combat (when the buff can't be read) can restart
        -- the timer.
        b:SetScript("PostClick", function(self) self.clickedAt = GetTime() end)

        b:SetScript("OnEnter", function(self)
            if not self.spellID then return end
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetSpellByID(self.spellID)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)

        -- Left-drag the pair to move it while unlocked (out of combat).
        b:RegisterForDrag("LeftButton")
        b:SetScript("OnDragStart", function()
            if not db.locked and not InCombatLockdown() then bf:StartMoving() end
        end)
        b:SetScript("OnDragStop", function()
            bf:StopMovingOrSizing()
            local p, _, rp, x, y = bf:GetPoint()
            if p then db.buffPos = { point = p, relativePoint = rp or p, x = x or 0, y = y or 0 } end
        end)

        bf.buttons[#bf.buttons + 1] = b
    end

    f.buffFrame = bf
    return bf
end

-- A buff was cast. In combat the buff can't be read, so if it came from our icon (a
-- self-cast), start its timer from now. Out of combat the next read covers it.
function CRFClass_BuffCastSucceeded(f, spellID)
    local bf = f.buffFrame
    if not bf or not InCombatLockdown() then return end
    for _, b in ipairs(bf.buttons) do
        if b.def.set[spellID] and b.clickedAt and GetTime() - b.clickedAt < 2 then
            b.clickedAt = nil
            b.expiry = GetTime() + (b.realDur or b.def.dur)
            RefreshBuffIcon(b)
        end
    end
end

function CRFClass_ApplyBuffPosition(f)   -- forward-declared above (options reset button uses it)
    if not f.buffFrame or InCombatLockdown() then return end
    local pos = db.buffPos or RR.defaults.buffPos
    f.buffFrame:ClearAllPoints()
    f.buffFrame:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.x or 0, pos.y or 0)
    f.buffFrame.placed = true
end

-- Refresh the icons. Out of combat: which spells you know, the click-to-cast setup,
-- visibility and the buffs' real times. In combat (click-to-cast buttons can't be
-- changed then, and buffs can't be read) only the timers carry on.
function CRFClass_UpdateBuffs(f)   -- forward-declared above
    if currentClass ~= "DRUID" then return end
    local bf = f.buffFrame
    if not bf then return end
    if not InCombatLockdown() then
        -- Scale and position can't be set in combat; catch up on any that were skipped
        -- (a /reload mid-fight, the scale slider used in combat).
        local s = db.scale or 1.0
        if math.abs(bf:GetScale() - s) > 1e-4 then bf:SetScale(s) end
        if not bf.placed then CRFClass_ApplyBuffPosition(f) end
        local x = 0
        for _, b in ipairs(bf.buttons) do
            local id = HighestKnown(b.def.ids)
            b.spellID = id
            b:SetShown(id ~= nil)
            if id then
                b.icon:SetTexture(SpellTex(id))
                b:ClearAllPoints()
                b:SetPoint("LEFT", bf, "LEFT", x, 0)
                x = x + ICON_SIZE + ICON_GAP
            end
            -- Armed only while locked, so an unlocked click just moves the icons.
            if id and db.locked then
                b:SetAttribute("type1", "spell")
                b:SetAttribute("spell", id)
                b:SetAttribute("unit", "player")
            else
                b:SetAttribute("type1", nil)
            end
        end
        bf:SetShown(x > 0 and not db.buffsHidden)
        ScanBuffs(bf)
    end
    for _, b in ipairs(bf.buttons) do RefreshBuffIcon(b) end
end

-- Show / hide the icons from the options. Not possible in combat (they hold
-- click-to-cast buttons); the checkbox then snaps back.
function CRFClass_ToggleBuffs(f, check)   -- forward-declared above
    if InCombatLockdown() then
        print("|cff00ff88ClassResourcesForever:|r can't show or hide these icons in combat.")
        return
    end
    db.buffsHidden = not check:GetChecked()
    CRFClass_UpdateBuffs(f)
end
end   -- buff icons block

local CRFClass_BuildWellFed
do   -- Well Fed warning block
-- ---------------------------------------------------------------------------
-- Optional "WELL FED MISSING" warning at the top of the screen. Buffs can only be read
-- out of combat and you can't eat in combat, so the warning hides when a fight starts
-- and the check runs again once it ends. "Dismiss" hides it until you're Well Fed again
-- (saved, so it survives a reload); the next time the buff is gone, it warns again.
-- ---------------------------------------------------------------------------
-- Food buffs: most are called "Well Fed" (matched by the game's own name and icon); a
-- few foods give a differently named buff, matched by spell ID.
local WELL_FED_ID = 19705
local WF_CONFIRM = 5   -- seconds the buff must stay missing before warning
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

-- true / false, or nil when it can't be told right now.
local function HasWellFed()
    if InCombatLockdown() or UnitAffectingCombat("player") then return nil end
    if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then return nil end
    local wfName, wfIcon = SpellName(WELL_FED_ID), SpellTex(WELL_FED_ID)
    local unsure = false
    for i = 1, 40 do
        local ok, a = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
        if not ok then return nil end
        if not a then   -- no more buffs
            -- In instances the list can come back empty, which says nothing about the buff.
            if i == 1 and IsInInstance() then return nil end
            break
        end
        local name, icon, sid = a.name, a.icon, a.spellId
        if not IsSecretV(sid) and sid and FOOD_BUFF_IDS[sid] then return true end
        if not IsSecretV(name) and wfName and name == wfName then return true end
        if not IsSecretV(icon) and wfIcon and icon == wfIcon then return true end
        if IsSecretV(name) or IsSecretV(icon) or IsSecretV(sid) then unsure = true end
    end
    if unsure then return nil end
    return false
end

function CRFClass_BuildWellFed(f)
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
        db.wellFedDismissed = true
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

-- `castID` (optional): a spell you just cast, so getting a food buff mid-fight counts
-- straight away instead of only when the fight ends.
function CRFClass_UpdateWellFed(f, castID)   -- forward-declared above (the options checkbox uses it)
    local w = f.wellFed
    if not w then return end
    local db = db
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

-- Your form changed (or its power type caught up): re-slot the bars, recolour the power
-- bar, refresh combo points and show that form's icons.
local function OnFormChange(f)
    CRFClass_ApplyBarVisibility(f)   -- also lays out this form's icons
    CRFClass_UpdatePower(f)
    UpdateCP(f)
end

-- ---------------------------------------------------------------------------
-- Wiring
-- ---------------------------------------------------------------------------
local frame
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")   -- DB is seeded here; SVs aren't ready at ADDON_LOADED
-- Power values (UNIT_POWER_FREQUENT carries the smooth energy/mana regen ticks) and
-- maximums (they change with gear, buffs and forms).
ev:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
ev:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
ev:RegisterUnitEvent("UNIT_MAXPOWER", "player")
-- The optional health bar.
ev:RegisterUnitEvent("UNIT_HEALTH", "player")
ev:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
pcall(ev.RegisterUnitEvent, ev, "UNIT_HEAL_PREDICTION", "player")   -- incoming heals
-- Shapeshifting. At the moment UPDATE_SHAPESHIFT_FORM fires, the active power type can
-- still be the old form's (seen in testing), so UNIT_DISPLAYPOWER -- the power type
-- actually changing -- triggers the same refresh.
ev:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
ev:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
-- Combo points live on the target.
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
-- UNIT_SPELLCAST_SUCCEEDED reports the cast spellID: the trigger for the cooldown icons.
ev:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
-- A cast with a cast time starting / ending: the mana cost segment on the mana bar.
ev:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
-- A cast being sent (before it lands): used to tell when Clearcasting procs again on the
-- same hit that used it up.
ev:RegisterUnitEvent("UNIT_SPELLCAST_SENT", "player")
ev:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
ev:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
ev:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
-- Re-lay-out the icon row when spells are learned, so new abilities appear.
ev:RegisterEvent("SPELLS_CHANGED")
-- A spell became usable / unusable (with the power events: the blue "no power" tint).
ev:RegisterEvent("SPELL_UPDATE_USABLE")
-- Your buffs changed: the Mark of the Wild / Thorns icons.
ev:RegisterUnitEvent("UNIT_AURA", "player")
-- Death and coming back to life: the optional Well Fed warning.
ev:RegisterEvent("PLAYER_DEAD")
ev:RegisterEvent("PLAYER_ALIVE")
ev:RegisterEvent("PLAYER_UNGHOST")
-- Entering / leaving combat, for the "Show only in combat" option.
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
-- Talents changed (respec or a loadout switch): Feral Charge may have been gained or lost.
-- pcall: not every client has all of these events.
local TALENT_EVENTS = { TRAIT_CONFIG_UPDATED = true, TRAIT_NODE_CHANGED = true, PLAYER_TALENT_UPDATE = true }
for e in pairs(TALENT_EVENTS) do pcall(ev.RegisterEvent, ev, e) end
-- Custom items: equipped / unequipped, gained / used up, and item data arriving late.
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
pcall(ev.RegisterEvent, ev, "BAG_UPDATE_DELAYED")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
-- Belt-and-suspenders: persist the frame position on logout/reload too.
ev:RegisterEvent("PLAYER_LOGOUT")

ev:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, arg4)
    if event == "PLAYER_LOGIN" then
        -- Class-only: on any other class build nothing and drop all events (the folder
        -- can sit installed on an alt harmlessly).
        local _, class = UnitClass("player")
        if class == "DRUID" or class == "ROGUE" or not (ns.Classes and ns.Classes[class]) then
            self:UnregisterAllEvents()
            return
        end
        currentClass = class
        profile = ns.Classes[class]
        ClassResourcesForeverDB = type(ClassResourcesForeverDB) == "table" and ClassResourcesForeverDB or {}
        db = ClassResourcesForeverDB[class]
        if type(db) ~= "table" then db = {} end
        ClassResourcesForeverDB[class] = db
        SPELLS = {}
        for _, spell in ipairs(profile.spells or {}) do
            SPELLS[#SPELLS + 1] = { key = "class" .. spell.id, ids = { spell.id }, dur = spell.active }
        end
        RACIALS = {}
        for _, racial in ipairs(ns.Racials or {}) do
            RACIALS[#RACIALS + 1] = { key = "racial" .. racial.id, id = racial.id, dur = racial.active }
        end
        L.casterForm = profile.label
        L.showPower = "Show " .. profile.label .. " resource bar"
        L.barPower = profile.label .. " resource"
        L.showBuffs = "Show class buffs"
        L.showCP = "Show secondary resource bar"
        L.showMana2 = "Show secondary resource"
        L.panelDesc = profile.label .. " resources and cooldowns. Use |cffffd100/cr unlock|r to move bars and icons, or |cffffd100/cr options|r to configure the tracker."
        if profile.spells and profile.spells[1] then CAT_FALLBACK_ICON = SpellTex(profile.spells[1].id) or CAT_FALLBACK_ICON end
        -- Seed the DB HERE, not at ADDON_LOADED: on this client SavedVariables aren't
        -- loaded until after ADDON_LOADED.
        db = ApplyDefaults(RR.defaults, db)
        -- Drop settings that are no longer used (incl. the earlier ClassResourcesForever addon's).
        for _, k in ipairs({ "iconOrder", "iconEnabled", "manaPos", "manaLocked", "manaScale", "minimapHidden", "ccDetached",
                          "iconEnabledByForm" }) do
            db[k] = nil
        end
        frame = BuildUI()
        CRFClass_BuildBuffFrame(frame)       -- Mark of the Wild / Thorns icons (set up by CRFClass_SetLocked below)
        CRFClass_BuildWellFed(frame)         -- the optional "Well Fed missing" warning
        BuildSettingsPanel(frame)   -- register the Options -> AddOns panel up front
        BuildMinimapButton(frame)
        RegisterAddonCompartment(frame)
        ApplyScale(frame)
        CRFClass_ApplyBarVisibility(frame)   -- height first: an older centre- or top-anchored
        CRFClass_ApplyPosition(frame)        -- position was saved with this height
        CRFClass_ApplyBuffPosition(frame)
        inCombat = UnitAffectingCombat("player") and true or false   -- e.g. /reload mid-fight
        CRFClass_SetLocked(frame, db.locked)   -- also applies "only in combat"
        CRFClass_UpdatePower(frame)
        UpdateCP(frame)
        CRFClass_UpdateHealth(frame)
        PollCooldowns(frame)   -- catch anything already on cooldown at login
        CRFClass_UpdateWellFed(frame)
        C_Timer.NewTicker(0.1, function() UpdateClearcasting(frame) end)
        C_Timer.NewTicker(2, function() CRFClass_UpdateWellFed(frame) end)
        return
    end

    if event == "PLAYER_LOGOUT" then
        if frame then
            local p, _, rp, x, y = frame:GetPoint()
            if p then db.position = { point = p, relativePoint = rp, x = x, y = y } end
        end
        return
    end

    if not frame then return end
    if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_HEAL_PREDICTION" then
        CRFClass_UpdateHealth(frame)
    elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" or event == "UNIT_MAXPOWER" then
        CRFClass_UpdatePower(frame)
        UpdateCP(frame)
        UpdateUsable(frame)
    elseif event == "SPELL_UPDATE_USABLE" then
        UpdateUsable(frame)
    elseif event == "UPDATE_SHAPESHIFT_FORM" or event == "UNIT_DISPLAYPOWER" then
        OnFormChange(frame)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UpdateCP(frame)
    elseif event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
        inCombat = (event == "PLAYER_REGEN_DISABLED")
        CRFClass_UpdateCombatVisibility(frame)
        CRFClass_UpdateBuffs(frame)      -- out of combat: re-read the buffs, re-arm click-to-cast
        if not inCombat then
            CRFClass_UpdateWellFed(frame)   -- buffs readable again
        elseif frame.wellFed then
            frame.wellFed:Hide()   -- nothing to do about it mid-fight
        end
    elseif event == "SPELLS_CHANGED" then
        -- Show/hide icons as abilities are learned. No cooldown poll here: this can fire
        -- mid-GCD (e.g. around a shift), and a poll would show the GCD on every idle icon.
        LayoutIcons(frame)
        CRFClass_RefreshOptions(frame)
        CRFClass_UpdateBuffs(frame)      -- a new Mark of the Wild / Thorns rank (or learning Thorns)
    elseif TALENT_EVENTS[event] then
        wipe(groupSeen)         -- re-check Feral Charge against the new talents
        LayoutIcons(frame)
    elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "BAG_UPDATE_DELAYED" then
        LayoutIcons(frame)      -- custom items gained, used up, equipped or unequipped
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        CRFClass_RefreshCustomItems(frame)   -- custom item names / icons / use spells
    elseif event == "UNIT_AURA" then
        CRFClass_UpdateBuffs(frame)      -- your buffs changed (read out of combat)
        CRFClass_UpdateWellFed(frame)
    elseif event == "PLAYER_DEAD" or event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        CRFClass_UpdateWellFed(frame)
    elseif event == "UNIT_SPELLCAST_START" then
        -- (unit, castGUID, spellID). Remember which cast the mana cost belongs to.
        frame.castGUID = (not IsSecretV(arg2)) and arg2 or nil
        ShowManaCost(frame, arg3)
    elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED"
        or event == "UNIT_SPELLCAST_INTERRUPTED" then
        -- Only the cast showing its cost ends it: pressing a spell again mid-cast fails
        -- on its own (with its own castGUID) while the real cast carries on.
        local cur = frame.castGUID
        local ends
        if IsSecretV(arg2) or cur == nil then
            ends = (event ~= "UNIT_SPELLCAST_FAILED")
        else
            ends = (arg2 == cur)
        end
        if ends then
            frame.castGUID = nil
            ShowManaCost(frame, nil)
        end
    elseif event == "UNIT_SPELLCAST_SENT" then
        -- (unit, target, castGUID, spellID): a cast about to use up Clearcasting.
        ClearcastingCastSent(frame, arg3, arg4)
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        -- arg3 = spellID for SUCCEEDED (unit, castGUID, spellID).
        ClearcastingCastSucceeded(frame, arg2)            -- a new proc on the same hit?
        if arg3 then CRFClass_BuffCastSucceeded(frame, arg3) end   -- Mark of the Wild / Thorns timers
        if arg3 then CRFClass_UpdateWellFed(frame, arg3) end       -- a food buff landing mid-fight
        if arg3 then
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
                -- Feral Charge: both charges share one cooldown, so the other form's
                -- icon copies the cooldown of the charge you just used.
                if cdIcon.group then
                    for _, o in ipairs(frame.cooldowns) do
                        if o ~= cdIcon and o.group == cdIcon.group then StartCooldownSwipe(o, arg3) end
                    end
                end
            end
        end
    end
end)

-- ---------------------------------------------------------------------------
-- Slash command: /cr
-- ---------------------------------------------------------------------------
SLASH_CLASSRESOURCESFOREVER1 = "/cr"
SlashCmdList.CLASSRESOURCESFOREVER = function(msg)
    if not frame then return end
    msg = (msg or ""):lower():gsub("%s+", "")
    if msg == "lock" then
        CRFClass_SetLocked(frame, true)
        CRFClass_RefreshOptions(frame)
    elseif msg == "unlock" then
        CRFClass_SetLocked(frame, false)
        CRFClass_RefreshOptions(frame)
    elseif msg == "options" or msg == "config" or msg == "" then
        ToggleOptions(frame)
    elseif msg == "layout" or msg == "arrange" then
        CRFClass_ToggleLayoutEditor(frame)
    elseif msg:match("^scale") then
        local n = tonumber(msg:match("scale(%d+%.?%d*)"))
        if n then
            n = math.max(SCALE_MIN, math.min(SCALE_MAX, n))
            db.scale = n
            ApplyScale(frame)
            CRFClass_RefreshOptions(frame)
            print(("|cff00ff88ClassResourcesForever:|r scale set to %d%%."):format(math.floor(n * 100 + 0.5)))
        else
            print(("|cff00ff88ClassResourcesForever:|r current scale %d%%. Usage: /cr scale 1.25 (%d-%d%%)."):format(
                math.floor((db.scale or 1) * 100 + 0.5),
                math.floor(SCALE_MIN * 100), math.floor(SCALE_MAX * 100)))
        end
    else
        print("|cff00ff88ClassResourcesForever:|r /cr options | layout | unlock | lock | scale <0.5-2.0>")
    end
end
