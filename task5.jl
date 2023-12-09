#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. Робот - в произвольной клетке поля между внешней и внутренней перегородками. 
РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру, как внутренней, так и внешней, перегородки поставлены маркеры.
=#

include("RobotFunc.jl")

function mark_angles(r)
    num_steps = through_rectangles_into_angle(r,(Sud,West))

    for side in (Nord,Ost,Sud,West)
        moves!(r,side) 
        putmarker!(r)
    end
    
    move_from_angle!(r,(Nord, Ost),num_steps)
end