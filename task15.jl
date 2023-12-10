#=
ДАНО: Робот в произвольной клетке поля (без внутренних перегородок и маркеров) 
РЕЗУЛЬТАТ: Робот -в исходном положении, и все клетки по периметру внешней рамки промакированы
ДОПОЛНИТЕЛЬНО: на поле могут находиться внутренние перегородки прямоугольной формы,
среди которых могут быть и вырожденные прямоугольники (отрезки), эти внутренние перегородки изолированы друг от друга и от внешней рамки.
=#

include("RobotFunc.jl")

function mark_perimeter(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))
    side = Nord
    for i in 0:1:3
        putmarkers_if_possible!(r, side)
        side = right(side)
    end
    movements_if_possible!(r, (Nord, Ost), reverse(num_steps))
end