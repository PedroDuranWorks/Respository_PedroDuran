(define (domain Rover) ; Definicion del dominio llamado "Rover"
(:requirements :typing :strips) ; Especificacion de los requisitos para el dominio
(:types rover waypoint store camera mode lander objective) ; Definicion de los tipos de objetos en el dominio
; Definicion de los predicados 
(:predicates (at ?x - rover ?y - waypoint) ; El rover x esta en el waypoint y
             (at_lander ?x - lander ?y - waypoint) ; El modulo de aterrizaje x esta en el waypoint y
             (can_traverse ?r - rover ?x - waypoint ?y - waypoint) ; El rover r puede moverse entre x y y
	     (equipped_for_soil_analysis ?r - rover) ; El rover r esta equipado para analisis de suelo
             (equipped_for_rock_analysis ?r - rover); El rover r esta equipado para analisis de rocas
             (equipped_for_imaging ?r - rover) ;  El rover r esta equipado para tomar imagenes
             (empty ?s - store) ; El almacen s esta vacio
             (have_rock_analysis ?r - rover ?w - waypoint) ; El rover r tiene analisis de roca en w
             (have_soil_analysis ?r - rover ?w - waypoint) ; El rover r tiene analisis de suelo en w
             (full ?s - store) ; El almacen s esta lleno
	     (calibrated ?c - camera ?r - rover) ; La camara c del rover r esta calibrada
	     (supports ?c - camera ?m - mode); La camara c admite el modo m
             (available ?r - rover);El rover r esta disponible para operar
             (visible ?w - waypoint ?p - waypoint) ; El waypoint w es visible desde p
             (have_image ?r - rover ?o - objective ?m - mode); El rover r tiene una imagen del objetivo o en el modo m
             (communicated_soil_data ?w - waypoint); Se han comunicado los datos de suelo de w
             (communicated_rock_data ?w - waypoint); Se han comunicado los datos de roca de w
             (communicated_image_data ?o - objective ?m - mode); Se han comunicado las imagenes del objetivo o en el modo m
	     (at_soil_sample ?w - waypoint); Hay una muestra de suelo en w
	     (at_rock_sample ?w - waypoint); Hay una muestra de roca en w
             (visible_from ?o - objective ?w - waypoint); El objetivo o es visible desde el waypoint w
	     (store_of ?s - store ?r - rover); El almacen s pertenece al rover r
	     (calibration_target ?i - camera ?o - objective); El objetivo o es el blanco de calibracion de la camara i
	     (on_board ?i - camera ?r - rover); La camara i esta a bordo del rover r
	     (channel_free ?l - lander); El canal de comunicacion del modulo l esta libre

)

	
(:action navigate ; Accion para mover el rover de un waypoint a otro
:parameters (?x - rover ?y - waypoint ?z - waypoint) 
:precondition (and (can_traverse ?x ?y ?z) (available ?x) (at ?x ?y) 
                (visible ?y ?z)
	    )
:effect (and (not (at ?x ?y)) (at ?x ?z)
		)
)

(:action sample_soil ; Accion para recolectar una muestra de suelo
:parameters (?x - rover ?s - store ?p - waypoint)
:precondition (and (at ?x ?p) (at_soil_sample ?p) (equipped_for_soil_analysis ?x) (store_of ?s ?x) (empty ?s)
		)
:effect (and (not (empty ?s)) (full ?s) (have_soil_analysis ?x ?p) (not (at_soil_sample ?p))
		)
)

(:action sample_rock ; Accion para recolectar una muestra de roca
:parameters (?x - rover ?s - store ?p - waypoint)
:precondition (and (at ?x ?p) (at_rock_sample ?p) (equipped_for_rock_analysis ?x) (store_of ?s ?x)(empty ?s)
		)
:effect (and (not (empty ?s)) (full ?s) (have_rock_analysis ?x ?p) (not (at_rock_sample ?p))
		)
)

(:action drop ; Accion para vaciar el almacen del rover
:parameters (?x - rover ?y - store)
:precondition (and (store_of ?y ?x) (full ?y)
		)
:effect (and (not (full ?y)) (empty ?y)
	)
)

(:action calibrate ; Accion para calibrar una camara
 :parameters (?r - rover ?i - camera ?t - objective ?w - waypoint)
 :precondition (and (equipped_for_imaging ?r) (calibration_target ?i ?t) (at ?r ?w) (visible_from ?t ?w)(on_board ?i ?r)
		)
 :effect (calibrated ?i ?r) 
)




(:action take_image ; Accion para tomar una imagen
 :parameters (?r - rover ?p - waypoint ?o - objective ?i - camera ?m - mode)
 :precondition (and (calibrated ?i ?r)
			 (on_board ?i ?r)
                      (equipped_for_imaging ?r)
                      (supports ?i ?m)
			  (visible_from ?o ?p)
                     (at ?r ?p)
               )
 :effect (and (have_image ?r ?o ?m)(not (calibrated ?i ?r))
		)
)


(:action communicate_soil_data ; Accion para comunicar datos de suelo al modulo de aterrizaje
 :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_soil_analysis ?r ?p) 
                   (visible ?x ?y)(available ?r)(channel_free ?l)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)
		(communicated_soil_data ?p)(available ?r)
	)
)

(:action communicate_rock_data ; Accion para comunicar datos de muestra de roca al modulo de aterrizaje
 :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_rock_analysis ?r ?p)
                   (visible ?x ?y)(available ?r)(channel_free ?l)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_rock_data ?p)(available ?r)
          )
)


(:action communicate_image_data ; Accion para comunicar datos la imagen al modulo de aterrizaje
 :parameters (?r - rover ?l - lander ?o - objective ?m - mode ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_image ?r ?o ?m)(visible ?x ?y)(available ?r)(channel_free ?l)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_image_data ?o ?m)(available ?r)
          )
)

)
