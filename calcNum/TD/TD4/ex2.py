import numpy.random as rnd

def guessUser(a, b):
	return int(input("\nvotre paris({},{}): ".format(a,b)))

def guessRandom(a, b):
	return rnd.randint(a, b)

def guessMiddle(a, b):
	return a+(b-a)//2

def play(guess, a=0, b=100, choice=None):
	print("A play by", guess.__name__)
	if not choice:
		choice = rnd.randint(a, b)
	g = guess(a, b)
	while (g != choice):
		if g < choice:
			print(g, "est trop petit !")
			if g >= a:
				a = g+1
		else:
			print(g, "est trop grand !")
			if g < b:
				b = g
		g = guess(a, b)
	print(g, "c'est gagné !\n\n")

play(guessUser)
play(guessRandom)
play(guessMiddle)
