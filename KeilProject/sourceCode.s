		AREA codigoSemaforos, CODE, READONLY
		ENTRY
		EXPORT	__main

APAGADO EQU 0
ENCENDIDO EQU 1

ROJO EQU 1
AMARILLO EQU 2
VERDE EQU 3

LIBRE EQU 0
NS EQU 1
OE EQU 2
NSOE EQU 3


; R0 almacena si el sistema se ha encendido o no (APAGADO o ENCENDIDO)
; R1 almacena la informacion de los semaforos vehiculares NS (ROJO, AMARILLO o VERDE)
; R2 almacena la informacion de los semaforos vehiculares OE (ROJO, AMARILLO o VERDE)
; R3 almacena la informacion de los semaforos peatonales NS (ROJO o VERDE)
; R4 almacena la informacion de los semaforos peatonales OE (ROJO o VERDE)
; R5 almacena la informacion de las solicitudes de cruce peatonal (LIBRE, NS, OE o NSOE)
; R6 funciona como un temporizador
; R7 le indica al temporizador hasta donde tiene que llegar


__main	


MAIN	B iniciarRegistros
		B esperarInicioUnidadControl
		B leerSolicitudesParaCruzar

iniciarRegistros	MOV R0,#0
					MOV R1,#0
					MOV R2,#0
					MOV R3,#0
					MOV R4,#0
					MOV R5,#0
					MOV R6,#0
					MOV R7,#0


esperarInicioUnidadControl	CMP R0,#ENCENDIDO
							BNE	esperarInicioUnidadControl


leerSolicitudesParaCruzar	CMP R5,#NSOE
							BEQ verdeCortoNS
							CMP R5,#NS
							BEQ verdeCortoNS
							B verdeLargoNS

verdeCortoNS	MOV R1,#VERDE
				MOV R2,#ROJO
				MOV R3,#ROJO
				MOV R4,#VERDE
				
				CMP R5,#NS
				MOVEQ R5,#LIBRE
				MOVNE R5,#OE

				MOV R6,#0
				MOV R7,#10
				B temporizador


verdeCortoOE	MOV R1,#ROJO
				MOV R2,#VERDE
				MOV R3,#VERDE
				MOV R4,#ROJO
				
				CMP R5,#OE
				MOVEQ R5,#LIBRE
				MOVNE R5,#NS

				MOV R6,#0
				MOV R7,#10
				B temporizador


verdeLargoNS 	MOV R1,#VERDE
				MOV R2,#ROJO
				MOV R3,#ROJO
				MOV R4,#VERDE
				MOV R6,#0
				MOV R7,#25
				B temporizador
				B amarilloNS
				
verdeLargoOE	MOV R1,#ROJO
				MOV R2,#VERDE
				MOV R3,#VERDE
				MOV R4,#ROJO
				MOV R6,#0
				MOV R7,#25
				B temporizador
				B amarilloOE
				
amarilloNS		MOV R1,#AMARILLO
				MOV R2,#ROJO
				MOV R3,#ROJO
				MOV R4,#VERDE
				MOV R6,#0
				MOV R7,#5
				B temporizador
				CMP R5,#NSOE
				BEQ verdeCortoOE
				CMP R5,#OE
				BEQ verdeCortoOE
				B verdeLargoOE

amarilloOE		MOV R1,#ROJO
				MOV R2,#AMARILLO
				MOV R3,#VERDE
				MOV R4,#ROJO
				MOV R6,#0
				MOV R7,#5
				B temporizador
				B leerSolicitudesParaCruzar

temporizador	ADD R6,R6,#1
				CMP R6,R7
				BNE temporizador

		END	