.Model small
.Data
;Mensajes a mostrar en pantalla
Linea DB 13,10,'=============================================$'
msj DB 13,10, 'Presionar una tecla para continuar. $'
P1 DB 13,10, '1. Fecha actual del sistema. $' 
P2 DB 13,10, '2. Ingresar formato UTC. $'
P3 DB 13,10, '3. Horarios de muestra. $'
P4 DB 13,10, '4. Cambio de hora local. $'
P5 DB 13,10, '5. Vista analoga del reloj. $'
India DB 13,10,'India: $'
Alemania DB 13,10,'Alemania: $'
EEUU DB 13,10,'EEUU: $'
Argentina DB 13,10,'Argentina: $'
Japon DB 13,10,'Japon: $'
;Variables a manipular
Fecha DB 13,10,'          00/00/00 $'
Hora DB '  00:00:00 $'
UTC DB 13,10, 'UTC$'
.Code
;Iniciar Programa
programa:
    MOV AX, @Data   ;Se obtiene la direccion de inicio del de datos.
    MOV DS, AX      ;Signamos al registro data segment la direccion de inicio
    Menu:           ;Menu principal
    LEA DX,Linea
    CALL Imprimir
    LEA DX,P1
    CALL Imprimir
    LEA DX,P2
    CALL Imprimir
    LEA DX,P3
    CALL Imprimir
    LEA DX,P4
    CALL Imprimir
    LEA DX,P5
    CALL Imprimir
    LEA DX,Linea
    CALL Imprimir
    CALL Leer       ;Leer respuesta y saltar a la etiqueta correspondiente
    SUB AL,30H
    CMP AL,2
    JL Uno
    JLE Dos
    CMP AL,4
    JL Tres
    JLE Cuatro
    CMP AL,6
    JL Cinco
    JMP Finalizar
    Uno:
    LEA DX,P1
    CALL Imprimir
    CALL ObtFecha       ;Obtiene fecha de la computadora.
    CALL ImprimirF      ;Imprime en pantalla la variable Fecha
    CALL ObtHora        ;Obtener la hora de la computadora
    CALL ImprimirH      ;Imprime en pantalla la variable Hora
    CALL Limpiar
    JMP Menu
    Dos:
    LEA DX,P2
    CALL Imprimir
    LEA DX,UTC
    CALL Imprimir
    CALL Leer
    MOV BL,AL           ;Guardar el simbolo en BL
    CALL Leer
    MOV AH,AL           ;Guardar primer digito en AH
    CALL Leer           ;Guardar segundo digito en AL
    CALL ObtFecha       ;Obtiene fecha de la computadora.
    CALL ImprimirF      ;Imprime en pantalla la variable Fecha
    CALL ObtHora        ;Obtener la hora de la computadora
    CALL ImprimirH      ;Imprime en pantalla la variable Hora
    CALL Limpiar
    JMP Menu
    Tres:
    LEA DX,P3
    CALL Imprimir
    CALL Limpiar
    JMP Menu
    Cuatro:
    LEA DX,P4
    CALL Imprimir
    CALL Limpiar
    JMP Menu
    Cinco:
    LEA DX,P5
    CALL Imprimir
    CALL Limpiar
    JMP Menu
    ;finalizar el programa
    Finalizar:
    MOV AH, 4Ch
    INT 21h
; -------- PROCEDIMIENTOS -------------------------------------------
    Leer proc near
    XOR AL,AL
    mov AH, 01h     ;Leer caracter desde el teclado y lo pone en AL
    int 21h   
    ret
    Leer endp
    Imprimir proc near
    MOV AH, 09h     ;Imprime en pantalla lo que hay en DX
    INT 21h
    ret
    Imprimir endp
    ImprimirNum proc near
    ADD DL,30h
    MOV AH, 02h         ;Imprime en pantalla lo que hay en DL
    INT 21h
    ret
    ImprimirNum endp
    ObtHora proc near
    MOV AH,2CH          ;Obtener la hora CH=Hora; CL=Min; DH=Seg
    INT 21H
    ret
    ObtHora endp
    ImprimirH proc near
    MOV AL,CH           ;Obtener hora de dos digitos
    MOV AH,0
    AAM
    ADD AL,30H
    ADD AH,30H
    MOV Hora[2],AH
    MOV Hora[3],AL      ;Escribir hora de dos digitos
    MOV AL,CL           ;Obtener min de dos digitos
    MOV AH,0
    AAM
    ADD AL,30H
    ADD AH,30H
    MOV Hora[5],AH
    MOV Hora[6],AL      ;Escribir min de dos digitos
    MOV AL,CH           ;Obtener seg de dos digitos
    MOV AH,0
    AAM
    ADD AL,30H
    ADD AH,30H
    MOV Hora[8],AH
    MOV Hora[9],AL      ;Escribir seg de dos digitos
    LEA DX,Hora
    CALL Imprimir
    ret
    ImprimirH endp
    ObtFecha proc near
    MOV AH,2AH          ;Obtener la fecha AL=diaS; CX=ano; DH=mes; DL=DiaM
    INT 21H
    ret
    ObtFecha endp
    ImprimirF proc near
    CALL diaSem         ;Escribe el d?a de la semana seg?n el valor en AL
    MOV AL,DL           ;Obtener el dia de dos digitos.
    MOV AH,0
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Fecha[12],AH
    MOV Fecha[13],AL    ;Escribir el d?a de dos digitos
    MOV AL,DH           ;Obtener el mes de dos digitos.
    MOV AH,0
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Fecha[15],AH
    MOV Fecha[16],AL    ;Escribir el mes de dos digitos
    MOV AX,CX           ;Obtener el a?o de cuatro digitos
    ADD AX,0F830H
    AAM
    ADD AL,30H
    ADD AH,30H
    MOV Fecha[18],AH
    MOV Fecha[19],AL    ;Escribir a?o de dos digitos
    LEA DX, Fecha
    CALL Imprimir
    ret
    ImprimirF endp
    Limpiar proc near ;Muestra un mensaje y limpia la pantalla
    LEA DX,msj
    CALL Imprimir
    CALL Leer
    MOV AH, 00h
    MOV AL, 03h
    INT 10h
    ret
    Limpiar endp
    DiaSem proc near ;Escribe el d?a de la semana seg?n AL
    CMP AL,1
    JL Domingo
    JLE Lunes
    CMP AL,3
    JL Martes1
    JLE Miercoles1
    CMP AL,5
    JL Jueves1
    JLE Viernes1
    MOV Fecha[2], 'S'   ;Si no es ninguno de los otros d?as
    MOV Fecha[3], 'a'
    MOV Fecha[4], 'b'
    MOV Fecha[5], 'a'
    MOV Fecha[6], 'd'
    MOV Fecha[7], 'o'
    JMP Terminar
    Domingo:            ;Domingo
    MOV Fecha[2], 'D'
    MOV Fecha[3], 'o'
    MOV Fecha[4], 'm'
    MOV Fecha[5], 'i'
    MOV Fecha[6], 'n'
    MOV Fecha[7], 'g'
    MOV Fecha[8], 'o'
    MOV Fecha[9], ' '
    MOV Fecha[10], ' '
    JMP Terminar        
    Viernes1:           ;Salto intermedio
    JMP Viernes
    Jueves1:            ;Salto intermedio
    JMP Jueves
    Miercoles1:         ;Salto intermedio
    JMP Miercoles
    Martes1:            ;Salto intermedio
    JMP Martes
    Lunes:              ;Lunes
    MOV Fecha[2], 'L'
    MOV Fecha[3], 'u'
    MOV Fecha[4], 'n'
    MOV Fecha[5], 'e'
    MOV Fecha[6], 's'
    MOV Fecha[7], ' '
    MOV Fecha[8], ' '
    MOV Fecha[9], ' '
    MOV Fecha[10], ' '
    JMP Terminar
    Viernes:            ;Viernes
    MOV Fecha[2], 'V'
    MOV Fecha[3], 'i'
    MOV Fecha[4], 'e'
    MOV Fecha[5], 'r'
    MOV Fecha[6], 'n'
    MOV Fecha[7], 'e'
    MOV Fecha[8], 's'
    MOV Fecha[9], ' '
    MOV Fecha[10], ' '
    JMP Terminar
    Jueves:             ;Jueves
    MOV Fecha[2], 'J'
    MOV Fecha[3], 'u'
    MOV Fecha[4], 'e'
    MOV Fecha[5], 'v'
    MOV Fecha[6], 'e'
    MOV Fecha[7], 's'
    MOV Fecha[8], ' '
    MOV Fecha[9], ' '
    MOV Fecha[10], ' '
    JMP Terminar
    Miercoles:          ;Miercoles
    MOV Fecha[2], 'M'
    MOV Fecha[3], 'i'
    MOV Fecha[4], 'e'
    MOV Fecha[5], 'r'
    MOV Fecha[6], 'c'
    MOV Fecha[7], 'o'
    MOV Fecha[8], 'l'
    MOV Fecha[9], 'e'
    MOV Fecha[10], 's'
    JMP Terminar
    Martes:             ;Martes
    MOV Fecha[2], 'M'
    MOV Fecha[3], 'a'
    MOV Fecha[4], 'r'
    MOV Fecha[5], 't'
    MOV Fecha[6], 'e'
    MOV Fecha[7], 's'
    MOV Fecha[8], ' '
    MOV Fecha[9], ' '
    MOV Fecha[10], ' '
    Terminar:
    ret
    DiaSem endp
        .Stack
END programa