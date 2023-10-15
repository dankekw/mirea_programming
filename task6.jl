include("MyFunctions.jl")

function task6(r::Robot)
    path = go_to_the_sud_west_corner_and_return_path!(r; go_around_barriers = true)
    side = Nord
    
    while side != "border"
        side = sneak!(r, side)
    end

    for i in (Nord, Ost, Sud, West)
        while isborder(r, clockwise_side(i))
            putmarker!(r)
            move!(r, i)
        end
        putmarker!(r)
        move!(r, clockwise_side(i))
    end 

    go_to_the_sud_west_corner_and_return_path!(r)
    go_by_path!(r, path)
end

function sneak!(r::Robot, side::HorizonSide) 
    while !isborder(r, side)
        (isborder(r, Ost)) ? break : move!(r,side)
    end

    if isborder(r, Ost)
        value = "border"
    else
        move!(r, Ost)
        value = inverse_side(side)
    end
    
    return value
end
