color(jaune).
color(vert).
color(rouge).

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

colormenu(Solution) :-
	yesno("Voulez vous choisir une couleur ?", YesNo),
	colormenu(YesNo, Solution).

colormenu(n, A-B-C-D) :-
	coloriage(A,B,C,D).

colormenu(y, Solution) :-
	askPos(Position),
	askColor(Color),!,
	colorPos(Position, Color, Solution).

colorPos(1, C, C-C2-C3-C4) :- coloriage(C, C2, C3, C4).
colorPos(2, C, C1-C-C3-C4) :- coloriage(C1, C, C3, C4).
colorPos(3, C, C1-C2-C-C4) :- coloriage(C1, C2, C, C4).
colorPos(4, C, C1-C2-C3-C) :- coloriage(C1, C2, C3, C).

myread(Atom) :-
	get_single_char(Code), char_code(Atom, Code), write(Atom), write("\n").
	%	get_code(_). % to use after a read/1

yesno(MSG, YN) :-
	string_concat(MSG, " (y/n)\n", STR),
	write(STR),
	myread(YN).

askPos(Position) :-
	write("Veuillez choisir une position: (1,2,3,4)\n"),
	myread(PositionAtom),
	atom_number(PositionAtom, Position).

askColor(Color) :-
	write("Choix de la couleur\n"),
	color(Color),
	yesno(Color,y).

