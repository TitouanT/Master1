

comp_not(1, 0).
comp_not(0, 1).

comp_xor(0, 0, 0).
comp_xor(0, 1, 1).
comp_xor(1, 0, 1).
comp_xor(1, 1, 0).

comp_nand(0, 0, 1).
comp_nand(0, 1, 1).
comp_nand(1, 0, 1).
comp_nand(1, 1, 0).

circuit(X, Y, Z) :-
	comp_not(X, NOTX),
	comp_nand(X, Y, NANDXY),
	comp_xor(NANDXY, NOTX, NOTZ),
	comp_not(NOTZ, Z).
