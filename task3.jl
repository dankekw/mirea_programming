using HorizonSideRobots

#передвигает робота и ставит маркеры до границы в заданном направлении 
function put_marks_side!(robot::Robot, side::HorizonSide)::Nothing
    while isborder(robot, side) == false
        move!(robot, side)
        putmarker!(robot)
    end
end

#передвигает робота в заданном направлнии на заданное колличество шагов 
function move_to_num_steps_to_side(robot::Robot, side::HorizonSide, num_steps::Int)::Nothing
    for _ in 1:num_steps
        move!(robot, side)
    end
end

#передвигает робота в заданном направлении до границы и считает, сколько понадобилось шагов 
function move_and_count(robot::Robot, side::HorizonSide)::Int
    num_steps = 0
    while isborder(robot, side) == false
        move!(robot, side)
        num_steps += 1
    end
    return num_steps
end

function move_to_side(robot::Robot, side::HorizonSide)::Nothing
    while isborder(robot, side) == false
        move!(robot, side)   
    end
end 

function inverse(side::HorizonSide)::HorizonSide
    if side == Nord
        return Sud
    elseif side == Sud
        return Nord
    elseif side == Ost
        return West
    else
        return Ost
    end
end

#ставит маркеры по границе окна и возвращает робота в исходное положение 
function mark_all(robot::Robot)::Nothing
    steps_to_Sud = move_and_count(robot, Sud)
    steps_to_West = move_and_count(robot, West)

    side = Ost
    putmarker!(robot)
    put_marks_side!(robot, side)
    move!(robot, Nord)
    while isborder(r, Nord) == false
        side = inverse(side)
        putmarker!(robot)
        put_marks_side!(r, side)
        move!(robot, Nord)
        putmarker!(robot)
    end

    put_marks_side!(robot, inverse(side))

    move_to_side(robot, Sud)
    move_to_side(robot, West)

    move_to_num_steps_to_side(robot, Nord, steps_to_Sud)
    move_to_num_steps_to_side(robot, Ost, steps_to_West)
end