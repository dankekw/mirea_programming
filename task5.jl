include("MyFunctions.jl")

function task5(r::Robot)

    path = go_to_the_sud_west_corner_and_return_path!(r; go_around_barriers = true)

    
    for side in (Nord, Ost, Sud, West)
        go_to_the_border_and_return_path!(r, side; go_around_barriers = true)
        putmarker!(r)
    end

    go_by_path!(r, path)
end

