data:extend({ --     {
--     type = "item",
--     name = "towel",
--     icon = "__reversetorio__/graphics/icons/towel.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, {
--     type = "item",
--     name = "dirty-towel",
--     icon = "__reversetorio__/graphics/icons/dirty-towel.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, {
--     type = "item",
--     name = "chaos-prism",
--     icon = "__reversetorio__/graphics/icons/chaos-prism.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, 
{
    type = "item",
    name = "probability-numbers",
    icon = "__reversetorio__/graphics/icons/probability-numbers-2.png",
    icon_size = 64,
    icon_mipmaps = 1,
    pictures = {{
        filename = "__reversetorio__/graphics/icons/numbers/number-1.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-2.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-3.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-4.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-5.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-6.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-7.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-8.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-9.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }, {
        filename = "__reversetorio__/graphics/icons/numbers/number-0.png",
        size = 64,
        scale = 0.25,
        mipmap_count = 1
    }},
    subgroup = "raw-resource",
    order = "1",
    stack_size = 1000
}, -- {
--     type = "item",
--     name = "fiber",
--     icon = "__reversetorio__/graphics/icons/fiber.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 100
-- }, {
--     type = "capsule",
--     name = "cocktail",
--     icon = "__reversetorio__/graphics/icons/cocktail.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     capsule_action = {
--         type = "use-on-self",
--         attack_parameters = {
--             type = "projectile",
--             activation_type = "consume",
--             ammo_category = "capsule",
--             cooldown = 30,
--             range = 0,
--             ammo_type = {
--                 category = "capsule",
--                 target_type = "position",
--                 action = {
--                     type = "direct",
--                     action_delivery = {
--                         type = "instant",
--                         target_effects = {{
--                             type = "damage",
--                             damage = {
--                                 type = "physical",
--                                 amount = -80
--                             }
--                         }, {
--                             type = "insert-item",
--                             item = "lemon-wrapped-gold-brick"
--                         }} -- TODO: Trigger "explosion" effect
--                     }
--                 }
--             }
--         }
--     },
--     order = "2",
--     stack_size = 50
-- }, {
--     type = "capsule",
--     name = "empty-bucket",
--     icon = "__reversetorio__/graphics/icons/bucket-empty.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     capsule_action = {
--         type = "use-on-self",
--         attack_parameters = {
--             type = "projectile",
--             activation_type = "consume",
--             ammo_category = "capsule",
--             cooldown = 30,
--             range = 0,
--             ammo_type = {
--                 category = "capsule",
--                 target_type = "position",
--                 action = {
--                     type = "direct",
--                     action_delivery = nil
--                 }
--             }
--         }
--     },
--     order = "2",
--     stack_size = 50
-- }, {
--     type = "item",
--     name = "lemon-wrapped-gold-brick",
--     icon = "__reversetorio__/graphics/icons/lemon-gold.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, {
--     type = "item",
--     name = "gold-brick",
--     icon = "__reversetorio__/graphics/icons/gold-ingot.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, {
--     type = "item",
--     name = "bucket-with-lemon-juice",
--     icon = "__reversetorio__/graphics/icons/bucket-lemon-juice.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, {
--     type = "item",
--     name = "bucket-with-dirty-water",
--     icon = "__reversetorio__/graphics/icons/bucket-dirty-water.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, {
--     type = "item", -- TODO: Change to capsule & add control.lua throw away water functionality (equal to fill empty bucket)
--     name = "bucket-with-water",
--     icon = "__reversetorio__/graphics/icons/bucket-water.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "raw-resource",
--     order = "1",
--     stack_size = 10
-- }, 
{
    type = "item",
    name = "huge-inserter",
    icons = {{
        icon = "__base__/graphics/icons/stack-inserter.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {0, 1, 1}
    }},
    subgroup = "inserter",
    order = "z[huge-inserter]",
    place_result = "huge-inserter",
    stack_size = 50
}, {
    type = "item",
    name = "ultra-lab",
    icons = {{
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {0.6, 1, 0.8}
    }},
    subgroup = "production-machine",
    order = "z[lab]",
    place_result = "ultra-lab",
    stack_size = 10
}, -- {
--     type = "item",
--     name = "finite-improbability-drive",
--     icon = "__reversetorio__/graphics/icons/finite-improbability-drive.png",
--     icon_size = 64,
--     icon_mipmaps = 1,
--     subgroup = "production-machine",
--     order = "y[drive]",
--     place_result = "finite-improbability-drive",
--     stack_size = 50
-- },
{
    type = "item",
    name = "bootstrap-power-source",
    stack_size = 50,
    icons = {{
        icon = "__base__/graphics/icons/accumulator.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {1, 0.8, 0.4}
    }},
    place_result = "bootstrap-power-source"
}, {
    type = "item",
    name = "spawn-essence",
    stack_size = 200,
    icons = {{
        icon = "__reversetorio__/graphics/vortex-red.png",
        icon_size = 658, -- TODO: Create 64px icons for this
        icon_mipmaps = 4
    }},
    item_subgroup = "essence"
}, {
    type = "tool", -- Needs to be tool because it is used as science
    durability = 1,
    name = "research-essence",
    stack_size = 200,
    icons = {{
        icon = "__reversetorio__/graphics/vortex-blue.png",
        icon_size = 658, -- TODO: Create 64px icons for this
        icon_mipmaps = 4
    }},
    item_subgroup = "essence"
}, {
    type = "item",
    name = "omniresource",
    icon = "__reversetorio__/graphics/icons/omniresource.png",
    icon_size = 64,
    icon_mipmaps = 1,
    stack_size = 1000,
    subgroup = "omniresource"
}, {
    type = "item",
    name = "inverse-lab",
    icons = {{
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {1, 0, 0}
    }},
    subgroup = "production-machine",
    order = "g[lab]-y",
    place_result = "inverse-lab",
    stack_size = 10
}})
