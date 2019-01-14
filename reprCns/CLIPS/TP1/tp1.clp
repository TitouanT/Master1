; Titouan Teyssier
(deffacts faits-initiaux
	; (relation ?nomdelarelation personne1 personne2) => personne2 est une nomdelarelation pour personne1	

	; les enfants de Eugenie 
	(relation couple 10 1)	
	(relation parent 11 10)
	(relation parent 12 10)
	(relation parent 2 10)
	(relation parent 11 1)
	(relation parent 12 1)
	(relation parent 2 1)

	; les fils de martine
	(relation parent 3 11)
	(relation parent 4 11)
	(relation parent 5 11)

	; les enfants de christiane: stephanie, thierry, sylvain
	(relation parent 13 12)
	(relation parent 6 12)
	(relation parent 7 12)

	; enfant de daniel: philipe et eric
	(relation parent 8 2)
	(relation parent 9 2)

	; (string relation sexe representation) => la "relation" est representer par "representation" pour une personne du sexe "sexe"
	(string parent homme "le pere")
	(string parent femme "la mere")

	(string fraterie homme "le frere")
	(string fraterie femme "la soeur")

	(string oncle_tante homme "l'oncle")
	(string oncle_tante femme "la tante")

	(string cousin homme "le cousin")
	(string cousin femme "la cousine")

	(string grand_parent homme "le grand pere")
	(string grand_parent femme "la grand mere")

	(string couple homme "le concubin")
	(string couple femme "la concubine")

	; EDIT: ajout de cette relation
	(string neveu_niece homme "le neveu")
	(string neveu_niece femme "la niece")

	; definition du sexe de tout ces personnage:
	(sexe homme 1)
	(sexe homme 2)
	(sexe homme 3)
	(sexe homme 4)
	(sexe homme 5)
	(sexe homme 6)
	(sexe homme 7)
	(sexe homme 8)
	(sexe homme 9)

	(sexe femme 10)
	(sexe femme 11)
	(sexe femme 12)
	(sexe femme 13)

	(id "Albert" 1)
	(id "Daniel" 2)
	(id "Herve" 3)
	(id "Laurent" 4)
	(id "Nicolas" 5)
	(id "Thierry" 6)
	(id "Sylvain" 7)
	(id "Philipe" 8)
	(id "Eric" 9)

	(id "Eugenie" 10)
	(id "Martine" 11)
	(id "Christiane" 12)
	(id "Stephanie" 13)

	; initalisation des liste
	(all fraterie)
	(all parent)
	(all cousin)
	(all grand_parent)
	(all oncle_tante)


)	

; init est resolu au début et end à la fin, ce qui permet d'ouvrir et fermer un fichier de log
(defrule init
	(declare (salience 10))
	=>
	(open "relation.txt" relfile "w")
)

(defrule end
	(declare (salience -10))
	=>
	(close relfile)
)

; affiche les liste par relation une fois qu'elles sont construite.
(defrule affListe
	(declare (salience -5))
	(all ?relation $?ids)
	;(not (displayed ?relation)) ; EDIT: obsolete
	=>
	;(assert (displayed ?relation)) ; EDIT: plus besoin car il y a une seule liste par relation
	(printout t "tableau des " ?relation ": " $?ids crlf)
)
	
; affiche tous les types de relation
(defrule disp_relation
	(relation ?relation ?id1 ?id2)
	(sexe ?sexe ?id2)
	(string ?relation ?sexe ?texte)
	(id ?name1 ?id1)
	(id ?name2 ?id2)
	=>
	(printout t ?name2 " est " ?texte " de " ?name1 crlf)
	(printout relfile ?name2 " est " ?texte " de " ?name1 crlf) ; pratique pour faire $ cat relation.txt | grep <name>
)


; generation de toutes les relation qui ne sont pas dans la base de connaissance
(defrule generate_fraterie
	(relation parent ?idenfant ?idparent)
	(relation parent ?idenfant2 ?idparent)
	(test (neq ?idenfant ?idenfant2))
	(not (relation fraterie ?idenfant ?idenfant2))
	=>
	(assert (relation fraterie ?idenfant ?idenfant2))
)


(defrule generate_oncle_tante
	(relation fraterie ?oncle_tante ?parent)
	(relation parent ?fieul ?parent)
	=>
	(assert (relation oncle_tante ?fieul ?oncle_tante))
)

; EDIT ajout de cette relation
(defrule generate_neveu_niece
	(relation oncle_tante ?neveu ?oncle)
	=>
	(assert (relation neveu_niece ?oncle ?neveu))
)


(defrule generate_cousin
	(relation oncle_tante ?cousin1 ?oncle)
	(relation parent ?cousin2 ?oncle)
	=>
	(assert (relation cousin ?cousin1 ?cousin2))
)

(defrule generate_grand_parent
	(relation parent ?parent ?grandparent)
	(relation parent ?petitenfant ?parent)
	=>
	(assert (relation grand_parent ?petitenfant ?grandparent))
)

(defrule generate_couple
	(relation parent ?commonchild ?conc)
	(relation parent ?commonchild ?ubin)
	(test (neq ?conc ?ubin)) ; EDIT: pas de couple avec soit même
	(not (relation couple ?conc ?ubin))
	=>
	(assert (relation couple ?conc ?ubin))
)

; generation des liste par groupe de role dans les relation.
(defrule generate_liste
	(relation ?relation ? ?p2)
	(not (all ?relation $? ?p2 $?))
	?pliste <- (all ?relation $?liste)
	=>
	(retract ?pliste) ; EDIT: pour avoir seulement une liste pour chaque relation
	(assert (all ?relation $?liste ?p2))
)
