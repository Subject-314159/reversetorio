require("util")
local lib = require("lib.util")
-- require ("prototypes.entity.pipecovers")
-- require ("prototypes.entity.transport-belt-pictures")
-- require ("prototypes.entity.transport-belt-pictures")
-- require ("circuit-connector-sprites")
-- require ("prototypes.entity.assemblerpipes")
-- require ("prototypes.entity.laser-sounds")

local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({{
    type = "lab",
    name = "ultra-lab",
    icons = {{
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {0.6, 1, 0.8}
    }},
    flags = {"placeable-player", "player-creation"},
    minable = {
        mining_time = 0.2,
        result = "ultra-lab"
    },
    max_health = 150,
    corpse = "lab-remnants",
    dying_explosion = "lab-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    drawing_box = {{-1, -1.5}, {1, 1}},
    damaged_trigger_effect = hit_effects.entity(),
    on_animation = {
        layers = {{
            filename = "__base__/graphics/entity/lab/lab.png",
            width = 98,
            height = 87,
            frame_count = 33,
            line_length = 11,
            animation_speed = 1 / 3,
            shift = util.by_pixel(0, 1.5),
            tint = {0.6, 1, 0.8},
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab.png",
                width = 194,
                height = 174,
                frame_count = 33,
                line_length = 11,
                animation_speed = 1 / 3,
                shift = util.by_pixel(0, 1.5),
                tint = {0.6, 1, 0.8},
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
    off_animation = {
        layers = {{
            filename = "__base__/graphics/entity/lab/lab.png",
            width = 98,
            height = 87,
            frame_count = 1,
            shift = util.by_pixel(0, 1.5),
            tint = {0.6, 1, 0.8},
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab.png",
                width = 194,
                height = 174,
                frame_count = 1,
                shift = util.by_pixel(0, 1.5),
                tint = {0.6, 1, 0.8},
                scale = 0.5
            }
        }, {
            filename = "__base__/graphics/entity/lab/lab-integration.png",
            width = 122,
            height = 81,
            frame_count = 1,
            shift = util.by_pixel(0, 15.5),
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
                width = 242,
                height = 162,
                frame_count = 1,
                shift = util.by_pixel(0, 15.5),
                scale = 0.5
            }
        }, {
            filename = "__base__/graphics/entity/lab/lab-shadow.png",
            width = 122,
            height = 68,
            frame_count = 1,
            shift = util.by_pixel(13, 11),
            draw_as_shadow = true,
            hr_version = {
                filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
                width = 242,
                height = 136,
                frame_count = 1,
                shift = util.by_pixel(13, 11),
                draw_as_shadow = true,
                scale = 0.5
            }
        }}
    },
    working_sound = {
        sound = {
            filename = "__base__/sound/lab.ogg",
            volume = 0.7
        },
        audible_distance_modifier = 0.7,
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input"
    },
    energy_usage = "60kW",
    researching_speed = 25,
    inputs = lib.getAllScienceNames(),
    module_specification = {
        module_slots = 2,
        module_info_icon_shift = {0, 0.9}
    }
}})
