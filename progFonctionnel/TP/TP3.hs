-- ################################
-- # Titouan Teyssier TP3 Haskell #
-- ################################
module TP3 where
import TestCommon
tests = [
		test_somme_terme,
		test_inv100,
		test_somme_terme,
		test_est_parfait,
		test_app_itere,
		test_matrice,
		test_matrice_dim
	]




-- #####################
-- # Q1 Somme et Série #
-- #####################

-- une fonction qui prend en parametre une suite et un entier qui
-- renvois la somme des n+1 premier termes de la suite.
somme_terme suite n = somme_terme_rec suite 0 n

somme_terme_rec suite i target
	| i == target = suite i
	| otherwise = suite i + somme_terme_rec suite (i+1) target

-- la suite des entiers
suite_entier i = i

-- suite qui alterne
suite_alter i
	| i == 0 = 1
	| otherwise = (-1)^i * (i+1)

inv100 x = somme_terme (\i -> (1-x)^i) 100

test_somme_terme = string_tuples [
		("somme_terme suite_entier 100", 5050, somme_terme suite_entier 100),
		("somme_terme (\\x -> if (mod x 2 == 0) then 0 else x) 10", 25, somme_terme (\x -> if (mod x 2 == 0) then 0 else x) 10),
		("somme_terme suite_alter 98", 50, somme_terme suite_alter 98)
	]

test_inv100 = string_tuples [("inv100 0.5", 2.0, inv100 0.5)]





-- #######################
-- # Q2 Nombres Parfaits #
-- #######################

-- caclcul la somme des élément respectant une condition parmi les n+1 premier
-- élément
somme_filtre test suite n = somme_terme (\i -> if test i then suite i else 0) n
somme_filtre_pair n = somme_filtre (\i -> mod i 2 == 0) suite_entier n

test_somme_filtre = string_tuples [
		("somme_filtre_pair 10", 30, somme_filtre_pair 10),
		("somme_filtre (\\i -> mod i 2 == 1) 10", 25, somme_filtre_pair 10)
	]

est_parfait 0 = False
est_parfait n = n*2 == somme_filtre (\i -> i > 0 && mod n i == 0) suite_entier n

test_est_parfait = string_tuples [
		("est_parfait 6", True, est_parfait 6),
		("est_parfait 28", True, est_parfait 28),
		("est_parfait 496", True, est_parfait 496),
		("est_parfait 8128", True, est_parfait 8128),
		("est_parfait 42", False, est_parfait 42),
		("est_parfait 72", False, est_parfait 72),
		("est_parfait 5", False, est_parfait 5)
	]





-- #########################
-- # Q3 Application itérée #
-- #########################

-- quand on applique 0 fois la fonction sur une valeur, alors c'est comme
-- la fonction identité
-- regle de recurrence f^n[x] = f[f^(n-1)[x]]
applyn _ 0 x = x
applyn f n x = f (applyn f (n-1) x)

-- utilisation d'une fonction anonyme qui à accès au scope supérieur
power x 0 = 1
power x n = applyn (\i -> i * x) (n-1) x

test_app_itere = string_tuples [
		("applyn (\\x -> x + 1) 5 10", 15, applyn (\x -> x + 1) 5 10),
		("power 3 3", 3^3, power 3 3),
		("power 5 1", 5, power 5 1),
		("power 5 0", 1, power 5 0),
		("power 0 2", 0, power 0 2)
	]


-- ##############################
-- # Q4 Matrices fonctionnelles #
-- ##############################

-- créé une matrice de taille nLines x nCols remplis avec la fonction calc
createMat nLines nCols calc =
	(\line col ->
		if line<1 || line>nLines || col<1 || col>nCols then (False, 0)
		else (True, calc line col)
	)

-- créé la matrice "identité" (on accepte les matrice non carré)
createIdent line col = createMat line col (\i j -> if i==j then 1 else 0)


-- création de l'exemple
example = createMat 6 5 (\i j -> 2*i + j)

-- création de la matrice identite 4x4
identite_4_4 = createIdent 4 4

-- et de la matrice null
mat_NULL l c = (False, 0)

-- calcul de la dimension d'une matrice
dim mat = (dim_line mat, dim_col mat)
dim_line mat = dim_mono mat (\i -> mat i 1)
dim_col mat = dim_mono mat (\i -> mat 1 i)

dim_mono mat extract = dim_mono_rec mat extract 1
dim_mono_rec mat extract i
	| success = dim_mono_rec mat extract (i+1)
	| otherwise = i-1
	where (success, _) = extract i


-- addition de deux matrice de même taille
add_mat matA matB
	| la /= lb || ca /= cb = mat_NULL
	| otherwise = createMat la ca (\l c -> snd (matA l c) + snd (matB l c))
	where
		(la, ca) = dim matA
		(lb, cb) = dim matB

-- test avec deux matrice de taille differente
qe_mat_should_be_null = add_mat example identite_4_4

-- test avec l'example et la matrice identité de mm taille
(lexp, cexp) = dim example
identite_same_size = createIdent lexp cexp

ex_plus_ident = add_mat example identite_same_size

-- repr mat = "[" ++ (map (\line -> "["++(foldl (\acc x -> acc ++ (show x) ++ ",") "" line)++"]") (to_real_mat mat)) ++ "]"

to_real_line mat l 0 _ _= []
to_real_line mat l c il ic = (snd (mat il ic)):(to_real_line mat l (c-1) il (ic+1))
to_real_mat_helper mat 0 c _ _= []
to_real_mat_helper mat l c il ic = (to_real_line mat l c il ic):(to_real_mat_helper mat (l-1) c (il+1) ic)
repr mat = let (l, c) = dim mat in to_real_mat_helper mat l c 1 1


test_matrice = string_tuples [
		("createMat 6 5 (\\i j -> 2*i + j)", [[3,4,5,6,7],[5,6,7,8,9],[7,8,9,10,11],[9,10,11,12,13],[11,12,13,14,15],[13,14,15,16,17]], repr (createMat 6 5 (\i j -> 2*i + j))),
		("createIdent 4 4", [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]], repr (createIdent 4 4)),
		("add_mat example identite_4_4", repr mat_NULL, repr qe_mat_should_be_null),
		("add_mat example identite_same_size", [[4,4,5,6,7],[5,7,7,8,9],[7,8,10,10,11],[9,10,11,13,13],[11,12,13,14,16],[13,14,15,16,17]], repr ex_plus_ident)
	]


test_matrice_dim = string_tuples [
		("dim example", (6,5), dim example),
		("dim identite_4_4", (4,4), dim identite_4_4),
		("dim mat_NULL", (0,0), dim mat_NULL),
		("dim identite_same_size", (6,5), dim identite_same_size),
		("dim ex_plus_ident", (6,5), dim identite_same_size)
	]
