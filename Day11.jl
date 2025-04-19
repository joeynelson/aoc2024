
import Base.^

function (^)(f::Function, i::Int)
    function inner(x)
       for ii in i:-1:1
          x=f(x)
       end
    x
    end
end

function blink(stones)
    stones = copy(stones)
    
    i = 1
    while i <= length(stones)
        stone_digits = ndigits(stones[i])    
        if stones[i] == 0
            stones[i] = 1
        elseif stone_digits % 2 == 0
            stone_string = string(stones[i])
            splice!(stones,i:i,[parse(Int128,stone_string[1:stone_digits ÷ 2]), parse(Int128,stone_string[stone_digits ÷ 2 + 1:stone_digits])])
            i += 1
        else
            stones[i] = stones[i] * 2024
        end
        i += 1
    end
    return stones
end

function blink2(stones)
    new_stones = Dict{Int128,Int128}()

    for k in keys(stones)
        stone_digits = ndigits(k)    
        if k == 0
            new_stones[1] = get(new_stones,1,0) + stones[k]
        elseif stone_digits % 2 == 0
            stone_string = string(k)
            s1 = parse(Int128,stone_string[1:stone_digits ÷ 2])
            s2 = parse(Int128,stone_string[stone_digits ÷ 2 + 1:stone_digits])
            new_stones[s1] = get(new_stones,s1,0) + stones[k]
            new_stones[s2] = get(new_stones,s2,0) + stones[k]
        else
            new_stones[k * 2024] = get(new_stones,k * 2024,0) + stones[k] 
        end
    end
    return new_stones
end

function blink_recurse(castone, n)
    if n == 0
        return 1
    end
    stone_digits = ndigits(stone)    
    if stone == 0
        return blink_recurse(1, n - 1)
    elseif stone_digits % 2 == 0
        stone_string = string(stone)
        c = blink_recurse(parse(Int128,stone_string[1:stone_digits ÷ 2]),n-1)
        c += blink_recurse(parse(Int128,stone_string[stone_digits ÷ 2 + 1:stone_digits]),n-1)
        return c
    else
        return blink_recurse(stone * 2024, n - 1)
    end
end

