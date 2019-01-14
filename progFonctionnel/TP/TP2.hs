-- ################################
-- # Titouan Teyssier TP2 Haskell #
-- ################################
module TP2 where
import TestCommon
tests = [
		test_somme,
		test_factorielle_non_terminal,
		test_factorielle_terminal,
		test_fibonnaci_non_terminal,
		test_fibonnaci_terminal,
		test_is_pow2_non_terminal,
		test_is_pow2_terminal,
		test_count_shuff,
		test_count_shuff_3,
		test_russe,
		test_ackerman,
		test_f91,
		test_knuth
	]


-- ######################
-- # q1 pour la chauffe #
-- ######################

-- fait la somme des entier de dans [0, n]
somme 0 = 0
somme n = n + somme (n-1)

test_somme = string_tuples [
		("somme 10", 55, (somme 10)),
		("somme 0", 0, (somme 0)),
		("somme 100", 5050, (somme 100))
	]

-- ####################
-- # q2 les classique #
-- ####################

-- a) factorielle recursive non terminal

factorielle_non_terminal 0 = 1
factorielle_non_terminal n = n * factorielle_non_terminal (n-1)

factorielle_non_terminal_cpt 0 = 0
factorielle_non_terminal_cpt n = 1 + factorielle_non_terminal_cpt (n-1)

test_factorielle_non_terminal = string_tuples [
		("factorielle_non_terminal 0", 1, (factorielle_non_terminal 0)),
		("factorielle_non_terminal 1", 1, (factorielle_non_terminal 1)),
		("factorielle_non_terminal 5", 120, (factorielle_non_terminal 5)),
		("factorielle_non_terminal_cpt 0", 0, (factorielle_non_terminal_cpt 0)),
		("factorielle_non_terminal_cpt 1", 1, (factorielle_non_terminal_cpt 1)),
		("factorielle_non_terminal_cpt 5", 5, (factorielle_non_terminal_cpt 5))
	]


-- b) factorielle recursive terminal

factorielle_terminal n = factorielle_terminal_helper n 1
factorielle_terminal_helper 0 res = res
factorielle_terminal_helper n res = factorielle_terminal_helper (n-1) (res*n)

factorielle_terminal_cpt 0 = 0
factorielle_terminal_cpt n = 1 + factorielle_terminal_cpt (n-1)

test_factorielle_terminal = string_tuples [
		("factorielle_terminal 0", 1, (factorielle_terminal 0)),
		("factorielle_terminal 1", 1, (factorielle_terminal 1)),
		("factorielle_terminal 5", 120, (factorielle_terminal 5)),
		("factorielle_terminal_cpt 0", 0, (factorielle_terminal_cpt 0)),
		("factorielle_terminal_cpt 1", 1, (factorielle_terminal_cpt 1)),
		("factorielle_terminal_cpt 5", 5, (factorielle_terminal_cpt 5))
	]



-- #############################
-- # même chose avec fibonnaci #
-- #############################

-- fibonnaci recursive non terminal

fibonnaci_non_terminal 0 = 0
fibonnaci_non_terminal 1 = 1
fibonnaci_non_terminal n =
	fibonnaci_non_terminal (n-1) + fibonnaci_non_terminal (n-2)

fibonnaci_non_terminal_cpt 0 = 0
fibonnaci_non_terminal_cpt 1 = 0
fibonnaci_non_terminal_cpt n =
	2 + fibonnaci_non_terminal_cpt (n-1) + fibonnaci_non_terminal_cpt (n-2)

test_fibonnaci_non_terminal = string_tuples [
		("fibonnaci_non_terminal 0", 0, (fibonnaci_non_terminal 0)),
		("fibonnaci_non_terminal 1", 1, (fibonnaci_non_terminal 1)),
		("fibonnaci_non_terminal 10", 55, (fibonnaci_non_terminal 10)),
		("fibonnaci_non_terminal_cpt 0", 0, (fibonnaci_non_terminal_cpt 0)),
		("fibonnaci_non_terminal_cpt 1", 0, (fibonnaci_non_terminal_cpt 1)),
		("fibonnaci_non_terminal_cpt 10", 176, (fibonnaci_non_terminal_cpt 10))
	]


-- fibonnaci recursive terminal

fibonnaci_terminal n = fibonnaci_terminal_helper (-1) 1 n
fibonnaci_terminal_helper a b 0 = a + b
fibonnaci_terminal_helper a b n = fibonnaci_terminal_helper b (a+b) (n-1)

fibonnaci_terminal_cpt 0 = 0
fibonnaci_terminal_cpt n = 1 + fibonnaci_terminal_cpt (n-1)

test_fibonnaci_terminal = string_tuples [
		("fibonnaci_terminal 0", 0, (fibonnaci_terminal 0)),
		("fibonnaci_terminal 1", 1, (fibonnaci_terminal 1)),
		("fibonnaci_terminal 10", 55, (fibonnaci_terminal 10)),
		("fibonnaci_terminal_cpt 0", 0, (fibonnaci_terminal_cpt 0)),
		("fibonnaci_terminal_cpt 1", 1, (fibonnaci_terminal_cpt 1)),
		("fibonnaci_terminal_cpt 10", 10, (fibonnaci_terminal_cpt 10))
	]


-- ###########################
-- # même chose avec is_pow2 #
-- ###########################

-- is_pow2 recursive non terminal
-- note: je n'ai pas trouvé de réel version non terminal
-- celle ci l'est mais seulement en modifiant légèrement la version terminal
-- elle n'est pas réellement terminal car le résultat de l'appel récursif ne recoit aucune modification
is_pow2_non_terminal 0 = False
is_pow2_non_terminal 1 = True
is_pow2_non_terminal n = is_pow2_non_terminal (div n 2) && mod n 2 == 0


is_pow2_non_terminal_cpt n
	| n < 2 = 0
	| otherwise = 1 + is_pow2_non_terminal_cpt (div n 2)

test_is_pow2_non_terminal = (string_tuples [
		("is_pow2_non_terminal 0", False, (is_pow2_non_terminal 0)),
		("is_pow2_non_terminal 1", True, (is_pow2_non_terminal 1)),
		("is_pow2_non_terminal 2", True, (is_pow2_non_terminal 2)),
		("is_pow2_non_terminal 3", False, (is_pow2_non_terminal 3)),
		("is_pow2_non_terminal 4", True, (is_pow2_non_terminal 4)),
		("is_pow2_non_terminal 128", True, (is_pow2_non_terminal 128)),
		("is_pow2_non_terminal 255", False, (is_pow2_non_terminal 255))
	]) ++ (string_tuples [
		("is_pow2_non_terminal_cpt 0", 0, (is_pow2_non_terminal_cpt 0)),
		("is_pow2_non_terminal_cpt 1", 0, (is_pow2_non_terminal_cpt 1)),
		("is_pow2_non_terminal_cpt 2", 1, (is_pow2_non_terminal_cpt 2)),
		("is_pow2_non_terminal_cpt 5", 2, (is_pow2_non_terminal_cpt 5)),
		("is_pow2_non_terminal_cpt 10", 3, (is_pow2_non_terminal_cpt 10)),
		("is_pow2_non_terminal_cpt 20", 4, (is_pow2_non_terminal_cpt 20)),
		("is_pow2_non_terminal_cpt 40", 5, (is_pow2_non_terminal_cpt 40)),
		("is_pow2_non_terminal_cpt 80", 6, (is_pow2_non_terminal_cpt 80)),
		("is_pow2_non_terminal_cpt 160", 7, (is_pow2_non_terminal_cpt 160))
	])

-- is_pow2 recursive terminal

is_pow2_terminal 0 = False
is_pow2_terminal 1 = True
is_pow2_terminal n
	| mod n 2 == 1 = False
	| otherwise = is_pow2_terminal (div n 2)

is_pow2_terminal_cpt n
	| n < 2 || mod n 2 == 1 = 0
	| otherwise = 1 + is_pow2_terminal_cpt (div n 2)

test_is_pow2_terminal = (string_tuples [
		("is_pow2_terminal 0", False, (is_pow2_terminal 0)),
		("is_pow2_terminal 1", True, (is_pow2_terminal 1)),
		("is_pow2_terminal 2", True, (is_pow2_terminal 2)),
		("is_pow2_terminal 3", False, (is_pow2_terminal 3)),
		("is_pow2_terminal 4", True, (is_pow2_terminal 4)),
		("is_pow2_terminal 128", True, (is_pow2_terminal 128)),
		("is_pow2_terminal 255", False, (is_pow2_terminal 255))
	]) ++ (string_tuples [
		("is_pow2_terminal_cpt 0", 0, (is_pow2_terminal_cpt 0)),
		("is_pow2_terminal_cpt 1", 0, (is_pow2_terminal_cpt 1)),
		("is_pow2_terminal_cpt 2", 1, (is_pow2_terminal_cpt 2)),
		("is_pow2_terminal_cpt 5", 0, (is_pow2_terminal_cpt 5)),
		("is_pow2_terminal_cpt 10", 1, (is_pow2_terminal_cpt 10)),
		("is_pow2_terminal_cpt 20", 2, (is_pow2_terminal_cpt 20)),
		("is_pow2_terminal_cpt 40", 3, (is_pow2_terminal_cpt 40)),
		("is_pow2_terminal_cpt 80", 4, (is_pow2_terminal_cpt 80)),
		("is_pow2_terminal_cpt 160", 5, (is_pow2_terminal_cpt 160))
	])

-- ##############
-- # Q3 Shuffle #
-- ##############

-- raisonnement:
-- f(n, 0) = 1
-- f(0, n) = 1
-- f(n, m) = somme pour i allant de 0 à n de f(i, m-1)
-- f(n, m) = (somme pour i allant de 0 à (n-1) de f(i, m-1)) + f(n, m-1)
-- f(n, m) = f(n-1, m) + f(n, m-1)

count_shuff 0 _ = 1
count_shuff _ 0 = 1
count_shuff l r = count_shuff l (r-1) + count_shuff (l-1) r

test_count_shuff = string_tuples [
		("count_shuff 0 0", 1, (count_shuff 0 0)),
		("count_shuff 5 0", 1, (count_shuff 5 0)),
		("count_shuff 0 5", 1, (count_shuff 0 5)),
		("count_shuff 3 2", 10, (count_shuff 3 2)),
		("count_shuff 3 3", 20, (count_shuff 3 3))
	]

-- raisonnement:
-- une fois qu'on a mélanger deux paquet de taille a et b, on a un paquet
-- de taille a + b
-- f(a,b) nous donne le nombre de paquet de taille a+b que l'on peut former
-- à partir de deux paquet de taille a et b donné
-- f(a+b, c) nous donne le nombre de paquet que l'on peut former avec UN
-- paquet de taille a+b et le paquet de taille c donné
-- on a donc f(a,b) * f(a+b, c) paquet possible
count_shuff_3 a b c = count_shuff a b * count_shuff (a+b) c

test_count_shuff_3 = string_tuples [
		("count_shuff_3 0 0 0", 1, (count_shuff_3 0 0 0)),
		("count_shuff_3 5 0 2", 21, (count_shuff_3 5 0 2)),
		("count_shuff_3 0 5 1", 6, (count_shuff_3 0 5 1)),
		("count_shuff_3 3 3 0", 20, (count_shuff_3 3 3 0)),
		("count_shuff_3 3 2 5", 2520, (count_shuff_3 3 2 5)),
		("count_shuff_3 5 3 2", 2520, (count_shuff_3 5 3 2))
	]

-- ###########################
-- # Q4 Multiplication Russe #
-- ###########################


-- multiplication russe étendu à tout nombre entier
russe x y
	| x < 0 = russe (-x) y
	| y < 0 = russe x (-y)
	| x == 0 = 0
	| mod x 2 == 0 = div x 2 * 2 * y
	| otherwise = div (x-1) 2 * 2 * y + y

test_russe = string_tuples [
		("russe 0 0", 0, russe 0 0),
		("russe 2 2", 4, russe 2 2),
		("russe 7 5", 35, russe 7 5),
		("russe 31 10", 310, russe 31 10)
	]



-- ##########################
-- # Q5 Fonctions rigolotes #
-- ##########################

-- la fonction d'ackerman
ackerman m n
	| m == 0 = n + 1
	| n == 0 = ackerman (m-1) 1
	| otherwise = ackerman (m-1) (ackerman m (n-1))

test_ackerman = string_tuples [
		("ackerman 0 0", 1, ackerman 0 0),
		("ackerman 2 2", 7, ackerman 2 2),
		("ackerman 3 2", 29, ackerman 3 2),
		("ackerman 3 4", 125, ackerman 3 4)
	]

-- la fonction f91 de McCarthy
f91 n
	| n > 100 = n - 10
	| otherwise = f91 (f91 (n+11))

test_f91 = string_tuples [
		("f91 0", 91, f91 0),
		("f91 2", 91, f91 2),
		("f91 70", 91, f91 70),
		("f91 115", 105, f91 115),
		("f91 100", 91, f91 100),
		("f91 102", 92, f91 102)
	]

-- Les puissance Itérées de Knuth
knuth n a b
	| a == 0 = 0
	| n == 0 = 1
	| n == 1 = a^b
	| b == 0 = 1
	| otherwise = knuth (n-1) a (knuth n a (b-1))

test_knuth = string_tuples [
		("knuth 0 0 0", 0, knuth 0 0 0),
		("knuth 2 2 2", 4, knuth 2 2 2),
		("knuth 1 7 5", 16807, knuth 1 7 5),
		("knuth 2 3 2", 27, knuth 2 3 2)
	]
