-- ########
-- # QTP1 #
-- ########
f91 n
	| n > 100 = n - 10
	| otherwise = f91(f91(n+11))

-- ########
-- # QTP2 #
-- ########
som_4 a b c d = a + b + c + d
som_l [] = 0
som_l (h:t) = h + som_l t
myfoldr _ acc [] = acc
myfoldr f acc (h:t) = f h (myfoldr f acc t)
som_lf l = myfoldr (\e acc -> e + acc) 0 l
-- test_concat a b = myfoldr (:) b a

-- ########
-- # QTP3 #
-- ########
inc_4 (a,b,c,d) = (a+1,b+1,c+1,d+1)
inc_l [] = []
inc_l (h:t) = (h+1):(inc_l t)
mymap _ [] = []
mymap f (h:t) = (f h):(mymap f t)
inc_lm l = map (\e -> e+1) l

-- ########
-- # QPB1 #
-- ########
intervalle_asc inf sup
	| inf >= sup = []
	| otherwise = inf:(intervalle_asc (inf + 1) sup)

-- ########
-- # QPB2 #
-- ########
longueur [] = 0
longueur (_:t) = 1 + longueur t

-- ########
-- # QPB3 #
-- ########
prefixes [] = [[]]
prefixes (h:t) = []:(map (\pref -> h:pref) (prefixes t))

-- ########
-- # QPB4 #
-- ########
partition_helper n 0 = [(n, 0)]
partition_helper a b = (a,b):(partition_helper (a+1) (b-1))

partition n = if n >= 0 then partition_helper 0 n
	else map (\(a,b) -> (-a,-b)) (partition_helper 0 (-n))

-- ########
-- # QPB5 #
-- ########
ote_debut l [] = l
ote_debut [] _ = []
ote_debut (_:l) (_:t) = ote_debut l t

-- ########
-- # QPB6 #
-- ########
suffixes [] = [[]]
suffixes l = l:(suffixes (tail l))
decoupe l = zip (prefixes l) (suffixes l)

