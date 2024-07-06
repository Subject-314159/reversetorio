for _, t in pairs(data.raw["technology"]) do
    -- Ignore our final two techs
    if t.name ~= "omniresource" and t.name ~= "spaceship-wreck" then
        local ptr
        if t.normal then
            ptr = t.normal
        elseif t.expensive then
            ptr = t.expensive
        else
            ptr = t
        end

        -- Add omniresource for all other techs that do not yet have a prerequisite
        if ptr and (not ptr.max_level or (ptr.max_level and ptr.max_level ~= "infinite")) and ptr.unit.count <
            1000000000 then
            if not ptr.prerequisites then
                ptr.prerequisites = {"omniresource"}
            end
        end
    end
end
