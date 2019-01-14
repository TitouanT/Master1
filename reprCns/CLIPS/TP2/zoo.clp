; Titouan Teyssier

(deffacts initiaux
	(animal Bozo)
	(prop Bozo grand_bond)
	(prop Bozo poche_ventral)
	(prop Bozo poilu)

	(animal Bobby)
	(prop Bobby poilu)
	(prop Bobby poche_ventral)
	(prop Bobby grimpe)

	(animal Betty)
	(prop Betty poilu)
	(prop Betty vole)
	(repas Betty carnivore)

	(animal Baloo)
	(prop Baloo poilu)
	(prop Baloo pond)
	(repas Baloo carnivore)

	(animal Koko)
	(repas Koko eucalyptus)
	(repas Koko bamboo)

	(values prop poilu poche_ventral phalangue_longue grimpe grand_bond pond queue_prehensible vole petit longue_queue)

	(values repas carnivore bamboo eucalyptus)



)
; #########################
; # informe l'utilisateur #
; #########################


(defrule dropask
	(declare (salience -5))
	(identification ?name ?)
	?ref <- (askuser ?name $?)
	=>
	(retract ?ref)
)

(defrule informe_ident
	(declare (salience -10))
	(identification ?name ?espece)
	=>
	(printout t (implode$ (create$ ?name est un ?espece)) crlf)
)

(defrule informe_not_ident
	(declare (salience -10))
	(animal ?name)
	(not (identification ?name ?))
	=>
	(printout t (implode$ (create$ Je n'ai pas pu identifier ?name)) crlf)
	(assert (askuser ?name))
)

; ##########################################################
; # demande des information complémentaire à l'utilisateur #
; ##########################################################

(defrule askuser
	(declare (salience -20))
	(askuser ?name)
	(values ?prop $? ?propval $?)
	=>
	(assert (askuser ?name ?prop ?propval))
)

(defrule askuserprop
	(declare (salience -15))
	(askuser ?name prop ?propval)
	=>
	(printout t (implode$ (create$ ?name à t'il comme propriété : ?propval)) "? ")
	(
		if (eq (readline) "oui")
		then (assert (prop ?name ?propval))
	)
)

(defrule askuserrepas
	(declare (salience -15))
	(askuser ?name repas ?propval)
	=>
	(printout t (implode$ (create$ ?name fait t'il un repas de ?propval)) "? ")
	(
		if (eq (readline) "oui")
		then (assert (repas ?name ?propval))
	)
)


; ######################################
; # Regle permettant l'identification: #
; ######################################

(defrule alaitement
	(prop ?name poilu)
	=>
	(assert (prop ?name allaite))
)

(defrule phalanger
	(prop ?name poche_ventral)
	(prop ?name phalangue_longue)
	=>
	(assert (identification ?name phalanger))
)

(defrule koala
	(famille ?name marsupial)
	(prop ?name grimpe)
	=>
	(assert (identification ?name koala))
)

(defrule marsupial
	(prop ?name poche_ventral)
	(prop ?name allaite)
	=>
	(assert (famille ?name marsupial))
)

(defrule kangourou
	(famille ?name marsupial)
	(prop ?name grand_bond)
	=>
	(assert (identification ?name kangourou))
)


(defrule mammifere
	(prop ?name allaite)
	=>
	(assert (famille ?name mammifere))
)

(defrule koala2
	(repas ?name eucalyptus)
	(not (repas ?name ~eucalyptus))
	=>
	(assert (identification ?name koala))
)

(defrule bat
	(prop ?name vole)
	(prop ?name allaite)
	(repas ?name carnivore)
	=>
	(assert (identification ?name bat))
)

(defrule faucon
	(repas ?name carnivore)
	(famille ?name oiseau)
	=>
	(assert (identification ?name faucon))
)

(defrule opposum
	(famille ?name marsupial)
	(repas ?name carnivore)
	(prop ?name queue_prehensible)
	=>
	(assert (identification ?name opposum))
)

(defrule origin
	(famille ?name marsupial)
	=>
	(assert (origin ?name hemisphere_sud))
)


(defrule oiseau
	(prop ?name vole)
	(prop ?name pond)
	=>
	(assert (famille ?name oiseau))
)

(defrule ornithorynque
	(famille ?name mammifere)
	(prop ?name pond)
	=>
	(assert (identification ?name ornithorynque))
)

(defrule souris
	(prop ?name petit)
	(famille ?name mammifere)
	(prop ?name longue_queue)
	=>
	(assert (identification ?name souris))
)
