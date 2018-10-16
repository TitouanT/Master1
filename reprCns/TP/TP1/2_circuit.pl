comp_not(1, 0).
comp_not(0, 1).

comp_xor(X, X, 0) :- !.
comp_xor(_, _, 1).

comp_nand(1, 1, 0) :- !.
comp_nand(_, _, 1).

