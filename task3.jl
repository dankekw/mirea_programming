#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля.
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы.
=#

include("RobotFunc.jl")

function mark_field!(r::Robot)
    num_vertically = moves!(r, Sud)
    num_horizontally = moves!(r, West)

    putmarkers_for_task3!(r, Nord)

    moves!(r, Sud)
    moves!(r, West)
    moves!(r, Nord, num_vertically)
    moves!(r, Ost, num_horizontally)
end


function putmarkers_for_task3!(r::Robot, side::HorizonSide)
    while !isborder(r, side)
        putmarker!(r)
        move!(r, side)
    end

    putmarker!(r)

    if !isborder(r, Ost)
        move!(r, Ost)
        return putmarkers!(r, inverse(side))#рекурсивный вызов функции в противоположенном напрапвлении 
    end
end
