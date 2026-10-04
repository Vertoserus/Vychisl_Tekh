.data

n:      .word 4          # значение n по условию
total:  .word 0          # сколько всего нужно считать: 16 + n
count:  .word 0          # сколько реально считано и сохранено

.align 2
array:  .space 80        # массив на 20 слов: 20 * 4 = 80 байт

.text
.globl main

main:
    # Вычисляем общее количество элементов: total = 16 + n
    la   t0, n
    lw   t1, 0(t0)       # t1 = n
    addi t1, t1, 16      # t1 = 16 + n

    la   t0, total
    sw   t1, 0(t0)       # сохраняем 16 + n в переменную total

read_loop:
    # Проверка: если count >= total, то чтение завершено
    la   t0, count
    lw   t2, 0(t0)       # t2 = count

    la   t0, total
    lw   t3, 0(t0)       # t3 = total

    bge  t2, t3, finish  # если count >= total, выходим

    # Чтение очередного целого числа из стандартного ввода
    # Результат возвращается в a0
    li   a7, 5
    ecall

    # Если введённое значение равно 0, завершаем чтение.
    # Нуль в массив не сохраняем.
    beq  a0, x0, finish

    # Сохраняем введённое значение в массив: array[count]--
    la   t0, count
    lw   t2, 0(t0)       # t2 = count

    la   t3, array       # t3 = адрес начала массива
    slli t4, t2, 2       # t4 = count * 4, так как одно слово = 4 байта
    add  t3, t3, t4      # t3 = адрес array[count]

    sw   a0, 0(t3)       # сохраняем введённое число

    # Увеличиваем счётчик реально сохранённых элементов
    addi t2, t2, 1

    la   t0, count
    sw   t2, 0(t0)       # count = count + 1

    j    read_loop

finish:
    # Завершение программы
    li   a7, 10
    ecall