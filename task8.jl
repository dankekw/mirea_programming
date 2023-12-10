#=
ДАНО: Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, в которой имеется проход шириной в одну клетку. 
РЕЗУЛЬТАТ: Робот - в клетке под проходом 
=#

include("RobotFunc.jl")

function find_entrance(r)
    n = 0
    side = Ost
    while isborder(r, Nord)
        n += 1
        moves!(r, side, n)
        side = inverse(side)
    end
end