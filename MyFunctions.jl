#Библиотека с функциями для задач

#Возвращает инвертированное направление
function inverse_side(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+2, 4))
end


#Возвращает следующее по часовой стрелке направление
function clockwise_side(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-1,4))
end


#Возвращает следующее против часовой стрелки направление
function counterclockwise_side(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+1,4))
end


#Возвращает общее количество шагов в массиве.
function get_length_path(path::Array{Tuple{HorizonSide,Int64},1})::Int
    length_path = 0
    for i in path
        length_path += i[2]
    end
    return length_path
end


#Перемещает робота в переданном направлении.
function go!(r::Robot, side::HorizonSide; steps::Int = 1, go_around_barriers::Bool = false, markers::Bool = false)::Int
    counter_steps = 0
    if markers
        putmarker!(r)
    end
    if go_around_barriers
        path = move_around_and_return_the_path!(r, side; steps, markers)
        counter_steps = get_length_path_in_direction!(path, side)
    else
        for i ∈ 1:steps

            if (markers)
                putmarker!(r)
            end

            if !isborder(r, side)
                move!(r, side)
                counter_steps += 1
            else
                for i ∈ 1:counter_steps
                    move!(r, inverse_side(side))
                end
                counter_steps = 0
                break
            end
        end
        if (markers)
            putmarker!(r)
        end
    end

    return counter_steps
end


#Вспомогательная функция. Возвращает путь после перемещения робота
function move_around_and_return_the_path!(r::Robot, side::HorizonSide; steps::Int = 1, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    path = [(Nord, 0)] 
    steps_need_to_do = steps
    
    while steps_need_to_do > 0

        if markers
            putmarker!(r)
        end

        path_now = go_around_barrier_and_get_path!(r, side)

        for i in path_now
            push!(path, i)
        end

        steps_need_to_do -= get_length_path_in_direction!(path_now, side)

        if !isborder(r, side) && steps_need_to_do > 0
            push!(path, ( inverse_side(side), 1))
            move!(r, side)
            steps_need_to_do -= 1

            if markers
                putmarker!(r)
            end

        elseif get_length_path_in_direction!(path_now, side) == 0
            steps_need_to_do = -1
            break
        end
        if markers && steps_need_to_do >= 0
            putmarker!(r)
        end
    end
    if steps_need_to_do < 0 
        go_by_path!(r, path)
        path = [(North, 0)]
    end
    return path
end


#Перемещает робота до границы и обратно, возвращая расстояние до границы.
function go_to_the_border_return_and_get_distance!(r::Robot, side::HorizonSide; go_around_barriers::Bool = false, markers = false)::Int
    counter_steps = 0
    if go_around_barriers
        if markers
            putmarker!(r)
        end

        if !isborder(r, side)
            move!(r, side)
            steps = 1
        else
            steps = get_length_path_in_direction!(go_around_barrier_and_get_path!(r, side), side)
        end

        counter_steps += steps
        if markers
            putmarker!(r)
        end

        while steps > 0
            if !isborder(r, side)
                move!(r, side)
                steps = 1
            else
                steps = get_length_path_in_direction!(go_around_barrier_and_get_path!(r, side), side)
            end
            counter_steps += steps
        end

        if markers
            putmarker!(r)
        end

        go!(r, inverse_side(side); steps = counter_steps, go_around_barriers = true)

    else
        while go!(r, side; markers) > 0
            counter_steps += 1
        end

        go!(r, inverse_side(side); steps = counter_steps)

    end
    
    return counter_steps
end


#Перемещает робота до границы и возвращает путь для обраного следования в виде массива пар типа (направление, количество шагов)
function go_to_the_border_and_return_path!(r::Robot, side::HorizonSide; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    path_return = [(Nord, 0)]

    if go_around_barriers
        steps = 0

        if markers
            putmarker!(r)
        end

        if !isborder(r, side)
            move!(r, side)
            steps = 1
            push!(path_return, (inverse_side(side), 1) )
        else
            path = go_around_barrier_and_get_path!(r, side)
            steps = get_length_path_in_direction!(path, side)
            for i in path
                push!(path_return, i)
            end
        end

        if markers
            putmarker!(r)
        end

        while steps > 0
            if !isborder(r, side)
                move!(r, side)
                steps = 1
                push!(path_return, (inverse_side(side), 1))
                if markers
                    putmarker!(r)
                end
            else
                path = go_around_barrier_and_get_path!(r, side)
                steps = get_length_path_in_direction!(path, side)
                for i in path
                    push!(path_return, i)
                end

                if markers
                    putmarker!(r)
                end
            end
        end

    else
        steps = 0
        steps_now = go!(r, side; markers)

        while steps_now > 0
            steps += steps_now
            steps_now = go!(r,side; markers)
        end

        push!(path_return, (inverse_side(side), steps) )
    end

    return path_return
end


#Перемещает робота в юго-западный угол и возвращает путь для возращения в исходную позицию(направление, количество шагов)
function go_to_the_sud_west_corner_and_return_path!(r::Robot; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    path_return = []
    path_to_west = go_to_the_border_and_return_path!(r, West; go_around_barriers, markers)
    path_to_sud = go_to_the_border_and_return_path!(r, Sud; go_around_barriers, markers)

    for i in path_to_west
        push!(path_return, i)
    end

    for i in path_to_sud
        push!(path_return, i)
    end

    return path_return
end


#перемещает робота в заданнны угол 
function go_to_transmitted_corner_and_return_path!(r::Robot, side_1::HorizonSide, side_2::HorizonSide; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    path_return = []
    path_side_1 = go_to_the_border_and_return_path!(r, side_1; go_around_barriers, markers)
    path_side_2 = go_to_the_border_and_return_path!(r, side_2; go_around_barriers, markers)

    for i in path_side_1
        push!(path_return, i)
    end 

    for i in path_side_2
        push!(path_return, i)
    end

    return path_return
end


#Перемещает робота по пути. Путь должен быть в формате массива пар (направление, количество шагов).
function go_by_path!(r::Robot, path::Array{Tuple{HorizonSide,Int64},1})
    reversed_path = reverse(path)

    for i in reversed_path
        go!(r, i[1]; steps = i[2])
    end
end


#Обходит барьер, если таковой имеется перед роботом. Возвращает путь для возвращения в формате массива пар (направление, количество шагов).
function go_around_barrier_and_get_path!(r::Robot, direct_side::HorizonSide)::Array{Tuple{HorizonSide,Int64},1}
    path_return = []
    orthogonal_side = clockwise_side(direct_side)
    reverse_side = inverse_side(orthogonal_side)
    num_of_orthohonal_steps = 0
    num_of_direct_steps = 0

    if !isborder(r, direct_side)
        path_return = [(Nord, 0)]
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_of_orthohonal_steps += 1
            else
                break
            end
        end        

        if isborder(r,direct_side) == false
            move!(r,direct_side)
            num_of_direct_steps += 1
            while isborder(r,reverse_side) == true
                num_of_direct_steps += 1
                move!(r,direct_side)
            end

            push!(path_return, (inverse_side(orthogonal_side), num_of_orthohonal_steps))
            push!(path_return, (inverse_side(direct_side), num_of_direct_steps))
            push!(path_return, (inverse_side(reverse_side), num_of_orthohonal_steps))
        else
            path_return = [(North, 0)]
        end

        while num_of_orthohonal_steps > 0
            num_of_orthohonal_steps=num_of_orthohonal_steps-1
            move!(r,reverse_side)
        end
    end
    return path_return
end


#Возвращает количество шагов в массиве в данном направлении, или в противоположном ему. Массив должен быть в формате пар (направление, количество шагов).
function get_length_path_in_direction!(path::Array{Tuple{HorizonSide,Int64},1}, direction::HorizonSide)::Int
    counter_steps = 0

    for i in path
        (i[1] == direction || i[1] == inverse_side(direction)) ? counter_steps += i[2] : Nothing
    end
    return counter_steps
end


#Робот двигается в направлении, если это возможно. Если препятствия нет, робот пройдёт 1 клетку. Иначе, обойдёт препятствие
function move_if_it_possible!(r::Robot, direct_side::HorizonSide)::Bool
    orthogonal_side = counterclockwise_side(direct_side)
    reverse_side = inverse_side(orthogonal_side)
    counter_steps=0

    if isborder(r,direct_side)==false
        move!(r,direct_side)
        result=true
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                counter_steps += 1
            else
                break
            end
        end

        if isborder(r,direct_side) == false
            move!(r,direct_side)
            while isborder(r,reverse_side) == true
                move!(r,direct_side)
            end
            result = true
        else
            result = false
        end
        
        while counter_steps>0
            counter_steps=counter_steps-1
            move!(r,reverse_side)
        end
    end
    return result
end