data:extend({{
    type = "technology",
    name = "spaceship-wreck",
    icon = "__reversetorio__/graphics/technology/spaceship.png",
    icon_size = 256,
    icon_mipmaps = 1,
    effects = {{
        type = "unlock-recipe",
        recipe = "crash-site-spaceship"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-big-1"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-big-2"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-medium-1"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-medium-2"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-medium-3"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-small-1"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-small-2"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-small-3"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-small-4"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-small-5"
    }, {
        type = "unlock-recipe",
        recipe = "crash-site-spaceship-wreck-small-6"
    }},
    order = "c-a-2",
    unit = {
        count = 50,
        ingredients = {},
        time = 15
    }
}, {
    type = "technology",
    name = "omniresource",
    icon = "__reversetorio__/graphics/technology/omniresource.png",
    icon_size = 256,
    icon_mipmaps = 1,
    effects = {},
    order = "c-a-2",
    unit = {
        count = 50,
        ingredients = {},
        time = 15
    },
    prerequisites = {"spaceship-wreck"}
}})
