# ClassResourcesForever

One class-aware addon for **World of Warcraft: Forever**. It selects a tracker for the player's class.

**Install:** [ClassResourcesForever-0.3.0.zip](https://github.com/uncle-bone/Resources/raw/refs/heads/main/downloads/ClassResourcesForever-0.3.0.zip)

## Trackers

- **Druid:** the original DruidResources module, retained with form-aware bars, per-form cooldown layouts, buff tools, health, and custom spell/item tracking.
- **Rogue:** the original RogueResources module, retained with combo-point and energy bars, cooldown layout, Slice and Dice, poison tools, health, and custom tracking.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** a repurposed copy of the DruidResources tracker. It uses the same bar UI, settings, movable frame, health display, cooldown icons, custom cooldown layout editor, custom spell/item tracking, and optional warnings. Class cooldown entries come from ClassData.lua. Hunter can track pet focus; Warlock counts Soul Shards.

The other-class module is adapted directly from the permitted DruidResources code. Its SavedVariables are stored per class under ClassResourcesForeverDB. The actual Druid and Rogue modules retain their separate settings and slash commands.

## Compatibility and validation

- WoW Forever interface `16001`.
- Resource values pass directly to status bars; secret values are not formatted.
- The addon has not yet been exercised in the live WoW Forever client. The seven class cooldown lists should be checked in game before treating every spell entry as confirmed.

## Commands

- `/cr options` opens the tracker settings.
- `/cr unlock` and `/cr lock` move or lock the tracker.
- `/cr layout` opens the drag-and-drop cooldown layout editor.
- `/cr scale <0.5-2.0>` adjusts scale; `/cr reset` restores the default position.
- `/dr` remains Druid-only and `/rr` remains Rogue-only.

Install the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/` and enable it at character select.

## Attribution

Integration and other-class adaptation by **Uncle Bone**. DruidResources and RogueResources by **Konchius**, copied and adapted with permission. Original licenses and the permission record are included.