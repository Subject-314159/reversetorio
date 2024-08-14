local util = require("lib.util")

-- Get some variables to work with
local sciences = util.getAllScienceNames()
local new = {}
local grp = {}
local end_itm = {}
local int_itm = {}
local raw_itm = {}
local valid_itm = {}
local valid_itm_name = {}
local invalid_itm = {}
local invalid_itm_name = {}
local valid_rec = {}
local invalid_rec = {}
local cost = {}

---------------------------------------------------------------------------
-- Step 1: Get list of valid recipes and items
---------------------------------------------------------------------------

-- Get initial array of valid items (i.e. items which are not hidden and not ignored)

for _, t in pairs(util.itypes) do
    for _, p in pairs(data.raw[t]) do
        -- Skip items with flag hidden
        local hidden = false
        if p.flags then
            hidden = util.arrayHasValue(p.flags, "hidden")
        end

        -- Validity check
        if (not util.arrayHasValue(util.itemsToIgnore, p.name)) and (not hidden) then
            table.insert(valid_itm, p)
            table.insert(valid_itm_name, p.name)
        else
            table.insert(invalid_itm, p)
            table.insert(invalid_itm_name, p.name)
        end
    end
end

local invi = {}
for _, i in pairs(invalid_itm) do
    table.insert(invi, i.name)
end
log(serpent.block({"Invalid itm", invi}))

-- Get array of valid recipes (i.e. where all the inputs and outputs are valid items)
for _, r in pairs(data.raw["recipe"]) do
    -- Normalize recipe pointer
    local rec = util.getRecipePointer(r)
    local results = util.getResultsNormalized(rec)
    local ingredients = util.getIngredientsNormalized(rec)

    -- Check validity, ignore spawning and voiding recipes
    local valid = true
    if #ingredients == 0 or #results == 0 then
        valid = false
    end

    -- Check if result contains only valid items
    for _, res in pairs(results) do
        valid = valid and util.arrayHasValue(valid_itm_name, res.name)
    end

    -- Check if ingredients only contain valid items
    for _, res in pairs(ingredients) do
        valid = valid and util.arrayHasValue(valid_itm_name, res.name)
    end

    if valid then
        table.insert(valid_rec, r)
    else
        table.insert(invalid_rec, r)
    end
end

local invr = {}
for _, r in pairs(invalid_rec) do
    table.insert(invr, r.name)
end

log(serpent.block({"Invalid rec", invr}))

-- Create list of items (and related groups) for items that do not have a creating recipe
local undefined = {}
for _, p in pairs(valid_itm) do

    -- Check if current item is ingredient or result
    local isresult = false
    local isingredient = false

    -- Loop through valid recipes
    for _, r in pairs(valid_rec) do

        -- Normalize recipe pointer
        local rec = util.getRecipePointer(r)
        local results = util.getResultsNormalized(rec)
        local ingredients = util.getIngredientsNormalized(rec)

        -- Consider only recipes that have ingredients and results
        -- I.e. ignore spawn out of nowhere recipes and void recipes
        if #ingredients > 0 and #results > 0 then

            -- Check if result contains only valid items
            for _, res in pairs(results) do
                if res.name == p.name then
                    isresult = true
                end
            end

            -- Check if ingredients only contain valid items
            for _, res in pairs(ingredients) do
                if res.name == p.name then
                    isingredient = true
                end
            end
        else
            log(serpent.block({"Hmm we have a valid recipe but no ingredients and results..", r}))
        end
    end

    -- Only consider items that are ingredients, results, or both
    if isingredient or isresult then
        -- If item is result but not an ingredien add to array of end items
        if isresult and (not isingredient) then
            -- End items only
            table.insert(end_itm, p)
        end

        -- If item is not a result and an ingredient add to array of raw items
        if (not isresult) and isingredient then
            table.insert(raw_itm, p.name)
        end

        if isresult and isingredient then
            table.insert(int_itm, p.name)
        end
    else
        table.insert(undefined, p.name)
    end
end
if #undefined > 0 then
    log("ERROR: Undefined items remain after validity check!")
    log(serpent.block(undefined))
end

---------------------------------------------------------------------------
-- Step 2: Build cost array
-- At this point all recipes need to be in
---------------------------------------------------------------------------

-- Initiate cost array

local function addRawCost(name)
    if not cost[name] then
        local type = "item"
        if util.itemIsFluid(name) then
            type = "fluid"
        end
        cost[name] = {
            type = type
        }
        cost[name][name] = 1
    end
end

-- Add all fluid results from offshore pumps as cost items
for _, p in pairs(data.raw["offshore-pump"]) do
    local name = p.fluid
    addRawCost(name)
end

-- Add all raw resources as cost items
for _, i in pairs(data.raw["resource"]) do
    local name = i.name
    addRawCost(name)
end

-- Add all other items which are never an input
for _, name in pairs(raw_itm) do
    addRawCost(name)
end

-- log("===== Raw resource base costs =====>")
-- log(serpent.block(cost))
local rec_to_calc = table.deepcopy(valid_rec)
while #rec_to_calc > 0 do
    local remaining_rec_before = #rec_to_calc
    -- Do magic
    -- Loop backwards through valid recipes array
    -- Check if we can make the recipe from the known cost array
    -- Add the resulting items with their relative cost and pop the recipe
    for i = #rec_to_calc, 1, -1 do
        -- Get recipe pointer
        local rec = util.getRecipePointer(rec_to_calc[i])

        -- Loop through ingredients and check if we have identified all of them in the cost array
        local raw = {}
        local costHasAllResults = true

        -- Normalize results
        local ingredients = util.getIngredientsNormalized(rec)
        if #ingredients > 0 then
            for _, res in pairs(ingredients) do
                if util.arrayHasKey(cost, res.name) then
                    for it, co in pairs(cost[res.name]) do
                        if it ~= "type" then -- Ignore key "type"
                            if raw[it] then
                                raw[it] = raw[it] + (res.amount * co)
                            else
                                raw[it] = (res.amount * co)
                            end
                        end
                    end
                else
                    costHasAllResults = false
                end
            end
        else
            costHasAllResults = false
        end

        if costHasAllResults then
            -- Loop through all results, add them to the cost array if not yet exist with their individual prices
            local results = util.getResultsNormalized(rec)
            for _, res in pairs(results) do

                -- Add to cost array if not yet exist
                if not util.arrayHasKey(cost, res.name) then
                    cost[res.name] = raw
                else
                    -- log("WARNING: Result is already available in cost array. Recipe '" .. rec_to_calc[i].name ..
                    --         "' raw cost:")
                    -- log(serpent.block(raw))
                    -- log("Existing cost in array:")
                    -- log(serpent.block(cost[res.name]))
                end
            end

            -- Pop the recipe from the array
            table.remove(rec_to_calc, i)
        end
    end

    -- Sanity check
    if remaining_rec_before == #rec_to_calc then
        log("ERROR: Unprocessed recipes remained equal (" .. #rec_to_calc .. ") after iteration. Remaining recipes:")
        log(serpent.block(rec_to_calc))
        local vi = {}
        for _, i in pairs(valid_itm) do
            table.insert(vi, i.name)
        end
        log("Valid items:")
        log(serpent.block(vi))
        break
    end
end

-- Get total raw resource usage for all cost items, in order to determine final ratio
local toti = {}
local totf = {}
local icnt = 0
local fcnt = 0
for _, item in pairs(cost) do

    for itm, cnt in pairs(item) do
        if itm ~= "type" then
            -- Get amount
            if cost[itm].type == "fluid" then
                -- Add total fluid amount
                if totf[itm] then
                    totf[itm] = totf[itm] + cnt
                else
                    totf[itm] = cnt
                end
                fcnt = fcnt + cnt
            else

                -- Add total item amount
                if toti[itm] then
                    toti[itm] = toti[itm] + cnt
                else
                    toti[itm] = cnt
                end
                icnt = icnt + cnt
            end
        end
    end
end

-- Pop all items with count 1 because they are not used in any other item
-- And count the total resources
-- TODO cleanup: Make subfunction for these two loops since we do 2x the same
local res = {}
for itm, cnt in pairs(toti) do
    if cnt > 1 then
        local prop = {itm, math.ceil((cnt / icnt) * 100)}
        table.insert(res, prop)

        local rec = {
            type = "recipe",
            name = "omni-from-" .. itm,
            ingredients = {prop},
            result = "omniresource",
            result_count = 1,
            category = "advanced-crafting",
            subgroup = "omniresource",
            enabled = false
        }
        table.insert(new, rec)

        -- Add as unlock recipe to tech
        local tech = data.raw["technology"]["omniresource"]
        local prop = {
            type = "unlock-recipe",
            recipe = rec.name
        }
        table.insert(tech.effects, prop)
    end
end
for itm, cnt in pairs(totf) do
    if cnt > 1 then
        local prop = {
            type = "fluid",
            name = itm,
            amount = math.ceil((cnt / fcnt) * 100)
        }
        table.insert(res, prop)

        local rec = {
            type = "recipe",
            name = "omni-from-" .. itm,
            ingredients = {prop},
            result = "omniresource",
            result_count = 1,
            category = "crafting-with-fluid",
            subgroup = "omniresource",
            enabled = false
        }
        table.insert(new, rec)

        -- Add as unlock recipe to tech
        local tech = data.raw["technology"]["omniresource"]
        local prop = {
            type = "unlock-recipe",
            recipe = rec.name
        }
        table.insert(tech.effects, prop)
    end
end

-- TODO low prio: Figure out if anything else needs to be done with this info besides creating omniresources

local function getCostCalculated(item)
    local cnt = 1
    if cost[item] then
        for itm, res in pairs(cost[item]) do
            if itm ~= "type" then
                local amt = res
                if cost[itm] and cost[itm].type == "fluid" then
                    amt = amt / 100
                end
                cnt = cnt + amt
            end
        end
    end
    return math.min(math.ceil(math.sqrt(cnt) / 2), 1000)
end

---------------------------------------------------------------------------
-- Step 3: Create new prototypes
---------------------------------------------------------------------------

-- Generate spawn recipe for end items
for _, p in pairs(end_itm) do
    if not (util.arrayHasValue(util.itemsToIgnore, p.name)) then
        local type = "item"
        if p.type == "fluid" then
            type = "fluid"
        end
        local gr = "other"
        if p.subgroup then
            gr = p.subgroup
        end

        if not util.arrayHasValue(grp, gr) then
            table.insert(grp, gr)
        end

        local cost = getCostCalculated(p.name)

        -- Get localised name (either via localised_name or item name without hypen)
        local lname = {string.gsub(p.name, "-", " ")}
        if p.localised_name then
            lname = {"item-name." .. p.name}
        elseif util.getEntityPrototypeByName(p.name) then
            lname = {"entity-name." .. p.name}
        end

        local prop = {
            type = "recipe",
            name = util.const.SPAWN_PREFIX .. p.name,
            localised_name = {"reversetorio.spawn-recipe", {"?", lname}},
            ingredients = {{"probability-numbers", cost}, {"spawn-essence", math.ceil(math.sqrt(cost))}},
            energy_required = 0.5,
            results = {{
                type = type,
                name = p.name,
                amount = 1
            }},
            subgroup = util.const.SPAWN_PREFIX .. gr,
            order = p.order,
            category = "finite-improbability"
        }

        -- Add research essence as ingredient if science, or as result if not science
        local re = {
            type = "item",
            name = "research-essence",
            amount = 1
            -- amount = math.ceil(math.sqrt(cost) / 2)
        }
        if util.arrayHasValue(sciences, p.name) then
            re.amount = 1
            table.insert(prop.ingredients, re)
        else
            re.amount = math.ceil(math.sqrt(cost) / 2)
            table.insert(prop.results, re)
        end

        -- Add recipe as unlock tech
        local techs = util.getTechsThatUnlockItem(p.name)
        if techs then
            for _, t in pairs(techs) do
                local tprop = {
                    type = "unlock-recipe",
                    recipe = prop.name
                }
                table.insert(t.effects, tprop)
            end
            prop.enabled = false
        end

        -- Add recipeto the new array
        table.insert(new, prop)
    end
end

-- Create probability recipes per crafting group
for _, s in pairs(data.raw["item-subgroup"]) do

    local reps = {}
    local hasscience = false

    -- Generate array of ingredients per crafting category
    for _, r in pairs(valid_rec) do
        if not util.arrayHasValue(util.recipesToIgnore, r.name) and
            not util.arrayHasValue(util.subgroupsToIgnore, r.subgroup) then
            -- Normalize pointers

            local rec = util.getRecipePointer(r)
            local results = util.getResultsNormalized(rec)
            local ingredients = util.getIngredientsNormalized(rec)

            -- if r.subgroup == s.name and string.sub(r.name, 1, 8) ~= "reverse-" then
            local name = rec.main_product
            if not name then
                name = results[1].name
            end
            local itm = util.getItemPrototypeByName(name)
            if r.subgroup == s.name or (itm and itm.subgroup == s.name) then
                for _, res in pairs(results) do
                    local co = getCostCalculated(res.name)
                    local inarray = false
                    for _, rep in pairs(reps) do
                        if rep then
                            if rep.name then
                                if rep.name == res.name then
                                    rep.amount = rep.amount + res.amount
                                    rep.cost = rep.cost + co
                                    inarray = true
                                end
                            end
                        end
                    end
                    if not inarray then
                        local prop = {
                            type = res.type,
                            name = res.name,
                            amount = res.amount,
                            cost = co
                        }
                        table.insert(reps, prop)
                    end

                    -- Check if this is a science
                    if util.arrayHasValue(sciences, res.name) then
                        hasscience = true
                    end
                end

                for _, res in pairs(ingredients) do
                    -- Check if this is a science
                    if util.arrayHasValue(sciences, res.name) then
                        hasscience = true
                    end
                end
            end
        end
    end

    if #reps > 0 then
        -- Add subgroup to update array
        if not util.arrayHasValue(grp, s.name) then
            table.insert(grp, s.name)
        end

        -- Inverse cost and sum
        local tco = 0
        local tp = 0
        for _, rep in pairs(reps) do
            tco = tco + rep.cost
            rep.cost = 1 / rep.cost
            tp = tp + rep.cost
        end

        -- Normalize for probability and get technologies that unlock these results
        local techs = {}
        for _, rep in pairs(reps) do
            -- Normalize for probability
            rep.probability = rep.cost / tp
            rep.cost = nil

            -- Get list technologies related to the results
            local ut = util.getTechsThatUnlockItem(rep.name)
            if ut then
                for _, t in pairs(ut) do
                    -- Add unique tech to array
                    if not util.arrayHasValue(techs, t.name) then
                        table.insert(techs, t.name)
                    end
                end
            end
        end

        -- Add spawn essence as result
        local prop = {
            type = "item",
            name = "spawn-essence",
            amount = math.ceil(math.sqrt(tco / 2))
        }
        table.insert(reps, prop)

        -- Create the recipe & add to new
        local itm = util.getItemPrototypeByName(reps[1].name)
        -- local ico
        -- if itm.icon then
        --     ico = itm.icon
        -- else
        --     ico = itm.icons
        -- end
        if itm then
            local prop = {
                type = "recipe",
                name = "probability-" .. s.name,
                localised_name = {"reversetorio.probability-recipe", {"?", string.gsub(s.name, "-", " ")}},
                subgroup = util.const.SPAWN_PREFIX .. s.name,
                order = "-",
                ingredients = {{"probability-numbers", math.ceil(tco * 0.8)}},
                results = reps,
                energy_required = 0.5,
                main_product = itm.name,
                category = "grouped-improbability"
            }

            -- Add research essence as ingredient if is science, but not if group is rocket launch
            if hasscience and s.name ~= util.const.ROCKET_CAT then
                local ing = {
                    type = "item",
                    name = "research-essence",
                    -- amount = math.ceil(math.sqrt(tco) / 2)
                    amount = 1
                }
                table.insert(prop.ingredients, ing)
            end

            -- Add recipe as unlock tech
            if #techs and not hasscience then
                -- log(serpent.block({"Add grouped improbability " .. prop.name .. " to following techs: ", techs}))
                for _, t in pairs(techs) do
                    local tech = data.raw["technology"][t]
                    local tprop = {
                        type = "unlock-recipe",
                        recipe = prop.name
                    }
                    table.insert(tech.effects, tprop)
                    -- if tech.effects then
                    --     table.insert(tech.effects, tprop)
                    -- elseif tech.normal then
                    --     table.insert(tech.normal.effects, tprop)
                    -- elseif tech.expensive then
                    --     table.insert(tech.expensive.effects, tprop)
                    -- end
                    -- log(serpent.block({"Updated tech for " .. tech.name, tech}))
                end
                prop.enabled = false
            end

            -- Include recipe prototype to be created
            table.insert(new, prop)
        end
    end

end

-- Create spawning recipe for science
-- Get total cost for all sciences and result array per science first
local tc = 0
local res = {}
for _, s in pairs(sciences) do
    -- Ignore essence items
    if not util.arrayHasValue(util.itemsToIgnore, s) then
        tc = tc + getCostCalculated(s)
        local prop = {
            type = "item",
            name = s,
            amount = 1
        }
        table.insert(res, prop)
    end
end

-- Add the actual recipe
local prop = {
    type = "recipe",
    name = util.const.SPAWN_PREFIX .. "all-science",
    icons = {{
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = {1, 0, 0}
    }},
    -- ingredients = {{"probability-numbers", tc}, {"research-essence", math.ceil(math.sqrt(tc))}},
    ingredients = {{"probability-numbers", tc}, {"research-essence", 1}},
    energy_required = 0.5,
    results = res,
    subgroup = util.const.SPAWN_PREFIX .. "science-pack",
    order = "a",
    category = "spawn-science",
    hidden = true
}
table.insert(new, prop)

-- Add subgroup to update array
if not util.arrayHasValue(grp, "science-pack") then
    table.insert(grp, "science-pack")
end

-- Set fixed recipe for spawning lab
local lab = data.raw["assembling-machine"]["inverse-lab"]
lab.fixed_recipe = prop.name

-- Add new dynamic subgroups that go on the spawn tab
for _, g in pairs(grp) do
    -- Get placeholder group order variables
    local sgo_order = "zzz"
    local go_order = "zzz"

    -- Get reference to original subgroup and parent group so that we can get their order
    local sgo = data.raw["item-subgroup"][g]
    if sgo then
        sgo_order = sgo.order or sgo_order -- Fallback to 'zzz' if no order was present in the subgroup
        local go = data.raw["item-group"][sgo.group]
        if go then
            go_order = go.order
        end

    end

    -- make new subgroup property
    local prop = {

        type = "item-subgroup",
        name = util.const.SPAWN_PREFIX .. g,
        group = "finite-improbability",
        order = go_order .. "_" .. sgo_order

    }

    -- Add it to the table to be extended
    table.insert(new, prop)
end

-- Extend the data with all new prototypes
data:extend(new)

---------------------------------------------------------------------------
-- Final step: Add red & blue flame borders
---------------------------------------------------------------------------

util.add_border_to_recipe_category(util.border.blue_border_icon, "grouped-improbability")
util.add_border_to_recipe_category(util.border.red_border_icon, "finite-improbability")
