local _, ns = ...

-- WoW Forever's nine playable classes. Spell IDs are the base Classic ranks used by
-- the source addons; all class abilities are filtered against the player's spellbook.
ns.Classes = {
    WARRIOR = {
        label = "Warrior", color = {0.78, 0.61, 0.43},
        spells = {
            {id=2687, cd=60}, {id=20230, cd=180}, {id=871, cd=180},
            {id=1719, cd=180}, {id=12292, cd=180}, {id=12975, cd=180},
            {id=6552, cd=10}, {id=1161, cd=600}, {id=676, cd=60},
            {id=100, cd=15}, {id=20252, cd=30}, {id=694, cd=60},
            {id=5246, cd=180}, {id=3411, cd=30}, {id=18499, cd=30},
        },
    },
    PALADIN = {
        label = "Paladin", color = {0.96, 0.55, 0.73},
        spells = {
            {id=642, cd=300}, {id=1022, cd=300}, {id=1044, cd=25},
            {id=6940, cd=120}, {id=633, cd=3600}, {id=31884, cd=180},
            {id=20216, cd=120}, {id=853, cd=60}, {id=20066, cd=60},
            {id=1038, cd=120}, {id=2812, cd=60}, {id=24275, cd=6},
        },
    },
    HUNTER = {
        label = "Hunter", color = {0.67, 0.83, 0.45},
        spells = {
            {id=5384, cd=30}, {id=3045, cd=300}, {id=19574, cd=120},
            {id=19263, cd=300}, {id=781, cd=30}, {id=1499, cd=30},
            {id=13809, cd=30}, {id=14311, cd=30}, {id=13795, cd=30},
            {id=5116, cd=10}, {id=19577, cd=60}, {id=34477, cd=30},
            {id=23989, cd=180}, {id=19503, cd=30},
        },
    },
    ROGUE = { label = "Rogue", color = {1.00, 0.96, 0.41} },
    PRIEST = {
        label = "Priest", color = {1.00, 1.00, 1.00},
        spells = {
            {id=586, cd=10}, {id=8122, cd=30}, {id=6346, cd=180},
            {id=10060, cd=180}, {id=32379, cd=12}, {id=34433, cd=300},
            {id=14751, cd=180}, {id=15286, cd=180}, {id=47585, cd=75},
            {id=33206, cd=180}, {id=33076, cd=15}, {id=48173, cd=15},
        },
    },
    SHAMAN = {
        label = "Shaman", color = {0.00, 0.44, 0.87},
        spells = {
            {id=2645, cd=0}, {id=16188, cd=180}, {id=16166, cd=180},
            {id=8177, cd=15}, {id=2825, cd=600}, {id=2062, cd=3600},
            {id=16190, cd=300}, {id=30823, cd=60}, {id=2894, cd=600},
            {id=5672, cd=60}, {id=2484, cd=15}, {id=3738, cd=0},
        },
    },
    MAGE = {
        label = "Mage", color = {0.25, 0.78, 0.92},
        spells = {
            {id=1953, cd=15}, {id=45438, cd=300}, {id=11958, cd=480},
            {id=12043, cd=180}, {id=11129, cd=180}, {id=2139, cd=24},
            {id=12472, cd=180}, {id=12051, cd=480}, {id=66, cd=300},
            {id=130, cd=25}, {id=30449, cd=30}, {id=31687, cd=180},
        },
    },
    WARLOCK = {
        label = "Warlock", color = {0.53, 0.53, 0.93},
        spells = {
            {id=6789, cd=120}, {id=17877, cd=15}, {id=18708, cd=900},
            {id=19647, cd=24}, {id=7814, cd=0}, {id=1122, cd=3600},
            {id=18540, cd=3600}, {id=18223, cd=12}, {id=18288, cd=60},
            {id=17925, cd=0}, {id=18265, cd=0}, {id=18220, cd=0},
        },
    },
    DRUID = { label = "Druid", color = {1.00, 0.49, 0.04} },
}

-- Combat racials from the Druid/Rogue reference addons, plus Forever-specific skills.
-- Learned-spell checks prevent unrelated racial icons from appearing.
ns.Racials = {
    {id=1259718}, {id=20600, active=20}, {id=20594, active=8},
    {id=1259799, active=15}, {id=20589}, {id=1259812},
    {id=20572, active=15}, {id=1299026, active=8}, {id=7744},
    {id=20554, active=10}, {id=1260270}, {id=20549},
}
