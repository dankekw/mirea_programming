include("MyFunctions.jl")

function task4(r::Robot)
    path = go_to_the_sud_west_corner_and_return_path!(r; go_around_barriers=false)

    distance = go_to_the_border_return_and_get_distance!(r, Ost; go_around_barriers=false)
    marks_to_do = distance

    while !isborder(r,Nord) && marks_to_do > 0
        go!(r, Ost; steps = marks_to_do, go_around_barriers = false, markers = true)
        go!(r, West; steps = marks_to_do, go_around_barriers = false, markers = false)
        move!(r,Nord)
        marks_to_do -= 1
    end

    go!(r, Ost; steps = marks_to_do, go_around_barriers = false, markers = true)
    go!(r, West; steps = marks_to_do, go_around_barriers = false, markers = false)

    go_to_the_sud_west_corner_and_return_path!(r; go_around_barriers=false)
    go_by_path!(r, path)
end

