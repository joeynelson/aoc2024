

function read_input14(filename::String)
    lines = readlines(filename)

    d = hcat(map(m -> parse.(Int,m), match.(Ref(r"p\=(.+),(.+) v=(.+),(.+)$"),lines))...)
    return d[1:2,:], d[3:4,:]   
end


function quadrant(p)
    p = p .- [50,51]
    if p[1] > 0 && p[2] > 0
        return 1
    elseif p[1] < 0 && p[2] > 0
        return 2
    elseif p[1] < 0 && p[2] < 0
        return 3
    elseif p[1] > 0 && p[2] < 0
        return 4
    else
        return 0
    end
end

function calculate_safety(p, v, t)
    space = [101, 103]
    (p + v * t .% space .+ space) .% space
    q = map(quadrant, eachcol(p100))
    return count(q.==1) * count(q .== 2) * count(q .== 3) * count(q .== 4)
end
