#=
ДАНО: Робот -в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные перегородки
(все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки) 
РЕЗУЛЬТАТ: Робот - в исходном положении, и в 4-х приграничных клетках, две из которых имеют ту же широту, а две -ту же долготу, что и Робот, стоят маркеры. 
=#

include("RobotFunc.jl")

function mark_centers(r)
    num_steps = through_rectangles_into_angle(r, (Sud, West))

    num_steps_to_ost = sum(num_steps[1:2:end])
    num_steps_to_nord = sum(num_steps[2:2:end])

    moves!(r, Nord, num_steps_to_nord)
    putmarker!(r)
    num_steps_to_sud = get_num_movements!(r, Nord)

    moves!(r, Ost, num_steps_to_ost)
    putmarker!(r)
    num_steps_to_west = get_num_movements!(r, Ost)

    moves!(r, Sud, num_steps_to_sud)
    putmarker!(r)
    moves!(r, Sud)
    
    moves!(r, West, num_steps_to_west)
    putmarker!(r)
    moves!(r, West)
    
    move_from_angle!(r, (Nord, Ost), num_steps)
end
