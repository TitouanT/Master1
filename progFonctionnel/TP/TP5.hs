-- #########################################################
-- # Titouan Teyssier -- TP5 Types structurés : les Arbres #
-- #########################################################

module TP5 where
import Text.Printf
import TestCommon
tests = [
		test_hauteur,
		test_transformation,

		test_abr_bien_forme,
		test_abr_insere,
		test_abr_from_liste,
		test_abr_to_liste,
		test_abr_tri,

		test_tas_bien_former,
		test_tas_insere,
		test_tas_from_liste,
		test_tas_to_liste,
		test_tas_tri
	]


-- ##########################
-- # Creation du type Arbre #
-- ##########################

data Arbre a = ArbreVide | Noeud a (Arbre a) (Arbre a) deriving (Show, Eq)
feuille v = Noeud v ArbreVide ArbreVide

-- mesure la hauteur d'un arbre
hauteur ArbreVide = -1
hauteur (Noeud v g d) = 1 + max (hauteur g) (hauteur d)

test_hauteur = string_tuples [
		("hauteur ArbreVide", -1, hauteur ArbreVide),
		("hauteur (Noeud 5 ArbreVide ArbreVide)", 0, hauteur (Noeud 5 ArbreVide ArbreVide)),
		("hauteur (feuille 5)", 0, hauteur (feuille 5)),
		("hauteur (Noeud 5 (feuille 1) ArbreVide)", 1, hauteur (Noeud 5 (feuille 1) ArbreVide))
	]


-- ####################
-- # Creation Prefixe #
-- ####################

-- Creation d'un arbre en rangeant les élément dans l'ordre prefixe (priorité à la racine, puis gauche, puis droit)
cree_prefix val = fst (cree_prefix_rec val)
cree_prefix_rec (0:rest) = (ArbreVide, rest)
cree_prefix_rec (root:rest) =
	let (g, tmpRest) = cree_prefix_rec rest
	in let (d, newRest) = cree_prefix_rec tmpRest
	in (Noeud root g d, newRest)

figure1 = cree_prefix [1,2,4,0,0,5,7,0,0,8,0,0,3,0,6,9,0,0,0]
figure2 = cree_prefix [27,12,5,0,0,19,17,0,0,24,0,0,43,36,0,0,77,0,0]
figure3 = cree_prefix [8,20,21,90,0,0,22,0,0,80,0,81,0,0,10,12,75,0,0,20,0,0,11,80,0,0,0]

-- ###########################
-- # Transformation en liste #
-- ###########################

-- prefixe
prefixe a = pre_rec a []
pre_rec ArbreVide res = res
pre_rec (Noeud v g d) res = v:(pre_rec g (pre_rec d res))

-- infixe
infixe a = in_rec a []
in_rec ArbreVide res = res
in_rec (Noeud v g d) res = in_rec g (v:(in_rec d res))

-- postfixe
postfixe a = post_rec a []
post_rec ArbreVide res = res
post_rec (Noeud v g d) res = post_rec g (post_rec d (v:res))

test_transformation = string_tuples [
		("prefixe figure1\n" ++ represente_ter figure1, [1,2,4,5,7,8,3,6,9], prefixe figure1),
		("infixe figure1", [4,2,7,5,8,1,3,9,6], infixe figure1),
		("postfixe figure1", [4,7,8,5,2,9,6,3,1], postfixe figure1)
	]


-- #############
-- # Affichage #
-- #############

represente_all_in_one tab = represente_all_in_one_ tab ""
represente_all_in_one_ [] res = res
represente_all_in_one_ (h:t) res = represente_all_in_one_ t (represente_colle res (represente_colle h "\n"))
-- Deux fonction importante:
--      + represente -> renvois un tableau contenant chaque ligne dans un tableau
--      + afficher -> fait l'affichage dans la console de l'arbre

-- Renvoi en tableau qui contient les ligne qui represente un arbre dans un format plus lisible
represente a = represente_all_in_one (represente_ a)
represente_ ArbreVide = []
represente_ (Noeud v g d) =
	let    repg = represente_shift (represente_ g) "|__" -- indentation de l'arbre gauche (la 1ere ligne sera marquée)
	in let repd = represente_shift (represente_ d) "|__" -- indentation de l'arbre droit (idem)
	in (show v):(represente_colle repg repd) -- concatenation des /s arbres et ajout de la racine au dessus

-- Ajoute un espace devant chaque ligne qui  représente un sous-arbre, afin de l'indenter
-- map...
represente_shift (h:t) s = (represente_colle s h):(represente_shift t "   ")
represente_shift [] _ = []

-- Concatene 2 tableau
-- concat...
represente_colle (h:t) l = h:(represente_colle t l)
represente_colle [] l = l


afficher a = printf (represente a)

-- afficher figure1
-- 1
-- |__2
--    |__4
--    |__5
--       |__7
--       |__8
-- |__3
--    |__6
--       |__9

-- ####################
-- # Affichage Avancé #
-- ####################

represente_bis a = represente_all_in_one (represente_bis_ a)
represente_bis_ ArbreVide = []
represente_bis_ (Noeud v g d) =
	let    repg = represente_shift_bis (represente_bis_ g) "|  " "   "-- indentation de l'arbre gauche (la 1ere ligne sera marquée)
	in let repd = represente_shift_bis (represente_bis_ d) "   " "|  "-- indentation de l'arbre droit (idem)
	in let root = '>':(show v)
	in let tmprepg = if repg == [] then root:repg else root:"|\n":repg
	in let newrepg = if repd == [] then tmprepg else "|\n":tmprepg
	in represente_colle repd newrepg -- concatenation des /s arbres et ajout de la racine au dessus

represente_shift_bis (h:t) enable disable
	| f == '>' = (represente_colle "+--" h):(represente_shift_bis t disable enable)
	| otherwise = (represente_colle enable h):(represente_shift_bis t enable disable)
	where (f:r) = h
represente_shift_bis [] _ _ = []

afficher_bis a = printf (represente_bis a)


represente_ter a = let (r, i, width, height) = represente_ter_ a in represente_all_in_one r
represente_ter_ ArbreVide = ([], 0, 0, 0)
represente_ter_ (Noeud v g d) =
	let (repv, repv_i, repv_w, repv_h) = showinbox v
	-- in let repv_w = length repv
	in let (repg, gi, gw, gh) = represente_ter_ g
	in let (repd, di, dw, dh) = represente_ter_ d
	in let child_h = max gh dh
	in let repg_padded = pad repg (pad "" ' ' gw) child_h
	in let repd_padded = pad repd (pad "" ' ' dw) child_h
	in let space_between = pad "" ' ' repv_w
	in let child_box = map (\(a, b) -> a++b) (zip repg_padded (map (\l -> space_between ++ l) repd_padded))
	in let child_w = gw + dw + repv_w
	in let linkg = if gw == 0 then "" else (pad "" ' ' (gi-1)) ++ '+':(pad "" '-' (gw-gi))
	in let linkg_= if gw == 0 then "" else (pad "" ' ' (gi-1)) ++ '|':(pad "" ' ' (gw-gi))
	in let linkd = if dw == 0 then "" else (pad "" '-' (di-1)) ++ '+':(pad "" ' ' (dw-di))
	in let linkd_= if dw == 0 then "" else (pad "" ' ' (di-1)) ++ '|':(pad "" ' ' (dw-di))
	in let top = map (\(a,b,c) -> a++b++c) (zip3 [pad "" ' ' gw, linkg, linkg_, linkg_] (repv ++ [space_between]) [pad "" ' ' dw, linkd, linkd_, linkd_])
	in (top++child_box, gw + repv_i, gw + dw + repv_w, child_h + repv_h + 1)

showinbox i =
	let stri = "# " ++ show i ++ " #"
	in let w = length stri
	in let side = pad "" '#' w
	in ([side, stri, side], 2, w, 3)
pad t e n = if n < 0 then pad_ t e (-n) else pad_ t e n
pad_ [] elt 0 = []
pad_ [] elt n = elt:(pad_ [] elt (n-1))
pad_ l elt 0 = l
pad_ (h:t) elt n = (h:pad_ t elt (n-1))

afficher_ter a = printf (represente_ter a)
-- afficher_ter a = printf (foldl (\lines l -> lines ++ l) "" (map (\line -> line ++ "\n") (represente_ter a)))

-- *TP5> afficher_ter figure2
--                              ######
--       +----------------------# 27 #-------+
--       |                      ######       |
--       |                                   |
--      ######                              ######
--  +---# 12 #-------+                 +----# 43 #-+
--  |   ######       |                 |    ###### |
--  |                |                 |           |
-- #####            ######            ######      ######
-- # 5 #       +----# 19 #-+          # 36 #      # 77 #
-- #####       |    ###### |          ######      ######
--             |           |
--            ######      ######
--            # 17 #      # 24 #
--            ######      ######


-- ###########################
-- # Les Arbres de Recherche #
-- ###########################

test fun v [] = True
test fun v (h:t) = fun v h && test fun v t

abr_bien_forme a = abr_bien_forme_ a [] []
abr_bien_forme_ ArbreVide _ _ = True
abr_bien_forme_ (Noeud v g d) infeq sup =
	test (<=) v infeq &&
	test (>) v sup &&
	abr_bien_forme_ g (v:infeq) sup &&
	abr_bien_forme_ d infeq (v:sup)

test_abr_bien_forme = string_tuples [
		("abr_bien_forme figure1\n" ++ represente_ter figure1, False, abr_bien_forme figure1),
		("abr_bien_forme figure2\n" ++ represente_ter figure2,  True, abr_bien_forme figure2),
		("abr_bien_forme figure3\n" ++ represente_ter figure3, False, abr_bien_forme figure3)
	]

-- b) insertion d'un élt dans un arbre
abr_insere v ArbreVide = feuille v
abr_insere v (Noeud e g d)
	| v <= e = (Noeud e (abr_insere v g) d)
	| otherwise = (Noeud e g (abr_insere v d))

test_abr_insere = string_tuples [
		("abr_insere 5 ArbreVide", Noeud 5 ArbreVide ArbreVide, abr_insere 5 ArbreVide),
		("abr_insere 5 (feuille 3)", Noeud 3 ArbreVide (feuille 5), abr_insere 5 (feuille 3)),
		("abr_insere 2 (feuille 3)", Noeud 3 (feuille 2) ArbreVide, abr_insere 2 (feuille 3))
	] ++ string_tuples [
		("abr_bien_forme (abr_insere 10 figure2)\n" ++ represente_ter figure2 ++ represente_ter (abr_insere 10 figure2), True, abr_bien_forme (abr_insere 10 figure2)),
		("abr_bien_forme (abr_insere 27 figure2)\n" ++ represente_ter figure2 ++ represente_ter (abr_insere 27 figure2), True, abr_bien_forme (abr_insere 27 figure2))
	]

-- c) insertion des élément de la liste dans un arbre
abr_from_liste [] = ArbreVide
abr_from_liste (h:t) = abr_insere h (abr_from_liste t)

test_abr_from_liste = string_tuples [
		("abr_from_liste [24,17,77,36,19,5,43,12,27]", figure2, abr_from_liste [24,17,77,36,19,5,43,12,27])
	]

-- d) la lecture infixe d'un abr donne une liste trié
abr_to_liste = infixe

test_abr_to_liste = string_tuples [
		("abr_to_liste figure2", [5,12,17,19,24,27,36,43,77], abr_to_liste figure2)
	]

-- e) tri d'un tableau
abr_tri l = abr_to_liste (abr_from_liste l)

test_abr_tri = string_tuples [
		("abr_tri (postfixe figure1)", [1,2,3,4,5,6,7,8,9], abr_tri (postfixe figure1)),
		("abr_tri (postfixe figure2)", [5,12,17,19,24,27,36,43,77], abr_tri (postfixe figure2)),
		("abr_tri (postfixe figure3)", [8,10,11,12,20,20,21,22,75,80,80,81,90], abr_tri (postfixe figure3)),
		("abr_tri [5,8,3,1,4,7,12,45,6]", [1,3,4,5,6,7,8,12,45], abr_tri [5,8,3,1,4,7,12,45,6])
	]

-- ###########
-- # Les Tas #
-- ###########


-- ##################
-- # Tas bien forme #
-- ##################
tas_bien_forme_local _ ArbreVide = True
tas_bien_forme_local v (Noeud e _ _) = v <= e
tas_bien_forme ArbreVide = True
tas_bien_forme (Noeud v g d) = tas_bien_forme_local v g && tas_bien_forme_local v d && ok_gauche_droite
	where ok_gauche_droite = tas_bien_forme g && tas_bien_forme d

test_tas_bien_former = string_tuples [
		("tas_bien_forme figure1\n" ++ represente_ter figure1, True, tas_bien_forme figure1),
		("tas_bien_forme figure2\n" ++ represente_ter figure2, False, tas_bien_forme figure2),
		("tas_bien_forme figure3\n" ++ represente_ter figure3, True, tas_bien_forme figure3)
	]


-- #########################
-- # Insertion dans un tas #
-- #########################

-- insertion dans un tas
-- 1) insertion dans à la place libre la moins profonde
--      1.a) trouver la place libre la moins profonde
--      1.b) inserer à la feuille la moins profonde
-- 2) percolation

profondeur_min ArbreVide = -1
profondeur_min (Noeud v g d) = 1 + min (profondeur_min g) (profondeur_min d)

tas_insere e ArbreVide = feuille e
tas_insere e tas = fst (tas_insere_ e tas (profondeur_min tas))
tas_insere_ _ ArbreVide _ = (ArbreVide, False)
tas_insere_ e (Noeud v ArbreVide d) 0
	| e < v = (Noeud e (feuille v) d, True)
	| otherwise = (Noeud v (feuille e) d, True)
tas_insere_ e (Noeud v g ArbreVide) 0
	| e < v = (Noeud e g (feuille v), True)
	| otherwise = (Noeud v g (feuille e), True)
tas_insere_ _ tas 0 = (tas, False)

tas_insere_ e tas n
	| gok && rg < r = (Noeud rg (Noeud r gg gd) d, True)
	| gok = (Noeud r gauche d, True)
	| dok && rd < r = (Noeud rd g (Noeud r dg dd), True)
	| dok = (Noeud r g droite, True)
	| otherwise = (tas, False)
	where
		(Noeud r g d) = tas
		(gauche, gok) = tas_insere_ e g (n-1)
		(droite, dok) = tas_insere_ e d (n-1)
		(Noeud rg gg gd) = gauche
		(Noeud rd dg dd) = droite

test_tas_insere = string_tuples [
		("tas_bien_forme (tas_insere 5 figure1)", True, tas_bien_forme (tas_insere 5 figure1)),
		("tas_bien_forme (tas_insere 5 figure3)", True, tas_bien_forme (tas_insere 5 figure3))
	]

-- #####################################
-- # Transformation d'une Liste en Tas #
-- #####################################
tas_from_liste [] = ArbreVide
tas_from_liste (h:l) = tas_insere h (tas_from_liste l)

test_tas_from_liste = string_tuples [
		("tas_bien_forme (tas_from_liste (prefixe figure1))\n" ++ represente_ter (tas_from_liste (prefixe figure1)), True,tas_bien_forme (tas_from_liste (prefixe figure1))),
		("tas_bien_forme (tas_from_liste (prefixe figure2))\n" ++ represente_ter (tas_from_liste (prefixe figure2)), True,tas_bien_forme (tas_from_liste (prefixe figure2))),
		("tas_bien_forme (tas_from_liste (prefixe figure3))\n" ++ represente_ter (tas_from_liste (prefixe figure3)), True,tas_bien_forme (tas_from_liste (prefixe figure3)))
	]
-- #####################################
-- # Transformation d'un Tas en Liste  #
-- #####################################
tas_get_min tas = let (Noeud min _ _) = tas in (min, tas_supr_root tas)
tas_supr_root tas =
	let (f, newtas) = tas_supr_feuille tas
	in let (Noeud val _ _) = f
	in tas_percole (tas_replace_root val newtas)

tas_supr_feuille tas = tas_supr_feuille_ tas (hauteur tas)
tas_supr_feuille_ (Noeud v ArbreVide ArbreVide) 0 = (feuille v, ArbreVide)
tas_supr_feuille_ tas 0 = (ArbreVide, tas)
tas_supr_feuille_ tas n
	| tas == ArbreVide = (ArbreVide, tas)
	| not (vg == ArbreVide) = (vg, Noeud v tg d)
	| not (vd == ArbreVide) = (vd, Noeud v g td)
	| otherwise = (ArbreVide, tas)
	where
		(Noeud v g d) = tas
		(vg, tg) = tas_supr_feuille_ g (n-1)
		(vd, td) = tas_supr_feuille_ d (n-1)

tas_replace_root v ArbreVide = ArbreVide
tas_replace_root v (Noeud _ g d) = Noeud v g d



tas_percole ArbreVide = ArbreVide
tas_percole tas
	| tas == ArbreVide = tas
	| g == ArbreVide && d == ArbreVide = tas
	| not (d == ArbreVide) && (g == ArbreVide || vg >= vd) && v > vd = (Noeud vd g (tas_percole (Noeud v dg dd)))
	| not (g == ArbreVide) && (d == ArbreVide || vd>=vg) && v > vg = (Noeud vg (tas_percole (Noeud v gg gd)) d)
	| otherwise = tas
	where
		(Noeud v g d) = tas
		(Noeud vg gg gd) = g
		(Noeud vd dg dd) = d

tas_to_liste ArbreVide = []
tas_to_liste tas =
	let (min, newTas) = tas_get_min tas
	in min:(tas_to_liste newTas)

test_tas_to_liste = string_tuples [
		("tas_to_liste figure1",[1,2,3,4,5,6,7,8,9],tas_to_liste figure1),
		("tas_to_liste figure3",[8,10,11,12,20,20,21,22,75,80,80,81,90],tas_to_liste figure3)
	]

-- ###################################
-- # Tri d'une Liste grace à un Tas  #
-- ###################################
tas_tri tab = tas_to_liste (tas_from_liste tab)
test_tas_tri = string_tuples [
		("tas_tri (postfixe figure1)", [1,2,3,4,5,6,7,8,9], tas_tri (postfixe figure1)),
		("tas_tri (postfixe figure2)", [5,12,17,19,24,27,36,43,77], tas_tri (postfixe figure2)),
		("tas_tri (postfixe figure3)", [8,10,11,12,20,20,21,22,75,80,80,81,90], tas_tri (postfixe figure3)),
		("tas_tri [5,8,3,1,4,7,12,45,6]", [1,3,4,5,6,7,8,12,45], tas_tri [5,8,3,1,4,7,12,45,6]),
		("tas_tri [4,5,7,8,3,4,9,6,8,12,14,22,0,4]", [0,3,4,4,4,5,6,7,8,8,9,12,14,22], tas_tri [4,5,7,8,3,4,9,6,8,12,14,22,0,4])
	]

