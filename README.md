# Welcome to Reversetorio

More or less, less is more, but how you keeping score? Means for every research you make your level drops, kinda like you're starting from the top. Turns out, you can do that.

Factorio but in reverse. You start with a rocket silo and your goal is to craft the crash site space ship. Decompose science into items, unassemble items into basic materials and unsmelt basic materials into ores.

## Generate random numbers

![One magical logo](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/factorio-logo.png)
The Factorio logo is imbued with magical powers and spawns random numbers

## Move items in bulk

![With great power comes great inserter hand capacity](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/huge-inserters.png)
I promised myself not to make a "that's what she said" joke but damn those things are huge..

## Spawn any item

![Nothing beats a nice hot cup of tea](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/cup-of-tea.png)
Feed probability numbers into finite probability drives to spawn items at will

## Or science

![Labs are also reversed](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/science-spawning.png)
Why go through all the trouble of long recipe chains if you can just spawn science from thin air?

## Embark on a mental journey

So you think you're good at Factorio, huh? Well be prepared to forget everything you know and get ready for one of the biggest mindfucks in historio.

---

# Mod compatibility

This mod relies on procedural creation of items, entities, recipes and technology. By design this mod should be compatible with a lot of other mods, even those that add a lot of content.

As always there are exceptions, **incompatibility** arises for:

-   Mods that add "free" recipes, i.e. either no ingredients required (spawning) or no results defined (voiding)
-   Mods that alter recipes during data-final-fixes
-   Mods that have an alternative victory condition

# Known issues

-   Oil refinery recipes not working correctly due to uneven in-/outputs (will be fixed)
-   Inverse machines for fluids not yet available (will be fixed)
-   Technology sort order is incorrect (will be fixed)
-   Enabling setting 'retain original recipes' creates non-exclusive smelting recipes (will be fixed)
-   Mods that copy recipes without updating the order or add recipes without order will mess up the order of the reverse recipes as well (won't fix)
-   The source code is a mess, but it works™

# Acknowledgement

-   JSON interpreter: https://github.com/rxi/json.lua/blob/master/json.lua
-   Blueprint decoder: https://burnysc2.github.io/Factorio/Tools/DecodeBlueprint/
-   JSON minifier: https://codebeautify.org/jsonminifier
