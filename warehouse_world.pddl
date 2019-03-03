(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
        :parameters (?r - robot ?l1 - location ?l2 - location)
        :precondition (and (free ?r) (no-robot ?l2) (connected ?l1 ?l2) (at ?r ?l1))
        :effect (and (not (no-robot ?l2)) (no-robot ?l1) (at ?r ?l2) (not (at ?r ?l1)))
   )
   
   (:action robotMoveWithPallette
        :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
        :precondition (and (no-pallette ?l2) (at ?p ?l1) (at ?r ?l1) (connected ?l1 ?l2) (no-robot ?l2) (free ?r))
        :effect (and (has ?r ?p) (no-robot ?l1) (not (no-robot ?l2)) (at ?r ?l2) (not (at ?r ?l1)) (at ?p ?l2) (no-pallette ?l1) (not (no-pallette ?l2)))
   )    
   
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?p - pallette ?si - saleitem ?s - shipment ?o - order)
        :precondition (and (packing-location ?l) (contains ?p ?si) (at ?p ?l) (ships ?s ?o) (orders ?o ?si) (unstarted ?s) (available ?l))
        :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )
   
   (:action completeShipment
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (started ?s) (packing-at ?s ?l) (not (complete ?s)) (ships ?s ?o))
        :effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l)) (not (started ?s)))
   )
   

)
