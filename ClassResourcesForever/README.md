# ClassResourcesForever

One class-aware addon for **World of Warcraft: Forever**. It selects a tracker for the player's class.

**Install:** [ClassResourcesForever-0.2.0.zip](https://github.com/uncle-bone/Resources/raw/refs/heads/main/downloads/ClassResourcesForever-0.2.0.zip)

## Trackers

- **Druid:** the imported DruidResources tracker, preserved with form-aware bars, class cooldown layouts, alerts, and custom tracking.
- **Rogue:** the imported RogueResources tracker, preserved with combo-point and energy bars, class cooldowns, Slice and Dice, poison tools, alerts, and custom tracking.
- **Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock:** a class-selected tracker whose bar construction and status-bar treatment are repurposed from DruidResources. Cooldown icons and layout controls follow the imported tracker patterns. It includes an optional health bar, move/lock controls, combat-only visibility, scale setting, Hunter pet power, and Warlock Soul Shard counting.

The DruidResources and RogueResources source, original licenses, and permission record remain in this repository. The combined addon loads only the matching class tracker.

## Compatibility and validation

- WoW Forever interface `16001`.
- Secret power values are passed to Blizzard status bars without formatting or arithmetic.
- The source has not been exercised in the live WoW Forever client; the class cooldown lists are initial candidates pending in-game verification.

## Commands

- `/cr options` opens the shared class tracker's settings.
- `/cr unlock` and `/cr lock` let you move or lock the frame.
- `/cr combat`, `/cr bars`, and `/cr cooldowns` toggle display features.
- `/cr scale 0.5-2.0` changes scale; `/cr reset` restores the position.
- The settings include cooldown icon size and slots-per-row controls.
- Druids retain `/dr`; Rogues retain `/rr`.

Install the `ClassResourcesForever` folder into `_forever_/Interface/AddOns/` and enable it at character select.

## Attribution

Integration by **Uncle Bone**. DruidResources and RogueResources by **Konchius**, copied and adapted with permission. See [ATTRIBUTION.md](ATTRIBUTION.md) and [docs/PERMISSION-RECORD.md](docs/PERMISSION-RECORD.md).
