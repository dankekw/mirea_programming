function putmarkers!(r::Robot, side::HorizonSide)::Nothing
    while isborder(r, side) == false
        move!(r, side)
        putmarker!(r)
    end
end

function move_by_markers(r::Robot, side::HorizonSide)::Nothing
    while ismarker(r) == true 
        move!(r, side) 
    end
end

function inverse(side::HorizonSide)
    HorizonSide(mod(Int(side) + 2, 4))
end

function moves!(r::Robot, side::HorizonSide) #передвигает робота по стороне horizonside и возвращает количество шагов 
    num_steps = 0
    while isborder(r, side) == false
        move!(r, side)
        num_steps += 1
    end
    return num_steps
end

function moves!(r::Robot, side::HorizonSide, num_steps::Int) #передвигает робота по horizonside на переданное количество шагов
    for _ in 1:num_steps 
        move!(r, side)
    end
end

"""
    through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})

-- Перемещает Робота в заданный угол, прокладывая путь межу внутренними прямоугольными перегородками и возвращает массив, содержащий числа шагов в каждом из заданных направлений на этом пути
"""
function through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})
    num_steps::Vector{Int}=[]
    while !isborder(r,angle[1]) || !isborder(r,angle[2]) 
        push!(num_steps, moves!(r, angle[2]))
        push!(num_steps, moves!(r, angle[1]))
    end
    return num_steps
end

"""
    move_from_angle!(r,sides,num_steps::Vector{Int})

-- перемещает Робота по пути, представленного двумя последовательностями, sides и num_steps 
-- sides - содержит последовательность направлений перемещений
-- num_steps - содержит последовательность чисел шагов в каждом из этих направлений, соответственно; при этом, если длина последовательности sides меньше длины последовательности num_steps, то предполагается, что последовательность sides должна быть продолжена периодически       
"""
function move_from_angle!(r, sides, num_steps)
    num_steps = reverse!(num_steps)
    for i in 1:length(num_steps)
        moves!(r, sides[i], num_steps[i])
    end
end