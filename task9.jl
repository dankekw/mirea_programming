include("MyFunctions.jl")

function task9(r::Robot)
    counter_steps = 1
    side = Nord

    while ismarker(r) == false
        for _ in 1:2
            move_for9(r,side,counter_steps)
            side = counterclockwise_side(side)
        end
        counter_steps += 1
    end
    println("Нашёлся")
end

function move_for9(r::Robot,side::HorizonSide,num::Int)
    for _ in 1:num
        if ismarker(r)
            return nothing
        end
        move!(r,side)
    end
end
