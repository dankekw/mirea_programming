#=
ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.
=#
include("RobotFunc.jl")

function mark_kross!(r::Robot)::Nothing 
    for side in (Nord, West, Sud, Ost)
        putmarkers!(r, side)
        move_by_markers(r, inverse(side)) 
    end
    putmarker!(r)
end
