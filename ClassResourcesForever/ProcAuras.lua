-- ClassResourcesForever proc aura catalog.
-- IDs are aura IDs from the WoW: Forever spell database. Passive talents that do not
-- expose a player aura (e.g. hidden proc scripts) are intentionally excluded.
local _, ns = ...
ns.ProcAuras = {
    DRUID = {
        { id = 1328827, label = "Poised" },
        -- Clearcasting / Omen of Clarity already has a dedicated Druid alert.
    },
    ROGUE = {
        { id = 1328826, label = "Poised" },
        -- Riposte already has its own Rogue proc alert.
    },
    WARRIOR = {
        { id = 1289681, label = "Bloodthrill (Overpower)" },
    },
    PALADIN = {
        { id = 53672, label = "Infusion of Light" },
        { id = 53489, label = "The Art of War" },
    },
    HUNTER = {
        -- Survival's Mongoose Bite availability is a reactive spell condition, not an
        -- exposed player aura in the currently indexed data; see ProcCatalog.md.
    },
    PRIEST = {
        { id = 431666, label = "Surge of Light" },
    },
    SHAMAN = {
        { id = 408505, label = "Maelstrom Weapon" },
        { id = 16246, label = "Clearcasting (Elemental Focus)" },
    },
    MAGE = {
        { id = 400670, label = "Fingers of Frost" },
        { id = 1326083, label = "Missile Barrage" },
        { id = 12536, label = "Clearcasting (Arcane Concentration)" },
    },
    WARLOCK = {
        { id = 17941, label = "Shadow Trance (Nightfall)" },
    },
}
