(deffacts faits-initiaux
	(celibataire Donald)
	(celibataire Daisy)
	(celibataire Fifi)
	(celibataire Riri)
	(celibataire Loulou)
	(celibataire Pluto)

	(age Donald)
	(age Daisy)
	(age Fifi)
	(age Riri)
	(age Loulou)
	(age Pluto)
)

(defrule marie
	?p <- (celibataire ?x)
	=>
	(retract ?p)
	(assert (marie ?x))
	(printout t ?x " vient de se marier" crlf)
)
