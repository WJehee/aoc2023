
function process_line(line)
    local matches = {}
    for w in string.gmatch(line, "%w%w%w") do
        table.insert(matches, w)
    end
    return matches
end

local f = io.open("input.txt", "r")
local nodes = {}

local navigation = f:read("*line")
f:read("*line")

local line = f:read("*line")
while line do
    local matches = process_line(line)
    nodes[matches[1]] = {matches[2], matches[3]}

    line = f:read("*line")
end

function calc_steps(start_node, part2)
    local current_node = nodes[start_node]
    local steps = 0
    local next_node = ""

    while true do
        for i=1, string.len(navigation) do
            local char = string.sub(navigation, i, i)
            if char == 'L' then
                next_node = current_node[1]
            elseif char == 'R' then
                next_node = current_node[2]
            end
            steps = steps + 1
            if not part2 and next_node == "ZZZ" then return steps end
            if part2 and string.find(next_node, "%w+Z") then return steps end
            current_node = nodes[next_node]
        end
    end
end

print("Part 1:")
steps = calc_steps("AAA", false)
print(steps)

steps = {}
for k, v in pairs(nodes) do
    if string.find(k, "%w+A") then
        s = calc_steps(k, true)
        table.insert(steps, s)
    end
end

function lcm(a, b) 
    local function gcd(a, b)
        if b == 0 then
            return a
        end
        return gcd(b, a % b)
    end
    return a * b / gcd(a, b)
end

a = table.remove(steps, 1)

for _, b in pairs(steps) do
    a = lcm(a, b)
end

print("Part 2:")
print(string.format("%.0f", a))

