(define (problem roverprob1234) ; Definicion del problema llamado "roverprob1234"
(:domain Rover) ; Se especifica que pertenece al dominio "Rover"
(:objects ; Definicion de los objetos en el problema
    general - Lander ; La base de aterrizaje
    colour high_res low_res - Mode ; Modos de imagen (color, alta resolucion y baja resolucion)
    rover0 - Rover ; Un rover disponible
    rover0store - Store ; Almacen
    waypoint0 waypoint1 waypoint2 waypoint3 waypoint4 - Waypoint ; Puntos de referencia o ubicaciones en el mapa
    camera0 - Camera ; Camara 
    objective0 objective1 objective2 - Objective ; Objetivos
)
(:init ; Estado inicial del problema
    ; Definicion de visibilidad entre waypoints, se anade la visibilidad del nuevo waypoint4 con el 1 
    (visible waypoint1 waypoint0)
    (visible waypoint0 waypoint1)
    (visible waypoint2 waypoint0)
    (visible waypoint0 waypoint2)
    (visible waypoint2 waypoint1)
    (visible waypoint1 waypoint2)
    (visible waypoint3 waypoint0)
    (visible waypoint0 waypoint3)
    (visible waypoint3 waypoint1)
    (visible waypoint1 waypoint3)
    (visible waypoint3 waypoint2)
    (visible waypoint2 waypoint3)
    
    (visible waypoint4 waypoint1)
    (visible waypoint1 waypoint4)
    
     ; Ubicacion de muestras de suelo y roca
    (at_soil_sample waypoint0)
    (at_rock_sample waypoint1)
    (at_soil_sample waypoint2)
    (at_rock_sample waypoint2)
    (at_soil_sample waypoint3)
    (at_rock_sample waypoint3)
    ; Ubicacion de la base y su disponibilidad de comunicacion
    (at_lander general waypoint0)
    (channel_free general)
     ; Posicion inicial del rover y la disponibilidad. Se anade ademas su capacidad para almacenar y que el almacen esta vacio, y que puede muetrear rocas y el suelo, ademas de tomar imagenes
    (at rover0 waypoint3)
    (available rover0)
    (store_of rover0store rover0)
    (empty rover0store)
    (equipped_for_soil_analysis rover0)
    (equipped_for_rock_analysis rover0)
    (equipped_for_imaging rover0)
    ; Definicion de que waypoints puede alcanzar desde cada uno
    (can_traverse rover0 waypoint3 waypoint0)
    (can_traverse rover0 waypoint0 waypoint3)
    (can_traverse rover0 waypoint3 waypoint1)
    (can_traverse rover0 waypoint1 waypoint3)
    (can_traverse rover0 waypoint1 waypoint2)
    (can_traverse rover0 waypoint2 waypoint1)
    (can_traverse rover0 waypoint1 waypoint4)
    (can_traverse rover0 waypoint4 waypoint1)
    ; Definicion de la camara, la calibracion y el soporte de fotos a color y en alta resolucion
    (on_board camera0 rover0)
    (calibration_target camera0 objective1)
    (supports camera0 colour)
    (supports camera0 high_res)
    ; Definicion de la visibilidad de los objetivos desde los waypoints. Se anade la condicion del enunciado
    (visible_from objective0 waypoint0)
    (visible_from objective0 waypoint1)
    (visible_from objective0 waypoint2)
    (visible_from objective0 waypoint3)
    (visible_from objective1 waypoint0)
    (visible_from objective1 waypoint1)
    (visible_from objective1 waypoint2)
    (visible_from objective1 waypoint3)
    
    (visible_from objective2 waypoint4)
)
; Definicion de los objetivos a cumplir: enviar datos de muestra de suelo desde waypoint2, de muestra de roca desde waypoint3 y enviar una imagen de objective1 en alta resolucion
; Se anaden los pedidos en el enunciado
(:goal (and
    (communicated_soil_data waypoint2)
    (communicated_rock_data waypoint3)
    (communicated_image_data objective1 high_res)
    (communicated_image_data objective2 high_res)
    (communicated_image_data objective2 colour)
))
)
