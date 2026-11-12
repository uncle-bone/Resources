# ClassResourcesForever

One class-aware resource and cooldown addon for **World of Warcraft: Forever**. It detects the character's class at login and builds the matching tracker.

**Install:** [ClassResourcesForever-0.2.0.zip](https://github.com/uncle-bone/Resources/raw/refs/heads/main/downloads/ClassResourcesForever-0.2.0.zip)

## Supported classes

- **Druid:** imported Druid Resources tracker, retaining form-aware bars, per-form cooldown layouts, alerts, optional health display, and custom spell/item tracking.
- **Rogue:** imported Rogue Resources tracker, retaining energy and combo-point bars, Slice and Dice, cooldowns, alerts, poison and weapon tools, optional health, and custom spell/item tracking.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** class-selected tracker with a status bar, optional health bar, cooldown icons, lockable/movable position, combat-only display, scale controls, and cooldown layout controls for icon size and slots per row. Hunter can display pet power; Warlock displays Soul Shards held in bags.

The seven-class tracker uses the compact status-bar presentation and cooldown layout approach from the Druid/Rogue references. Druid and Rogue keep their complete imported class interfaces and their original `/dr` and `/rr` commands.

## Compatibility

- WoW Forever interface `16001`.
- Uses guarded `C_Spell` and `C_SpellBook` APIs with legacy fallbacks.
- Secret resource values are passed to Blizzard status bars without formatting or arithmetic.
- The code is based on Forever research for client build `1.60.1.70707`; validation on later client builds remains pending.

## Commands

- `/cr options` opens class tracker settings.
- `/cr unlock` and `/cr lock` change whether the frame can be moved.
- `/cr combat`, `/cr bars`, and `/cr cooldowns` toggle tracker visibility.
- `/cr scale 0.5-2.0` sets tracker size; `/cr reset` restores its position.
- The options panel includes cooldown layout controls for icon size and slots per row.

Install the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/` and enable **Class Resources Forever** at character select.

## Attribution and license

New shared code and integration by **Uncle Bone**. The Druid and Rogue trackers are by **Konchius**, included and adapted with the author's permission. Their original license files are included. See [ATTRIBUTION.md](ATTRIBUTION.md) and [docs/PERMISSION-RECORD.md](docs/PERMISSION-RECORD.md).

**Validation note:** This source has not yet been exercised in the live WoW Forever client. The seven non-Druid/Rogue class cooldown lists are initial candidates and may need tuning against each class's in-game spellbook.
