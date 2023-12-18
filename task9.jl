#=
ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. Робот - в произвольной клетке поля. 
РЕЗУЛЬТАТ: Робот - в клетке с тем маркером. 
=#

include("RobotFunc.jl")

function spiral!(stop_condition::Function, r)
    n = 1
    side = Nord
    while !stop_condition() 
        for _ in 1:2
            find_marker(stop_condition, r, side, n=max_steps)
            side = right(side)
        end
        n += 1
    end
end

function along!(stop_condition::Functionr, side, max_steps)
    for _ in 1:max_steps
        if stop_condition()
            return nothing
        end
        move!(r, side)
    end
end