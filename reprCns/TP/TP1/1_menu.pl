/* les entrées */
entree(crudites).
entree(terrine).
entree(melon).

/* les viandes (avec les légumes associés) */
viande(steak).
viande(poulet).
viande(gigot).

/* les viandes (avec légumes associés) */
poisson(bar).
poisson(saumon).

/* les dessert */
dessert(sorbet).
dessert(creme).
dessert(tarte).

/* composition d'un menu simple : une entrée ET un plat ET un dessert */
menuSimple(E, P, D) :- entree(E), plat(P), dessert(D).

/* le plat de résistance : viande OU poisson */
plat(P) :- viande(P).
plat(P) :- poisson(P).

/*
*
* Quels sont les menus simples avec des crudités en entrée ?
* menuSimple(crudites, P, D).
*
* Peut-on avoir un menu avec des crudités et une mousse au chocolat ?
* menuSimple(crudites, P, mousseAuChocolat).
*
* Quels sont les menus avec du poisson comme plat ?
* poisson(P), menuSimple(E, P, D).
*
* Quels sont les menus avec du melon en entrée et du poisson comme plat ?
* poisson(P), menuSimple(melon, P, D).
* 

/* Etape 5
* menuSimple(E, P, D), entree(crudites).
* Quels sont les menus qui ont en entrée des crudites ?
*
* menuSimple(E, P, D), !.
* Quel est le premier menus que prolog propose ?
*
* menuSimple(E, P, D), poisson(P), !.
* Quel est le premier menu avec du poisson que prolog propose ?
*
* menuSimple(E, P, D), !, poisson(P).
* Le premier plat que prolog propose est-il au poisson ?
