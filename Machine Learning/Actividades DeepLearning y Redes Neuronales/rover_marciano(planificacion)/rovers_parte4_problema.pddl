(define (problem roverprob1234)  ; Definicion del problema llamado "roverprob1234"
  (:domain Rover2)  ; Se especifica que pertenece al dominio "Rover2"

  (:objects  ; Definicion de los objetos en el problema
      general - Lander  ; La base de aterrizaje
      colour high_res low_res - Mode  ; Modos de imagen (color, alta resolucion y baja resolucion)
      rover0 rover1 - Rover  ; Dos rovers disponibles
      rover0store rover1store - Store  ; Almacenes de cada rover
      waypoint0 waypoint1 waypoint2 waypoint3 - Waypoint  ; Puntos de referencia o ubicaciones en el mapa
      camera0 camera1 - Camera  ; Camaras montadas en los rovers
      objective0 objective1 - Objective  ; Objetivos
  )

  (:init  ; Estado inicial del problema
      ; Definicion de visibilidad entre waypoints
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

      ; Posiciones iniciales de los rovers
      (at rover0 waypoint3)  
      (at rover1 waypoint2)  

      ; Disponibilidad para operar
      (available rover0)
      (available rover1)

      ; Almacenes de cada rover
      (store_of rover0store rover0)
      (store_of rover1store rover1)

      ; Almacenes vacios al inicio
      (store_empty rover0store)
      (store_empty rover1store)

      ; Capacidades de cada rover: rover0 puede analizar suelo y rocas y tomar imagenes, pero rover1 solo puede tomar imagenes
      (equipped_for_soil_analysis rover0)  
      (equipped_for_rock_analysis rover0)  
      (equipped_for_imaging rover0)  
      (equipped_for_imaging rover1)  

      ; Definicion de que waypoints puede alcanzar cada rover
      (can_traverse rover0 waypoint3 waypoint0)
      (can_traverse rover0 waypoint0 waypoint3)
      (can_traverse rover0 waypoint3 waypoint1)
      (can_traverse rover0 waypoint1 waypoint3)
      (can_traverse rover0 waypoint1 waypoint2)
      (can_traverse rover0 waypoint2 waypoint1)

      (can_traverse rover1 waypoint3 waypoint0)
      (can_traverse rover1 waypoint0 waypoint3)
      (can_traverse rover1 waypoint3 waypoint1)
      (can_traverse rover1 waypoint1 waypoint3)
      (can_traverse rover1 waypoint1 waypoint2)
      (can_traverse rover1 waypoint2 waypoint1)

      ; Camaras montadas en los rovers y sus caracteristicas: se indica que las camaras estan en los rovers, la calibracion y la capacidad para tomar imagenes en color y en alta resolucion
      (on_board camera0 rover0)  
      (calibration_target camera0 objective1)  
      (supports camera0 colour)  
      (supports camera0 high_res)  

      (on_board camera1 rover1)  
      (calibration_target camera1 objective1)
      (supports camera1 colour)
      (supports camera1 high_res)

      ; Definicion de la visibilidad de los objetivos desde los waypoints
      (visible_from objective0 waypoint0)
      (visible_from objective0 waypoint1)
      (visible_from objective0 waypoint2)
      (visible_from objective0 waypoint3)

      (visible_from objective1 waypoint0)
      (visible_from objective1 waypoint1)
      (visible_from objective1 waypoint2)
      (visible_from objective1 waypoint3)

      ; Niveles iniciales de bateria
      (battery_full rover0)
      (battery_full rover1)
  )

  (:goal  ; Definicion de los objetivos a cumplir: enviar datos de muestra de suelo desde waypoint2, de muestra de roca desde waypoint3 y enviar una imagen de objective1 en alta resolucion
      (and
          (communicated_soil_data waypoint2)   
          (communicated_rock_data waypoint3)    
          (communicated_image_data objective1 high_res)   
      )
  )
)
