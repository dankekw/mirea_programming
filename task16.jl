#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля 
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
ДОПОЛНИТЕЛЬНО: на поле могут находиться внутренние перегородки прямоугольной формы,
среди которых могут быть и вырожденные прямоугольники (отрезки), эти внутренние перегородки изолированы друг от друга и от внешней рамки.
=#

include("RobotFunc.jl")

function mark_all_cells(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))

    side = Ost
    while (isborder(r, Nord) == false) || (isborder(r, Ost) == false)
        putmarkers_if_possible!(r, side)
        if (isborder(r, Nord) == false)
            move!(r, Nord)
        end
        side = inverse(side)
    end
    through_rectangles_into_angle(r, (Sud, West))
    movements_if_possible!(r, (Nord, Ost), reverse(num_steps))
end