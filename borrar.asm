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
NHora DB 13,10, 'Ingresar nueva hora: $'
NMin DB 13,10, 'Ingresar minutos: $'
;Variables a manipular
Fecha DB 13,10,'          00/00/00 $'
Hora DB '  00:00:00 $'
UTC DB 13,10, 'UTC$'
Aux DB 0
Min DB 0
;Graficar el circulo
    XC    DW 320  ; Pos X del centro
    YC    DW 350  ; Pos Y del centro
    TEMPO DW ?    ; Temporal    
    COLOR DB 20   ; Color inicial
    LAST  DB "5"
    RAD   DW 120  ; Radio del c?rculo
    HOR   DW ?
    VER   DW ?
    VID   DB ?  ; Salvamos el modo de video :)
    NUM   DB 48D
    NUM2  DB 49D
    DIR   DB 0
    DIR2  DB 0
.Code
;Iniciar Programa
programa:
    MOV AX, @Data   ;Se obtiene la direccion de inicio del de datos.
    MOV DS, AX      ;Signamos al registro data segment la direccion de inicio
    Menu:           ;Menu principal
    CALL ObtFecha       ;Obtiene fecha de la computadora.
    CALL ObtHora        ;Obtener la hora de la computadora
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
    JLE Cuatro1
    CMP AL,6
    JL Cinco1
    JMP Finalizar
    Uno:
    LEA DX,P1
    CALL Imprimir
    CALL ObtFecha       ;Obtiene fecha de la computadora.
    CALL ObtHora        ;Obtener la hora de la computadora
    CALL ImprimirF      ;Imprime fecha y hora en pantalla
    CALL Limpiar
    JMP Menu
    Dos:
    LEA DX,P2
    CALL Imprimir
    CALL CorregirUTC
    LEA DX,UTC
    CALL Imprimir
    CALL Leer
    MOV DH,AL           ;Guardar el simbolo en DH
    CALL Leer
    MOV CH,AL           ;Guardar primer digito en CH
    SUB CH,30H
    CALL Leer
    MOV CL,AL           ;Guardar segundo digito en CL
    SUB CL,30H
    CALL Leer
    SUB AL,30H
    MOV BL,10D
    MUL BL
    MOV Min,AL
    CALL Leer
    SUB AL,30H
    ADD Min,AL
    CALL ModHora
    CALL ImprimirF      ;Imprime en pantalla la fecha y hora
    CALL Limpiar
    JMP Menu
    Cuatro1:            ;Salto intermedio
    JMP Cuatro
    Cinco1:             ;Salto intermedio
    JMP Cinco
    Tres:
    CALL CorregirUTC    ;Sumar 6 a la hora de la computadora
    MOV DH,43D          ;ASCII del simbolo: +
    MOV CH,0
    MOV CL,5
    MOV Min,30
    CALL ModHora        ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito
    CALL Reloj
    LEA DX,P3
    CALL Imprimir
    LEA DX,India        ;INDIA: UTC + 5:30
    CALL Imprimir
    LEA DX,Fecha
    CALL Imprimir
    LEA DX,Hora
    CALL Imprimir
    CALL Limpiar
    CALL ObtHora        ;Restablecer el horario UTC
    CALL ObtFecha
    CALL CorregirUTC
    MOV DH,43D          ;ASCII del simbolo: +
    MOV CH,0
    MOV CL,2
    MOV Min,0
    CALL ModHora        ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito
    CALL Reloj
    LEA DX,Alemania     ;Alemania: UTC +2
    CALL Imprimir
    LEA DX,Fecha
    CALL Imprimir
    LEA DX,Hora
    CALL Imprimir
    CALL Limpiar
    CALL ObtHora        ;Restablecer el horario UTC
    CALL ObtFecha
    CALL CorregirUTC
    MOV DH,45D          ;ASCII del simbolo: -
    MOV CH,0
    MOV CL,4
    CALL ModHora        ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito
    CALL Reloj
    LEA DX,EEUU         ;EEUU: UTC -4
    CALL Imprimir
    LEA DX,Fecha
    CALL Imprimir
    LEA DX,Hora
    CALL Imprimir
    CALL Limpiar
    CALL ObtHora        ;Restablecer el horario UTC
    CALL ObtFecha
    CALL CorregirUTC
    MOV DH,45D          ;ASCII del simbolo: -
    MOV CH,0
    MOV CL,3
    CALL ModHora        ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito
    CALL Reloj
    LEA DX,Argentina    ;Argentina: UTC -3
    CALL Imprimir
    LEA DX,Fecha
    CALL Imprimir
    LEA DX,Hora
    CALL Imprimir
    CALL Limpiar
    CALL ObtHora
    CALL ObtFecha
    CALL CorregirUTC
    MOV DH,43D          ;ASCII del simbolo: +
    MOV CH,0
    MOV CL,9
    CALL ModHora        ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito
    CALL Reloj
    LEA DX,Japon
    CALL Imprimir       ;Japon: UTC +9
    LEA DX,Fecha
    CALL Imprimir
    LEA DX,Hora
    CALL Imprimir
    CALL Limpiar
    JMP Menu
    Cuatro:
    LEA DX,P4
    CALL Imprimir
    LEA DX,NHora        ;Hora = (Decenas*10) + unidades
    CALL Imprimir
    CALL Leer
    MOV BL,10D
    MUL BL
    MOV CH,AL           ;Primer digito * 10
    CALL Leer
    ADD CH,AL          ; + Segundo digito
    LEA DX,NMin
    CALL Imprimir      ;Min = (Decenas *10) + unidades
    CALL Leer
    MOV BL,10D
    MUL BL
    MOV CL,AL       ;Primer digito * 10
    CALL Leer
    ADD CL,AL       ; + Segundo digito
    SUB CH,16D      ;Corrigo el formato de las horas
    SUB CL,16D      ;Corrigo el formato de los min
    MOV DH,00D      ;DH = SEG, DL =Centecima (Intentar cambiar Centecimas dara error)
    MOV AH,2DH
    int 21h
    CALL Limpiar
    JMP Menu
    Cinco:
    CALL Reloj
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
    ImprimirF proc near
    LEA DX,Fecha
    CALL Imprimir
    LEA DX,Hora
    CALL Imprimir
    ret
    ImprimirF endp
    ObtHora proc near
    MOV AH,2CH          ;Obtener la hora CH=Hora; CL=Min; DH=Seg
    INT 21H
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
    ret
    ObtHora endp
    ObtFecha proc near
    MOV AH,2AH          ;Obtener la fecha AL=diaS; CX=ano; DH=mes; DL=DiaM
    INT 21H
    CALL diaSem         ;Escribe el dia de la semana segun el valor en AL
    MOV AL,DL           ;Obtener el dia de dos digitos.
    MOV AH,0
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Fecha[12],AH
    MOV Fecha[13],AL    ;Escribir el dia de dos digitos
    MOV AL,DH           ;Obtener el mes de dos digitos.
    MOV AH,0
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Fecha[15],AH
    MOV Fecha[16],AL    ;Escribir el mes de dos digitos
    ADD CX,0F830H
    MOV AX,CX           ;Obtener el ano de dos digitos
    AAM
    ADD AL,30H
    ADD AH,30H
    MOV Fecha[18],AH
    MOV Fecha[19],AL    ;Escribir ano de dos digitos
    ret
    ObtFecha endp
    Limpiar proc near ;Muestra un mensaje y limpia la pantalla
    LEA DX,msj
    CALL Imprimir
    CALL Leer
    MOV AH, 00h
    MOV AL, 03h
    INT 10h
    ret
    Limpiar endp
    DiaSem proc near ;Escribe el d?a de la semana segun AL
    MOV Aux,AL          ;Guardo el dato por si ocurre un cambio de fecha
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
    MOV Fecha[8], ' '
    MOV Fecha[9], ' '
    MOV Fecha[10], ' '
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
    ModHora proc near   ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito, minutos en la variable Min
    ;Obtener los minutos
    MOV AL,Hora[5]
    SUB AL,30H
    MOV BL,10D
    MUL BL
    ADD AL,Hora[6]
    SUB AL,30H      ;Obtengo los minutos del reloj actual en AL
    CMP DH,43D      ;Reviso si es una resta
    JNE RestaMin     ;Salto a la logica de la resta o sigo en la de suma
    ADD AL,Min
    CMP AL,59       ;Ver si se acumulan mas de 59 minutos
    JLE Proseguir   ;Si no es necesario, ignoro instrucci?nes de aumentar la hora
    INC CL
    SUB AL,59
    Proseguir:
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Hora[5],AH
    MOV Hora[6],AL
    JMP Nami
    RestaMin:       ;Se restan minutos
    CMP AL,Min      ;min actual < min a restar
    JGE Proseguir2  ;Si no es necesario ignoro instrucciones de retroceder una hora
    DEC Hora[3]
    SUB Min,AL
    MOV AL,59D
    SUB AL,Min
    JMP Proseguir
    Proseguir2:
    SUB AL,Min
    JMP Proseguir
    ;Obtener la hora actual en DL
    Nami:
    MOV AL,Hora[2]
    SUB AL,30H
    MOV BL,10D
    MUL BL
    ADD AL,Hora[3]
    SUB AL,30H
    MOV DL,AL
    ;Obtener la hora que ingreso el usuario en CH
    MOV AL,CH
    MUL BL
    ADD AL,CL
    MOV CH,AL
    ;Obtener Dia actual en CL
    MOV AL,Fecha[12]
    SUB AL,30H
    MUL BL
    ADD AL,Fecha[13]
    SUB AL,30H
    MOV CL,AL
    MOV AL,CH
    CMP DH,43D          ;43 es el ASCII del simbolo: +
    JE Suma
    ;Ver si hay que cambiar de fecha
    CMP DL,AL
    JL Menor            ;hora actual < hora usuario
    SUB DL,AL           ;Hora actual = hora actual - hora usuario
    MOV AL,DL
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Hora[2],AH
    MOV Hora[3],AL
    JMP Acabar
    Menor:
    SUB AL,DL           ;Hora usuario - hora actual
    MOV DL,24
    SUB DL,AL           ;24 - (hora usuario - hora actual)
    MOV AL,DL
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Hora[2],AH
    MOV Hora[3],AL
    ;Dia --
    MOV AL,CL
    DEC AL
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Fecha[12],AH
    MOV Fecha[13],AL
    ;Escribir el dia anterior
    MOV AL,AUX
    CMP AL,0
    JNE NoReseteo   ;Si no es necesario no colocarle 7 al dia de la semana
    MOV AL,7
    NoReseteo:  
    DEC AL
    CALL DiaSem
    JMP Acabar
    Suma:
    ;Horas faltantes para el cambio de fecha (BH)   
    MOV BH,23D
    SUB BH,DL 
    ;Escribir la hora en la variable
    CMP AL,BH   ;AL - BH > 0
    JG Mayor    ;AL > BH
    ADD AL,DL
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Hora[2],AH
    MOV Hora[3],AL
    JMP Acabar
    Mayor:
    SUB AL,BH
    DEC AL
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Hora[2],AH
    MOV Hora[3],AL
    ;D?a++
    MOV AL,CL
    INC AL
    AAM
    ADD AH,30H
    ADD AL,30H
    MOV Fecha[12],AH
    MOV Fecha[13],AL
    ;Escribir el siguiente dia
    INC Aux
    MOV AL,Aux
    CMP AL,7
    JNE NoReset         ;Si no es necesario no colocarle 0 al dia de la semana
    MOV AL,0
    NoReset:
    CALL DiaSem
    Acabar:
    ret
    ModHora endp
    CorregirUTC proc near
    MOV DH,43D          ;43 es el ASCII del simbolo: +
    MOV CH,0
    MOV CL,6
    MOV Min,0
    CALL ModHora        ;Modifica la hora DH =+/-, CH=1er digito, CL=2ndo digito 
    ret
    CorregirUTC endp
    
    PUNTEAR PROC NEAR
    ; Grafica un punto en CX,DX 
    MOV AH,0Ch      ; Petici?n para escribir un punto
    MOV AL,COLOR    ; Color del pixel
    MOV BH,00h      ; P?gina
    INT 10H         ; Llamada al BIOS
    RET
    PUNTEAR ENDP
    GRAFICAR PROC NEAR
; Graficamos todo el circulo !
    MOV HOR,0
    MOV AX,RAD
    MOV VER,AX
    
    BUSQUEDA:
    CALL BUSCAR
    
    MOV AX,VER
    SUB AX,HOR
    CMP AX,1
    JA BUSQUEDA
    RET
    GRAFICAR ENDP   
    BUSCAR PROC NEAR
; Se encarga de buscar la coord del pixel sgte.
    INC HOR ; Horizontalmente siempre aumenta 1
    
    MOV AX,HOR  
    MUL AX
    MOV BX,AX ; X^2 se almacena en BX
    MOV AX,VER
    MUL AX    ; AX almacena Y^2
    ADD BX,AX ; BX almacena X^2 + Y^2
    MOV AX,RAD
    MUL AX    ; AX almacena R^2
    SUB AX,BX ; AX almacena R^2 - (X^2+Y^2)
    
    MOV TEMPO,AX
    
    MOV AX,HOR  
    MUL AX
    MOV BX,AX ; BX almacena X^2
    MOV AX,VER
    DEC AX    ; una unidad menos para Y (?VAYA DIFERENCIA!)
    MUL AX    ; AX almacena Y^2
    ADD BX,AX ; BX almacena X^2 + Y^2
    MOV AX,RAD
    MUL AX    ; AX almacena R^2
    SUB AX,BX ; AX almacena R^2 - (X^2+Y^2)
    
    CMP TEMPO,AX
    JB NODEC
    DEC VER
    NODEC:
    CALL REPUNTEAR
    PUSH VER
    PUSH HOR
    POP VER
    POP HOR   ; Cambiamos valores
    CALL REPUNTEAR
    PUSH VER
    PUSH HOR
    POP VER
    POP HOR   ; Devolvemos originales 
    RET
    BUSCAR ENDP
    REPUNTEAR PROC NEAR
    ; I CUADRANTE
    MOV CX,XC
    ADD CX,HOR
    MOV DX,YC
    SUB DX,VER
    CALL PUNTEAR
    ; IV CUADRANTE
    MOV DX,YC
    ADD DX,VER
    CALL PUNTEAR
    ; III CUADRANTE
    MOV CX,XC
    SUB CX,HOR
    CALL PUNTEAR
    ; II CUADRANTE
    MOV DX,YC
    SUB DX,VER
    CALL PUNTEAR
    RET
    REPUNTEAR ENDP
    Cursor proc near
    MOV BH,0
    MOV AH,02H
    INT 10H
    RET
    Cursor endp
    
    Reloj proc near
    MOV AH,0Fh  ; Petici?n de obtenci?n de modo de v?deo
    INT 10h     ; Llamada al BIOS
    MOV VID,AL

    MOV AH,00h  ; Funci?n para establecer modo de video
    MOV AL,12h  ; Modo gr?fico resoluci?n 640x480
    INT 10h 
    
    MOV BX, RAD
    MOV NUM,0
    MOV NUM2,1
    ;DL = COLUMNA, DH = FILA
    ;Imprimir 1
    MOV DH,16d
    MOV DL,45d
    CALL Cursor
    MOV DIR,46D
    MOV DIR2,16D
    CALL MiColor
    ;Imprimir 2
    INC NUM2
    MOV DH,18d
    MOV DL,49d
    CALL Cursor
    MOV DIR,50D
    MOV DIR2,18D
    CALL MiColor
    ;Imprimir 3
    INC NUM2
    MOV DH,21d
    MOV DL,51d
    CALL Cursor
    MOV DIR,52D
    MOV DIR2,21D
    CALL MiColor
    ;Imprimir 4
    inc NUM2
    MOV DH,24d
    MOV DL,49d
    CALL Cursor
    MOV DIR,50D
    MOV DIR2,24D
    CALL MiColor
    ;Imprimir 5
    INC NUM2
    MOV DH,27d
    MOV DL,45d
    CALL Cursor
    MOV DIR,46D
    MOV DIR2,27D
    CALL MiColor
    ;Imprimir 6
    INC NUM2
    MOV DH,28d
    MOV DL,39d
    CALL Cursor
    MOV DIR,40D
    MOV DIR2,28D
    CALL MiColor
    ;Imprimir 7
    INC NUM2
    MOV DH,27d
    MOV DL,32d
    CALL Cursor
    MOV DIR,33D
    MOV DIR2,27D
    CALL MiColor
    ;Imprimir 8
    INC NUM2
    MOV DH,24d
    MOV DL,28d
    CALL Cursor
    MOV DIR,29d
    MOV DIR2,24d
    CALL MiColor
    ;Imprimir 9
    INC NUM2
    MOV DH,21d
    MOV DL,26d
    CALL Cursor
    MOV DIR,27d
    MOV DIR2,21d
    CALL MiColor
    ;Imprimir 10
    INC NUM
    MOV NUM2,0
    MOV DH,18d
    MOV DL,28d
    CALL Cursor
    MOV DIR,29D
    MOV DIR2,18D
    CALL MiColor
    ;Imprimir 11
    INC NUM2
    MOV DH,16d
    MOV DL,32d
    CALL Cursor
    MOV DIR,33D
    MOV DIR2,16D
    CALL MiColor
    ;Imprimir 12
    INC NUM2
    MOV DH,15d
    MOV DL, 39d
    CALL Cursor
    MOV DIR,40D
    MOV DIR2,15D
    CALL MiColor
    ;Dibujar el circulo
    MOV CX,XC
    MOV DX,YC
    CALL PUNTEAR
    CALL Graficar
    MOV DH,0
    MOV DL,0
    CALL Cursor
    ret
    Reloj endP
    MiColor proc near
    MOV AL,NUM
    MOV BL,10D
    MUL BL
    ADD AL,NUM2
    MOV CL,AL       ;VALOR HORA EN CL
    MOV AL, Hora[2]
    SUB AL,30H
    MUL BL
    ADD AL, Hora[3]
    sub AL,30h
    CMP AL,0
    JNE Kevin       ;Si no es cero no lo convierto
    MOV AL,12
    Kevin:
    CMP AL,12       ;si es mayor a doce restarle 12
    JLE Andrino
    SUB AL,12
    Andrino:
    CMP CL,AL
    JNE Blanco  ;Si no son iguales pintar de blanco
    mov AL,NUM
    ADD AL,30H
    MOV BL, 14h ;Pintar de amarillo si son iguales
    MOV CX, 1
    MOV AH,09H
    INT 10H
    MOV DL,DIR
    MOV DH,DIR2
    CALL Cursor
    mov AL,NUM2
    ADD AL,30H
    MOV BL, 14h ;Pintar de amarillo si son iguales
    MOV CX, 1
    MOV AH,09H
    INT 10H
    JMP Chang
    Blanco:
    mov AL,NUM
    ADD AL,30H
    MOV BL, 0fh ;Pintar de amarillo si son iguales
    MOV CX, 1
    MOV AH,09H
    INT 10H
    MOV DL,DIR
    MOV DH,DIR2
    CALL Cursor
    mov AL,NUM2
    ADD AL,30H
    MOV BL, 0fh ;Pintar de amarillo si son iguales
    MOV CX, 1
    MOV AH,09H
    INT 10H
    Chang:
    ret
    MiColor endp
    .Stack
END programa