# Changelog

Each version's tag message (`scripts/release.sh`), shown in the app's update prompt, is kept short: a link to this file.

## Unreleased

- Windows: the What's new page shows its titles and lists again (it showed the raw text).
- Addon on WoW Forever: party members' progress, vendor supplies, the quest item button, gear upgrades and the character profile (spells, riding) updated for the game's current functions. The low health alert may stay silent there: the game can hide your health from addons; its own low health flash and Combat Audio Alerts remain.
- Addon on WoW Forever and Classic Era: the play time the addon asks for (/played) is no longer printed in the chat at login, reload and level up.
- Addon on WoW Classic and TBC: automatic training at the class trainer buys the leveling spells (it bought nothing).

## 0.8.0 (2026-10-14)

The app on Mac, a new look, a Characters page, and class quests planned again.

### App

- macOS: the app now runs on Mac (Apple Silicon and Intel), with automatic updates. Thanks to @csselement.
- New look: a night-blue theme, explanations in tooltips, readable at the keyboard (visible focus, stronger contrast). The light theme is gone.
- Characters page: each recorded character with its full name, level and professions, and the guide it follows. A character follows only the guide chosen for it in the app.
- No character shown? The Characters page tells why: wrong game version chosen, addon not installed, or character not recorded yet (log in, then /reload, log out or quit).
- New guide: character, professions, dungeons by level and zone map on one screen; profession skill set on a curve.
- Advanced settings as sliders with their default marked, a search, and folded expert sections.
- Guides: every action on each row, "Clone" to start a new guide from the same setup, gold spent on flights.
- Addon page: settings saved as you change them; "Install in game" appears when the game is not up to date.
- Contribute page: the tools that send what your game sees to the community quest databases.
- What's new page, and links, licenses and data notice under Settings.
- Guide editor: leaving it with changes not saved (another page, another game version) asks first.
- New guide: each game version keeps its configuration; switching back finds it as you left it.
- Faster start and game version switch (the dungeon list took seconds), the window stays responsive meanwhile.

### Guides

- Fixed: camps around a mob of unknown level are counted right.
- Quests needing an item first now send you to get it: Marla's Last Wish has you kill Samuel Fipps before burying his remains.
- Night elves: Rut'theran Village and the top of Teldrassil are linked by the portal, no longer walked between.
- TBC: portals and orbs no longer count a boat's wait.
- Druids: the bear form quests are planned again. Moonglade is reached with the teleport the quest "Moonglade" teaches, and Lunaclaw is met at the right Moonkin Stone (the Barrens for the Horde).
- Warlocks: The Binding (Voidwalker, Succubus) is planned again, at the summoning circle.
- WoW Forever: class quests filed under a zone count as class quests: the dwarf shaman's Call of Earth, and Archaic Rune before it, are always in the guide.
- Classic and WoW Forever: Blackrock Depths, Blackrock Spire and the Sunken Temple are in the dungeon list again.

### WoW data

- In Search of Thaelrid is no longer offered to the Horde.

## 0.7.1 (2026-10-13)

- Addon on WoW Classic and TBC: the guide now shows, and quests are accepted automatically.

## 0.7.0 (2026-10-13)

A security fix (updating is recommended), and better guides.

### Security

- The addon's saved data is now read as plain data: a tampered file can no longer run anything on your PC.
- A tampered file can no longer freeze or crash the app either.

### Guides

- Better guides: shorter on average, by tens of minutes on a 1-60.
- Short guides (a few levels) are now optimized as carefully as long ones.
- The same settings now give the same guide on any PC; only the computing time differs.
- The calculation presets (Preview, Normal, Thorough) set how hard the app searches.
- Faster calculations.
- Fixed: some starting routes ended with a full quest log.
- Fixed: guides asked for too many of some items or mobs (6 sacks instead of 1, Henze Faulk killed 8 times).

### WoW Forever data

- Tauren guides start in Mulgore again, instead of walking to Durotar at level 1.
- Human guides start in Northshire again, instead of going through Ironforge to the dwarf start.
- Both came from vendors and trainers taken for hostile monsters.

### App

- The calculation screen shows its progress, and the best route so far on the map.

## 0.6.0 (2026-10-12)

The guide editor, and a much faster optimizer.

### Guide editor

- "Edit the steps" on a guide's page: move, remove or add steps by hand.
- Steps you can add: quests, hearthstone, flights, flight paths, dungeons, mobs to kill.
- After each change the guide is replayed: its time, and each step's time, level and XP.
- Impossible steps are shown with the reason, and block saving.
- Saving makes a new version of the guide.
- Each step does one thing: flights, training and grinding are steps of their own.
- A quest step can also kill every mob met on the way to it.
- The zone map beside the steps follows the pointer.

### Guides

- Much faster optimization, using less memory.
- Every quest taken, done or turned in is its own step, so it can be edited.
- Objectives at the same place come one after the other.
- Fixed: a generation that hit an internal error never ended.

### App

- New guide in two steps: setup, then generation; the guide then opens in "My guides".
- Fixed: on Linux with an NVIDIA card under Wayland, the window closed at start.

## 0.5.0 (2026-10-11)

Better use of the hearthstone, mage teleports and Astral Recall, timed quests, and no more addon popups.

### Guides

- Objectives in several places: the guide picks the closest worthwhile one.
- The hearthstone is set again as you move on, at the best inn.
- The hearthstone is used where it saves the most time.
- Mage teleports and the shaman's Astral Recall are used.
- No more grinding for a quest you are not strong enough for yet.
- No more "mobs" to kill in capitals.
- Timed quests are turned in on time ("timed: turn it in within 60 min").
- Fixed: a grind step could land between a dungeon and its quests.

### Addon

- No more "blocked action" popups.
- The guide's buttons have their own bar, with tooltips.
- The XP bar shows where the current tasks should take you.
- Mobs to kill on the way have their own line, with a counter.
- The box under the guide has two tabs: "Next" and "To pick up".
- Start over also undoes steps marked done by hand (`/fg restart`).
- The quest tracker follows the guide, not the game's quest log.
- "Only the guide's quests" no longer accepts quests the guide gave up.

### WoW Forever data

- Fixed wrong positions for 179 quest NPCs.
- Added 59 missing prerequisites: no more guides sending you to a quest you cannot take yet.

## 0.4.0 (2026-10-11)

Stop or cancel a generation, a new guide page, dungeon quests step by step.

### Generation

- "Stop and keep this guide" ends the calculation and keeps the best guide so far.
- "Cancel" goes back to the setup without saving.
- The chosen computing time is now all spent on optimizing.
- Paths around mountains are remembered, so the next guides are faster to compute.

### Guide page

- All steps in one table by zone, with filters and colors.
- The zone map beside the table on wide windows.
- A cleaner guide map, colored from start to end.
- Easier-to-read figures.

### Setup and settings

- A clearer setup screen.
- Advanced settings changed from their default are marked, with a reset button.
- Addon tab: the save bar stays visible.
- Settings: a "Browse…" button for the game folder.
- Dates and numbers follow the app's language.

### Dungeons

- Quests done in a dungeon are steps of their own.

### Addon

- New "To pick up" box: the quests you can take now, with their distance.
- Left-click a step to point the arrow at it.
- The quest tracker shows the next 10 quests in the guide's order.
- A yellow mark on the XP bar shows where the guide expects you.
- Grind steps count the XP of quests ready to turn in.

### Guides

- A catch-up step when you fall more than 10% of a level behind.
- Groups of mobs are harder than lone ones; the wait for respawns is counted.
- "Crowded server" becomes a slider.
- Killing mobs on the way has its own limit per level.

### Fixes

- WoW Forever, Redridge: Blackrock Blockade is no longer abandoned too early.

## 0.3.0 (2026-10-11)

Guides in every language, and guides started from your character.

### Languages

- Guides follow the app's language; the addon page picks the language in game.
- Guide texts in 10 languages.
- Older guides keep their texts: generate them again to translate them.
- Older guide files are updated when opened; newer ones ask you to update the app.

### Starting from your character

- Quests already in your log no longer have to be finished: the guide keeps the useful ones.

### Fixes

- Objects among stronger mobs wait until you are strong enough.
- Group: a companion whose class your race cannot play still gets their class quests.
- App: the window no longer stays scrolled down after ticking a box.

## 0.2.0 (2026-10-10)

Personalized leveling guides for WoW Forever, Classic Era / Hardcore and TBC Anniversary.

### Character power

- Fights depend on your level, gear and class spells.
- The guide wears quest rewards and dungeon loot when they are upgrades.
- The addon picks the reward the guide planned.
- Training happens when the new spells are worth it, and only for useful spells.
- Each step shows your power and what your gear brings.

### What the character takes on

- New play styles: cautious (hardcore), normal or risky.
- Cautious avoids groups of mobs above your level.
- Normal does yellow quests, never orange; risky takes orange ones and some elites.
- Elite camps need more power the more elites you pull.
- No more quests started by a mob far above your level.
- Quest NPCs inside a camp wait until you can fight through it.
- New "Crowded server" option: the guide counts the wait for contested mobs and events.

### Grinding

- New "Grind on the way" option: kill mobs met on the way, near your level.
- Grinding is limited to a share of each level (10% by default).
- New "Grinding allowed" option: without it, the guide takes more quests.
- Quest objects among other quests' mobs are picked up between kills.

### Start from your character

- The addon keeps a profile of your character (`/fg profile` saves it at once).
- New guide: pick one of your characters; race, class and level follow.
- The guide goes on from where you are: quests done, log, hearthstone, flight paths.
- Rested XP is counted.
- Flight paths are known once you open a flight master's map in game.

### Professions

- Professions no longer add time or steps.
- The addon tells you if your skill is ahead or behind for your level.
- The profession curve starts when you take it.
- Profession quests are suggested as optional.

### Checkpoints

- Checkpoints from level 20: ahead of plan, skip to the next one.
- Behind plan, grind before going on: "be level 19 and 93%".

### Quests

- No dungeon quests without dungeons, no battleground quests unless asked.
- Quests are taken and turned in together at quest hubs.
- A zone is done in one go.
- Walks go around mountains and cliffs.
- Mobs and objects of quests in the log are done on the way.
- Pet and form class quests are done early.
- No more quests started by rare drops, nor gray quests.
- Fewer trips for just one or two quests.
- Fixed: Deeprun Tram quests, Frostmane Hold, the paladin's Tome of Divinity.

### In the app

- During generation, the best routes and their curves are shown live.
- The calculation keeps to the time chosen.
- My guides: class colors, faction emblems, sortable columns.
- The addon accepts only the guide's quests by default.

### Addon look

- The addon takes the game's look, or the style of ElvUI, EllesmereUI or SpartanUI.
- New "Look" option: automatic, game style or dark.
- A big arrow points to the current step.
- Ctrl + mouse wheel (or `/fg scale 1.3`) resizes the windows.

### Fixes

- Fixed quests taken or turned in on the way too early, or dropped at the end.
- Group: every class's required class quests are planned.
- Addon: quests marked done by hand belong to their guide only.
- Addon: opening the world map no longer raises a Lua error.
- TBC: correct XP in the blood elf and draenei starting zones, and in Outland.
- A dropped quest no longer opens its follow-up.
- Dungeon mobs give the right XP when you outlevel them.
- Correct flight prices; only real flight paths are shown.
- Forever: quests with unknown objectives are left out.
- The hearthstone takes a new character back to its starting area.
- Hearthstone, flight and boat steps name the town and show their own time.
- Ratchet and the Crossroads flight paths are in the Barrens.
- The time shown during the calculation is the guide's play time.
- Mobs on the way are no longer counted twice.
- The guide windows always grow downwards.
- Objectives in progress stay in the guide until done.
- Quest names fall back to English.
- Updates are checked only in published builds.
