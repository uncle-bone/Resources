# Architecture

## Loading and class selection

`ClassResourcesForever.toc` loads one addon folder and one SavedVariables set for the shared core plus separate SavedVariables for the two integrated class modules. The Druid and Rogue modules have independent addon namespaces and prefixed global callbacks, avoiding collisions from their original standalone code. Each checks the player's class at `PLAYER_LOGIN` and unregisters its event frame for every other class. The shared core similarly unregisters itself for Druids and Rogues.

## Shared core

`ClassData.lua` contains the nine class profiles, cooldown candidates, and Forever racial spell IDs. `Core.lua` creates the generic resource and cooldown display for Warrior, Paladin, Hunter, Priest, Shaman, Mage, and Warlock. It reads live player power using the current power type, displays Hunter pet power when present, and counts Soul Shards from the bag API for Warlocks. Learned-spell checks keep untrained abilities out of the icon row.

The core does not read aura data or turn secret power values into text or numbers. It passes power values to the status-bar widget and uses duration-object cooldown APIs where available. API access is feature-probed because interface `16001` is the Forever client line, not the current Retail interface line.

## Research basis and limits

The implementation follows the Forever addon foundation and engineering notes in `uncle-bone/FWoW-Research`, particularly its client detection, modern API, secret-value, startup, and compatibility guidance. The repository notes date to build `1.60.1.70707`; live verification against the user's current `1.60.1.70790` client is still outstanding. Spell profiles are initial candidates and should be compared against the current Forever spellbook before claiming full cooldown coverage.
