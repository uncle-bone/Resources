# Rogue Resources

A compact resource and cooldown tracker for **Rogues** on the **WoW Classic (Forever)**
client: energy, combo points, Slice and Dice, your key cooldowns, and weapon poisons,
all in one movable bar.

## Features

### Energy and combo points
- **Energy bar** with a live value.
- **Combo-point bar**, a segmented bar showing your current combo points.
- **5th combo point highlight:** the last segment brightens and pulses red when you
  reach 5 combo points.

### Slice and Dice
- An icon with a **remaining-time countdown**.
- A **yellow warning** (glowing edge with sparks running around it) in the last
  5 seconds, so you know to reapply it soon.
- **Improved Slice and Dice** is detected automatically from your talents, with no
  setup needed.

> The client keeps combo points and buff durations hidden from addons, so the Slice
> and Dice timer is **estimated** from the combo points you build and spend. It's
> exact for a clean rotation, but a dodged or parried builder can make it drift.

### Cooldown trackers
- A radial swipe, countdown number, and a one-shot **flash** when each ability is
  ready again: Evasion, Vanish, Kick, Shank, Sprint, Blade Flurry, Adrenaline Rush, Blind,
  Kidney Shot, Gouge, Cold Blood, Ghostly Strike, Premeditation and Preparation.
- **Evasion**, **Sprint**, **Blade Flurry** and **Adrenaline Rush** show a red
  **"active" effect** (sparks running around the icon plus a soft glow) with the buff's
  countdown, then switch to the normal cooldown.
- **Racial abilities** for your race: Will to Survive, Perception, Stoneform, Elune's
  Light, Escape Artist, Eureka!, Blood Fury, Shatter Curse, Will of the Forsaken,
  Berserking and Rapid Regeneration. The ones with a buff get the red active effect too.
- **Only your learned skills** show, including talent abilities. New ones appear
  automatically as you train them.
- All animations run **in sync** with each other.
- **Riposte proc:** once you have Riposte, its icon pops up with blue sparks and a
  countdown for the few seconds after you parry, while you can use it. It has its own
  spot above the bars; unlock to drag it anywhere. Its size has its own slider in the
  options.

### Weapon poisons
- A separate, movable pair of icons showing your **main-hand and off-hand weapons**.
- Remaining time on each weapon's poison (`25m`, then `45s` in the last minute).
- The icon **pulses red** when that weapon has no poison.
- **Left-click** a weapon to apply what it needs from your bags (while the bars are locked):
  a missing or wrong poison first, then a missing stone, then whichever runs out sooner.
  **Right-click** to choose which poison each weapon uses: Instant, Deadly, Wound,
  Mind-numbing or Crippling. The highest rank you're carrying is used automatically.
- A weapon can hold a poison and a stone at once. A small **stone badge** in the corner of
  the icon shows the stone and its time. **Shift + left-click** always applies a stone, and the
  right-click menu lets you pick one (sharpening stones for blades, weightstones for blunt
  weapons). A missing stone never pulses red, only a missing poison does.
- Hidden until **level 20**, when Rogues can first use poisons. The off-hand icon hides
  when you're not dual-wielding.

### Layout and options
- **Cooldown layout editor:** click **"Customize cooldown layout..."** in options (or
  type `/rr layout`). Build the icon area row by row: each row has a number of slots,
  and fewer slots means bigger icons (every row spans the bar width). Drag icons
  between slots or into the **Hidden** tray (right-click hides or shows an icon). Also
  icon spacing, keeping empty slots so icons never shift, and placing the icons above
  or below the bars. **Reset** goes back to the default look. Changes show on the bar
  straight away.
- **Custom spells and items:** in the layout editor, click **"Custom spells & items..."**
  and drag a spell from your spellbook or an item from your bags (trinkets, potions,
  engineering items...) onto the box to track its cooldown too. Optionally enter how
  long its effect lasts to get the red active countdown first. Items stay on the bar,
  greyed out while you have none.
- **Options** in **ESC  Options  AddOns  Rogue Resources**, or a standalone window
  with `/rr options`: UI scale, show or hide the energy bar, combo points bar, an
  optional **health bar** (off by default, with incoming heals shown Blizzard style),
  the cooldown icons and poison icons, the
  **order of the bars**, **show only in combat**,
  lock/unlock, and reset positions.
- **Well Fed reminder** (optional, off by default): a "WELL FED MISSING" warning at the
  top of the screen when your food buff is gone. **Dismiss** hides it until you eat again.
- **Minimap button** and an **Addon Compartment** entry to open the options.
- Works on **any client language**. Spells and poisons are identified by ID, and the
  options are translated into English, Portuguese, Spanish, French and German.
- Only loads for **Rogues**, so it stays out of the way on your other characters.

## Installation

**CurseForge app:** search for *Rogue Resources* and install.

**Manual:** download the latest release, unzip it, and drop the `RogueResources`
folder into your WoW install at:

```
World of Warcraft/_classic_beta_/Interface/AddOns/
```

Then fully restart the client (a `/reload` won't pick up a brand-new addon folder) and
enable **Rogue Resources** at the character-select AddOns screen.

## Commands

| Command                  | What it does                                              |
| ------------------------ | --------------------------------------------------------- |
| `/rr options`            | Open the options window                                   |
| `/rr layout`             | Open the cooldown layout editor                           |
| `/rr unlock` / `/rr lock` | Unlock the bars and poison icons to drag them, then lock  |
| `/rr poison`             | Show or hide the poison icons                             |
| `/rr scale <0.5-2.0>`    | Set the UI scale                                          |

## License

c 2026 Konchius. **All rights reserved.** You're welcome to use the addon, but copying,
modifying or redistributing its code requires the author's permission. See
[LICENSE](LICENSE).
