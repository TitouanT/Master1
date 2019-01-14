(deffacts initial-facts
	(num 1)
)

(defrule add
	(num ?x)
	=>
	(assert (num (+ ?x 1)))
)
