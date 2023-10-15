include("MyFunctions.jl")

function task3(r::Robot)
    path = go_to_the_sud_west_corner_and_return_path!(r)

    side = Ost
    while !isborder(r, Nord)
        go_to_the_border_and_return_path!(r, side; markers=true)
        side = inverse_side(side)
        go!(r, Nord)
    end

    go_to_the_border_and_return_path!(r, side; markers=true)

    go_to_the_sud_west_corner_and_return_path!(r)
    go_by_path!(r, path)
end