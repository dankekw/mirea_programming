#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. Робот -в произвольной клетке поля между внешней и внутренней перегородками. 
РЕЗУЛЬТАТ: Робот -в исходном положении и по всему периметру внутренней перегородки поставлены маркеры. 
=#

include("RobotFunc.jl")


function mark_rectangle_perimeter(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))
    direct = Ost
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
        if isborder(r, right(direct)
            move!(r, direct)
        else
            direct = HorizonSide(right(direct))
            move!(r, direct)
        end
    end
   
    move_from_angle!(r, (Nord, Ost), num_steps)
end