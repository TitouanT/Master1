egaux a b c d = a == b && b == c && c == d

max2 a b = if a > b then a else b
min2 a b = if a > b then b else a

max4 a b c d = max2 (max2 a b) (max2 c d) 
min4 a b c d = min2 (min2 a b) (min2 c d) 

dist a b = max2 (a-b) (b-a)
dist4 a b c d = dist a b + dist a c + dist a d
leplusloin a b c d =
	let dA = dist4 a b c d in
	let dB = dist4 b a c d in
	let dC = dist4 c a b d in
	let dD = dist4 d a b c in
	let maxDist = max4 dA dB dC dD in
	if maxDist == dA then a else if maxDist == dB then b else if maxDist == dC then c else d
	--case (max4 dA dB dC dD) of
	--	dA -> a
	--	dB -> b
	--	dC -> c
	--	_ -> d

main = do
	print "leplusloin 5 9 12 20"
	print (leplusloin 5 9 12 20)
	
