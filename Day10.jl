
function score(trailmap, location)

    trailendset = Set{CartesianIndex{2}}()
    value = trailmap[location]

    if value == 9
        return Set([location])
    end
    for step in [CartesianIndex(1,0), CartesianIndex(-1,0), CartesianIndex(0,1), CartesianIndex(0,-1)]
        if trailmap[location + step] == value + 1
            union!(trailendset, score(trailmap, location + step))
        end
    end
    return trailendset

end


function score2(trailmap, location)

    trailends = 0
    value = trailmap[location]

    if value == 9
        return 1
    end
    for step in [CartesianIndex(1,0), CartesianIndex(-1,0), CartesianIndex(0,1), CartesianIndex(0,-1)]
        if trailmap[location + step] == value + 1
            trailends += score2(trailmap, location + step)
        end
    end
    return trailends

end
