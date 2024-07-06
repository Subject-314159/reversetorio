local util = {}

util.const = {
    SPAWN_PREFIX = "spawn-",
    ROCKET_CAT = "reversetorio-rocketlaunch"
}

util.border = {
    inverse_border_icon = {
        icon = "__reversetorio__/graphics/inverse-border.png",
        icon_size = 64
    },
    blue_border_icon = {
        icon = "__reversetorio__/graphics/blue-border.png",
        icon_size = 256
    },
    red_border_icon = {
        icon = "__reversetorio__/graphics/red-border.png",
        icon_size = 256
    }
}

util.itypes = {"item", "fluid", "ammo", "capsule", "gun", "module", "rail-planner", "spidertron-remote", "tool",
               "armor", "repair-tool", "item-with-entity-data"}

util.etypes = {"accumulator", "artillery-turret", "beacon", "boiler", "burner-generator", "arithmetic-combinator",
               "decider-combinator", "constant-combinator", "container", "logistic-container", "infinity-container",
               "assembling-machine", "rocket-silo", "furnace", "electric-energy-interface", "electric-pole",
               "combat-robot", "construction-robot", "logistic-robot", "gate", "generator", "heat-interface",
               "heat-pipe", "inserter", "lab", "lamp", "land-mine", "linked-container", "market", "mining-drill",
               "offshore-pump", "pipe", "infinity-pipe", "pipe-to-ground", "power-switch", "programmable-speaker",
               "pump", "radar", "curved-rail", "straight-rail", "rail-chain-signal", "rail-signal", "reactor",
               "roboport", "simple-entity-with-owner", "simple-entity-with-force", "solar-panel", "storage-tank",
               "train-stop", "linked-belt", "loader-1x1", "loader", "splitter", "transport-belt", "underground-belt",
               "turret", "ammo-turret", "electric-turret", "fluid-turret", "car", "artillery-wagon", "cargo-wagon",
               "fluid-wagon", "locomotive", "spider-vehicle", "wall", "fish", "simple-entity"}

util.fluidmachines = {"assembling-machine", "furnace", "rocket-silo", "boiler"}

util.recipesToIgnore = {"omniresource", "express-loader", "bank-coin", "bank-market", "crash-site-spaceship",
                        "crash-site-spaceship-wreck-big-1", "crash-site-spaceship-wreck-big-2",
                        "crash-site-spaceship-wreck-medium-1", "crash-site-spaceship-wreck-medium-2",
                        "crash-site-spaceship-wreck-medium-3", "crash-site-spaceship-wreck-small-1",
                        "crash-site-spaceship-wreck-small-2", "crash-site-spaceship-wreck-small-3",
                        "crash-site-spaceship-wreck-small-4", "crash-site-spaceship-wreck-small-5",
                        "crash-site-spaceship-wreck-small-6"}

util.itemsToIgnore = {"item-unknown", "coin", "omniresource", "reversetorio-market", "crash-site-spaceship",
                      "crash-site-spaceship-wreck-big-1", "crash-site-spaceship-wreck-big-2",
                      "crash-site-spaceship-wreck-medium-1", "crash-site-spaceship-wreck-medium-2",
                      "crash-site-spaceship-wreck-medium-3", "crash-site-spaceship-wreck-small-1",
                      "crash-site-spaceship-wreck-small-2", "crash-site-spaceship-wreck-small-3",
                      "crash-site-spaceship-wreck-small-4", "crash-site-spaceship-wreck-small-5",
                      "crash-site-spaceship-wreck-small-6", "spawn-essence", "research-essence"}

util.recipesWithoutUnlockTech = {"finite-improbability-drive", "inverse-lab", "ultra-lab"}
util.categoriesToIgnore = {"reversetorio-rocketlaunch", "finite-improbability", "grouped-improbability"}
util.subgroupsToIgnore = {"boiler-recipes", "fill-barrel", "empty-barrel", "omniresource"}

util.rollingStockTypes = {"locomotive", "fluid-wagon", "cargo-wagon", "artillery-wagon"}

util.entitiesToIgnore = {}

-- Crash site entities
util.crashsite_parts = {{
    name = "reversetorio-bank",
    angle_deviation = 1,
    max_distance = 40,
    min_separation = 20,
    fire_count = 0,
    explosion_count = 0,
    force = "neutral"
}, {
    name = "rocket-silo",
    angle_deviation = 0
}}

-- Items in debris chests
util.crashsite_debris_items = {
    ["coin"] = 50
}

-- Items in the main ship trunk
util.crashsite_ship_items = {} -- Should be an empty array, can't be nil

-- Custom character starter items
util.starter_items = {
    ["coin"] = 10
}

-- Custom character respawn items
util.respawn_items = {}

---------------------------------------------------------------------------
-- Generic utilities
---------------------------------------------------------------------------

util.toProperCase = function(str)
    -- Replace hyphens and underscores with spaces
    str = str:gsub("[-_]", " ")

    -- Capitalize only the first word
    return str:gsub("^%l", string.upper)
end

util.arrayHasValue = function(arr, val)
    for i = 1, #arr do
        if arr[i] == val then
            return true
        end
    end
    return false
end

util.arrayHasKey = function(arr, key)
    for k, v in pairs(arr) do
        if k == key then
            return true
        end
    end
    return false
end

util.arrayCombine = function(arr1, arr2)
    local combined = {}
    for i = 1, #arr1 do
        table.insert(combined, arr1[i])
    end
    for i = 1, #arr2 do
        table.insert(combined, arr2[i])
    end
    return combined
end

---------------------------------------------------------------------------
-- Entity utilities
---------------------------------------------------------------------------

util.getEntityPrototypeByName = function(name)
    for _, t in pairs(util.etypes) do
        for _, ent in pairs(data.raw[t]) do
            if ent.name == name then
                return ent
            end
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- Item utilities
---------------------------------------------------------------------------
util.getItemPrototypeByName = function(name)
    for _, t in pairs(util.itypes) do
        for _, itm in pairs(data.raw[t]) do
            if itm.name == name then
                return itm
            end
        end
    end
    return nil
end

util.itemIsFluid = function(item)
    local itm = data.raw["fluid"][item]
    if itm then
        return true
    else
        return false
    end
end

util.getAllScienceNames = function()

    local science = {}
    for _, l in pairs(data.raw["lab"]) do
        for _, s in pairs(l.inputs) do
            if not util.arrayHasValue(science, s) then
                table.insert(science, s)
            end
        end
    end
    return science
end

---------------------------------------------------------------------------
-- Recipe utilities
---------------------------------------------------------------------------
util.getRecipePointer = function(r)
    if r.normal then
        return r.normal
    elseif r.expensive then
        return r.expensive
    else
        return r
    end
end

util.getRecipeIcons = function(r)
    local icons
    if r.icons then
        -- Recipe already has icons array, copy that
        icons = table.deepcopy(r.icons)
    else
        -- Recipe doesn't have an icons array, so create one from available properties
        if r.icon then
            -- Recipe has a single icon, use that icon
            icons = {{
                icon = r.icon,
                icon_size = r.icon_size or 64,
                icon_mipmaps = r.icon_mipmaps or 1
            }}
        else
            -- Recipe does not have icon nor icons, so we need to use the resulting product icon
            local rec = util.getRecipePointer(r)

            -- Get the reference item
            local itm
            if rec.main_product then
                -- Use the main product as item
                itm = util.getItemPrototypeByName(rec.main_product)
            else
                -- Get the first new ingredient as item
                local inp = util.getResultsNormalized(rec)
                if inp and #inp > 0 then
                    local name = inp[1].name
                    itm = util.getItemPrototypeByName(name)
                end
            end

            if itm then
                if itm.icons then
                    -- Item has icons array, copy that
                    icons = table.deepcopy(itm.icons)
                elseif itm.icon then
                    -- Item has single icon, make icons array based on that
                    local prop = {
                        icon = itm.icon,
                        icon_size = itm.icon_size or 64,
                        icon_mipmaps = itm.icon_mipmaps or 1
                    }
                    icons = {prop}
                end
            end
        end
    end

    -- Correct mipmaps
    if icons then
        for _, i in pairs(icons) do
            if not i.icon_mipmaps then
                i.icon_mipmaps = 1
            end

            if not i.icon_size then
                i.icon_size = 64
            end
        end
    end
    return icons
end

util.getDummyIcons = function()
    -- Create icons array using solid fuel icon
    local icons = {{
        icon = "__base__/graphics/icons/solid-fuel.png",
        icon_size = 64,
        icon_mipmaps = 4
    }}
    return icons
end

util.getItemProductNormalized = function(data)
    local type = "item"
    local name = ""
    local amount = 0
    if data.name or data.result then
        if data.name then
            name = data.name
        elseif data.result then
            name = data.result
        end
        type = data.type

        -- Get the amount based on which property is available
        if data.amount then
            amount = data.amount
        elseif data.count then
            amount = data.count
        elseif data.result_count then
            amount = data.result_count
        elseif data.amount_min and data.amount_max then
            amount = math.ceil((data.amount_min + data.amount_max) / 2)
        elseif data.amount_min then
            amount = data.amount_min
        else
            amount = data.amount_max
        end

        -- Compensate for probability
        if data.probability then
            amount = math.ceil(amount * data.probability)
        end

    elseif data[1] then
        name = data[1]
        amount = data[2]
    end

    local prop = {
        type = type,
        name = name,
        amount = amount
    }
    return prop
end

util.getIngredientsNormalized = function(rec)
    local ingredients = {}
    if rec and rec.ingredients then
        for _, i in pairs(rec.ingredients) do
            -- Get normalized item prduct
            local prop = util.getItemProductNormalized(i)
            table.insert(ingredients, prop)
        end
    end
    return ingredients
end

util.getResultsNormalized = function(rec)
    local results = {}
    if rec and rec.results then
        for _, res in pairs(rec.results) do
            -- Get normalised item product
            local prop = util.getItemProductNormalized(res)
            table.insert(results, prop)

        end
    elseif rec and rec.result then
        -- Create our own prop
        local name = rec.result
        local amount = rec.result_count or 1
        local type = "item"

        local prop = {
            type = type,
            name = name,
            amount = amount
        }
        table.insert(results, prop)

    end
    return results
end

util.recipeSwapInOut = function(r)

    -- Get pointer to recipe data based on normal/expensive
    local rec = util.getRecipePointer(r)

    -- Tranform result to results array
    if not rec.results then
        local prop = {{
            type = "item",
            name = rec.result,
            amount = rec.result_count or 1
        }}
        rec.results = prop
        rec.result = nil
        rec.result_count = nil
    end

    -- Switch ingredients and results if both of them are not empty
    local inp = table.deepcopy(rec.ingredients)
    local res = table.deepcopy(rec.results)
    if inp and inp[1] and res and res[1] then
        -- Normalize min/max and probability output
        -- We can't use normalized item product because we need to calculate probability
        -- TODO low prio: Figure out if we can refactor normalized item product function to be more generic and use here as well
        local p = 0
        local q = 0
        for _, o in pairs(res) do
            -- Normalize output amount
            if not o.amount then
                -- Check min/max
                if o.amount_min and o.amount_max then
                    -- Both min and max specified, take average
                    o.amount = math.ceil((o.amount_min + o.amount_max) / 2)
                elseif o.amount_min then
                    -- Only min specified, use that
                    o.amount = o.amount_min
                else
                    -- Only max specified, use that
                    o.amount = o.amount_max
                end
            end

            -- Track probability
            if o.probability then
                p = p + o.probability
            else
                p = p + 1
            end
            q = q + 1
        end

        -- Swap input and output
        rec.ingredients = res
        rec.results = inp

        -- Update average probability on new output
        if p > 0 and p ~= q then
            local prob = p / q
            -- Make new results array bases on existing results
            -- We can't use normalized item product because we need our own calculated probability for swapped in/out
            local arr = {}
            for _, rs in pairs(rec.results) do
                -- Get name and amount from result
                local name = ""
                local amount = 0
                local type = "item"
                if not rs.name then
                    name = rs[1]
                    amount = rs[2]
                else
                    name = rs.name
                    amount = rs.amount
                end
                if rs.type then
                    type = rs.type
                end

                -- Construct new prop
                local prop = {
                    type = type,
                    name = name,
                    amount = amount,
                    probability = prob
                }

                -- Add to array
                table.insert(arr, prop)
            end

            -- Replace result array
            rec.results = arr
        end
    end

    -- Update icon of main ingredient (instead of main product)
    -- TODO cleanup: Replace with util.getRecipeIcons (need to do sanity check outside of function)
    if (not rec.icons) and (not rec.icon) then
        -- Get the item reference to use the icon data from
        local itm
        if rec.main_product then
            itm = util.getItemPrototypeByName(rec.main_product)
        else
            -- Get the first new ingredient as item
            local inp = util.getIngredientsNormalized(rec)
            if inp and #inp > 0 then
                local name = inp[1].name
                itm = util.getItemPrototypeByName(name)
            end
        end

        if itm then
            -- Get the icon
            if itm.icons then
                r.icons = table.deepcopy(itm.icons)
            else
                r.icon = itm.icon
                r.icon_mipmaps = itm.icon_mipmaps
            end
            r.icon_size = itm.icon_size

            -- Get the subgroup and order of the item
            -- TODO cleanup: When replacing this with util. function need to do this separately
            if not r.subgroup then
                r.subgroup = itm.subgroup
            end
            if not r.order then
                r.order = itm.order
            end
        else
            log("ERROR: Unable to retrieve ingredient input item for recipe " .. r.name)
            log(serpent.block(r))
        end
    end

    -- Wether or not main_product was defined it doesn't work anymore because that item is now an input and not an output
    if rec.results[1] then
        local name = ""
        if rec.results[1].name then
            name = rec.results[1].name
        else
            name = rec.results[1][1]
        end
        rec.main_product = name
    end

    -- Final settings fixes
    local order = ""
    if r.order then
        order = r.order .. "-2"
    end
    r.order = order

    rec.always_show_products = true
    rec.hide_from_player_crafting = false
    rec.always_show_made_in = true
    rec.allow_decomposition = false
    rec.show_amount_in_title = false
end

util.addEssenceToRecipe = function(r)
    local rec = util.getRecipePointer(r)
    if rec.results then
        -- Add spawn essence to result
        local props = {{
            type = "item",
            name = "spawn-essence",
            amount_min = 6,
            amount_max = 9,
            probability = 0.42
        }, {
            type = "item",
            name = "research-essence",
            amount = 10,
            probability = 0.03141
        }}
        for _, prop in pairs(props) do
            table.insert(rec.results, prop)
        end
    else
        log(serpent.block({"WERRORNING: Recipe " .. r.name .. " does not have results array", r}))
    end
end

util.makeRecipeSwapped = function(r)
    -- Create localised name based on either item name or recipe name
    local lname = r.localised_name
    if not lname then
        local entp = util.getEntityPrototypeByName(r.name)
        local itmp = util.getItemPrototypeByName(r.name)
        if entp then
            if entp.localised_name then
                lname = entp.localised_name
            else
                lname = {"entity-name." .. r.name}
            end
        elseif itmp then
            if itmp.localised_name then
                lname = itmp.localised_name
            else
                lname = {"item-name." .. r.name}
            end
        elseif r.localised_name then
            lname = {"recipe-name." .. r.localised_name}
        else
            lname = {r.name}
        end
    else
        -- log("Got localized name")
    end

    -- Update recipe localised name
    r.localised_name = {"reversetorio.reverse", {"?", lname}}
    -- table.insert(r.localised_name[2], lname)

    -- Update actual recipe content
    util.recipeSwapInOut(r)
    util.addEssenceToRecipe(r)
    util.add_border_to_recipe(util.border.inverse_border_icon, r)
end

util.getCopyReverseRecipe = function(recipe)
    -- Create swapped copy of recipe
    local r = table.deepcopy(recipe)
    util.makeRecipeSwapped(r)

    -- Final fixes: Update recipe name (after swapping)
    r.name = "reverse-" .. r.name
    return r
end

util.add_border_to_recipe = function(border_icon_array, recipe)
    local icons = util.getRecipeIcons(recipe)

    if icons then
        if recipe.icon then
            -- clean up after ourselves
            recipe.icon = nil
            recipe.icon_size = nil
            recipe.icon_mipmaps = nil
        end

        table.insert(icons, border_icon_array)
        recipe.icons = icons
    end
end

util.add_border_to_recipe_category = function(border_icon_array, recipe_category)
    for _, recipe in pairs(data.raw["recipe"]) do
        local recipe_name = recipe.name

        -- Check validity
        local valid = true
        if recipe.category then
            valid = valid and (recipe.category == recipe_category)
        else
            valid = valid and (recipe_category == "crafting")
        end
        valid = valid and (not util.arrayHasValue(util.recipesToIgnore, recipe.name))
        if valid then
            util.add_border_to_recipe(border_icon_array, recipe)
        end
    end

end

---------------------------------------------------------------------------
-- Technology utilities
---------------------------------------------------------------------------

util.getTechsThatUnlockItem = function(name)
    -- Early exit if we try to find an item that is on the ignore list
    if util.arrayHasValue(util.itemsToIgnore, name) then
        return
    end

    local techs = {}

    for _, t in pairs(data.raw["technology"]) do
        if t.effects then
            -- Check if the technology unlocks a recipe that produces our end result
            local ismatch = false
            for _, e in pairs(t.effects) do
                if e.type == "unlock-recipe" then
                    -- Cycle through the recipes that are not on the ignore list
                    local r = data.raw["recipe"][e.recipe]

                    if r and not util.arrayHasValue(util.categoriesToIgnore, r.category) then
                        -- Cycle through the results that are not on the ignore list

                        local rec = util.getRecipePointer(r)
                        local results = util.getResultsNormalized(rec)
                        for _, res in pairs(results) do
                            if res.name == name and not util.arrayHasValue(util.itemsToIgnore, res.name) then
                                ismatch = true
                            end
                        end
                    end
                end
            end
            if ismatch then
                table.insert(techs, t)
            end
        end
    end
    if #techs > 0 then
        return techs
    else
        return
    end
end

return util
