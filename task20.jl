#=
Посчитать число всех горизонтальных прямолинейных перегородок (вертикальных - нет)
=#

include("RobotFunc.jl")

function horizion_borders(r::Robot)

    through_rectangles_into_angle(r, (Sud, West))

    num_steps = get_num_movements!(r, Ost) # определяем размер поля
    num_borders = 0

    while isborder(r, Nord) == false || isborder(r, Ost) == false 
        for side in (West, Ost)
            if isborder(r, Nord) == true && isborder(r, Ost) == true 
                break
            end
                num_borders += search_border(r, side, num_steps)
            if isborder(r, Nord) == false
                move!(r, Nord)
            end
        end
    end
    print(num_borders)
end

function search_border(r::Robot, side::HorizonSide, numsteps::Int)
    num_borders = 0
    num_steps = 0
    state = false

    for _ in 1:numsteps
        if isborder(r, side) == false
            move!(r, side)
            if isborder(r, Nord) == true && state == false
                num_borders += 1
                state = true
            else
                state = false
            end
        else 
            while isborder(r, side) == true
                move!(r, Sud)
                num_steps += 1
            end
            move!(r, side)
            for _ in 1:num_steps
                move!(r, Nord)
            end
            num_steps = 0
        end
    end

    return (num_borders)
end