.data

y:       .word 121       # константа y
h:       .word 4         # шаг изменения
current: .word 0         # текущее значение
limit:   .word 0         # верхняя граница диапазона

.text
.globl main

main:
    # Считываем целое число x
    li   a7, 5
    ecall

    # t0 = введённое значение x
    mv   t0, a0

    # Загружаем y из памяти
    la   t5, y
    lw   t1, 0(t5)

    # Если x < y, переходим к ветке, где текущее значение равно x
    blt  t0, t1, x_less

    # Иначе current = y, limit = x
    la   t5, current
    sw   t1, 0(t5)

    la   t5, limit
    sw   t0, 0(t5)

    j    loop

x_less:
    # current = x, limit = y
    la   t5, current
    sw   t0, 0(t5)

    la   t5, limit
    sw   t1, 0(t5)

loop:
    # Загружаем текущее значение
    la   t5, current
    lw   t0, 0(t5)

    # Загружаем верхнюю границу
    la   t5, limit
    lw   t1, 0(t5)

    # Если current > limit, выходим из цикла
    # То есть если limit < current
    blt  t1, t0, done

    # Выводим текущее значение
    mv   a0, t0
    li   a7, 1
    ecall

    # Выводим пробел между числами
    li   a7, 11
    li   a0, 32          # ASCII-код пробела
    ecall

    # Загружаем текущее значение и шаг
    la   t5, current
    lw   t0, 0(t5)

    la   t5, h
    lw   t2, 0(t5)

    # current = current + h
    add  t0, t0, t2

    # Сохраняем обновлённое текущее значение
    la   t5, current
    sw   t0, 0(t5)

    j    loop

done:
    # Выводим перевод строки
    li   a7, 11
    li   a0, 10          # ASCII-код '\n'
    ecall

    # Завершаем программу
    li   a7, 10
    ecall