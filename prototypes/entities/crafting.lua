local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({{
    type = "assembling-machine",
    name = "finite-improbability-drive",
    icon = "__reversetorio__/graphics/icons/finite-improbability-drive.png",
    icon_size = 64,
    icon_mipmaps = 1,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {
        mining_time = 0.2,
        result = "finite-improbability-drive"
    },
    max_health = 300,
    corpse = "big-remnants",
    dying_explosion = "big-explosion",
    resistances = {{
        type = "fire",
        percent = 70
    }},
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    alert_icon_shift = util.by_pixel(-3, -12),
    animation = {
        layers = {{
            filename = "__reversetorio__/graphics/entities/finite-probability-drive.png",
            priority = "high",
            width = 300,
            height = 300,
            frame_count = 1,
            line_length = 1,
            scale = 0.4,
            shift = util.by_pixel(11, 3)
        }, {
            filename = "__reversetorio__/graphics/entities/finite-probability-drive-shadow.png",
            priority = "high",
            width = 300,
            height = 300,
            frame_count = 1,
            line_length = 1,
            scale = 0.4,
            draw_as_shadow = true,
            shift = util.by_pixel(11, 3)
        }}
    },
    crafting_categories = {"finite-improbability", "grouped-improbability"},
    crafting_speed = 0.5,
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
        sound = {{
            filename = "__base__/sound/assembling-machine-t1-1.ogg",
            volume = 0.5
        }},
        audible_distance_modifier = 0.5,
        fade_in_ticks = 4,
        fade_out_ticks = 20
    }
} --[[@as data.AssemblingMachinePrototype]] })
