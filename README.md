# Enunciado Proyecto Reloj
Como parte de la comunidad open source, usted quiere participar aportando un módulo de reloj
y calendario para un nuevo sistema operativo experimental basado en DOS. El lenguaje de
programación a utilizar es Turboassembler.

Entre los requerimientos especificados están:
1. Creación de un programa que muestre la fecha actual del sistema, además mostrar la
hora actual de la computadora en ese momento.
2. Deberá contar con un apartado para ingresar un formato en UTC como “UTC+5” y
mostrar la fecha y hora para esa región respectivamente.
3. Deberá tener, a modo de muestra, ciertos husos horarios ya agregados, junto a sus
respectivas fechas, estos serán de acuerdo a los países:
* India
* Alemania
* Costa este de los Estados unidos
* Argentina
* Japón

La fecha debe mostrar:
* El día de la semana
* El año
* El mes
* El día

La hora debe mostrar:
* Hora
* Minutos
* Segundos
4. Los cálculos respecto a los horarios de otros países deben ser basados en la hora local
de la computadora, pero además debe permitirse al usuario cambiar la hora utilizando la
interrupción correspondiente (este cambio no necesariamente debe reflejarse en el reloj
que ya tiene el sistema operativo); dado lo anterior, los relojes y fechas alternos deben
reflejar los cambios en tiempo real.
5. El usuario debe poseer una vista análoga de cada uno de los relojes (solamente con
horas y minutos) 