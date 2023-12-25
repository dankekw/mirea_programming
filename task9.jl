#=
ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. Робот - в произвольной клетке поля. 
РЕЗУЛЬТАТ: Робот - в клетке с тем маркером. 
=#

include("RobotFunc.jl")


function spiral!(stop_condition::Function, robot)
    r = BorderRobot(robot)
    n = 1
    side = Nord
    while !stop_condition() 
        for _ in 1:2
            along!(stop_condition, r, side, max_steps=n)
            side = right(side)
        end
        n += 1
    end
end


function along!(stop_condition::Function, r, side, max_steps)
    for _ in 1:max_steps
        if stop_condition()
            return nothing
        end
        try_move!(r, side)
    end
end
