# ClassResourcesForever proc catalog

Scope: player-facing, actionable proc buffs documented for WoW: Forever. Passive talents that do not expose a readable player aura are excluded. This is a data-backed starting catalog; aura presence and identifiers must be verified in the live Forever client and can change with hotfixes.

| Class / spec area | Proc / ready state | What it signals | Status |
|---|---|---|---|
| Druid — Omen, all specs | Clearcasting | Next eligible ability is free | Already has dedicated Druid alert |
| Druid — Feral | Poised | Next Energy ability costs 10 less | Added to shared proc alerts |
| Rogue — Subtlety | Poised | Next Energy ability costs 10 less | Added to shared proc alerts |
| Rogue — Combat | Riposte | Riposte is available after a parry | Already has dedicated Rogue alert |
| Warrior — Arms | Bloodthrill | Overpower is enabled by the talent proc | Added |
| Paladin — Holy | Infusion of Light | Holy Shock critical proc improves the next heal | Added |
| Paladin — Retribution | The Art of War | Melee critical proc enables a faster Flash of Light or Exorcism | Added |
| Hunter — Survival | Mongoose Bite ready | Reactive ability after a dodge or Expose Prey; this is spell usability, not a confirmed readable player aura | Not in aura row; needs a spell-usability indicator |
| Priest — Discipline / Holy | Surge of Light | Next Smite, Flash Heal, or Binding Heal is instant | Added |
| Shaman — Enhancement | Maelstrom Weapon | Stacks make the next Lightning Bolt faster and cheaper | Added |
| Shaman — Elemental | Clearcasting (Elemental Focus) | Next eligible damage spell is free | Added |
| Mage — Frost | Fingers of Frost | Next spells treat the target as frozen | Added |
| Mage — Arcane | Missile Barrage | Next Arcane Missiles is faster and free | Added |
| Mage — Arcane | Clearcasting | Next damage spell is free | Added |
| Mage — Fire | Heating Up / Hot Streak | Fire criticals build toward faster Pyroblast | Action-bar override/stack state; aura ID needs live-client verification |
| Warlock — Affliction | Shadow Trance (Nightfall) | Next Shadow Bolt is instant | Added |

Use `/crprocs unlock` to move the shared proc row and `/crprocs lock` to lock it. The Druid Clearcasting and Rogue Riposte alerts retain their original specialized behavior.

This list covers identified actionable class proc states, not every passive modifier, temporary self-buff, item/racial proc, target debuff, or mechanic with no readable player aura. The addon skips aura data it cannot safely read. Live-client verification is still needed for API visibility and aura IDs.
