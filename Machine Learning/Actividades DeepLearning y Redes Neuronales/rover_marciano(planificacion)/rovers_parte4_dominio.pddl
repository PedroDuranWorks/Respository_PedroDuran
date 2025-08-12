(define (domain Rover2) ; Definicion del dominio llamado "Rover2"
  (:requirements :negative-preconditions :typing :strips :conditional-effects) ; Especificacion de los requisitos para el dominio
  (:types rover waypoint store camera mode lander objective level) ; Definicion de los tipos de objetos en el dominio

  ; Definicion de los predicados
  (:predicates 
    (at ?x - rover ?y - waypoint) ; El rover x esta en el waypoint y
    (at_lander ?x - lander ?y - waypoint) ; El modulo de aterrizaje x esta en el waypoint y
    (can_traverse ?r - rover ?x - waypoint ?y - waypoint) ; El rover r puede moverse entre x y y
    (equipped_for_soil_analysis ?r - rover) ; El rover r esta equipado para analisis de suelo
    (equipped_for_rock_analysis ?r - rover) ; El rover r esta equipado para analisis de rocas
    (equipped_for_imaging ?r - rover) ; El rover r esta equipado para tomar imagenes
    (store_empty ?s - store) ; El almacen s esta vacio
    (store_full ?s - store) ; El almacen s esta lleno
    (have_rock_analysis ?r - rover ?w - waypoint) ; El rover r tiene analisis de roca en w
    (have_soil_analysis ?r - rover ?w - waypoint) ; El rover r tiene analisis de suelo en w
    (calibrated ?c - camera ?r - rover) ; La camara c del rover r esta calibrada
    (supports ?c - camera ?m - mode) ; La camara c admite el modo m
    (available ?r - rover) ; El rover r esta disponible para operar
    (visible ?w - waypoint ?p - waypoint) ; El waypoint w es visible desde p
    (have_image ?r - rover ?o - objective ?m - mode) ; El rover r tiene una imagen del objetivo o en el modo m
    (communicated_soil_data ?w - waypoint) ; Se han comunicado los datos de suelo de w
    (communicated_rock_data ?w - waypoint) ; Se han comunicado los datos de roca de w
    (communicated_image_data ?o - objective ?m - mode) ; Se han comunicado las imagenes del objetivo o en el modo m
    (at_soil_sample ?w - waypoint) ; Hay una muestra de suelo en w
    (at_rock_sample ?w - waypoint) ; Hay una muestra de roca en w
    (visible_from ?o - objective ?w - waypoint) ; El objetivo o es visible desde el waypoint w
    (store_of ?s - store ?r - rover) ; El almacen s pertenece al rover r
    (calibration_target ?i - camera ?o - objective) ; El objetivo o es el blanco de calibracion de la camara i
    (on_board ?i - camera ?r - rover) ; La camara i esta a bordo del rover r
    (channel_free ?l - lander) ; El canal de comunicacion del modulo l esta libre
    (battery_full ?r - rover) ; La bateria del rover r esta llena
    (battery_high ?r - rover) ; La bateria del rover r esta alta
    (battery_medium ?r - rover) ; La bateria del rover r esta media
    (battery_low ?r - rover) ; La bateria del rover r esta baja
    (battery_empty ?r - rover) ; La bateria del rover r esta vacia
  )

  ; Accion para moverse entre waypoints
  (:action navigate ; Accion para mover el rover de un waypoint a otro
    :parameters (?x - rover ?y - waypoint ?z - waypoint) 
    :precondition (and (can_traverse ?x ?y ?z) (available ?x) (at ?x ?y) (visible ?y ?z) (not (battery_empty ?x)))
    :effect (and 
      (not (at ?x ?y)) (at ?x ?z)
      ; Disminuir el nivel de bateria durante la navegacion
      (when (battery_full ?x) (and (not (battery_full ?x)) (battery_high ?x)))
      (when (battery_high ?x) (and (not (battery_high ?x)) (battery_medium ?x)))
      (when (battery_medium ?x) (and (not (battery_medium ?x)) (battery_low ?x)))
      (when (battery_low ?x) (and (not (battery_low ?x)) (battery_empty ?x)))
    )
  )

  ; Accion para tomar una muestra de suelo
  (:action sample_soil ; Accion para recolectar una muestra de suelo
    :parameters (?x - rover ?s - store ?p - waypoint)
    :precondition (and (at ?x ?p) (equipped_for_soil_analysis ?x) (store_of ?s ?x) (store_empty ?s))
    :effect (and 
      (not (store_empty ?s)) (store_full ?s) (have_soil_analysis ?x ?p)
    )
  )

  ; Accion para tomar una imagen
  (:action take_image ; Accion para tomar una imagen
    :parameters (?r - rover ?p - waypoint ?o - objective ?i - camera ?m - mode)
    :precondition (and (calibrated ?i ?r) (on_board ?i ?r) (equipped_for_imaging ?r) 
                        (supports ?i ?m) (visible_from ?o ?p) (at ?r ?p))
    :effect (and 
      (have_image ?r ?o ?m) (not (calibrated ?i ?r))
    )
  )

  ;; Accion para recargar la bateria
  (:action recharge_battery ; Accion para recargar la bateria del rover
    :parameters (?r - rover ?l - lander ?p - waypoint) 
    :precondition (and (at ?r ?p) (at_lander ?l ?p) (not (battery_full ?r)))
    :effect (and 
      (not (battery_empty ?r)) 
      (not (battery_low ?r)) 
      (not (battery_medium ?r)) 
      (not (battery_high ?r)) 
      (battery_full ?r)
  )
)

 
)
