local function accumulator_picture(tint, repeat_count)
    return {
        layers = {{
            filename = "__base__/graphics/entity/accumulator/accumulator.png",
            priority = "high",
            width = 66,
            height = 94,
            repeat_count = repeat_count,
            shift = util.by_pixel(0, -10),
            tint = tint,
            animation_speed = 0.5,
            hr_version = {
                filename = "__base__/graphics/entity/accumulator/hr-accumulator.png",
                priority = "high",
                width = 130,
                height = 189,
                repeat_count = repeat_count,
                shift = util.by_pixel(0, -11),
                tint = tint,
                animation_speed = 0.5,
                scale = 0.5
            }
        }, {
            filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png",
            priority = "high",
            width = 120,
            height = 54,
            repeat_count = repeat_count,
            shift = util.by_pixel(28, 6),
            draw_as_shadow = true,
            hr_version = {
                filename = "__base__/graphics/entity/accumulator/hr-accumulator-shadow.png",
                priority = "high",
                width = 234,
                height = 106,
                repeat_count = repeat_count,
                shift = util.by_pixel(29, 6),
                draw_as_shadow = true,
                scale = 0.5
            }
        }}
    }
end

local function accumulator_charge()
    return {
        layers = {accumulator_picture({
            r = 1,
            g = 0.6,
            b = 0.3,
            a = 1
        }, 24), {
            filename = "__base__/graphics/entity/accumulator/accumulator-charge.png",
            priority = "high",
            width = 90,
            height = 100,
            line_length = 6,
            frame_count = 24,
            draw_as_glow = true,
            shift = util.by_pixel(0, -22),
            hr_version = {
                filename = "__base__/graphics/entity/accumulator/hr-accumulator-charge.png",
                priority = "high",
                width = 178,
                height = 206,
                line_length = 6,
                frame_count = 24,
                draw_as_glow = true,
                shift = util.by_pixel(0, -22),
                scale = 0.5
            }
        }}
    }
end

data:extend({{
    type = "electric-energy-interface",
    name = "bootstrap-power-source",
    energy_source = {
        type = "electric",
        buffer_capacity = "1MJ",
        usage_priority = "tertiary",
        input_flow_limit = "0kW",
        output_flow_limit = "500GW"
    },
    energy_production = "3.1415MW",
    energy_usage = "0kW",
    icons = {{
        icon = "__base__/graphics/icons/accumulator.png",
        icon_size = 64,
        icon_mipmaps = 4,
        flags = {"placeable-neutral", "player-creation"},
        tint = {1, 0.8, 0.4}
    }},
    flags = {"placeable-player", "player-creation"},
    minable = {
        mining_time = 0.5,
        result = "bootstrap-power-source"
    },
    allow_copy_paste = true,
    continuous_animation = true,
    animation = accumulator_charge(),
    max_health = 150,
    corpse = "accumulator-remnants",
    dying_explosion = "accumulator-explosion",
    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    selection_box = {{-1, -1}, {1, 1}},
    drawing_box = {{-1, -1.5}, {1, 1}}
} --[[@as data.ElectricEnergyInterfacePrototype]] })
