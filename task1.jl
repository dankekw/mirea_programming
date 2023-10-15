include("MyFunctions.jl")

function task1(r::Robot)::Nothing
    for i ∈ (Nord, Sud, West, Ost)
        go_to_the_border_return_and_get_distance!(r, i; markers=true)
    end
    putmarker!(r)
end
