local util = require("lib.util")

-- Add tech for every recipe that is already unlocked and hide the recipe
local add = {}
for _, r in pairs(data.raw["recipe"]) do
    if not util.arrayHasValue(util.recipesWithoutUnlockTech, r.name) and
        not util.arrayHasValue(util.recipesToIgnore, r.name) then
        local enabled = true
        local rec = util.getRecipePointer(r)
        if rec.enabled == nil then
            if r.enabled == nil then
                enabled = true
            else
                enabled = r.enabled
            end
        else
            enabled = rec.enabled
        end

        if enabled then
            local ico = util.getRecipeIcons(rec)
            if not ico then
                ico = util.getDummyIcons()
            end

            local prop = {
                type = "technology",
                name = r.name,
                localised_name = util.toProperCase(r.name),
                icons = table.deepcopy(ico),
                effects = {{
                    type = "unlock-recipe",
                    recipe = r.name
                }},
                order = "z",
                unit = {
                    count = 50,
                    -- ingredients = {{"automation-science-pack", 1}},
                    ingredients = {},
                    time = 15
                }
            }
            table.insert(add, prop)
            rec.enabled = false

        end
    end
end

data:extend(add)

-- Go over our final add array and their respective unlock recipes
local unused = {}
for _, a in pairs(add) do
    -- Get the actual recipe prototype that is now in data raw
    local aref = data.raw["technology"][a.name]

    -- Go through all technology (including recently added tech)
    for _, t in pairs(data.raw["technology"]) do
        -- Ignore ourself
        if aref.effects and aref.name ~= t.name then
            -- Get target pointer
            local ptr
            if t.normal then
                ptr = t.normal
            elseif t.expensive then
                ptr = t.expensive
            else
                ptr = t
            end

            -- Go through all unlock recipes
            if ptr and ptr.effects then
                local usesitem = false
                local producesitem = false
                for _, e in pairs(t.effects) do
                    if e.type == "unlock-recipe" then

                        -- Check if the unlock recipe uses one of our ingredients

                        -- Go over our added recipes
                        for _, ur in pairs(aref.effects) do
                            -- Our added recipe
                            if ur.recipe then

                                -- TODO cleanup: Make below a separate function and pass recipe as argument because we do 2x the same

                                -- First check if our results are used in the target tech ingredients
                                local r = data.raw["recipe"][ur.recipe]
                                local rec = util.getRecipePointer(r)
                                local results = util.getResultsNormalized(rec)

                                -- Loop through all results
                                for _, res in pairs(results) do

                                    -- The taget technology unlock recipe
                                    local rc = data.raw["recipe"][e.recipe]
                                    local rp = util.getRecipePointer(rc)
                                    local ingp = util.getIngredientsNormalized(rp)

                                    -- Loop through all ingretients
                                    for _, rs in pairs(ingp) do
                                        -- Check for match
                                        if rs.name == res.name then
                                            -- Set the flag
                                            usesitem = true
                                        end
                                    end
                                end

                            end
                        end
                    end
                end

                -- TODO cleanup: Make below a separate function and pass prereq as argument because we do 2x the same
                -- Add our tech as prerequisite if the tech uses any of our products
                if usesitem then
                    if ptr.prerequisites then
                        local unique = true
                        for _, prq in pairs(ptr.prerequisites) do
                            if prq == aref.name then
                                unique = false
                            end
                        end
                        if unique then
                            table.insert(ptr.prerequisites, aref.name)
                        end
                    else
                        ptr.prerequisites = {aref.name}
                    end
                else
                    table.insert(unused, aref)
                end

            end
        end
    end
end

-- Go over tech that was not appointed as prerequisite and find technology that is a prerequisite for us
for _, u in pairs(unused) do
    -- Get the actual recipe prototype that is now in data raw
    local aref = data.raw["technology"][u.name]

    -- Go through all technology (including recently added tech)
    for _, t in pairs(data.raw["technology"]) do
        -- Ignore ourself also if we already have a prerequisite
        if aref.effects and not aref.prerequisites and aref.name ~= t.name then
            -- Get target pointer
            local ptr
            if t.normal then
                ptr = t.normal
            elseif t.expensive then
                ptr = t.expensive
            else
                ptr = t
            end

            -- Go through all unlock recipes
            if ptr and ptr.effects then
                local producesitem = false
                for _, e in pairs(t.effects) do
                    if e.type == "unlock-recipe" then

                        -- Check if the unlock recipe uses one of our ingredients

                        -- Go over our added recipes
                        for _, ur in pairs(aref.effects) do
                            -- Our added recipe
                            if ur.recipe then

                                -- TODO cleanup: Make below a separate function and pass recipe as argument because we do 2x the same

                                -- First check if our results are used in the target tech ingredients
                                local r = data.raw["recipe"][ur.recipe]
                                local rec = util.getRecipePointer(r)

                                -- Next check if our ingredients are one of the target tech's results
                                local ingredients = util.getIngredientsNormalized(rec)

                                -- Loop through all results
                                for _, res in pairs(ingredients) do

                                    -- The taget technology unlock recipe
                                    local rc = data.raw["recipe"][e.recipe]
                                    local rp = util.getRecipePointer(rc)
                                    local resp = util.getResultsNormalized(rp)

                                    -- Loop through all ingretients
                                    for _, rs in pairs(resp) do
                                        -- Check for match
                                        if rs.name == res.name then
                                            -- Set the flag
                                            producesitem = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- TODO cleanup: Make below a separate function and pass prereq as argument because we do 2x the same
                -- Add target tech as prerequisite if we use any of their products
                if producesitem then
                    if aref.prerequisites then
                        local unique = true
                        for _, prq in pairs(aref.prerequisites) do
                            if prq == t.name then
                                unique = false
                            end
                        end
                        if unique then
                            table.insert(aref.prerequisites, t.name)
                        end
                    else
                        aref.prerequisites = {t.name}
                    end
                end

            end
        end
    end
end
