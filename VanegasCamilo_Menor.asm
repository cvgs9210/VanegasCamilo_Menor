.data
    prompt:     .asciiz "Ingrese un n�mero: "
    result:     .asciiz "El n�mero menor es: "
    numbers:    .word 0, 0, 0, 0, 0   # Almacena los 5 n�meros

.text
    .globl main

main:
    # Inicializaci�n de registros
    li $t0, 0          # $t0: Contador de bucle (i = 0)
    la $t1, numbers     # $t1: Direcci�n base del array de n�meros

input_loop:
    # Pedir al usuario que ingrese un n�mero
    li $v0, 4           # C�digo del servicio 4: imprimir cadena
    la $a0, prompt      # Direcci�n de la cadena "Ingrese un n�mero: "
    syscall

    # Leer el n�mero ingresado por el usuario
    li $v0, 5           # C�digo del servicio 5: leer entero
    syscall
    sw $v0, 0($t1)      # Almacenar el n�mero en el array numbers

    # Actualizar el puntero del array
    addi $t1, $t1, 4    # Moverse al siguiente espacio en el array

    # Incrementar el contador y verificar si ya hemos le�do 5 n�meros
    addi $t0, $t0, 1
    li $t2, 5           # Comparar con 5 (n�mero total de entradas)
    bne $t0, $t2, input_loop   # Repetir si no se han ingresado 5 n�meros

    # Encontrar el n�mero mayor
    la $t1, numbers     # Reiniciar el puntero del array numbers
    lw $t3, 0($t1)      # Cargar el primer n�mero en $t3 (mayor inicial)
    addi $t1, $t1, 4    # Moverse al siguiente n�mero

find_min:
    lw $t4, 0($t1)      # Cargar el siguiente n�mero en $t4
    beq $t4, $zero, print_result   # Si ya le�mos todos los n�meros, salir del bucle
    bgt $t4, $t3, next_number      # Si $t4 es menor que $t3, omitir actualizaci�n
    move $t3, $t4      # Si $t4 es mayor, actualizar el valor de $t3 (nuevo mayor)

next_number:
    addi $t1, $t1, 4    # Moverse al siguiente n�mero en el array
    bne $t1, $zero, find_min   # Repetir hasta que se lean todos los n�meros

print_result:
    # Imprimir el mensaje "El n�mero mayor es: "
    li $v0, 4
    la $a0, result
    syscall

    # Imprimir el n�mero mayor (valor almacenado en $t3)
    li $v0, 1
    move $a0, $t3
    syscall

    # Salir del programa
    li $v0, 10           # C�digo del servicio 10: salir del programa
    syscall