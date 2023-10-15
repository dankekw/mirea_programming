include("MyFunctions.jl")

function task2(r::Robot)
    path = go_to_the_sud_west_corner_and_return_path!(r)

    for i ∈ (Nord, Ost, Sud, West)
        go_to_the_border_and_return_path!(r, i; markers=true)
    end
    go_by_path!(r, path)
end
