-- ClassResourcesForever proc aura catalog.
-- IDs are aura IDs from the WoW: Forever spell database. Passive talents that do not
-- expose a player aura (e.g. hidden proc scripts) are intentionally excluded.
local _, ns = ...
ns.ProcAuras = {
    DRUID = {
        { id = 1328827, label = "Poised" },
        { id = 16886, label = "Nature's Grace" },
        -- Clearcasting / Omen of Clarity already has a dedicated Druid alert.
    },
    ROGUE = {
        { id = 1328826, label = "Poised" },
        -- Riposte already has its own Rogue proc alert.
    },
    WARRIOR = {
        { id = 1289681, label = "Bloodthrill (Overpower)" },
        { id = 12880, label = "Enrage" },
    },
    PALADIN = {
        { id = 53672, label = "Infusion of Light" },
        { id = 53489, label = "The Art of War" },
        { id = 20127, label = "Redoubt" },
        { id = 1326084, label = "Reckoning" },
    },
    HUNTER = {
        { id = 1310726, label = "Expose Prey (Mongoose Bite)" },
    },
    PRIEST = {
        { id = 431666, label = "Surge of Light" },
        { id = 15271, label = "Spirit Tap" },
    },
    SHAMAN = {
        { id = 408505, label = "Maelstrom Weapon" },
        { id = 16246, label = "Clearcasting (Elemental Focus)" },
        { id = 30165, label = "Elemental Devastation" },
        { id = 16257, label = "Flurry" },
    },
    MAGE = {
        { id = 400670, label = "Fingers of Frost" },
        { id = 1326083, label = "Missile Barrage" },
        { id = 12536, label = "Clearcasting (Arcane Concentration)" },
        { id = 400625, label = "Heating Up" },
    },
    WARLOCK = {
        { id = 17941, label = "Shadow Trance (Nightfall)" },
        { id = 440873, label = "Decimation" },
    },
}
