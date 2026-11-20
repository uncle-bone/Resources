# ClassResourcesForever

One class-aware addon for **World of Warcraft: Forever**. It selects a tracker for the player's class.

**Download:** [Resources source archive ZIP](https://github.com/uncle-bone/Resources/archive/refs/heads/main.zip) (contains the installable `ClassResourcesForever/` folder).

## Trackers

- **Druid:** the original DruidResources module, including successful-cast timers for Mark of the Wild and Thorns when battleground aura reads are unavailable, retained with form-aware bars, per-form cooldown layouts, Clearcasting/Omen of Clarity alert, buff tools, health, and custom spell/item tracking. Poised and Nature's Grace are included in the shared proc row.
- **Rogue:** the original RogueResources module, retained with combo-point and energy bars, cooldown layout, Riposte alert, Slice and Dice, poison tools, health, and custom tracking. Poised is included in the shared proc row.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** a repurposed copy of the DruidResources tracker. It uses the same bar UI, settings, movable frame, health display, cooldown icons, custom cooldown layout editor, custom spell/item tracking, and optional warnings. Class cooldown entries come from ClassData.lua. Hunter can track pet focus; Warlock counts Soul Shards.
- **Move everything together:** enable this in the class options, unlock the tracker, then drag the main bars or cooldown row. The proc row and detached class alerts move the same distance and save their updated positions. Turn the option off to place components separately.
- **Proc alerts:** enabled by default for identified actionable proc auras across classes. Toggle alerts and unlock the main tracker to move both the tracker and proc row, or use the proc movement checkbox on the normal **Class Resources Forever** options page. No proc-specific command is needed. Icons match the existing cooldown icon size and style, stay behind interface dialogs, and show the in-game spell tooltip on hover. The spell-by-spec list and coverage limits are in [ProcCatalog.md](ProcCatalog.md).

The other-class module is adapted directly from the permitted DruidResources code. Its SavedVariables are stored per class under ClassResourcesForeverDB. The actual Druid and Rogue modules retain their separate settings and slash commands.

## Blizzard Cooldown Manager mode

Each class tracker has an optional **Use Blizzard Cooldown Manager** setting. When enabled, ClassResourcesForever hides its own cooldown icon row while keeping its resource bars and proc alerts. Use the game's `/cdm` settings to select spells and Edit Mode to position Blizzard's bars.

The mode does not automatically import ClassResourcesForever's cooldown list. WoW Forever's 1.60.1.70959 UI source exposes no public addon API for adding spells to the manager; the APIs that query or write cooldown entries require untainted calls. The default ClassResourcesForever cooldown row remains available when the setting is off.

## Compatibility and validation

- WoW Forever interface `16001`.
- Resource values pass directly to status bars; secret values are not formatted.
- Proc aura IDs come from current WoW: Forever spell data. Aura visibility and API restrictions still need live-client verification. Some passives are hidden scripts or spell-usability states and cannot be detected by this aura-only tracker; those are called out in ProcCatalog.md.
- The proc alert settings, hover tooltips, and icon layout have not yet been exercised in the live WoW Forever client. The native Cooldown Manager mode and class cooldown lists should be checked in game before treating every entry as confirmed.

## Commands

- `/cr options` opens the tracker settings.
- `/cr unlock` and `/cr lock` move or lock the tracker.
- `/cr layout` opens the drag-and-drop cooldown layout editor.
- `/cr scale <0.5-2.0>` adjusts scale; `/cr reset` restores the default position.
- `/dr` remains Druid-only and `/rr` remains Rogue-only.

Install the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/` and enable it at character select.

## Attribution

Integration and other-class adaptation by **Uncle Bone**. DruidResources and RogueResources by **Konchius**, copied and adapted with permission. Original licenses and the permission record are included.
