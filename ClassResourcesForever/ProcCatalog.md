# ClassResourcesForever proc catalog

Catalog basis: actionable, player-visible class proc auras found in WoW: Forever spell/talent data checked 17 November 2026. Passive scripts with no player aura and effects applied only to an enemy or ally are listed as exclusions. A spec is included only where the spell/talent belongs. The aura names and IDs should still be checked in the live game because WoW: Forever updates frequently.

| Class / spec | Proc | Alert |
|---|---|---|
| Druid — Balance / Feral | Clearcasting (Omen of Clarity) | Existing dedicated Druid alert |
| Druid — Balance | Nature's Grace | Added |
| Druid — Feral | Poised | Added |
| Rogue — Subtlety | Poised | Added |
| Rogue — Combat | Riposte | Existing dedicated Rogue alert |
| Warrior — Arms | Bloodthrill (Overpower activation) | Added |
| Warrior — Arms / Fury | Enrage | Added |
| Warrior — Fury | Flurry after a melee critical | Passive proc aura; not yet independently verified as the visible aura ID |
| Paladin — Holy | Infusion of Light | Added |
| Paladin — Retribution | The Art of War | Added |
| Paladin — Protection | Redoubt | Added |
| Paladin — Protection | Reckoning extra attacks | Added |
| Hunter — Survival | Expose Prey / Mongoose Bite enabled | Added |
| Priest — Discipline / Holy | Surge of Light | Added |
| Priest — Shadow | Spirit Tap | Added |
| Shaman — Elemental | Elemental Focus / Clearcasting | Added |
| Shaman — Elemental / Enhancement | Elemental Devastation | Added |
| Shaman — Enhancement | Maelstrom Weapon stacks | Added |
| Shaman — Enhancement | Flurry after a melee critical | Added |
| Mage — Arcane | Clearcasting | Added |
| Mage — Arcane | Missile Barrage | Added |
| Mage — Fire | Heating Up stacks | Added |
| Mage — Frost | Fingers of Frost | Added |
| Warlock — Affliction | Shadow Trance (Nightfall) | Added |
| Warlock — Demonology | Decimation | Added |

## Important limits

This is the complete list of the actionable, player-aura proc candidates identified for the addon in the checked spell data, but it is not a claim that every hidden talent script or every class mechanic is exposed as an aura. Some passives grant spell usability or alter a spell without making a readable aura. Examples include dodge-based Mongoose Bite availability, passive extra attacks, target-only effects such as Priest Inspiration, and hidden trigger scripts. These need separate event or spell-usability indicators and cannot be safely represented by this aura-only tracker.

The Druid Clearcasting and Rogue Riposte alerts retain their source modules' specialized handling. Other listed alerts use the shared icon row. It appears only while an aura is detected; use `/crprocs unlock` to move the row and `/crprocs lock` to lock it. Aura fields hidden by the client are skipped safely. Live-client verification remains necessary.
