# ClassResourcesForever

One class-aware addon for **World of Warcraft: Forever**. It selects a tracker for the player's class.

**Install:** [ClassResourcesForever-0.3.3.zip](https://github.com/uncle-bone/Resources/archive/refs/heads/main.zip) (download the repository archive; the install folder is `ClassResourcesForever/`)

## Trackers

- **Druid:** the original DruidResources module, retained with form-aware bars, per-form cooldown layouts, Clearcasting/Omen of Clarity alert, buff tools, health, and custom spell/item tracking. Poised is included in the shared proc row.
- **Rogue:** the original RogueResources module, retained with combo-point and energy bars, cooldown layout, Riposte alert, Slice and Dice, poison tools, health, and custom tracking. Poised is included in the shared proc row.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** a repurposed copy of the DruidResources tracker. It uses the same bar UI, settings, movable frame, health display, cooldown icons, custom cooldown layout editor, custom spell/item tracking, and optional warnings. Class cooldown entries come from ClassData.lua. Hunter can track pet focus; Warlock counts Soul Shards.
- **Proc alerts:** a shared movable icon row for identified actionable proc auras across classes. Use `/crprocs unlock` to move it and `/crprocs lock` to lock it. The catalog and known limitations are in [ProcCatalog.md](ProcCatalog.md).

The other-class module is adapted directly from the permitted DruidResources code. Its SavedVariables are stored per class under ClassResourcesForeverDB. The actual Druid and Rogue modules retain their separate settings and slash commands.

## Compatibility and validation

- WoW Forever interface `16001`.
- Resource values pass directly to status bars; secret values are not formatted.
- Proc aura IDs are based on indexed WoW: Forever spell data. Aura visibility and any API restrictions need live-client verification; Hunter's Mongoose Bite readiness and Mage Heating Up require non-aura indicators and are documented as not yet represented.
- The addon has not yet been exercised in the live WoW Forever client. The seven class cooldown lists should be checked in game before treating every spell entry as confirmed.

## Commands

- `/cr options` opens the tracker settings.
- `/cr unlock` and `/cr lock` move or lock the tracker.
- `/cr layout` opens the drag-and-drop cooldown layout editor.
- `/cr scale <0.5-2.0>` adjusts scale; `/cr reset` restores the default position.
- `/crprocs unlock` and `/crprocs lock` move or lock proc alerts.
- `/dr` remains Druid-only and `/rr` remains Rogue-only.

Install the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/` and enable it at character select.

## Attribution

Integration and other-class adaptation by **Uncle Bone**. DruidResources and RogueResources by **Konchius**, copied and adapted with permission. Original licenses and the permission record are included.
