function update!(dm)
    lfb = findlast(block -> block != -1, dm)
    feb = findfirst(block -> block == -1, dm)
    if lfb > feb
        dm[feb] = dm[lfb]
        dm[lfb] = -1
        return true
    end
    
end

function solve(dm)
    dm = map(t -> iseven(t[1]) ? (-1,t[2]) : (t[1] ÷ 2, t[2]), enumerate(dm))
    last_size = sum(last,dm)
    last_len = length(dm)
    lastfile = maximum(first.(dm[1:2:end])) 
    for i in lastfile:-1:0
        fileidx = findfirst(block -> block[1] == i, dm)
        filesize = dm[fileidx][2]
        slotidx = findfirst(block -> block[1] == -1 && block[2] >= filesize, dm)
        if isnothing(slotidx) || slotidx > fileidx
            continue
        end
        splice!(dm,fileidx:fileidx)
        remainder = dm[slotidx][2] - filesize
        if remainder > 0
            splice!(dm,slotidx:slotidx,[(i,filesize), (-1,remainder)])
        else
            dm[slotidx] = (i,filesize)
        end
        cur_size = sum(last,dm)
        if cur_size != last_size
            println("$i: $last_size -> $cur_size, $filesize $remainder")
            println("$(last_len) -> $(length(dm))")
        end
        last_size = cur_size
        last_len = length(dm)
    end
    return dm
end

    