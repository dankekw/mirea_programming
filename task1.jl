using HorizonSideRobots

#ставит маркеры, пока не дойдет до назначенной стены 
function put_marks_side!(robot::Robot,side::HorizonSide)::Nothing
    while isborder(robot,side)==false 
        move!(robot,side)
        putmarker!(robot)
    end
end

#передвигает робота пока под ним есть маркеры в назначенную сторону
function move_by_markers(robot::Robot,side::HorizonSide)::Nothing
    while ismarker(robot)==true 
        move!(robot, side) 
    end
end

#изменяет направление робота на противоположенное
function inverse(side::HorizonSide)::HorizonSide
    if side == Nord
        return Sud
    elseif side == Sud
        return Nord
    elseif side == Ost
        return West
    else return Ost
    end
end 

#рисует прямоугольный крест
function rectangular_cross!(robot::Robot)::Nothing
    for side in (Nord,West,Sud,Ost) 
        put_marks_side!(robot,side)
        move_by_markers(robot,inverse(side))
    end
    putmarker!(r)
end
