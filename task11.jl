include("MyFunctions.jl")

function task11(r::Robot)
    for i in (Nord, Ost, Sud, West)
        path = go_to_the_border_and_return_path!(r, i; go_around_barriers = true)
        putmarker!(r)
        go_by_path!(r, path)
    end
end