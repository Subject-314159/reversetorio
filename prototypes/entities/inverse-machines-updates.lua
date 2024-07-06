local util = require("lib.util")

-- Go through all crafting machines
local new = {}
for _, a in pairs({"furnace", "assembling-machine", "rocket-silo"}) do
    for _, ref in pairs(data.raw[a]) do
        -- Check if the crafting machine has a fixed recipe
        if ref.fixed_recipe then
            -- Get a list of all items that place this entity
            local itms = {}
            for _, t in pairs(util.itypes) do
                for _, p in pairs(data.raw[t]) do
                    if p.place_result and p.place_result == ref.name then
                        -- Store original item in array
                        table.insert(itms, p.name)

                        -- Make an inverse copy
                        local invitm = table.deepcopy(p)
                        invitm.name = "inverse-" .. p.name
                        invitm.place_result = "inverse-" .. ref.name
                        if invitm.order then
                            invitm.order = invitm.order .. "-y"
                        end
                        table.insert(new, invitm)
                    end
                end
            end

            -- Create recipes that generate all of these inverse-items
            local recs = {}
            for _, r in pairs(data.raw["recipe"]) do
                local isresult = false
                local rec = util.getRecipePointer(r)
                local results = util.getResultsNormalized(rec)
                for _, res in pairs(results) do
                    if util.arrayHasValue(itms, res.name) then
                        -- Store original recipe in array (we dont do anything with it currently)
                        table.insert(recs, r)

                        -- Remember is result
                        isresult = true
                    end
                end

                -- Copy recipe if result
                if isresult then
                    local invr = table.deepcopy(r)
                    invr.name = "inverse-" .. r.name
                    local invrec = util.getRecipePointer(invr)
                    local invresults = util.getResultsNormalized(invrec)
                    for _, res in pairs(invresults) do
                        -- Replace original result with our copy result
                        if util.arrayHasValue(itms, res.name) then
                            res.name = "inverse-" .. res.name
                        end
                    end
                    -- Update results
                    invrec.results = invresults
                    invrec.result = nil
                    if invr.order then
                        invr.order = invr.order .. "-y"
                    end

                    -- Add recipe to new table
                    table.insert(new, invr)
                end
            end

            -- Copy the crafting machine and make an inverse machine
            local cpyent = table.deepcopy(ref)
            local cpyrec = "reverse-" .. ref.fixed_recipe
            cpyent.name = "inverse-" .. ref.name

            -- Update recipe localised name
            local lname = {string.gsub(ref.name, "-", " ")}
            if util.getEntityPrototypeByName(ref.name) then
                lname = {"entity-name." .. ref.name}
            elseif util.getItemPrototypeByName(ref.name) then
                lname = {"item-name." .. ref.name}
            end
            cpyent.localised_name = {"reversetorio.inverse", {"?", lname}}

            -- TODO: Fix icon (tint)
            -- TODO: Fix sprite (tint)
            cpyent.fixed_recipe = cpyrec

            -- Get/update minable items
            if cpyent.minable then
                -- Check if original item was returned as minable item, if so replace it with reverse variant
                if cpyent.minable.result then
                    if util.arrayHasValue(itms, ref.minable.result) then
                        cpyent.minable.result = cpyent.name
                    end
                elseif cpyrec.minable.results then
                    for _, r in pairs(cpyrec.minable.results) do
                        if r.name == ref.name then
                            if util.arrayHasValue(itms, r.name) then
                                r.name = "inverse-" .. r.name
                            end
                        end
                    end
                end
            end

            -- Add entity prototype to new array
            table.insert(new, cpyent)

            -- Check if the reverse fixed recipe exists, if not create it
            local rec = data.raw["recipe"][cpyrec]
            if not rec then
                local rev = util.getCopyReverseRecipe(data.raw["recipe"][ref.fixed_recipe])
                table.insert(new, rev)
            end

            -- Create new crafting recipe for our inverse machine
            -- Add one of every original item as ingredient
            local ing = {}
            for _, i in pairs(itms) do
                local ip = {i, 1}
                table.insert(ing, ip)
            end

            -- Make the recipe
            local prop = {
                type = "recipe",
                name = cpyent.name,
                ingredients = ing,
                result = cpyent.name,
                result_count = 1
            }
            table.insert(new, prop)
        end
    end
end

-- Create inverse entities of fuild machines with uneven input/output fluid boxes
-- TODO cleanup: Clean up the mess below
-- TODO: Create crafting recipes for the new entities
-- TODO cleanup: Refactor and make nice function if possible
for _, t in pairs(util.fluidmachines) do
    for _, p in pairs(data.raw[t]) do
        if p.fluid_boxes then
            -- Count the number of inputs/outputs
            local inp = 0
            local outp = 0
            local inb = 0
            local outb = 0
            local hasfilter = false
            for i, b in pairs(p.fluid_boxes) do
                if type(b) == "table" then
                    -- Check production types in/out
                    if b.production_type == "input" then
                        inb = inb + 1
                    elseif b.production_type == "output" then
                        outb = outb + 1
                    end

                    -- Check pipe connections in/out
                    for _, p in pairs(b.pipe_connections) do
                        if p.type == "input" then
                            inp = inp + 1
                        elseif p.type == "output" then
                            outp = outp + 1
                        end
                    end

                    if b.filter then
                        hasfilter = true
                    end
                end

            end

            if inb ~= outb or inp ~= outp or hasfilter then

                -- Duplicate the entity if there is unequal in/out
                local cp = table.deepcopy(p)
                local name = "inverse-" .. p.name
                cp.name = name
                cp.minable.result = name

                for _, b in pairs(cp.fluid_boxes) do
                    if type(b) == "table" then
                        -- Check production types in/out
                        if b.production_type == "input" then
                            b.production_type = "output"
                        elseif b.production_type == "output" then
                            b.production_type = "input"
                        end

                        -- Check pipe connections in/out
                        for _, p in pairs(b.pipe_connections) do
                            if p.type == "input" then
                                p.type = "output"
                            elseif p.type == "output" then
                                p.type = "input"
                            end
                        end
                    end
                end

                -- Add the entity to the new table
                table.insert(new, cp)

                -- Get the item belonging to the entity
                local itm = util.getItemPrototypeByName(p.name)
                local ci
                if itm then
                    ci = table.deepcopy(itm)
                    ci.name = name
                    ci.place_result = name
                else
                    log("Hmm.. item " .. cp.name .. " not found..")
                    log(serpent.block(p))
                    ci = {
                        type = "item",
                        name = name,
                        stack_size = 50,
                        place_result = name
                    }
                end

                -- Add the item to the new table
                table.insert(new, ci)

            end
        end
    end
end

-- Add inverse boilers
for _, b in pairs(data.raw["boiler"]) do
    if b.fluid_box.filter or b.output_fluid_box.filter then
        -- Create a copy of the boiler with input/output fluid boxes swapped
        local cp = table.deepcopy(b)
        local name = "inverse-" .. b.name
        cp.name = name
        cp.minable.result = name

        -- Swap fluid boxes
        local inp = table.deepcopy(cp.fluid_box)
        local out = table.deepcopy(cp.output_fluid_box)
        cp.fluid_box = out
        cp.output_fluid_box = inp
        table.insert(new, cp)

        -- Get the item belonging to the entity
        local itm = util.getItemPrototypeByName(b.name)
        local ci
        if itm then
            ci = table.deepcopy(itm)
            ci.name = name
            ci.place_result = name
        else
            log("Hmm.. item " .. cp.name .. " not found..")
            log(serpent.block(b))
            ci = {
                type = "item",
                name = name,
                stack_size = 50,
                place_result = name
            }
        end

        -- Add the item to the new table
        table.insert(new, ci)
    end
end

data:extend(new)
