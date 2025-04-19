

function Day18a(filename)
    lines = split.(readlines("Day18.txt"),Ref(","))
    bytelocs = map(bl -> parse.(Ref(Int),bl),lines)

    bytelocidxs = [CartesianIndex((bl .+ 2)...) for bl in bytelocs]

    map18 = ones(Int8, 73, 73)

    map18[2:end-1,2:end-1] .= 0

    map18[bytelocidxs[1:1024]] .= 1

    paths = findall(map18 .== 0)
    pathdict = Dict{CartesianIndex,Int}([(p => i) for (i,p) in enumerate(paths)])

    start = pathdict[CartesianIndex(2,2)]
    finish = pathdict[CartesianIndex(72,72)]

    findall(paths .+ CartesianIndex(1,0) .== paths)

    vertedge = [Edge(i, pathdict[CartesianIndex(0,1) + p]) for (i,p) in enumerate(paths) if map18[CartesianIndex(0,1) + p] == 0]
    horedge = [Edge(i, pathdict[CartesianIndex(1,0) + p]) for (i,p) in enumerate(paths) if map18[CartesianIndex(1,0) + p] == 0]

    edges = vcat(vertedge, horedge)
    g = SimpleGraph(edges)

    shortest = a_star(g, start,finish)

    return length(shortest),map18

    
    

end