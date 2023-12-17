#=
ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля 
РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, следующий - весь, за исключением одной последней клетки на Востоке,
следующий - за исключением двух последних клеток на Востоке, и т.д. 
ДОПОЛНИТЕЛЬНО: на поле могут находиться внутренние перегородки прямоугольной формы,
среди которых могут быть и вырожденные прямоугольники (отрезки), эти внутренние перегородки изолированы друг от друга и от внешней рамки. 
=#

include("RobotFunc.jl")

function mark_ladder(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))

    cells_in_raw = mark_and_enumerate_if_possible!(r, Ost)
    cells_to_mark = cells_in_raw - 1

    while (isborder(r, Nord) == false) || (isborder(r, West) == false)
        movements_if_possible!(r, West)
        if (isborder(r, Nord) == false)
            move!(r, Nord)
        end

        cells_to_not_mark = cells_in_raw - get_num_movements_if_possible!(r, Ost)
        movements_if_possible!(r, West, cells_in_raw)
        cells_remained = move_and_check(r, Ost, cells_to_mark)
        if ((cells_remained - cells_to_not_mark) > 0)
            putmarkers_if_possible!(r, Ost, cells_remained - cells_to_not_mark)
        end
        cells_to_mark -= 1
    end
    through_rectangles_into_angle(r, (Sud, West))
    movements_if_possible!(r, (Nord, Ost), reverse(num_steps))
end

function move_and_check(r, side, count)
    putmarker!(r)
    while (count != 0 && isborder(r, side) == false)
        move!(r, side)
        putmarker!(r)
        count -= 1
    end
    return count
end