HSR = HorizonSideRobots

abstract type AbstractRobot end

HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

struct BorderRobot <: AbstractRobot
     robot::Robot
end

get_baserobot(robot::BorderRobot) = robot.robot

function try_move!(robot::BorderRobot, side)
     ortogonal_side = left(side)
     back_side = inverse(ortogonal_side)
     n=0
     while isborder(robot, side)==true && isborder(robot, ortogonal_side) == false
         move!(robot, ortogonal_side)
        n += 1
     end
     if isborder(robot,side)==true
         move!(robot, back_side, n)
         return false
     end
     move!(robot, side)
     if n > 0 # продолжается обход
         along!(()->!isborder(robot, back_side), robot, side) 
         move!(robot, back_side, n)
     end
     return true
 end

along!(robot::BorderRobot, side::HorizonSide) = while try_move!(robot, side) end

along!(stop_condition::Function, robot::BorderRobot, side::HorizonSide) =
     while !stop_condition() && try_move!(robot, side) end


"""
    putmarkers!(r::Robot, side::HorizonSide)

-- Ставит маркеры в указанном направлении, пока не упрется в стену
"""
function putmarkers!(r::Robot, side::HorizonSide)::Nothing
    while isborder(r, side) == false
        move!(r, side)
        putmarker!(r)
    end
end

"""
    move_by_markers(r::Robot, side::HorizonSide)

-- Двигается по маркерам в указанном направлении
"""
function move_by_markers(r::Robot, side::HorizonSide)::Nothing
    while ismarker(r) == true 
        move!(r, side) 
    end
end

"""
    inverse(side::HorizonSide)

-- Возвращает направление, противоположное заданному    
"""
function inverse(side::HorizonSide)
    HorizonSide(mod(Int(side) + 2, 4))
end

"""
    right(side::HorizonSide)

-- Возвращает направление, следующее по часовой стрелке, по отношению к заданному    
"""
function right(side::HorizonSide)
    HorizonSide(mod(Int(side)-1, 4))
end

function left(side::HorizonSide)  
    HorizonSide(mod(Int(side) + 1, 4))
end


"""
    moves!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки и возвращает сделанное число шагов    
"""
function moves!(r::Robot, side::HorizonSide)
    num_steps = 0
    while isborder(r, side) == false
        move!(r, side)
        num_steps += 1
    end
    return num_steps
end

"""
    moves!(r::Robot, side::HorizonSide, num_steps::Int)

-- Перемещает Робота в заданном направлении на заданное число шагов    
"""
function moves!(r::Robot, side::HorizonSide, num_steps::Int) 
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
function move_from_angle!(r, sides, num_steps::Vector{Int})
    num_steps = reverse(num_steps)
    for (i, n) in enumerate(num_steps)
        moves!(r, sides[mod(i - 1, length(sides))+1], n)
    end
end

"""
    get_num_movements!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки и возвращает сделанное число шагов    
"""
function get_num_movements!(r::Robot, side::HorizonSide)
    num_steps = 0
    while isborder(r, side) == false
        move!(r, side)
        num_steps += 1
    end
    return num_steps
end


"""
    move_if_possible!(r::Robot, side::HorizonSide)

-- Двигается в заданном направлении, пока возможно, минуя внутренние перегородки    
"""
function move_if_possible!(r::Robot, direct_side::HorizonSide)::Bool
    left_side = right(direct_side)
    right_side = inverse(left_side)
    num_of_steps = 0

    if isborder(r, direct_side) == false
        move!(r, direct_side)
        result = true
    else
        while isborder(r, direct_side) == true
            if isborder(r, left_side) == false
                move!(r, left_side)
                num_of_steps += 1
            else
                break
            end
        end
        if isborder(r, direct_side) == false
            move!(r, direct_side)
            while isborder(r, right_side) == true
                move!(r, direct_side)
            end
            result = true
        else
            result = false
        end
        while num_of_steps > 0
            num_of_steps -= 1
            move!(r, right_side)
        end
    end
    return result
end


"""
    movements_if_possible!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки, минуя внутренние перегородки    
"""
function movements_if_possible!(r::Robot, side::HorizonSide) 
    while isborder(r, side) == false
        move_if_possible!(r, side)
    end
end

"""
    movements_if_possible!(r, sides, num_steps::Vector{Any})

-- перемещает Робота по пути, представленного двумя последовательностями, sides и num_steps 
-- sides - содержит последовательность направлений перемещений
-- num_steps - содержит последовательность чисел шагов в каждом из этих направлений, соответственно; при этом, если длина последовательности sides меньше длины последовательности num_steps, то предполагается, что последовательность sides должна быть продолжена периодически        
"""
function movements_if_possible!(r, sides, num_steps::Vector{Int})
    for (i, n) in enumerate(num_steps)
        movements_if_possible!(r, sides[mod(i - 1, length(sides))+1], n)
    end
end

"""
    movements_if_possible!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении на определенное количетво шагов, минуя внутренние перегородки
"""
function movements_if_possible!(r::Robot, side::HorizonSide, num_steps::Int) 
    for _ in 1:num_steps
        move_if_possible!(r, side)
    end
end

"""
    putmarkers_if_possible!(r::Robot, side::HorizonSide)

-- Ставит маркеры в указанном направлении, пока не наткнется на ограду, минуя внутренние перегородки
"""
function putmarkers_if_possible!(r::Robot, side::HorizonSide)
    putmarker!(r)
    while move_if_possible!(r, side) == true
        putmarker!(r)
    end
end

"""
    putmarkers_if_possible!(r::Robot, side::HorizonSide, count::Int)

-- Ставит маркеры в указанном направлении, минуя внутренние перегородки, пока не обнулится счетчик
"""
function putmarkers_if_possible!(r::Robot, side::HorizonSide, count::Int)
    putmarker!(r)
    while count != 0
        move_if_possible!(r, side)
        putmarker!(r)
        count -= 1
    end
end

"""
    get_num_movements_if_possible!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки, минуя внутренние перегородки, и возвращает сделанное число шагов    
"""
function get_num_movements_if_possible!(r::Robot, side::HorizonSide)
    num_steps = 0
    while move_if_possible!(r, side) == true
        num_steps += 1
    end
    return num_steps
end

"""
    mark_and_enumerate_if_possible!(r::Robot, side::HorizonSide)

--  Ставит маркеры в указанном направлении, пока не наткнется на перегородку, не считая внутренние перегородки, а также считает количетво шагов сделанных в эту сторону и возвращает их
"""
function mark_and_enumerate_if_possible!(r::Robot, side::HorizonSide)
    num_steps = 0
    putmarker!(r)
    while move_if_possible!(r, side) == true
        putmarker!(r)
        num_steps += 1
    end
    return num_steps
end
