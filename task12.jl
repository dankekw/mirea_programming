#=
На прямоугольном поле произвольных размеров расставить маркеры в виде "шахматных" клеток, начиная с юго-западного угла поля, когда каждая отдельная "шахматная" клетка имеет размер
 n x n клеток поля (n - это параметр функции). Начальное положение Робота - произвольное, конечное - совпадает с начальным. Клетки на севере и востоке могут получаться "обрезанными"
 - зависит от соотношения размеров поля и "шахматных" клеток. 
(Подсказка: здесь могут быть полезными две глобальных переменных, в которых будут содержаться текущие декартовы координаты
 Робота относительно начала координат в левом нижнем углу поля, например) 
=#
include("RobotFunc.jl")


CELL_SIZE = 0
ROBOT_CURRENT_POS = [0, 0]

function mark_chess(r::Robot, n::Int=0)
    global CELL_SIZE

    if n != 0
        CELL_SIZE = n
    end

    side = Ost
    mark_row(r, side)
    while isborder(r, Nord) == false
        move_decart!(r, Nord)
        side = inverse(side)
        mark_row(r, side)
    end

end

function mark_row(r::Robot, side::HorizonSide)
    putmarker_chess!(r)
    while isborder(r, side) == false
        move_decart!(r, side)
        putmarker_chess!(r)
    end
end

function putmarker_chess!(r::Robot)
    global ROBOT_CURRENT_POS
    if (mod(ROBOT_CURRENT_POS[1], 2 * CELL_SIZE)) < CELL_SIZE && (mod(ROBOT_CURRENT_POS[2], 2 * CELL_SIZE)) < CELL_SIZE || (mod(ROBOT_CURRENT_POS[1] + CELL_SIZE, 2 * CELL_SIZE)) < CELL_SIZE && (mod(ROBOT_CURRENT_POS[2], 2 * CELL_SIZE)) >= CELL_SIZE
        putmarker!(r)
    end
end

function move_decart!(r::Robot, side::HorizonSide)
    global ROBOT_CURRENT_POS
    if side == Nord
        ROBOT_CURRENT_POS[2] += 1
    elseif side == Sud
        ROBOT_CURRENT_POS[2] -= 1
    elseif side == Ost
        ROBOT_CURRENT_POS[1] += 1
    else
        ROBOT_CURRENT_POS[1] -= 1
    end
    move!(r, side)
end