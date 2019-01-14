check s p2 p1 p50c p10c
	| s == 0 = True
	| s >= 200 &&   p2 > 0 = check (s - 200) (p2 - 1) p1 p50c p10c
	| s >= 100 &&   p1 > 0 = check (s - 100) p2 (p1 - 1) p50c p10c
	| s >= 50  && p50c > 0 = check (s -  50) p2 p1 (p50c - 1) p10c
	| s >= 10  && p10c > 0 = check (s -  10) p2 p1 p50c (p10c - 1)
	| otherwise = False

paye s p2 p1 p50c p10c
	| check s p2 p1 p50c p10c = paye_helper s p2 p1 p50c p10c 0 0 0 0
	| otherwise = (-1, -1, -1, -1)


paye_helper s p2 p1 p50c p10c np2 np1 np50c np10c
	| s == 0 = (np2, np1, np50c, np10c)
	| s >= 200 &&   p2 > 0 = paye_helper (s - 200) (p2 - 1) p1 p50c p10c (np2 + 1) np1 np50c np10c
	| s >= 100 &&   p1 > 0 = paye_helper (s - 100) p2 (p1 - 1) p50c p10c np2 (np1 + 1) np50c np10c
	| s >= 50  && p50c > 0 = paye_helper (s -  50) p2 p1 (p50c - 1) p10c np2 np1 (np50c + 1) np10c
	| s >= 10  && p10c > 0 = paye_helper (s -  10) p2 p1 p50c (p10c - 1) np2 np1 np50c (np10c + 1)

test s p2 p1 p50c p10c = 
	putStr ("paye " ++ show s ++ " euros avec " ++ show p2 ++ "x2, " ++ show p1 ++ "x1, " ++ show p50c ++ "x.5, " ++ show p10c ++ "x.1\n" ++ show (paye (floor (s * 100)) p2 p1 p50c p10c) ++ "\n")	

main = do
	test 10 5 0 0 100
	test 3.5 0 4 0 5
	test 4.5 2 4 1 5
