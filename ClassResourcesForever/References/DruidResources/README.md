# Druid Resources

A compact, form-aware resource and cooldown tracker for **Druids** on the **WoW Classic
(Forever)** client: rage, energy, mana, combo points, Clearcasting and your key
cooldowns, all in one movable bar that follows your shapeshifts.

## Features

### Power bars that follow your form
- **Rage / energy bar** that switches with your form: rage in Bear Form, energy in
  Cat Form, with a live value.
- **Mana bar** with the exact value, shown in every form, so you can see at a
  glance whether you have the mana to shift back. While you cast, a light blue part
  of the bar shows how much mana the spell will use.
- **Combo-point bar** in Cat Form, a segmented bar whose last segment brightens and
  pulses red at 5 combo points.
- **Health bar** (optional, turn it on in options) with your health, coloured green,
  orange or red by how much you have left. Incoming heals show as a light green part
  right after your health.

### Clearcasting
- When **Omen of Clarity** procs, a Clearcasting icon pops up above the bars with blue
  sparks running around it and the buff's countdown. It disappears as soon as the proc
  is used.
- It starts just above the bars. To move it anywhere on the screen, unlock, drag the
  icon where you want it, then lock.

> The 15-second countdown is timed from the moment the proc appears.

### Mark of the Wild and Thorns
- A separate, movable pair of icons showing the **time left** on your own Mark of the
  Wild (Gift of the Wild counts too) and Thorns, in minutes, then seconds.
- The icon **pulses red** when the buff is missing.
- **Left-click** an icon to cast it on yourself (while the bars are locked). Unlock to
  drag the pair into place.
- Can be turned off in the options.

### Cooldown trackers
- A radial swipe, countdown number, and a one-shot **flash** when each ability is ready
  again: Dash, Shifting Power, Faerie Fire, Cower, Feral Charge (Cat and Bear), Enrage,
  Frenzied Regeneration, Bash, Growl, Challenging Roar, Innervate, Barkskin, Rebirth,
  Nature's Swiftness, Swiftmend, Tranquility and Hurricane.
- **Dash**, **Enrage**, **Frenzied Regeneration**, **Innervate** and
  **Barkskin** show a red **"active" effect** (sparks running around the icon plus a
  soft glow) with the buff's countdown, then switch to the normal cooldown.
- **Feral Charge:** the Cat and Bear charges share their cooldown, so charging in one
  form shows the cooldown on both.
- Icons turn **blue when you don't have enough** rage, energy or mana, just like the
  default action bars.
- **Racial abilities:** Elune's Light (Night Elf) and War Stomp (Tauren).
- **Only your learned skills** show, including talent abilities. New ones appear
  automatically as you train them.
- **Custom tracking:** drag any spell from your spellbook or item from your bags (a
  trinket, a potion) into "Custom spells & items..." in the layout editor to track its
  cooldown in every form. Stackable items show how many you have left, and you can give
  each one a buff time for the red active countdown.

### A layout for every form
- **Cat, Bear and caster form each have their own icon layout.** Any ability can be
  shown in any form, e.g. track Bash while in Cat Form to know when the stun is ready
  before shifting.
- **Layout editor:** click **"Customize cooldown layout..."** in options (or type
  `/dr layout`). Pick a form, then drag and drop its icons between rows of slots. The
  rows, spacing and options are shared by all forms, so the tracker keeps its shape
  when you shift. Fewer slots in a row means bigger icons. Right-click or drag an icon
  to Hidden to hide it. You can also set the spacing, keep empty slots, put the icons
  above the bars, and preview skills you haven't learned yet.

### Options
- **Options** in **ESC  Options  AddOns  Druid Resources**, or a standalone window
  with `/dr options`: UI scale, show or hide the rage / energy bar, combo points bar,
  mana bar and health bar, **show only in combat**, lock/unlock, and reset
  position.
- **Bar order:** drag the bars into the order you like in the options.
- **Well Fed reminder** (optional, off by default): a "WELL FED MISSING" warning at the
  top of the screen when your food buff is gone. **Dismiss** hides it until you eat again.
- The cooldown icons never move: when you shift or turn bars on or off, the bars grow
  or shrink upward.
- **Minimap button** and an **Addon Compartment** entry to open the options.
- Works on **any client language**. Spells are identified by ID, and the options are
  translated into English, Portuguese, Spanish, French and German.
- Only loads for **Druids**, so it stays out of the way on your other characters.

## Installation

**CurseForge app:** search for *Druid Resources* and install.

**Manual:** download the latest release, unzip it, and drop the `DruidResources`
folder into your WoW install at:

```
World of Warcraft/_classic_beta_/Interface/AddOns/
```

Then fully restart the client (a `/reload` won't pick up a brand-new addon folder) and
enable **Druid Resources** at the character-select AddOns screen.

## Commands

| Command                   | What it does                                             |
| ------------------------- | -------------------------------------------------------- |
| `/dr options`             | Open the options window                                  |
| `/dr layout`              | Open the cooldown layout editor                          |
| `/dr unlock` / `/dr lock` | Unlock the bars to drag them, then lock                  |
| `/dr scale <0.5-2.0>`     | Set the UI scale                                         |

## License

c 2026 Konchius. **All rights reserved.** You're welcome to use the addon, but copying,
modifying or redistributing its code requires the author's permission. See
[LICENSE](LICENSE).
