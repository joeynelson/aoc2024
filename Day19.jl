

function Day19a(filename)
    lines = readlines(filename)
    flags = strip.(split(lines[1], ","))
    patterns = lines[3:end]

    return flags,patterns
    flags_or = join(flags, "|")
    flags_regex = Regex("(?:$flags_or)+")
    p1 = findall(map(p-> match(flags_regex, p).match,patterns) .== patterns)

    flagset = Set(flags)
    p2 = findall(p -> rrmatch(p, flagset), patterns)
    return(p1,p2)
end

function Day19b(filename)
    lines = readlines(filename)
    flags = strip.(split(lines[1], ","))
    patterns = lines[3:end]

    flags_or = join(flags, "|")
    flags_regex = Regex("(?:$flags_or)+")
    p1 = findall(map(p-> match(flags_regex, p).match,patterns) .== patterns)

    println("Part 1: $(length(p1))")
    flagset = Set(flags)
    p2 = findall(p -> rrmatch(p, flagset), patterns)
    sumways = 0
    println("Part 2: $(length(p2))")
    for idx in p2[2:2]
        ways= rrmatchb(patterns[idx], flagset)
        println("$idx: $ways")
        sumways += ways
    end
    #sumways = map(p -> rrmatchb(p, flagset), patterns[p2])
    return sumways
end

function rmatch(pattern, flagset)
    len = 1
    while len <= length(pattern)
        if pattern[1:len] in flagset
            if len == length(pattern) || rrmatch(pattern[len+1:end], flagset)
                return true

            end
        end
        len += 1
    end
    return false
end

function rrmatch(pattern, flagset)
    start = length(pattern)
    while start >= 1
        if pattern[start:end] in flagset
            if start == 1 || rmatch(pattern[1:start-1], flagset)
                return true
            end
        end
        start -= 1
    end
    return false
end


function rmatchb(pattern, flagset)
    len = 1
    ways = 0
    while len <= length(pattern)
        if pattern[1:len] in flagset
            if len == length(pattern) 
                return 1
            else
                ways += rrmatchb(pattern[len+1:end], flagset)
            end
        end
        len += 1
    end
    return ways
end

function rrmatchb(pattern, flagset)
    start = length(pattern)
    ways = 0
    while start >= 1
        if pattern[start:end] in flagset
            if start == 1
                return 1
            else
                ways += rmatchb(pattern[1:start-1], flagset)
            end
        end
        start -= 1
    end
    return ways
end