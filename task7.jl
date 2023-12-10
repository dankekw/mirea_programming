#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок) 
РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с Роботом стоит маркер, и все остальные клетки поля промаркированы в шахматном порядке 
=#

include("RobotFunc.jl")

function mark_chess_and_return(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))
    direct = Ost
    put_marker_flag = true

    if (sum(num_steps[1:2:end]) % 2 != 0)
        put_marker_flag = false
    end

    while (isborder(r, Nord) == false) || (isborder(r, Ost) == false)
        if put_marker_flag
            putmarker!(r)
            put_marker_flag = false
        else
            put_marker_flag = true
        end
        if isborder(r, direct)
            direct = inverse(direct)
            move!(r, Nord)
        else
            move!(r, direct)
        end
    end
    through_rectangles_into_angle(r, (Sud, West))
    move_from_angle!(r, (Nord, Ost), num_steps)
end