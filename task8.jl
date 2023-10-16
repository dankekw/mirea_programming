include("MyFunctions.jl")

function task8(r::Robot)
    side = Ost

    while isborder(r,Nord)==true
        putmarker!(r)
        while ismarker(r)==true
            move!(r,side)
        end
        side=inverse_side(side)
        
    end
end
