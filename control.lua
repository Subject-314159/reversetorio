local startsite = require("scripts.startsite")
local watchdog = require("scripts.watchdog")

local util = require("lib.util")
-- local mod_gui = require("mod-gui")
-- script.on_event(defines.events.on_tick, function()
--     -- Do magic here
-- end)
script.on_init(function()
    -- Set up the game environment
    if remote.interfaces["freeplay"] then

        -- Set starter and respawn items
        remote.call("freeplay", "set_created_items", util.starter_items)
        remote.call("freeplay", "set_respawn_items", util.respawn_items)

        -- Disable crash site & intro
        remote.call("freeplay", "set_skip_intro", true)
        remote.call("freeplay", "set_disable_crashsite", true)

        -- Set custom intro
        -- if not remote.interfaces["freeplay"]["set_custom_intro_message"] then
        --     return
        -- end
        -- remote.call("freeplay", "set_custom_intro_message", {"message.reversetorio-intro"})

        -- Disable victory by rocket launch
        for _, interface in pairs {"silo_script", "better-victory-screen"} do
            if remote.interfaces[interface] and remote.interfaces[interface]["set_no_victory"] then
                remote.call(interface, "set_no_victory", true)
            end
        end

        -- Init startsite
        startsite.init()

    end

end)

script.on_event(defines.events.on_player_created, function(e)
    -- TODO cleanup: Move this to dedicated function
    if remote.interfaces["freeplay"] and not settings.global["skip-intro-cutscene"].value then
        local player = game.players[e.player_index]
        local waypoints = {{
            position = global.silo.position,
            transition_time = 1,
            zoom = 1.4,
            time_to_wait = 7 * 60
        }, {
            position = global.silo.position,
            transition_time = 2 * 60,
            zoom = 0.7,
            time_to_wait = 7 * 60
        }, {
            position = player.position,
            transition_time = 1 * 60,
            zoom = 1,
            time_to_wait = 1
        }}
        player.set_controller {
            type = defines.controllers.cutscene,
            waypoints = waypoints,
            start_position = global.silo.position,
            start_zoom = 1
        }

        remote.call("freeplay", "set_custom_intro_message", {"message.reversetorio-intro"})
    end

end)
script.on_event(defines.events.on_tick, function()
    startsite.tick_update()

    -- TODO cleanup: Optimize to maybe not run every tick & move to proper files
    -- TODO low prio: Add a working animation (glowing light?) over the teacups
    for _, d in pairs(global.drives) do
        if d and d.valid and d.status == defines.entity_status.working then
            if math.random(1, 1000) < 25 then
                local pos = {
                    x = d.position.x + (math.random(-15, 15) / 10),
                    y = d.position.y + (math.random(-15, 15) / 10)
                }
                local beam = game.surfaces[1].create_entity({
                    name = "electric-beam",
                    position = d.position,
                    target_position = d.position,
                    source_position = pos,
                    duration = math.random(10, 30)
                })
            end
        elseif not d.valid then
            global.drives[d.unit_number] = nil
        end
    end
end)

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity,
                 defines.events.script_raised_built, defines.events.script_raised_revive -- defines.events.on_entity_cloned
}, function(e)
    -- Script placement returns 'entity' while player/robot placement returns 'created_entity'
    -- Convert player/robot entity to script entity so they can be handled the same way
    if e["created_entity"] and not e["entity"] then
        e["entity"] = e["created_entity"]
    end
    if not e["entity"] then
        return
    end
    watchdog.on_built(e)
end)

script.on_event({defines.events.on_entity_died, defines.events.on_pre_player_mined_item,
                 defines.events.on_robot_pre_mined, defines.events.script_raised_destroy}, function(e)
    -- Triggers on entity destroyed
    watchdog.on_destroyed(e)
end)
