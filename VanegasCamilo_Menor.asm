.data
    prompt:     .asciiz "Ingrese un número: "
    result:     .asciiz "El número menor es: "
    numbers:    .word 0, 0, 0, 0, 0   # Almacena los 5 números

.text
    .globl main

main:
    # Inicialización de registros
    li $t0, 0          # $t0: Contador de bucle (i = 0)
    la $t1, numbers     # $t1: Dirección base del array de números

input_loop:
    # Pedir al usuario que ingrese un número
    li $v0, 4           # Código del servicio 4: imprimir cadena
    la $a0, prompt      # Dirección de la cadena "Ingrese un número: "
    syscall

    # Leer el número ingresado por el usuario
    li $v0, 5           # Código del servicio 5: leer entero
    syscall
    sw $v0, 0($t1)      # Almacenar el número en el array numbers

    # Actualizar el puntero del array
    addi $t1, $t1, 4    # Moverse al siguiente espacio en el array

    # Incrementar el contador y verificar si ya hemos leído 5 números
    addi $t0, $t0, 1
    li $t2, 5           # Comparar con 5 (número total de entradas)
    bne $t0, $t2, input_loop   # Repetir si no se han ingresado 5 números

    # Encontrar el número mayor
    la $t1, numbers     # Reiniciar el puntero del array numbers
    lw $t3, 0($t1)      # Cargar el primer número en $t3 (mayor inicial)
    addi $t1, $t1, 4    # Moverse al siguiente número

find_min:
    lw $t4, 0($t1)      # Cargar el siguiente número en $t4
    beq $t4, $zero, print_result   # Si ya leímos todos los números, salir del bucle
    bgt $t4, $t3, next_number      # Si $t4 es menor que $t3, omitir actualización
    move $t3, $t4      # Si $t4 es mayor, actualizar el valor de $t3 (nuevo mayor)

next_number:
    addi $t1, $t1, 4    # Moverse al siguiente número en el array
    bne $t1, $zero, find_min   # Repetir hasta que se lean todos los números

print_result:
    # Imprimir el mensaje "El número mayor es: "
    li $v0, 4
    la $a0, result
    syscall

    # Imprimir el número mayor (valor almacenado en $t3)
    li $v0, 1
    move $a0, $t3
    syscall

    # Salir del programa
    li $v0, 10           # Código del servicio 10: salir del programa
    syscall