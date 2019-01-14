-- ###########################################################
-- # Titouan Teyssier -- TP4 : Types structurés : les Listes #
-- ###########################################################

module TP4 where
import TestCommon
tests = [
		test_chauffe_reduction,
		test_chauffe_liste,
		test_max,
		test_intervalle,
		test_pref_suf,
		test_inferieur,
		test_conjugue,
		test_lyndon,
		test_insertion,
		test_fusion,
		test_genere
	]


-- #################
-- # Q1 La chauffe #
-- #################

somme [] = 0
somme (h:t) = h + somme t

produit [] = 1
produit (h:t) = h * produit t

len [] = 0
len l = 1 + len (tail l)

test_chauffe_reduction = string_tuples [
		("somme [5..8]", 26, somme [5..8]),
		("somme []", 0, somme []),
		("produit [3..5]", 60, produit [3..5]),
		("produit []", 1, produit []),
		("len [5..15]", 11, len [5..15]),
		("len []", 0, len [])
	]

insert elt [] = [elt]
insert elt list
	| elt < h = elt:list
	| otherwise = h:(insert elt t)
	where h:t = list

sort l = sort_helper l []
sort_helper [] sorted = sorted
sort_helper (h:t) sorted = sort_helper t (insert h sorted)


concatenate [] b = b
concatenate (h:t) b = h:(concatenate t b)

inverse l = inverse_helper l []
inverse_helper [] l = l
inverse_helper (h:t) inv = inverse_helper t (h:inv)

test_chauffe_liste = string_tuples [
		("insert 5 []", [5], insert 5 []),
		("insert 5 [6]", [5,6], insert 5 [6]),
		("insert 5 [3]", [3,5], insert 5 [3]),
		("insert 5 [5]", [5,5], insert 5 [5]),
		("insert 10 [1,2,8,16,17]", [1,2,8,10,16,17], insert 10 [1,2,8,16,17]),
		("sort []", [], sort []),
		("sort [1]", [1], sort [1]),
		("sort [1,2]", [1,2], sort [1,2]),
		("sort [2,1]", [1,2], sort [2,1]),
		("sort [2,1,0]", [0,1,2], sort [2,1,0]),
		("sort [8,4,6,2,7,6,3,4,9]", [2,3,4,4,6,6,7,8,9], sort [8,4,6,2,7,6,3,4,9]),
		("concatenate [] []", [], concatenate [] []),
		("concatenate [1,2] []", [1,2], concatenate [1,2] []),
		("concatenate [1,2] [5,4]", [1,2,5,4], concatenate [1,2] [5,4]),
		("concatenate [] [5,4]", [5,4], concatenate [] [5,4]),
		("inverse []", [], inverse []),
		("inverse [2]", [2], inverse [2]),
		("inverse [1,2]", [2,1], inverse [1,2]),
		("inverse [1,2,3,4,5,6,7,8,9]", [9,8,7,6,5,4,3,2,1], inverse [1,2,3,4,5,6,7,8,9])

	]


-- ##############
-- # Q2 Les Max #
-- ##############

-- coupe en deux une liste, au maximum n élément dans la première
n_tail 0 l = ([],l)
n_tail n [] = ([],[])
n_tail n l = (h:heads, tail)
	where
		h:t = l
		(heads, tail) = n_tail (n-1) t


-- renvois les n plus grand élément d'une liste dans un tableau
max_n n l =
	let (firsts, t) = n_tail n l -- on coupe la liste en deux
	in max_n_helper (sort firsts) t -- et on lance la récursion avec comme premiers max, les premier élément de la liste

max_n_helper maxes [] = maxes -- quand on à épuisé la liste, alors les plus grands éléments sont dans maxes
max_n_helper maxes (h:t) =
	let _:newm = insert h maxes -- on insert le prochain élément dans la liste triée des max, on supprime ensuite le plus petit
	in max_n_helper newm t

-- definition de nos extracteur de maximum grace à max_n qui est plus généraliste
max_un l = let a:_     = max_n 1 l in  a
max_deux l   = let a:b:_   = max_n 2 l in (a, b)
max_trois l  = let a:b:c:_ = max_n 3 l in (a, b, c)

test_max = string_tuples [
		("max_un [1,2,3,5,8,7,4]", 8, max_un [1,2,3,5,8,7,4])
	] ++ string_tuples [
		("max_deux [1,2,3,5,8,7,4]", (7,8), max_deux [1,2,3,5,8,7,4])
	] ++ string_tuples [
		("max_trois [1,2,3,5,8,7,4]", (5,7,8), max_trois [1,2,3,5,8,7,4])
	]


-- ######################
-- # Q3 Les Intervalles #
-- ######################

intervalles_asc inf sup
	| inf == sup = [sup]
	| otherwise = inf:(intervalles_asc (inf+1) sup)


intervalles_des inf sup
	| inf == sup = [inf]
	| otherwise = sup:(intervalles_des inf (sup-1))

test_intervalle = string_tuples [
		("intervalles_asc 4 12", [4..12], intervalles_asc 4 12),
		("intervalles_des 4 12", reverse [4..12], intervalles_des 4 12)
	]



-- ###########################
-- # Q4 Préfixes et suffixes #
-- ###########################

-- propriété utilisé:
-- pref abc = ["", a, ab, abc] = "" + a * pref bc
-- pref  bc = [   "",  b,  bc] = "" + b * pref b
-- pref   c = [        "",  c] = "" + c * pref ""
-- pref  "" = [""]
prefixe [] = [[]]
prefixe (h:t) = []:(add_to_all h (prefixe t))

add_to_all _ [] = []
add_to_all elt (h:t) = (elt:h):(add_to_all elt t)

suffixe [] = [[]]
suffixe l = l:(suffixe (tail l))

test_pref_suf = string_tuples [
		("prefixe 'abcd'", ["", "a", "ab", "abc", "abcd"] , prefixe "abcd"),
		("suffixe 'abcd'", ["abcd", "bcd", "cd", "d", ""] , suffixe "abcd")
	]

-- ####################
-- # Q5 Mot de Lyndon #
-- ####################

 -- a) la fonction inférieur, test si le premier mot est plus petit que le second. NOTE: < fonctionne pour les chaine de caratctere
inferieur m n
	| n == "" = False -- "" est le plus petit mot, on ne peut donc pas être plus petit que lui
	| m == "" = True -- "" si on arrive ici alors m est forcément inférieur à n
	| hm == hn = inferieur tm tn -- m et n sont pour le moment égaux, on va voir les caractères suivant
	| otherwise = hm<hn -- pour finir si on a deux caractere différent alors on sait si m est plus petit
	where
		hm:tm = m
		hn:tn = n

test_inferieur = string_tuples [
		("inferieur '' ''", False, inferieur "" ""),
		("inferieur a ''", False, inferieur "a" ""),
		("inferieur '' a", True, inferieur "" "a"),
		("inferieur a a", False, inferieur "a" "a"),
		("inferieur a aa", True, inferieur "a" "aa"),
		("inferieur abcde abd", True, inferieur "abcde" "abd"),
		("inferieur abcde abc", False, inferieur "abcde" "abc")
	]

-- b) la fonction conjugue decoupe en deux morceau puis recole
conjugue m n = let (heads, tail) = n_tail (n-1) m in concatenate tail heads
test_conjugue = [
		("conjugue abcde 0", "abcde", conjugue "abcde" 0),
		("conjugue abcde 1", "abcde", conjugue "abcde" 1),
		("conjugue abcde 2", "bcdea", conjugue "abcde" 2),
		("conjugue abcde 3", "cdeab", conjugue "abcde" 3),
		("conjugue abcde 4", "deabc", conjugue "abcde" 4),
		("conjugue abcde 5", "eabcd", conjugue "abcde" 5),
		("conjugue abcde 6", "abcde", conjugue "abcde" 6),
		("conjugue '' 6", "", conjugue "" 6),
		("conjugue '' 0", "", conjugue "" 0)
	]

-- c) la fonction lyndon test si un mot est un mot de lyndon,
-- un mot de lyndon est un mot qui est plus grand que toutes
-- ses permutations circulaire
lyndon m = lyndon_helper m 2 (len m + 1)
lyndon_helper m i n
	| i >= n = True
	| not (inferieur m (conjugue m i)) = False
	| otherwise = lyndon_helper m (i+1) n

test_lyndon = string_tuples [
		("lyndon ''", True, lyndon ""),
		("lyndon 0", True, lyndon "0"),
		("lyndon 1", True, lyndon "1"),
		("lyndon 01", True, lyndon "01"),
		("lyndon 10", False, lyndon "10"),
		("lyndon 011", True, lyndon "011"),
		("lyndon 00101", True, lyndon "00101"),
		("lyndon 01011", True, lyndon "01011")
	]

-- d) inserer_liste_mot, insere une liste de mots non trié
-- dans une liste de mots trié
inserer_mot mot [] = [mot]
inserer_mot mot liste
	| h == mot = liste
	| inferieur h mot = h:(inserer_mot mot t)
	| otherwise = mot:liste
	where h:t = liste

inserer_liste_mot [] cible = cible
inserer_liste_mot source cible = inserer_liste_mot (tail source) (inserer_mot (head source) cible)
test_insertion = string_tuples [
		("inserer_liste_mot [ee,aa,cc] [bb, dd]", ["aa", "bb", "cc", "dd", "ee"], inserer_liste_mot ["ee","aa","cc"] ["bb", "dd"]),
		("inserer_liste_mot [] [bb, dd]", ["bb", "dd"], inserer_liste_mot [] ["bb", "dd"]),
		("inserer_liste_mot [ee,aa,cc] []", ["aa", "cc", "ee"], inserer_liste_mot ["ee","aa","cc"] [])
	]


-- e) fusion liste, créé une liste contenant tous les mots
-- de lyndon composé en prefixe par un mot de la première
-- liste, et en suffixe par un mot de la seconde.
fusion_liste_mot [] _ = []
fusion_liste_mot (h:t) l2 =
	concatenate (concat_to_all h l2) (fusion_liste_mot t l2)

concat_to_all mot [] = []
concat_to_all mot (h:t)
	| lyndon wordg = wordg:fu
	| otherwise = fu
	where
		wordg = concatenate mot h
		fu = concat_to_all mot t

test_fusion = string_tuples [
		("fusion_liste_mot [01, 10] [001, 011]", ["01011"], fusion_liste_mot ["01","10"] ["001","011"]),
		("fusion_liste_mot [001, 011] [01, 10]", ["00101"], fusion_liste_mot ["001","011"] ["01","10"])

	]

-- f) genere TOUS les mots de lyndon de longueur n (contrairement aux exemples du tp)
-- renvois une liste trié car la méthode d'insertion à besoin de trié pour supprimmer les doublons
genere 1 = ["0", "1"]
genere n = genere_helper 1 (n-1)

genere_helper _ 0 = []
genere_helper a b =
	inserer_liste_mot (fusion_liste_mot (genere a) (genere b)) (genere_helper (a+1) (b-1))


test_genere = string_tuples [
		("genere 1", ["0", "1"], genere 1),
		("genere 2", ["01"], genere 2),
		("genere 3", ["001", "011"], genere 3),
		("genere 4", ["0001", "0011", "0111"], genere 4),
		("genere 5", ["00001","00011","00101","00111","01011","01111"], genere 5)
	]

