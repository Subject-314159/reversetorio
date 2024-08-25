# Welcome to Reversetorio

More or less, less is more, but how you keeping score? Means for every research you make your level drops, kinda like you're starting from the top. Turns out, you can do that.

Factorio but in reverse. You start with a rocket silo and your goal is to craft the crash site space ship. Decompose science into items, unassemble items into basic materials and unsmelt basic materials into ores.

## Start by generating some random numbers

![One magical logo](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/factorio-logo.png)
The Factorio logo is imbued with magical powers and spawns random numbers

## ..and move them in bulk

![With great power comes great inserter hand capacity](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/huge-inserters.png)
I promised myself not to make a "that's what she said" joke but damn those things are huge..

## ..to spawn any item

![Nothing beats a nice hot cup of tea](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/cup-of-tea.png)
Feed probability numbers into finite probability drives to spawn items at will

## ..or any science

![Labs are also reversed](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/science-spawning.png)
Why go through all the trouble of long recipe chains if you can just spawn science from thin air?

## ..then uncraft every item back to raw resources

![Uncraft any item](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/reverse-craft.png)
Break down items to the most basic resources

## ..so that you can rebuild the crash site

![Research the crash site](https://raw.githubusercontent.com/Subject-314159/reversetorio/main/assets/crashsite-research.png)
Finally your personal space ship is here! It's a bit wrecked though..

## Embark on a mental journey

So you think you're good at Factorio, huh? Well be prepared to forget everything you know and get ready for one of the biggest mindfucks in historio.

---

# Recommended companion mods

-   [What is it really used for](https://mods.factorio.com/mod/what-is-it-really-used-for) or [Recipe Book](https://mods.factorio.com/mod/RecipeBook)

# Mod compatibility

This mod relies on procedural creation of items, entities, recipes and technology. By design this mod should be compatible with a lot of other mods, even those that add a lot of content.

As always there are exceptions, **incompatibility** arises for:

-   Mods that add "free" recipes, i.e. either no ingredients required (spawning) or no results defined (voiding)
-   Mods that alter recipes during data-final-fixes
-   Mods that have an alternative victory condition
-   Mods that unlock recipes outside the technology tree

This mod starts with a limited number of crafting recipes available which by design _should_ prevent deadlocks. However, since fast progression and growing the factory is desirable, risk on **inefficiency** grows for:

-   Mods that add a lot of new technology preceding key technology unlocks (such as belts, power poles, inserters)
    -   Since the technology tree is traversed backwards it would take a lot of time to reach these key points
-   Mods that add a lot of recipes that require key entities (such as belts, power poles, inserters)
    -   Because spawn recipes are only generated for end items (i.e. items which are not an ingredient in other recipes)

---

# Known issues

This mod is in early development stage and playable from finish to start. There are still some major-minor issues which are non-gamebreaking that should be taken into account:

-   Recipe balancing and gameplay mechanics are currently being tested and might change in the future
-   Technology names for end items are not displayed correctly
-   Oil refinery recipes not working correctly due to uneven in-/outputs
-   Inverse machines for fluids not yet available
-   Technology sort order is incorrect
-   Enabling setting 'retain original recipes' creates non-exclusive smelting recipes
-   Mods that copy recipes without updating the sort order or add recipes without sort order will mess up the sort order of the reverse recipes as well (won't fix)
-   Start menu background videos with crafting chains are broken (won't fix)
-   The source code is a mess, but it works™

# Roadmap

-   Solve known issues

# Acknowledgement

-   JSON interpreter: https://github.com/rxi/json.lua/blob/master/json.lua
-   Blueprint decoder: https://burnysc2.github.io/Factorio/Tools/DecodeBlueprint/
-   JSON minifier: https://codebeautify.org/jsonminifier
