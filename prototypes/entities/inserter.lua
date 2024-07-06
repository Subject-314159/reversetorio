require("util")
require("circuit-connector-sprites")
local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({{
    type = "inserter",
    name = "huge-inserter",
    icons = {{
        icon = "__base__/graphics/icons/stack-inserter.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {0, 1, 1}
    }},
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    stack = true,
    stack_size_bonus = 100,
    minable = {
        mining_time = 0.1,
        result = "huge-inserter"
    },
    max_health = 160,
    corpse = "stack-inserter-remnants",
    dying_explosion = "stack-inserter-explosion",
    resistances = {{
        type = "fire",
        percent = 90
    }},
    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    selection_box = {{-0.9, -0.85}, {0.9, 0.95}},
    damaged_trigger_effect = hit_effects.entity(),
    pickup_position = {-0.5, -1.5},
    insert_position = {0.5, 1.7},
    energy_per_movement = "20KJ",
    energy_per_rotation = "20KJ",
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        drain = "1kW"
    },
    extension_speed = 0.1,
    rotation_speed = 0.06,
    fast_replaceable_group = "inserter",
    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    working_sound = sounds.inserter_fast,

    hand_base_picture = {
        filename = "__base__/graphics/entity/stack-inserter/hr-stack-inserter-hand-base.png",
        priority = "extra-high",
        width = 32,
        height = 136,
        scale = 0.4,
        tint = {0, 1, 1}
    },
    hand_closed_picture = {
        filename = "__base__/graphics/entity/stack-inserter/hr-stack-inserter-hand-closed.png",
        priority = "extra-high",
        width = 100,
        height = 164,
        scale = 0.4,
        tint = {0, 1, 1}
    },
    hand_open_picture = {
        filename = "__base__/graphics/entity/stack-inserter/hr-stack-inserter-hand-open.png",
        priority = "extra-high",
        width = 130,
        height = 164,
        scale = 0.4,
        tint = {0, 1, 1}
    },
    hand_base_shadow = {
        filename = "__base__/graphics/entity/burner-inserter/hr-burner-inserter-hand-base-shadow.png",
        priority = "extra-high",
        width = 32,
        height = 132,
        scale = 0.4,
        tint = {0, 1, 1}
    },
    hand_closed_shadow = {
        filename = "__base__/graphics/entity/stack-inserter/hr-stack-inserter-hand-closed-shadow.png",
        priority = "extra-high",
        width = 100,
        height = 164,
        scale = 0.4,
        tint = {0, 1, 1}
    },
    hand_open_shadow = {
        filename = "__base__/graphics/entity/stack-inserter/hr-stack-inserter-hand-open-shadow.png",
        priority = "extra-high",
        width = 130,
        height = 164,
        scale = 0.4,
        tint = {0, 1, 1}
    },
    platform_picture = {
        sheet = {
            filename = "__base__/graphics/entity/stack-inserter/hr-stack-inserter-platform.png",
            priority = "extra-high",
            width = 105,
            height = 79,
            shift = util.by_pixel(1.5, 7.5 - 1),
            tint = {0, 1, 1},
            scale = 0.8
        }
    },
    circuit_wire_connection_points = circuit_connector_definitions["inserter"].points,
    circuit_connector_sprites = circuit_connector_definitions["inserter"].sprites,
    circuit_wire_max_distance = inserter_circuit_wire_max_distance,
    default_stack_control_input_signal = inserter_default_stack_control_input_signal
}})
