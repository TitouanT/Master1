-- ######################################################
-- # Titouan Teyssier -- TP6 : Les schémas de programme #
-- ######################################################

module TP6 where
import Data.Char
import TestCommon
import qualified TP5
import qualified TP3
tests = [
		test_somme_produit_longueur,
		test_tri_concatenate,
		test_norme_ecarttype_addone,
		test_parcours,
		test_somme_inc,
		test_matrice_creuse,
		test_mat_diagonal,
		test_mat_produit,
		test_chiffrement_cesar
	]

-- #################
-- # Q1 La Chauffe #
-- #################

-- ############################
-- # a) utilisation de reduce #
-- ############################

-- somme, produit et longueur
somme, produit, longueur :: (Num a) => [a] -> a
somme = foldr (\i acc -> acc + i) 0
produit = foldr (\i acc -> acc * i) 1
longueur = foldr (\_ acc -> acc + 1) 0

test_somme_produit_longueur = string_tuples [
		("somme [1,5,6]", 12, somme [1,5,6]),
		("somme [1,5,6,-11,-1]", 0, somme [1,5,6,-11,-1]),
		("somme []", 0, somme []),
		("produit [4,5,6]", 120, produit [4,5,6]),
		("produit [4,5,6,0]", 0, produit [4,5,6,0]),
		("produit []", 1, produit []),
		("longueur [4,5,6]", 3, longueur [4,5,6]),
		("longueur []", 0, longueur [])
	]

-- tri croissant
tri = foldr insere []
insere i [] = [i]
insere i (h:l)
	| i < h = i:h:l
	| otherwise = h:(insere i l)

-- concatenation
concatenate a b = foldr (\x conc -> x:conc) b a

test_tri_concatenate = string_tuples [
		("tri [-2,5,-10,12,5,4,3]", [-10,-2,3,4,5,5,12], tri [-2,5,-10,12,5,4,3]),
		("tri []", [], tri []),
		("concatenate []", [], tri []),
		("concatenate [1,2,3] [4,5,6]", [1,2,3,4,5,6], concatenate [1,2,3] [4,5,6]),
		("concatenate [] [4,5,6]", [4,5,6], concatenate [] [4,5,6])
	]

-- ################################
-- # b) norme, vect+1, ecart-type #
-- ################################

norme v = sqrt (foldr (\x s2 -> s2 + (x*x)) 0 v)
addone v = map (\x -> x+1) v
ecarttype v =
	let lon = longueur v
	in let moy = somme v / lon
	in sqrt ((1/lon) * (foldr (\x s -> s + ((x-moy)^2)) 0 v))

test_norme_ecarttype_addone = string_tuples [
		("norme [1,1]",sqrt 2,norme [1,1]),
		("norme [3,4]",5.0,norme [3,4]),
		("ecarttype [10,12]",1.0,ecarttype [10,12])
	] ++ string_tuples [
		("addone [7,2,3]", [8,3,4], addone [7,2,3])
	]

-- ###################################################
-- # c) réécriture des trois parcour d'arbre binaire #
-- ###################################################

-- parcours général
fold_arbre _ def TP5.ArbreVide = def
fold_arbre meth def (TP5.Noeud v g d) =
	let rg = fold_arbre meth def g
	in let rd = fold_arbre meth def d
	in meth v rg rd

-- les parcours
prefixe = fold_arbre (\v g d -> concatenate (v:g) d) []
infixe = fold_arbre (\v g d -> concatenate g (v:d)) []
postfixe = fold_arbre (\v g d -> concatenate g (concatenate d [v])) []


test_parcours = string_tuples [
		("prefixe TP5.figure1\n" ++ TP5.represente_ter TP5.figure1, TP5.prefixe TP5.figure1, prefixe TP5.figure1),
		("infixe TP5.figure1", TP5.infixe TP5.figure1, infixe TP5.figure1),
		("postfixe TP5.figure1", TP5.postfixe TP5.figure1, postfixe TP5.figure1),

		("prefixe TP5.figure2\n" ++ TP5.represente_ter TP5.figure1, TP5.prefixe TP5.figure2, prefixe TP5.figure2),
		("infixe TP5.figure2", TP5.infixe TP5.figure2, infixe TP5.figure2),
		("postfixe TP5.figure2", TP5.postfixe TP5.figure2, postfixe TP5.figure2),

		("prefixe TP5.figure3\n" ++ TP5.represente_ter TP5.figure1, TP5.prefixe TP5.figure3, prefixe TP5.figure3),
		("infixe TP5.figure3", TP5.infixe TP5.figure3, infixe TP5.figure3),
		("postfixe TP5.figure3", TP5.postfixe TP5.figure3, postfixe TP5.figure3)
	]

-- ######################################################
-- # d) somme et incrémentation des éléments d'un arbre #
-- ######################################################

arbre_somme = fold_arbre (\v g d -> v + g + d) 0
arbre_inc = fold_arbre (\v g d -> TP5.Noeud (v+1) g d) TP5.ArbreVide

test_somme_inc = string_tuples [
		("arbre_somme TP5.figure1", somme (infixe TP5.figure1), arbre_somme TP5.figure1),
		("arbre_somme TP5.figure2", somme (infixe TP5.figure2), arbre_somme TP5.figure2),
		("arbre_somme TP5.figure3", somme (infixe TP5.figure3), arbre_somme TP5.figure3),

		("arbre_somme (arbre_inc TP5.figure1)\n" ++ TP5.represente_ter TP5.figure1 ++ TP5.represente_ter (arbre_inc TP5.figure1), somme (addone (infixe TP5.figure1)), arbre_somme (arbre_inc TP5.figure1)),
		("arbre_somme (arbre_inc TP5.figure2)\n" ++ TP5.represente_ter TP5.figure2 ++ TP5.represente_ter (arbre_inc TP5.figure2), somme (addone (infixe TP5.figure2)), arbre_somme (arbre_inc TP5.figure2)),
		("arbre_somme (arbre_inc TP5.figure3)\n" ++ TP5.represente_ter TP5.figure3 ++ TP5.represente_ter (arbre_inc TP5.figure3), somme (addone (infixe TP5.figure3)), arbre_somme (arbre_inc TP5.figure3))
	]

-- ######################
-- # Q2 Les sous listes #
-- ######################

sous_liste :: [a] -> [[a]]
sous_liste = foldr (\i acc -> acc ++ (map (\item -> i:item) acc)) [[]]

test_sous_liste = string_tuples [
		("sous_liste [1,2,3]",[[],[3],[2],[2,3],[1],[1,3],[1,2],[1,2,3]],sous_liste [1,2,3])
	]

-- ###########################
-- # Q3 Les Matrices creuses #
-- ###########################
transpose ((lines, columns), points) =
	((columns, lines), map (\((i,j),w) -> ((j,i), w)) points)

addition ((la, ca),a) ((lb, cb),b)
	| la /= lb || ca /= cb = error "pas les même dimension"
	| otherwise = ((la, ca), points)
	where points = foldl addpoint b a

addpoint [] point = [point]
addpoint (h:t) point
	| d == dh = if newval == 0 then t else (d, newval):t
	| otherwise = h:(addpoint t point)
	where
		(d, v) = point
		(dh,vh) = h
		newval = v+vh

example = ((4,6), [((1,3),7),((1,6),4),((4,2),5)])
mat_4_6 = ((4,6), [((1,5),-2),((1,6),-4),((4,2),-10)])

test_matrice_creuse = string_tuples [
		("transpose example", ((6,4), [((3,1),7),((6,1),4),((2,4),5)]), transpose example),
		("transpose mat_4_6", ((6,4), [((5,1),-2),((6,1),-4),((2,4),-10)]), transpose mat_4_6),
		("addition mat_4_6 example", ((4,6),[((1,3),7),((4,2),-5),((1,5),-2)]), addition mat_4_6 example)
	]

-- #############################
-- # Q4 Matrice Fonctionnelles #
-- #############################
mat_diagonale mat = mat_diagonale_ mat 1
mat_diagonale_ mat n
	| success = val:(mat_diagonale_ mat (n+1))
	| otherwise = []
	where (success, val) = mat n n

test_mat_diagonal = string_tuples [
		("mat_diagonale TP3.example", [3,6,9,12,15], mat_diagonale TP3.example),
		("mat_diagonale (TP3.createIdent 4 4)", [1,1,1,1], mat_diagonale (TP3.createIdent 4 4))
	]

mat_produit a b
	| ca /= lb = TP3.mat_NULL
	| otherwise = TP3.createMat la cb (\l c -> mat_produit_elem a b ca l c)
	where
		(la, ca) = TP3.dim a
		(lb, cb) = TP3.dim b

mat_produit_elem a b 0 l c = 0
mat_produit_elem a b n l c =
	(snd (a l n)) * (snd (b n c)) + mat_produit_elem a b (n-1) l c

test_mat_produit = string_tuples [
		("TP3.repr (mat_produit TP3.example (TP3.createMat 5 3 (\\i j -> i+j)))", [[110,135,160],[150,185,220],[190,235,280],[230,285,340],[270,335,400],[310,385,460]], TP3.repr (mat_produit TP3.example (TP3.createMat 5 3 (\i j -> i+j)))),
		("TP3.repr (mat_produit TP3.example (TP3.createIdent 5 5))", [[3,4,5,6,7],[5,6,7,8,9],[7,8,9,10,11],[9,10,11,12,13],[11,12,13,14,15],[13,14,15,16,17]], TP3.repr (mat_produit TP3.example (TP3.createIdent 5 5)))
	]

-- ##############################
-- # Q5 Le Chiffrement de César #
-- ##############################

nb_occ msg = foldl (\count word -> foldl nb_occ_add_letter count word) [] msg

nb_occ_add_letter [] l = [(l, 1)]
nb_occ_add_letter (h:t) l
	| l == fst h = (l, snd h + 1):t
	| otherwise = h:(nb_occ_add_letter t l)

freq msg = map (\(l,lc) -> (l, lc/n)) count
	where
		count = nb_occ msg
		n = foldl (\total (_,c) -> total + c) 0 count

trouve_cle msg = ord mostfrequent - ord 'E'
	where (mostfrequent, _) = foldl (\(ml, mc) (l, c) -> if c > mc then (l,c) else (ml, mc)) ('@', -1) (freq msg)

dechiffre msg =
	map (\word -> map (\c -> chr (mod (ord c - a - key) 26 + a)) word) msg
	where
		key = trouve_cle msg
		a = ord 'A'

test_chiffrement_cesar = string_tuples [
		("dechiffre ['NBSDIF', 'TJ', 'WPUSF', 'NFTTBHF', 'B', 'CFBVDPVQ', 'EF', 'F']", ["MARCHE","SI","VOTRE","MESSAGE","A","BEAUCOUP","DE","E"], dechiffre ["NBSDIF", "TJ", "WPUSF", "NFTTBHF", "B", "CFBVDPVQ", "EF", "F"])
	]


