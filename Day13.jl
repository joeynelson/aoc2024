


function check_machine(desc, adder = 0)
    m = match(r"A: X\+(\d+), Y\+(\d+).*B: X\+(\d+), Y\+(\d+).*Prize: X\=(\d+), Y\=(\d+)"s,desc)

    vals = parse.(Int, m) 

    A = reshape(vals[1:4],2,2)
    b = vals[5:6] .+ adder
    x = A \ b

    if all(abs.(x .- round.(Int,x)) .< 0.0001 ) && all(x .>= 0)
        if any(x .> 100)
            println("Too high")
        end
        return round(Int, 3 * x[1] + x[2])
    else
        return 0
    end
end
    

function val_machine(desc)
    m = match(r"A: X\+(\d+), Y\+(\d+).*B: X\+(\d+), Y\+(\d+).*Prize: X\=(\d+), Y\=(\d+)"s,desc)

    vals = parse.(Int, m) 

    A = reshape(vals[1:4],2,2)
    b = vals[5:6]
    x = A \ b

    println("$b = $A * $x")


end
