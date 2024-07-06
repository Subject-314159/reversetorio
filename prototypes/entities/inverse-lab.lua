require("util")

local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

-- Plain machines that do not require any procedural updates
data:extend({{
    type = "assembling-machine",
    name = "inverse-lab",
    icons = {{
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {1, 0, 0}
    }},
    flags = {"placeable-player", "player-creation"},
    minable = {
        mining_time = 0.2,
        result = "inverse-lab"
    },
    max_health = 150,
    corpse = "lab-remnants",
    dying_explosion = "lab-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    animation = {
        layers = {{
            filename = "__base__/graphics/entity/lab/lab.png",
            width = 98,
            height = 87,
            frame_count = 33,
            line_length = 11,
            animation_speed = 1 / 3,
            shift = util.by_pixel(0, 1.5),
            tint = {1, 0, 0},
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab.png",
                width = 194,
                height = 174,
                frame_count = 33,
                line_length = 11,
                animation_speed = 1 / 3,
                shift = util.by_pixel(0, 1.5),
                tint = {1, 0, 0},
                scale = 0.5
            }
        }, {
            filename = "__base__/graphics/entity/lab/lab-integration.png",
            width = 122,
            height = 81,
            frame_count = 1,
            line_length = 1,
            repeat_count = 33,
            animation_speed = 1 / 3,
            shift = util.by_pixel(0, 15.5),
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
                width = 242,
                height = 162,
                frame_count = 1,
                line_length = 1,
                repeat_count = 33,
                animation_speed = 1 / 3,
                shift = util.by_pixel(0, 15.5),
                scale = 0.5
            }
        }, {
            filename = "__base__/graphics/entity/lab/lab-light.png",
            blend_mode = "additive",
            draw_as_light = true,
            width = 106,
            height = 100,
            frame_count = 33,
            line_length = 11,
            animation_speed = 1 / 3,
            shift = util.by_pixel(-1, 1),
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab-light.png",
                blend_mode = "additive",
                draw_as_light = true,
                width = 216,
                height = 194,
                frame_count = 33,
                line_length = 11,
                animation_speed = 1 / 3,
                shift = util.by_pixel(0, 0),
                scale = 0.5
            }
        }, {
            filename = "__base__/graphics/entity/lab/lab-shadow.png",
            width = 122,
            height = 68,
            frame_count = 1,
            line_length = 1,
            repeat_count = 33,
            animation_speed = 1 / 3,
            shift = util.by_pixel(13, 11),
            draw_as_shadow = true,
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
                width = 242,
                height = 136,
                frame_count = 1,
                line_length = 1,
                repeat_count = 33,
                animation_speed = 1 / 3,
                shift = util.by_pixel(13, 11),
                scale = 0.5,
                draw_as_shadow = true
            }
        }}
    },
    crafting_categories = {"spawn-science"},
    crafting_speed = 1,
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = 4
    },
    energy_usage = "75kW",
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    vehicle_impact_sound = sounds.generic_impact,
    working_sound = {
        sound = {
            filename = "__base__/sound/lab.ogg",
            volume = 0.7
        },
        audible_distance_modifier = 0.7,
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    module_specification = {
        module_slots = 10
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}
}})
