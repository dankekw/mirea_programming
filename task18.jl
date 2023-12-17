#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные перегородки
(все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки) 
Результат: все углы промаркированны, а робот в исходной позиции?
ДОПОЛНИТЕЛЬНО: на поле могут находиться внутренние перегородки прямоугольной формы,
среди которых могут быть и вырожденные прямоугольники (отрезки), эти внутренние перегородки изолированы друг от друга и от внешней рамки.
=#

include("RobotFunc.jl")

function mark_angels(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))
    putmarker!(r)
    through_rectangles_into_angle(r, (Nord, West))
    putmarker!(r)
    through_rectangles_into_angle(r, (Nord, Ost))
    putmarker!(r)
    through_rectangles_into_angle(r, (Sud, Ost))
    putmarker!(r)
    through_rectangles_into_angle(r, (Sud, West))
    movements_if_possible!(r, (Nord, Ost), reverse(num_steps))
end