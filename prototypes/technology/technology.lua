data:extend({{
    type = "technology",
    name = "huge-inserter",
    icons = {{
        icon = "__base__/graphics/technology/stack-inserter.png",
        icon_size = 256,
        icon_mipmaps = 4,
        tint = {0, 1, 1}
    }},
    effects = {{
        type = "unlock-recipe",
        recipe = "huge-inserter"
    }},
    prerequisites = {"advanced-electronics-2", "stack-inserter"},
    unit = {
        count = 150,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}},
        time = 30
    },
    order = "c-o-a"
}})
