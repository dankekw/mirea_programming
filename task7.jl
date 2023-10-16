include("MyFunctions.jl")

function task7(r::Robot)
    path = go_to_the_sud_west_corner_and_return_path!(r)

    is_marker_now = iseven(get_length_path(path)) 

    side = Ost
    while !(isborder(r, Nord) && isborder(r, side))
        if (is_marker_now)
            putmarker!(r)
        end
        
        if !(isborder(r, side))
            move!(r,side)
            is_marker_now = !is_marker_now  
        end

        if move_cond(r)
            if (is_marker_now)
                putmarker!(r)
            end
            move!(r, Nord)
            is_marker_now = !is_marker_now
            
            side = inverse_side(side)
        end  
    end

    if is_marker_now
        putmarker!(r)
    end

    go_to_the_sud_west_corner_and_return_path!(r)
    go_by_path!(r, path)

end

function move_cond(r::Robot)::Bool
    return (isborder(r, Ost) || isborder(r, West)) && !(isborder(r,Nord))
end