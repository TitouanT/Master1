(deffacts faits-initiaux
    (meurtre Pierre Paul couteau)
    (meurtre Jacques Eric pistolet)
    (meurtre Philippe David baton))

(defrule quituequi
	(declare (salience 2))
	(meurtre ?meurtrier ?victime ?arme)
	=>
	(printout t ?meurtrier " a tué " ?victime " avec un " ?arme crlf)
)

(defrule estmort
	(declare (salience 1))
	(meurtre ? ?victime ?)
	=>
	(printout t ?victime " est mort" crlf)
)

(defrule jaccuse
	(meurtre ?meurtrier $?)
	=>
	(printout t "J'accuse " ?meurtrier " d'être un meurtrier" crlf)
)

