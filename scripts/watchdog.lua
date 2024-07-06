local watchdog = {}

function watchdog.win(force_index)

    if remote.interfaces["better-victory-screen"] and remote.interfaces["better-victory-screen"]["trigger_victory"] then
        remote.call("better-victory-screen", "trigger_victory", game.forces[force_index], true) -- Force it always
    else
        game.set_game_state({
            game_finished = true,
            player_won = true,
            can_continue = true,
            victorious_force = game.forces[force_index]
        })
    end
end

function watchdog.on_built(e)
    local entity = e.entity
    if e.player_index then
        local player = game.players[e.player_index]
        if player then
            local frc = player.force
            if frc then
                local force_index = frc.index

                if entity.name == "crash-site-spaceship" then
                    watchdog.win(force_index)
                end
            end
        end
    end

    -- Store finite improbability drives in global
    if entity.name == "finite-improbability-drive" then
        global.drives[entity.unit_number] = entity
    end
end

function watchdog.on_destroyed(e)
    local entity = e.entity

    -- Remove finite improbability drives from global
    if entity.name == "finite-improbability-drive" then
        global.drives[entity.unit_number] = nil
    end
end

return watchdog
