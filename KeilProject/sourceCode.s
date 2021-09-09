		AREA codigoSemaforos, CODE, READONLY
		ENTRY
		EXPORT	__main

APAGADO EQU 0 ;La unidad de control esta apagada
ENCENDIDO EQU 1 ;La unidad de control esta encendida

ROJO EQU 1 ;El semaforo esta en rojo
AMARILLO EQU 2 ;El semaforo esta en amarillo
VERDE EQU 3 ;El semaforo esta en verde

LIBRE EQU 0 ;No hay ninguna solicitud en ningun cruce peatonal
NS EQU 1 ;Hay una solicitud para el cruce peatonal NS
OE EQU 2 ;Hay una solicitud para el cruce peatonal OE
NSOE EQU 3 ;Hay solicitud para cruzar en NS y OE


__main	

;Inicio del programa.
MAIN	B iniciarRegistros
		B esperarInicioUnidadControl
		B leerSolicitudesParaCruzar

;Se reinician todos los registros a 0
iniciarRegistros	MOV R0,#0 ;R0 almacena si el sistema se ha encendido o no (APAGADO o ENCENDIDO)
					MOV R1,#0 ;R1 almacena el color de los semaforos vehiculares NS (ROJO, AMARILLO o VERDE)
					MOV R2,#0 ;R2 almacena el color de los semaforos vehiculares OE (ROJO, AMARILLO o VERDE)
					MOV R3,#0 ;R3 almacena el color de los semaforos peatonales NS (ROJO o VERDE)
					MOV R4,#0 ;R4 almacena el color de los semaforos peatonales OE (ROJO o VERDE)
					MOV R5,#0 ;R5 almacena la informacion de las solicitudes de cruce peatonal (LIBRE, NS, OE o NSOE)
					MOV R6,#0 ;R6 funciona como un temporizador
					MOV R7,#0 ;R7 le indica al temporizador hasta donde tiene que contar

;Se espera a que la unidad de control se encienda
esperarInicioUnidadControl	
							CMP R0,#ENCENDIDO ;Almacena si el sistema se ha encendido
							BNE	esperarInicioUnidadControl ;En caso de que no, se sigue en el bucle

;Se evalua que solicitudes hay pendientes en los cruces peatonales
leerSolicitudesParaCruzar	
							CMP R5,#NSOE ;Almacena si hay solicitudes en ambos cruces peatonales
							BEQ verdeCortoNS ;En caso de que si, entra en la rama de verdeCortoNS
							CMP R5,#NS ;Almacena si hay solicitudes en el cruce peatonal NS
							BEQ verdeCortoNS ;En caso de que si, entra en la rama de verdeCortoNS
							B verdeLargoNS ;En caso de que no haya entrado en verdeCortoNS, puede entrar en verdeLargoNS


verdeCortoNS	
				MOV R1,#VERDE ;Se pone el semaforo vehicular NS en verde
				MOV R2,#ROJO ;Se pone el semaforo vehicular OE en rojo
				MOV R3,#ROJO ;Se pone el semaforo peatonal NS en rojo
				MOV R4,#VERDE ;Se pone el semaforo peatonal OE en verde
				
				CMP R5,#NS ;Almacena si se tiene de una solicitud de cruce peatonal NS
				MOVEQ R5,#LIBRE ;En caso de ser asi, como ya se esta haciendo un tiempo reducido para los vehiculos, se elimina la solicitud (ya se tomo en cuenta)
				
				CMP R5,#NSOE
				MOVEQ R5,#OE
				

				MOV R7,#10 ;Se establece el limite 10 segundos para el temporizador
						
				ADD R6,R6,#1 ;Se comienza a contar, añadiendo 1 al temporizador
				CMP R6,R7 ;Almacena si el temporizador ha alcanzado el limite de 10 segundos
				BNE verdeCortoNS ;En caso de no ser asi, entra nuevamente en la rama verdeCortoNS
				
				MOV R6,#0 ;Cuando ya se ha alcanzado el limite del temporizador (10 segundos), se limpia el temporizador
				
				B amarilloNS ;Se entra en la rama amarilloNS


verdeCortoOE	
				MOV R1,#ROJO ;Se pone el semaforo vehicular NS en rojo
				MOV R2,#VERDE ;Se pone el semaforo vehicular OE en verde
				MOV R3,#VERDE ;Se pone el semaforo peatonal NS en verde
				MOV R4,#ROJO ;Se pone el semaforo peatonal OE en rojo
				
				CMP R5,#OE ;Almacena si se tiene de una solicitud de cruce peatonal OE
				MOVEQ R5,#LIBRE ;En caso de ser asi, como ya se esta haciendo un tiempo reducido para los vehiculos, se elimina la solicitud (ya se tomo en cuenta)
				
				CMP R5,#NSOE
				MOVEQ R5,#NS

				MOV R7,#10 ;Se establece el limite 10 segundos para el temporizador
				
				ADD R6,R6,#1 ;Se comienza a contar, añadiendo 1 al temporizador
				CMP R6,R7 ;Almacena si el temporizador ha alcanzado el limite de 10 segundos
				BNE verdeCortoOE ;En caso de no ser asi, entra nuevamente en la rama verdeCortoOE
				
				MOV R6,#0 ;Cuando ya se ha alcanzado el limite del temporizador (10 segundos), se limpia el temporizador
				
				B amarilloOE ;Se entra en la rama amarilloOE


verdeLargoNS 	
				MOV R1,#VERDE ;Se pone el semaforo vehicular NS en verde
				MOV R2,#ROJO ;Se pone el semaforo vehicular OE en rojo
				MOV R3,#ROJO ;Se pone el semaforo peatonal NS en rojo
				MOV R4,#VERDE ;Se pone el semaforo peatonal OE en verde
				
				MOV R7,#25 ;Se establece el limite 25 segundos para el temporizador
				
				ADD R6,R6,#1 ;Se comienza a contar, añadiendo 1 al temporizador
				CMP R6,R7 ;Almacena si el temporizador ha alcanzado el limite de 25 segundos
				BNE verdeLargoNS ;En caso de no ser asi, entra nuevamente en la rama verdeLargoNS
				
				MOV R6,#0 ;Cuando ya se ha alcanzado el limite del temporizador (25 segundos), se limpia el temporizador
				B amarilloNS ;Se entra en la rama amarilloNS
				
				
verdeLargoOE	
				MOV R1,#ROJO ;Se pone el semaforo vehicular NS en rojo
				MOV R2,#VERDE ;Se pone el semaforo vehicular OE en verde
				MOV R3,#VERDE ;Se pone el semaforo peatonal NS en verde
				MOV R4,#ROJO ;Se pone el semaforo peatonal OE en rojo
				
				MOV R7,#25 ;Se establece el limite 25 segundos para el temporizador
								
				ADD R6,R6,#1 ;Se comienza a contar, añadiendo 1 al temporizador
				CMP R6,R7 ;Almacena si el temporizador ha alcanzado el limite de 25 segundos
				BNE verdeLargoOE ;En caso de no ser asi, entra nuevamente en la rama verdeLargoOE
				
				MOV R6,#0 ;Cuando ya se ha alcanzado el limite del temporizador (25 segundos), se limpia el temporizador
				B amarilloOE ;Se entra en la rama amarilloOE
				
				
amarilloNS		
				MOV R1,#AMARILLO ;Se pone el semaforo vehicular NS en amarillo
				MOV R2,#ROJO ;Se pone el semaforo vehicular OE en rojo
				MOV R3,#ROJO ;Se pone el semaforo peatonal NS en rojo
				MOV R4,#VERDE ;Se pone el semaforo peatonal OE en verde
				
				MOV R7,#5 ;Se establece el limite 5 segundos para el temporizador
				
				ADD R6,R6,#1 ;Se comienza a contar, añadiendo 1 al temporizador
				CMP R6,R7 ;Almacena si el temporizador ha alcanzado el limite de 5 segundos
				BNE amarilloNS ;En caso de no ser asi, entra nuevamente en la rama amarilloNS
				
				MOV R6,#0 ;Cuando ya se ha alcanzado el limite del temporizador (5 segundos), se limpia el temporizador
				
				CMP R5,#NSOE ;Almacena si se tiene una solicitud de cruce peatonal NSOE (en los dos cruces peatonales)
				BEQ verdeCortoOE ;En caso de ser asi, entra a verdeCortoOE, para agilizar el paso de vehiculos y peatones
				CMP R5,#OE ;Almacena si se tiene una solicitud de cruce peatonal OE
				BEQ verdeCortoOE ;En caso de ser asi, entra a verdeCortoOE, para agilizar el paso de vehiculos y peatones
				B verdeLargoOE ;En caso de no tener solicitudes de cruces peatones que involucren el transito de vehiculos OE, se les puede dejar pasar por mas tiempo, entrando a verdeLargoOE


amarilloOE		
				MOV R1,#ROJO ;Se pone el semaforo vehicular NS en rojo
				MOV R2,#AMARILLO ;Se pone el semaforo vehicular OE en amarillo
				MOV R3,#VERDE ;Se pone el semaforo peatonal NS en verde
				MOV R4,#ROJO ;Se pone el semaforo peatonal OE en rojo
				
				MOV R7,#5 ;Se establece el limite 5 segundos para el temporizador
								
				ADD R6,R6,#1 ;Se comienza a contar, añadiendo 1 al temporizador
				CMP R6,R7 ;Almacena si el temporizador ha alcanzado el limite de 5 segundos
				BNE amarilloOE ;En caso de no ser asi, entra nuevamente en la rama amarilloOE
				
				MOV R6,#0 ;Cuando ya se ha alcanzado el limite del temporizador (5 segundos), se limpia el temporizador
				
				B leerSolicitudesParaCruzar ;Se entra a leerSolicitudesParaCruzar, volviendo a comenzar el programa
				
				
				END