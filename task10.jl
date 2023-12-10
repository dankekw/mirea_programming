#=
ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров 
РЕЗУЛЬТАТ: Функция вернула значение средней температуры всех замаркированных клеток 
=#

include("RobotFunc.jl")

function get_average_temperature(r)
    count_marks = 0
    all_temperature = 0
    direction = Ost

    while ((isborder(r, Ost) == false) || (isborder(r, Nord) == false))
        if ismarker(r)
            count_marks += 1
            all_temperature += temperature(r)
        end
        if isborder(r, direction)
            direction = inverse(direction)
            move!(r, Nord)
        else
            move!(r, direction)
        end
    end

    println(all_temperature / count_marks)
end
