
function read_input15(filename::String)
    inp = read(filename, String)
    mtxt,ctxt = split(inp, "\n\n")
    m = Int8.(hcat(collect.(split(mtxt,"\n"))...))'
    c2 = Int8.(collect(replace(ctxt, "\n" => "")))
    c = replace(c2, Int8('>') => 1, Int8('^') => 2, Int8('<') => 3, Int8('v') => 4)

    dd = Dict('c' =<CartesianIndex(0,1), 2 => CartesianIndex(-1,0), 3 => CartesianIndex(0,-1), 4 => CartesianIndex(1,0))
    return m,c
end

function moveboxto(m, l, d)
    l = copy(l)

    while m(l) == Int8('O')
        l += d
    end
    return m(l) == Int8('.') ? l : nothing
end

function update_map15(m, l, d)
    m = copy(m)
    next = moveboxto(m, l, d)
    if next !== nothing
        m[next] = Int8('O')
        m[l] = Int8('.')
        return (true, (m, next, d))
    end
    return (false, (m, l, d))
end

