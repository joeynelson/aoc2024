load_map(file) = Int8.(hcat(collect.(readlines(file))...))'

function find_antinodes(map1, freq)
    antennae = findall(map1 .== freq)
    antenna_pairs = tuple.(antennae,hcat(antennae...))
    antinodes = map((a1,a2) -> a2 + 2 * (a1 - a2), antenna_pairs)
    return antinodes
end