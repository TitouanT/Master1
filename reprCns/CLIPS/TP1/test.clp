;File menu->Load bacteria.clp
;Execution menu->Reset
;Execution menu->Run

;Start CLIPS

;define characteristics to be used in rules:
(deftemplate Shape (slot BacteriaShape))
(deftemplate GramStain (slot BacteriaGramStain))
(deftemplate Bacteria (slot BacteriaType))
(deftemplate Color (slot BacteriaColor))

;rules to define to which category the bacteria belongs(if bacteria)
(defrule actinomycete
	(Shape (BacteriaShape rod | filamentous | unknown))
        (GramStain (BacteriaGramStain positive | unknown))
=>
	(assert (Bacteria (BacteriaType actinomycete)))
	(printout t "The Bacteria might be actinomycete." crlf))

(defrule coccoid
	(Shape (BacteriaShape spherical | unknown))
	(GramStain (BacteriaGramStain positive | unknown))
=>
	(assert (Bacteria (BacteriaType coccoid)))
	(printout t "The Bacteria might be coccoid" crlf))

(defrule algae
	(Color (BacteriaColor green))
	(Bacteria (BacteriaType coccoid))
	(GramStain (BacteriaGramStain unknown))
=>
	(printout t "This might be coccoid microalgae" crlf))

;constructs dealing with the dialog with the user
(defrule welcome
=>
	(printout t "Welcome. " crlf crlf))

(defrule enter_Shape
=>
	(printout t "Please enter the shape (rod, filamentous, spherical, or unknown)" crlf)
	(bind ?the_BacteriaShape (read))
	(assert (Shape (BacteriaShape ?the_BacteriaShape))))

(defrule enter_GramStain
	=>
	(printout t "Please enter the gram stain (positive or unknown)" crlf)
	(bind ?Stain (read))
	(assert (GramStain (BacteriaGramStain ?Stain))))

(defrule enter_Color
	(Bacteria (BacteriaType coccoid))
	=>
	(printout t "Please enter the color (green or transparent)" crlf)
	(bind ?Color (read))
	(assert (Color (BacteriaColor ?Color))))
;End CLIPS
