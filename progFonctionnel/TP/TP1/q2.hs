main = do
	putStr "domino_check (2,3) (1,3) -> "
	print (domino_check (2,3) (1,3)) 
	putStr "domino_check (2,3) (1,4) -> "
	print (domino_check (2,3) (1,4)) 
	putStr ("domino_merge (2, 3) (1, 3) ->")
	print (domino_merge (2, 3) (1, 3))
	
	putStr "domino_check_3 (2,3) (2,4) (1,3)"
	print (domino_check_3 (2,3) (2,4) (1,3))
	putStr "domino_check_3 (2,3) (2,4) (1,2)"
	print (domino_check_3 (2,3) (2,4) (1,2))


domino_check (a, b) (c, d) = a == c || a == d || b == c || b == d

domino_merge (a, b) (c, d)
		|a==c = (b, d)
		|a==d = (b, c)
		|b==c = (a, d)
		|b==d = (a, c)

domino_check_3_helper a b c = domino_check a b && domino_check (domino_merge a b) c
domino_check_3 a b c =
	domino_check_3_helper a b c ||
	domino_check_3_helper a c b ||
	domino_check_3_helper b c a
