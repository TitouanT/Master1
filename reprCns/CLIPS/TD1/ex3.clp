(deffacts faits-initiaux
    (le pere de "Paul" est "Pierre")
    (le pere de "Jacques" est "Paul")
    (le pere de "Eric" est "Jacques"))

(defrule grandpa
	(le pere de ?pere est ?grandpa)
	(le pere de ?petitfils est ?pere)
	=>
	(assert (le grandpere de ?petitfils est ?grandpa))
)

