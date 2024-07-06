local startsite = {}

local json = require("lib.json")
local start = require("lib.start")

local util = require("lib.util")

local function get_init_entity(entity_name)
    local entity = game.surfaces[1].find_entities_filtered({
        name = entity_name
    })
    if not entity then
        game.print("ERROR: Crash site entity " .. entity_name ..
                       " not found! Check mod compatibility and report to mod author.")
        return nil
    else
        return entity
    end
end

function startsite.init()

    -- Deploy starting blueprint
    -- TODO validate recurring: Make sure there are recipes for rocket parts & space science available
    -- TODO validate recurring: Make sure startsite teacups has proper recipes & update start.lua blueprint
    local bp = json.decode(start.str)
    local off = bp.blueprint["position-relative-to-grid"]
    local snap = bp.blueprint["snap-to-grid"]
    local entities = util.arrayCombine(bp.blueprint.entities, bp.blueprint.tiles)

    local rolling = {}
    for _, t in pairs(util.rollingStockTypes) do
        local prot = game.get_filtered_entity_prototypes {{
            filter = "type",
            type = t
        }}

        for _, p in pairs(prot) do
            table.insert(rolling, p.name)
        end
    end

    -- Prep area
    local ar = {{off.x - snap.x, off.y - snap.y}, {off.x, off.y}}
    local srf = game.surfaces[1]

    -- Remove debris
    local ent = srf.find_entities(ar)
    for _, e in pairs(ent) do
        e.destroy()
    end
    srf.destroy_decoratives({
        area = ar
    })

    -- Place landfill over water
    local wtr = srf.find_tiles_filtered({
        area = ar,
        collision_mask = "water-tile"
    })

    local tiles = {}
    for _, t in pairs(wtr) do
        local prop = {
            name = "landfill",
            position = {
                x = t.position.x,
                y = t.position.y
            }
        }
        table.insert(tiles, prop)
    end
    if #tiles > 0 then
        srf.set_tiles(tiles)
    end

    -- Prepare & place all 
    local redo = {}
    for _, ent in pairs(bp.blueprint.entities) do
        -- Correct position and add player force
        local pos = {
            x = ent.position.x + off.x - snap.x,
            y = ent.position.y + off.y - snap.y
        }
        ent.position = pos
        ent.force = "player"

        -- Place the entity or store the train parts for later
        if util.arrayHasValue(rolling, ent.name) then
            table.insert(redo, ent)
        else
            local ce = srf.create_entity(ent)
            -- Store certain entities in global
            if ent.name == "rocket-silo" then
                global.silo = ce
            end

        end

    end

    -- Place the rolling stock
    for _, ent in pairs(redo) do
        local ce = srf.create_entity(ent)
    end

    -- Place the concrete tiles
    for _, tile in pairs(bp.blueprint.tiles) do
        local pos = {
            x = tile.position.x + off.x - snap.x,
            y = tile.position.y + off.y - snap.y
        }
        tile.position = pos
        srf.set_tiles({tile})
    end

    -- Store the entities in global
    global.logo = get_init_entity("factorio-logo-22tiles")[1]
    global.silo = get_init_entity("inverse-rocket-silo")[1]
    global.drives = {}
    local drives = get_init_entity("finite-improbability-drive")
    if drives then
        for _, d in pairs(drives) do
            global.drives[d.unit_number] = d
        end
    end

    -- Set control parameters
    global.firstlaunched = false

    -- Early exit if logo not found
    if (not global.logo) or (not global.silo) then
        return
    end

    -- Make indestructible & non-minable
    global.logo.destructible = false
    global.logo.minable = false
end

function startsite.tick_update()
    -- Get the trunk entity & fill with probability numbers
    if global.logo and global.logo.valid then
        local inv = global.logo.get_inventory(defines.inventory.chest)
        if not inv then
            return
        end
        inv.insert({
            name = "probability-numbers",
            count = 100
        })
        -- TODO later: Track how much numbers are added each tick and add that to the global debt counter
    end

    -- Launch first rocket
    if not global.firstlaunched and global.silo and global.silo.valid then
        if global.silo.rocket_silo_status == defines.rocket_silo_status.rocket_ready then

            local inv = global.silo.get_inventory(defines.inventory.rocket_silo_rocket)
            if inv then
                if inv.get_item_count("space-science-pack") == 0 then
                    inv.insert({
                        name = "space-science-pack",
                        count = 1
                    })
                else
                    global.silo.launch_rocket()
                end
            end
        elseif global.silo.rocket_silo_status == defines.rocket_silo_status.launch_started then
            global.firstlaunched = true
        elseif global.silo.rocket_silo_status == defines.rocket_silo_status.building_rocket and global.silo.rocket_parts <
            100 then
            global.silo.rocket_parts = 100
        end
    end
end

return startsite
