#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольной рамкой поля без внутренних перегородок и маркеров. 
РЕЗУЛЬТАТ: Робот - в исходном положении в центре косого креста (в форме X) из маркеров.
=#
import HorizonSideRobots: isborder
include("RobotFunc.jl")


function mark_kross_x(r::Robot)
    num_steps = through_rectangles_into_angle(r, (Sud, West))
    for side in ((Nord, Ost), (Sud, Ost), (Sud, West), (Nord, West))
        move_and_putmarkers_diagonal!(r, side)
        return_back!(r, side)
    end
    putmarker!(r)
    move_from_angle!(r, (Nord, Ost), num_steps)
end

function move_and_putmarkers_diagonal!(r::Robot, side::NTuple{2,HorizonSide})
    while isborder(r, side) == false
        move_diagonal!(r, side)
        putmarker!(r)
    end
end

function return_back!(r::Robot, side::NTuple{2,HorizonSide})
    while ismarker(r)
        move_diagonal!(r, inverse(side))
    end
end

function move_diagonal!(r::Robot, side::NTuple{2,HorizonSide})
    move!(r, side[1])
    move!(r, side[2])
end


isborder(r::Robot, side::NTuple{2,HorizonSide})::Bool = (isborder(r, side[1]) || isborder(r, side[2]))
inverse(side::NTuple{2,HorizonSide}) = (inverse(side[1]), inverse(side[2]))