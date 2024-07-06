-- Reverse dependency direction of technology
local shadow = {}
for _, t in pairs(data.raw["technology"]) do
    -- Copy the prerequisite to the shadow array
    if t.prerequisites and t.max_level ~= "infinite" then
        -- TODO: Figure out what to do with infinite and leveling technology, maybe infinite before lvl1 and leveling show all tech in tree gui
        for _, p in pairs(t.prerequisites) do
            -- Look if the prerequisite technology already exists in our array
            local idx = 0
            for i, s in pairs(shadow) do
                if s and s.name == p then
                    idx = i
                    break
                end
            end

            -- Add new technology entry to shador array if not yet exists
            if idx == 0 then
                local prop = {
                    name = p,
                    prereq = {}
                }
                table.insert(shadow, prop)
                -- Set the index to the last added item
                idx = #shadow
            end
            -- Add the parent technology as prerequisite in the shadow array
            table.insert(shadow[idx].prereq, t.name)
        end
        -- Clear the prerequisite
        t.prerequisites = nil

    end

end

for i, t in pairs(shadow) do
    -- Update the new tech with the reverse prerequisite
    local tech = data.raw["technology"][t.name]
    local prereq = table.deepcopy(t.prereq)
    tech.prerequisites = prereq
end
