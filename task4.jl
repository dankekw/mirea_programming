#=
ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля.
РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, следующий - весь, за исключением одной последней клетки на Востоке, следующий - за исключением двух последних клеток на Востоке, и т.д.
=#

include("RobotFunc.jl")

function mark_rows!(r::Robot)
    num_steps_ost = moves!(r, Ost)
    num_vertically = moves!(r, Sud)
    num_horizontally = moves!(r, West)

    putmarkers_for_task4!(r, num_horizontally)

    moves!(r, Sud)
    moves!(r, West)
    moves!(r, Nord, num_vertically)
    moves!(r, Ost, num_horizontally - num_steps_ost)
end


function put_num_markers!(r::Robot, side::HorizonSide, num_marks::Int)# маркирует заданное количество клеток в заданной стороне
    for _ in 1:num_marks
        putmarker!(r)
        move!(r, side)
    end
    putmarker!(r)
end

function putmarkers_for_task4!(r::Robot, num_marks::Int)
    while !isborder(r, Nord)
        put_num_markers!(r, Ost, num_marks)

        move!(r, Nord)
        moves!(r, West)
        num_marks -= 1
    end
    
    put_num_markers!(r, Ost, num_marks)
end