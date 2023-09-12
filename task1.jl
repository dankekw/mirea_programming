using HorizonSideRobots

function put_marks_side!(robot,side)::Nothing
    while isborder(robot,side)==false 
        move!(robot,side)
        putmarker!(robot)
    end
end

function move_by_markers(r,side)::Nothing
    while ismarker(r)==true 
        move!(r,side) 
    end
end

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

function rectangular_cross!(robot)::Nothing
    for side in (Nord,West,Sud,Ost) 
        put_marks_side!(r,side)
        move_by_markers(r,inverse(side))
    end
    putmarker!(r)
end
