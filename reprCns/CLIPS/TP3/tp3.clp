; ####################
; # Titouan Teyssier #
; ####################
(deftemplate etat
	(slot quatre (type INTEGER) (default 0))
	(slot trois (type INTEGER) (default 0))
	(slot action (type STRING) (default "Tout est vide"))
	(slot pere (type FACT-ADDRESS SYMBOL) (default nil))
	(slot profondeur (type INTEGER) (default 0))
)

(deffacts initiaux
	(etat)
)

; ########################
; # definition de la fin #
; ########################

(deffunction afficher_solution (?fact)
	(if (neq ?fact nil) then
		(bind ?pere (fact-slot-value ?fact pere))
		(bind ?action (fact-slot-value ?fact action))
		(bind ?t (fact-slot-value ?fact trois))
		(bind ?q (fact-slot-value ?fact quatre))
		(afficher_solution ?pere)
		(printout t (implode$ (create$ ?t ?q :)) ?action crlf)
	)
)

; on regarde les solution à la toute fin afin de laisser l'optimisation des solution se faire
(defrule fini
	(declare (salience -10))
	(or
		?ref <- (etat (quatre 2))
		?ref <- (etat (trois 2))
	)
	=>
	(printout t crlf "Nouvelle solution:" crlf)
	(afficher_solution ?ref)
	(halt)
)

; ############################
; # suppression des doublons #
; ############################

; au lieu de supprimer le fait le plus jeune, je supprime le fait qui à la plus grande profondeur
(defrule doublon
	(declare (salience 20))
	?p1 <- (etat (quatre ?q) (trois ?t) (profondeur ?e1))
	?p2 <- (etat (quatre ?q) (trois ?t) (profondeur ?e2))
	(test (> ?e1 ?e2))
	=>
	(assert (replace ?p1 ?p2))
	(retract ?p1)
)

(defrule replace
	(declare (salience 50))
	(replace ?old ?new)
	?node <- (etat (pere ?old))
	=>
	(modify ?node (pere ?new))
)

(defrule deletereplace
	(declare (salience 49))
	?ref <- (replace ?old ?)
	(not (etat (pere ?old)))
	=>
	(retract ?ref)
)

; #####################################
; # actions sur la cruche de taille 3 #
; #####################################

(defrule remplirTrois
	?pere <- (etat (trois ~3) (profondeur ?p))
	=>
	(duplicate ?pere (trois 3) (pere ?pere) (action "remplis 3") (profondeur (+ ?p 1)))
)

(defrule viderTrois
	?pere <- (etat (trois ~0)(profondeur ?p))
	=>
	(duplicate ?pere (trois 0) (pere ?pere) (action "vide 3")(profondeur (+ ?p 1)))
)

(defrule transvaserTrois
	?pere <- (etat (quatre ?q&~4) (trois ?t&~0)(profondeur ?p))
	=>
	(assert (etat (quatre (+ ?q ?t)) (pere ?pere) (action "transvaser 3 -> 4")(profondeur (+ ?p 1))))
)

(defrule equilibreTrois
	(declare (salience 100))
	?ref <- (etat (quatre ?q) (trois ?t&:(> ?t 3)))
	=>
	(modify ?ref (trois 3) (quatre (+ ?q (- ?t 3))))
)

; #####################################
; # actions sur la cruche de taille 4 #
; #####################################

(defrule remplirQuatre
	?pere <- (etat (quatre ~4)(profondeur ?p))
	=>
	(duplicate ?pere (quatre 4) (pere ?pere) (action "remplis 4")(profondeur (+ ?p 1)))
)

(defrule viderQuatre
	?pere <- (etat (quatre ~0)(profondeur ?p))
	=>
	(duplicate ?pere (quatre 0) (pere ?pere) (action "vide 4")(profondeur (+ ?p 1)))
)

(defrule transvaserQuatre
	?pere <- (etat (quatre ?q&~0) (trois ?t&~3)(profondeur ?p))
	=>
	(assert (etat (trois (+ ?q ?t)) (pere ?pere) (action "transvase 4 -> 3")(profondeur (+ ?p 1))))
)

(defrule equilibreQuatre
	(declare (salience 100))
	?ref <- (etat (quatre ?q&:(> ?q 4)) (trois ?t))
	=>
	(modify ?ref (quatre 4) (trois (+ ?t (- ?q 4))))
)
