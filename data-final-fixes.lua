---------------------------------------------------------------------------
-- Change furnace entities to assemblers
require("prototypes.entities.furnace-final")

---------------------------------------------------------------------------
--[[
In data-final-fixes we should have all items, recipes and technology from other mods loaded
The last things we need to do:
    - create new spawning recipes for end products
    - invert all technology dependencies
    - swap recipe input-output
]] ---------------------------------------------------------------------------
-- First add spawning recipes
require("prototypes.recipes.spawn-final")

-- Then swap the recipes and technology tree
require("prototypes.technology.swap-final")
require("prototypes.recipes.swap-final")

-- Last fix the technology tree
require("prototypes.technology.technology-final")
