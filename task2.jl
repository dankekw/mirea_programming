using HorizonSideRobots

#передвигает робота и ставит маркеры до границы в заданном направлении 
function put_marks_side!(robot, side)::Nothing
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

#передвигает робота в заданном направлениидо границы и считает, сколько понадобилось шагов 
function move_and_count(robot::Robot, side::HorizonSide)::Int
    num_steps = 0
    while isborder(r, side) == false
        move!(robot, side)
        num_steps += 1
    end
    return num_steps
end

#ставит маркеры по границе окна и возвращает робота в исходное положение 
function mark_perimetr(robot::Robot)::Nothing
    steps_to_Sud = move_and_count(robot, Sud)
    steps_to_West = move_and_count(robot, West)

    for side in (Nord, Ost, Sud, West)
        put_marks_side!(robot, side)
    end

    move_to_num_steps_to_side(robot, Nord, steps_to_Sud)
    move_to_num_steps_to_side(robot, Ost, steps_to_West)
end
