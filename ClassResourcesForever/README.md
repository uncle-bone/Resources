# ClassResourcesForever

One class-aware resource and cooldown addon for **World of Warcraft: Forever**. It detects the character's class at login and loads the matching tracker.

**Install:** [ClassResourcesForever-0.1.0.zip](https://github.com/uncle-bone/Resources/raw/refs/heads/main/downloads/ClassResourcesForever-0.1.0.zip)

## Supported classes

- **Druid:** retains the Druid Resources form-aware bars, per-form cooldown layouts, Clearcasting alert, Mark of the Wild and Thorns timers, optional health display, Well Fed warning, and custom spell/item tracking.
- **Rogue:** retains the Rogue Resources energy and combo-point bars, estimated Slice and Dice timer, cooldowns, Riposte alert, poison and weapon-stone tools, optional health display, Well Fed warning, and custom spell/item tracking.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** shared resource bar and a learned-spell cooldown bar. The Hunter view can also show pet power; the Warlock view counts Soul Shards in the bags.

The shared modules use the Druid and Rogue addons as the design and implementation references. Their original source, documentation, changelogs, and licenses are preserved under `References/`. Class-specific modules are namespaced and class-gated so only the matching module creates its UI. The shared core handles the other seven classes.

## Compatibility

- WoW Forever interface `16001`.
- Uses modern `C_Spell`/`C_SpellBook` APIs when available, with guarded fallbacks.
- Resource values that the client marks secret are passed directly to Blizzard status-bar widgets and are not formatted or used in calculations.
- Health and aura tracking are not part of the shared core. Forever restricts access to some combat values; the reference class modules keep their existing behavior.

## Commands

| Command | Action |
| --- | --- |
| `/cr` | Show command help |
| `/cr unlock` / `/cr lock` | Move or lock the shared frame |
| `/cr combat` | Toggle display only during combat |
| `/cr bars` | Toggle the primary resource bar |
| `/cr cooldowns` | Toggle cooldown icons |
| `/cr scale 0.5-2.0` | Set frame scale |
| `/cr reset` | Reset the shared frame position |

Druids keep `/dr` and `/dr layout`; Rogues keep `/rr` and `/rr layout` for their imported class tools.

## Install

Copy the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/`, then enable **Class Resources Forever** from the character-select AddOns screen. The addon folder contains the TOC and every file required at runtime.

## Current build

Version `0.1.0` is the initial unified build. The Druid and Rogue modules retain their existing feature sets. The other seven class profiles provide the shared power and cooldown framework with a first-pass list of class cooldown spells; their class-specific trackers will be expanded from in-game observations and the Forever class data. This source has not yet been validated in the live client.

## Attribution and license

New shared code and integration by **Uncle Bone**. The Druid and Rogue reference addons are by **Konchius**, included and adapted for this combined addon with the author's permission. The original license files remain with their respective reference sources. See [ATTRIBUTION.md](ATTRIBUTION.md) and [docs/PERMISSION-RECORD.md](docs/PERMISSION-RECORD.md).