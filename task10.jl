include("MyFunctions.jl")

function task10(r::Robot)
    answer = 0
    size_that_field = 1
    side = Ost

    answer += temperature(r)
    println("Температура здесь: " * string(temperature(r)))

    while !isborder(r,Nord)

        while !isborder(r,side) 
            answer += move_sp(r, side)
            size_that_field += 1
        end

        answer += move_sp(r, Nord)
        size_that_field += 1
        side=inverse_side(side)
    end

    while !isborder(r,side)   
        answer += move_sp(r, side)
        size_that_field += 1
    end 
    
    return (answer/(size_that_field))
end

function move_sp(r::Robot, side::HorizonSide)
    move!(r,side)
    println("Температура здесь: " * string(temperature(r)))
    return temperature(r)
end