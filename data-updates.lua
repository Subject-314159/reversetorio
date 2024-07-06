require("prototypes.items.vanilla-updates")
require("prototypes.recipes.hidden-updates")

require("prototypes.entities.lab-updates")

-- Add reverse rocket silos
require("prototypes.entities.inverse-machines-updates")

-- Technology updates last because here we fix dependencies
-- First generic technology updates, then crashsite updates
require("prototypes.technology.technology-updates")
require("prototypes.technology.crashsite-updates")
