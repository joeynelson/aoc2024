using Graphs
function read_input20(filename::String)
    inp = read(filename, String)
    m = Int8.(hcat(collect.(readlines(filename))...))'
    return m
end


function make_graph20(m)
    paths = findall(m .!= Int8('#')) 
    pathdict = Dict{CartesianIndex,Int}([(p => i) for (i,p) in enumerate(paths)])
    
    start = pathdict[findfirst(m .== Int8('S'))]
    finish = pathdict[findfirst(m .== Int8('E'))]

    vertedge = [Edge(i, pathdict[CartesianIndex(0,1) + p]) for (i,p) in enumerate(paths) if m[CartesianIndex(0,1) + p] != Int8('#')]
    horedge = [Edge(i, pathdict[CartesianIndex(1,0) + p]) for (i,p) in enumerate(paths) if m[CartesianIndex(1,0) + p] != Int8('#')]

    edges = vcat(vertedge, horedge)
    g = SimpleGraph(edges)

    shortest = a_star(g, start,finish)

    timedict = Dict{Int,Int}([(p.dst => i) for (i,p) in enumerate(shortest)])

    m2 = Int64.(copy(m))
    m2[[paths[p.dst] for p in shortest]] .= [i+90 for i in 1:length(shortest)]
    m2[findfirst(m .== Int8('S'))] = 90
    return m2

end


function find_cheats(m, loc, mindelta)
    cost = 2
    cheats = Vector{Tuple{CartesianIndex{2},CartesianIndex{2},Int}}()
    value = m[loc]
    dirs = [CartesianIndex(0,1), CartesianIndex(1,0), CartesianIndex(0,-1), CartesianIndex(-1,0)]
    for dir in dirs
        for dir2 in dirs
                if dir - dir2 != 0
                dst = loc + dir + dir2
                if all(dst.I .> 0) && all(dst.I .<= size(m)) && m[dst] != Int8('#')
                    delta = m[dst] - value - cost
                        push!(cheats, (loc,dst,delta))
                end
            end
        end
    end

    return cheats
end


function find_cheats2(m, loc, paths)
    max_cheat = 20
    cheats = Vector{Tuple{CartesianIndex{2},CartesianIndex{2},Int}}()
    value = m[loc]
    cheats= [value - m[p] - sum(abs.((p.I .- loc.I))) for p in paths if sum(p.I .- loc.I) <= max_cheat]

    return cheats
end

function find_cheats3(m)
    locs = findall(m .>= 90)

    count = 0
    for s in locs
        for t in locs
            if m[s] + m[t] >= 50 && sum(abs.(Tuple(s.I .- t.I))) <= 20
                count += 1
            end
        end
    end
    return count
end

function make_cheat_maps(m, cheat)
    m2 = copy(m)
    loc, dst, delta =  cheat
    m2[dst] = 300
    m2[loc] = 200 
    return m2
end

