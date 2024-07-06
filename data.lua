require("prototypes.entities.crafting")
require("prototypes.entities.crashsite")
require("prototypes.entities.inserter")
require("prototypes.entities.inverse-lab")
require("prototypes.entities.lab")
require("prototypes.entities.power-source")
require("prototypes.entities.vanilla")

require("prototypes.items.crafting")
require("prototypes.items.crashsite")
require("prototypes.items.items")
require("prototypes.items.vanilla")

require("prototypes.recipes.crashsite")
require("prototypes.recipes.recipes")

require("prototypes.technology.technology")
require("prototypes.technology.crashsite")

require("prototypes.misc.groups")

require("__base__/prototypes/entity/pipecovers")
require("__base__/prototypes/entity/assemblerpipes")

-- local util = require("lib.util")

-- TODO: Add recipes for inverse fluid machines
-- TODO: Update tint of inverse machines
-- TODO: The fluid boxes of the fluid machines are swapped, but when placing the entity the icons/arrows are still incorrect --> Do solve

-- -- Add market entity and item
-- local mkt = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
-- mkt.name = "reversetorio-market"
-- mkt.icon = "__base__/graphics/icons/market.png"
-- mkt.icon_size = 64
-- mkt.icon_mipmaps = 4
-- mkt.flags = {"placeable-neutral", "placeable-player", "player-creation"}
-- mkt.minable = {
--     mining_time = 0.2,
--     result = "reversetorio-market"
-- }
-- mkt.max_health = 400
-- mkt.corpse = "big-remnants"
-- mkt.dying_explosion = "big-explosion"
-- mkt.crafting_categories = {"reversetorio-market"}
-- mkt.crafting_speed = 1
-- mkt.energy_usage = "150kW"
-- mkt.animation = {
--     filename = "__base__/graphics/entity/market/market.png",
--     width = 156,
--     height = 127,
--     shift = {0.95, 0.2},
--     frame_count = 1,
--     line_length = 1,
--     tint = {0.5, 0.5, 1}
-- }
-- data:extend({mkt, {
--     type = "item",
--     name = "reversetorio-market",
--     stack_size = 50,
--     icon = "__base__/graphics/icons/market.png",
--     icon_size = 64,
--     icon_mipmaps = 4,
--     subgroup = "production-machine",
--     place_result = "reversetorio-market"
-- }})

-- -- Add bank entity
-- data:extend({{
--     type = "assembling-machine",
--     name = "reversetorio-bank",
--     icon = "__reversetorio__/graphics/entities/bank.png",
--     icon_size = 110,
--     icon_mipmaps = 1,
--     health = 9001,
--     crafting_categories = {"reversetorio-bank"},
--     crafting_speed = 1,
--     energy_usage = "150kW",
--     animation = {
--         filename = "__reversetorio__/graphics/entities/bank.png",
--         width = 110,
--         height = 110,
--         frame_count = 1,
--         line_length = 1
--     },
--     energy_source = {
--         type = "void"
--     },
--     collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
--     selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
-- }})

-- -- Add new recipes

-- -- Generate list of all resources as ingredient
-- local ing = {}
-- for _, r in pairs(data.raw["resource"]) do
--     local p = util.getItemPrototypeByName(r.name)
--     local type = "item"
--     local amount = 1
--     if p.type == "fluid" then
--         type = p.type
--         amount = 100
--     end
--     local prop = {
--         type = type,
--         name = r.name,
--         amount = amount
--     }
--     table.insert(ing, prop)
-- end
-- data:extend({{
--     type = "recipe",
--     name = "omniresource",
--     ingredients = ing,
--     result = "omniresource",
--     result_count = 1,
--     category = "crafting-with-fluid"
-- }, {
--     type = "recipe",
--     name = "bank-coin",
--     ingredients = {},
--     energy_required = (1 / 30),
--     result = "coin",
--     result_count = 1,
--     category = "reversetorio-bank"
-- }, {
--     type = "recipe",
--     name = "bank-market",
--     ingredients = {{"coin", 1}},
--     energy_required = (1 / 30),
--     result = "reversetorio-market",
--     result_count = 1,
--     category = "reversetorio-bank"
-- }})

-- -- Add new bank and market crafting category
-- data:extend({{
--     type = "recipe-category",
--     name = "reversetorio-bank"
-- }, {
--     type = "recipe-category",
--     name = "reversetorio-market"
-- }})

