
index_in_map(m, l) = l[1] >= 1 && l[1] <= size(m, 1) && l[2] >= 1 && l[2] <= size(m, 2)

function update_map(m, l, d, t)
    m = copy(m)
    l = copy(l)
    d = copy(d)

    rot = Int64.([0 1; -1 0])
    m[CartesianIndex(l...)] = 88
    next = l + d
    if !index_in_map(m, next)
        return (false, (m, next, d,t ))
    end   

    if m[CartesianIndex(next...)] == 35
        if vcat(l,d) in t
            return (false, (m, l, d,t))
        end
        push!(t, vcat(l,d))
        d = rot * d
        next = l
    end
    return (true, (m, next, d,t))
end




function solve(m,l,d)
    m = copy(m)
    count = 0
    t = Set{Vector{Int64}}()
    while true
        ok, (m, l, d, t) = update_map(m, l, d,t)
        if !ok 
            break
        end
        count += 1
    end
    return m
end

function has_loop(m,l,d)
    m = copy(m)
    t = Set{Vector{Int64}}()
    count = 0
    while true
        ok, (m, l, d, t) = update_map(m, l, d, t)
        if !ok
            break
        end
        count += 1
    end
    return l in t
end

function find_loop_blocks(m,l,d,potential_blocks)
    loop_blocks = Vector{CartesianIndex{2}}()
    for block in potential_blocks
        if block == CartesianIndex(l...)
            continue
        end
        mt = copy(m)
        mt[block] = 35
        if has_loop(mt, l, d)
            push!(loop_blocks, block)
        end
    end
    return loop_blocks
end

load_map(file) = Int8.(hcat(collect.(readlines(file))...))'
