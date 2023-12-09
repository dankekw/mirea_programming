include("MyFunctions.jl")

function task12(r::Robot, cell_size::Int)
    path = go_to_the_sud_west_corner_and_return_path!(r)
    x=0; y=0
    direction = Ost
    
    while !(isborder(r, Nord) && isborder(r, Ost))
        marker_sp(r, x, y, cell_size)
        if move_cond(r)
            move!(r, Nord)
            y += 1
            marker_sp(r, x, y, cell_size)
            direction = inverse_side(direction)
        end
        
        move!(r,direction)
        (direction == Ost) ? x += 1 : x -= 1
    end

    marker_sp(r, x, y, cell_size)

    go_to_the_sud_west_corner_and_return_path!(r)
    go_by_path!(r, path)
end

function marker_sp(r, x, y, cell_size)
    if (mod(x, 2 * cell_size)) < cell_size && (mod(y, 2 * cell_size)) < cell_size || 
        (mod(x + cell_size, 2 * cell_size)) < cell_size && (mod(y, 2 * cell_size)) >= cell_size
        putmarker!(r)
    end
end

function move_cond(r)
    return isborder(r, Ost) || isborder(r, West) && !(isborder(r, Sud) && isborder(r, West))
end