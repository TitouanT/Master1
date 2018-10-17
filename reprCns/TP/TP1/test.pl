range(Max, Max, Max) :-!.
range(Min,   _, Min).
range(Min, Max, X) :-
	Newmin is Min + 1,
	range(Newmin, Max, X).

rangeAlpha(Min, Max, L) :-
	char_code(Min, MinInt),
	char_code(Max, MaxInt),
	range(MinInt, MaxInt, LInt),
	char_code(L, LInt).

nextAlpha(L, NL) :-
	char_code(L, Li),
	NLi is Li + 1,
	char_code(NL, NLi).

grid(0, _, []) :- !.
grid(Lines, Cols, [FirstLine|Rest]) :-
	line(Cols, FirstLine),
	NewLines is Lines - 1,
	grid(NewLines, Cols, Rest).

line(0, []) :- !.
line(Length, [empty|Line]) :-
	NewLength is Length - 1,
	line(NewLength, Line).

printGrid([Head|Sub]) :-
	lineSep(Head, First, Middle, Last),
	printRuler(Head),
	write(First),
	printLine(Head),
	printGridHelper(Sub, Middle),
	write(Last).

printGridHelper([Line|Rest], Sep) :-
	write(Sep),
	printLine(Line),
	printGridHelper(Rest, Sep).
printRuler(List) :-
	writeMargin(),
	printRulerRec(List, a).

printRulerRec([_|List], L) :-
	writeMark(L),
	nextAlpha(L, NL).

% compute the line separators once and for all
lineSep(Line, First, Middle, Last) :-
	lineSepHelper(Line, '╔', '╤', '╗', '═',First),
	lineSepHelper(Line, '╟', '┼', '╢', '─', Middle),
	lineSepHelper(Line, '╚', '╧', '╝', '═', Last).

lineSepHelper([_|Tail], L, M, R, Inter, Result):-
	string_concat(L, Inter, Sofar),
	string_concat(M, Inter, NewM),
	lineSepRec(Tail, Sofar, NewM, R, Result).

lineSepRec([_|Tail], Sofar, M, R, Total) :-
	string_concat(Sofar, M, Further), 
	lineSepRec(Tail, Further, M, R, Total).

lineSepRec([], Sofar, _, R, Total) :-
	string_concat(Sofar, R, Total).
