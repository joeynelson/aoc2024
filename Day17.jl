
function read17(filename)
    inp = read(filename,String)
    
    m = match(r"Register A: (\d*)\nRegister B: (\d*)\nRegister C: (\d*)\n\nProgram: (.*)$"m,inp)

    return parse.(Int, collect(m)[1:3]), parse.(Ref(Int64),split(m[4],","))

end


function step_program(registers, program, ip)
    registers = copy(registers)
    outv = nothing
    if ip+1 > length(program)
        return registers, ip, nothing
    end
    instr = program[ip]
    operand = program[ip + 1]

    if instr == 0
        registers[1] = registers[1] >> combo(registers, operand)
    elseif instr == 1
        registers[2] = xor(registers[2], operand)
    elseif instr == 2
        registers[2] = combo(registers, operand) % 8
    elseif instr == 3
        if registers[1] != 0
            return registers, operand+1, nothing
        end
    elseif instr == 4
        registers[2] = xor(registers[2], registers[3])
    elseif instr == 5
        outv = combo(registers, operand) % 8
    elseif instr == 6
        registers[2] = registers[1] >> combo(registers, operand)
    elseif instr == 7
        registers[3] = registers[1] >> combo(registers, operand)
    end
    return registers, ip + 2, outv
end

function combo(registers, operand)
    if operand <= 3
        return operand
    elseif operand == 4
        return registers[1]
    elseif operand == 5
        return registers[2]
    elseif operand == 6
        return registers[3]
    end
end

function combostring(operand)
    if operand <= 3
        return "$operand"
    elseif operand == 4
        return "A"
    elseif operand == 5
        return "B"
    elseif operand == 6
        return "C"
    end
end

function instructionstring(inst,operand)
    if inst == 0
        return "adiv $(combostring(operand))"
    elseif inst == 1
        return "bxl $operand"
    elseif inst == 2
        return "bst $(combostring(operand))"
    elseif inst == 3
        return "jnz $operand"
    elseif inst == 4
        return "bxc"
    elseif inst == 5
        return "out $(combostring(operand))"
    elseif inst == 6
        return "bdiv $(combostring(operand))"
    elseif inst == 7
        return "cdiv $(combostring(operand))"
    end
    return "unknown"
end
    
        
        


function simulate(registers, program, trace = false, stop_at_out = false)
    registers = copy(registers)
    ip = 1
    outs = []
    while ip < length(program)
        if trace
            println("$ip $(program[ip]) $registers $(mod.(registers,Ref(8)))")
            println(instructionstring(program[ip],program[ip+1]))
        end
        registers, ip, outv = step_program(registers, program, ip)
        if outv != nothing
            push!(outs, outv)
            if stop_at_out
                return outs
            end
        end
    end
    return outs
end

function simulate2(registers, program)
    registers = copy(registers)
    ip = 1
    outs = Vector{Int64}()
    while ip < length(program)
        registers, ip, outv = step_program(registers, program, ip)
        if outv != nothing
            push!(outs, outv)
            if length(outs) <= length(program) && program[1:length(outs)] != outs
                return outv
            end
        end
    end
    return outs
end



function Day17a(filename)
    registers, program = read17(filename)

end

function Day17b(filename)
    registers, program = read17(filename)
    rprogram = reverse(program)
    for i in 1:length(program)
        for j in 1:8
            
            if simulate(registers, rprogram, false, true) == program
                return j
            end
        end
    end

    while simulate2(registers, program) != program
        if registers[1] % 1000 == 0
            println("$(registers[1]) $(simulate2(registers, program))")
        end
        registers[1] += 1
    end
    return registers[1]
end