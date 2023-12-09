#=
ДАНО: Робот в произвольной клетке поля (без внутренних перегородок и маркеров) 
РЕЗУЛЬТАТ: Робот -в исходном положении, и все клетки по периметру внешней рамки промакированы 
=#

include("RobotFunc.jl")


function mark_frame_perimetr!(r::Robot)
    num_vertically = moves!(r, Sud)
    num_horizontally = moves!(r, West)
    
    for side in [Nord, Ost, Sud, West]
        putmarkers!(r, side) 
    end

    moves!(r, Nord, num_vertically)
    moves!(r, Ost, num_horizontally)
end
