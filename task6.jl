#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. Робот -в произвольной клетке поля между внешней и внутренней перегородками. 
РЕЗУЛЬТАТ: Робот -в исходном положении и по всему периметру внутренней перегородки поставлены маркеры. 
=#

include("RobotFunc.jl")


function mark_rectangle_perimeter(r)
    num_steps = through_rectangles_into_angle(r, (Sud, Ost))
    direct = West
    while (isborder(r, Nord) == false)
        if isborder(r, direct)
            direct = inverse(direct)
            move!(r, Nord)
        else
            move!(r, direct)
        end
    end
    while (ismarker(r) == false)
        putmarker!(r)
        if isborder(r, HorizonSide(mod(Int(direct) - 1, 4)))
            move!(r, direct)
        else
            direct = HorizonSide(mod(Int(direct) - 1, 4))
            move!(r, direct)
        end
    end
    through_rectangles_into_angle(r, (Sud, West))
    move_from_angle!(r, (Nord, Ost), num_steps)
end