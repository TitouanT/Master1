coloriage(C1, C2, C3, C4) :-
	color(C1),
	color(C2),
	C1 \== C2,
	color(C3),
	C1 \== C3,
	C2 \== C3,
	color(C4),
	C1 \== C4,
	C3 \== C4.

coloriage(A-B-C-D) :-
	coloriage(A, B, C, D).

color(rouge).
color(vert).
color(jaune).

colormenu(S) :-
	%	write("Voulez vous choisir une couleur ?(y/n)"),
	read(REP),
	colormenu(REP, S).
%#write(S).

colormenu(n, S) :-
	coloriage(S).

colormenu(y, S) :-
	write("Veuillez choisir une position: (1,2,3,4) "),
	read(POS),
	write("Choix de la couleur\n"),
	askColor(COL),
	colorPos(POS, COL, S).

askColor(COL) :-
	color(COL),
	validate(COL).

validate(COL) :-
	write(COL-"? (y/n)"),
	read(y).

colorPos(1, C, C-C2-C3-C4) :- coloriage(C, C2, C3, C4).
colorPos(2, C, C1-C-C3-C4) :- coloriage(C1, C, C3, C4).
colorPos(3, C, C1-C2-C-C4) :- coloriage(C1, C2, C, C4).
colorPos(4, C, C1-C2-C3-C) :- coloriage(C1, C2, C3, C).
