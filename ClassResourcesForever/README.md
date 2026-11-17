# ClassResourcesForever

One class-aware addon for **World of Warcraft: Forever**. It selects a tracker for the player's class.

**Download:** [Resources source archive ZIP](https://github.com/uncle-bone/Resources/archive/refs/heads/main.zip) (contains the installable `ClassResourcesForever/` folder).

## Trackers

- **Druid:** the original DruidResources module, retained with form-aware bars, per-form cooldown layouts, Clearcasting/Omen of Clarity alert, buff tools, health, and custom spell/item tracking. Poised and Nature's Grace are included in the shared proc row.
- **Rogue:** the original RogueResources module, retained with combo-point and energy bars, cooldown layout, Riposte alert, Slice and Dice, poison tools, health, and custom tracking. Poised is included in the shared proc row.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** a repurposed copy of the DruidResources tracker. It uses the same bar UI, settings, movable frame, health display, cooldown icons, custom cooldown layout editor, custom spell/item tracking, and optional warnings. Class cooldown entries come from ClassData.lua. Hunter can track pet focus; Warlock counts Soul Shards.
- **Proc alerts:** enabled by default for identified actionable proc auras across classes. Toggle alerts and unlock their icons to move them from the normal **Class Resources Forever** options page; no proc slash command is needed. Icons match the existing cooldown icon size and style, and hovering shows the in-game spell tooltip. The spell-by-spec list and coverage limits are in [ProcCatalog.md](ProcCatalog.md).

The other-class module is adapted directly from the permitted DruidResources code. Its SavedVariables are stored per class under ClassResourcesForeverDB. The actual Druid and Rogue modules retain their separate settings and slash commands.

## Compatibility and validation

- WoW Forever interface `16001`.
- Resource values pass directly to status bars; secret values are not formatted.
- Proc aura IDs come from current WoW: Forever spell data. Aura visibility and API restrictions still need live-client verification. Some passives are hidden scripts or spell-usability states and cannot be detected by this aura-only tracker; those are called out in ProcCatalog.md.
- The proc alert settings, hover tooltips, and icon layout have not yet been exercised in the live WoW Forever client. The class cooldown lists and proc alerts should be checked in game before treating every entry as confirmed.

## Commands

- `/cr options` opens the tracker settings.
- `/cr unlock` and `/cr lock` move or lock the tracker.
- `/cr layout` opens the drag-and-drop cooldown layout editor.
- `/cr scale <0.5-2.0>` adjusts scale; `/cr reset` restores the default position.
- `/dr` remains Druid-only and `/rr` remains Rogue-only.

Install the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/` and enable it at character select.

## Attribution

Integration and other-class adaptation by **Uncle Bone**. DruidResources and RogueResources by **Konchius**, copied and adapted with permission. Original licenses and the permission record are included.
