-- Update crash site collision box size and non-free placeable
local ship = data.raw["container"]["crash-site-spaceship"]
ship.collision_box = {{-8.9, -2.9}, {6.9, 4.9}}
ship.map_generator_bounding_box = ship.collision_box
ship.sticker_box = ship.collision_box
ship.selection_box = {{-9, -3}, {7, 5}}
ship.minable = nil

-- Update factorio logo properties
local logo = data.raw["container"]["factorio-logo-22tiles"]
logo.minable = {
    mining_time = 0.5,
    result = "factorio-logo-22tiles"
}
