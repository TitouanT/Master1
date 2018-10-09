# ecrire un programme en python

def main():
	dic = {}
	#n = int(input("cb de lignes ? "))
	with open("/info/etu/m1/s146292/code/calcNum/TD/TD1/dict.txt", "r") as f:
		for line in f.readlines():
			afficherLigne(line)
			stocker(line, dic)

	afficherAll(input("mot ? ").strip(), dic)


	afficherMots("e t y d j A~", dic)
	#afficherMots("k u l e", dic)



def afficherLigne(line):
	print(line, end='')

def stocker(line, dic):
	key, *val = line.split(';')
	dic[key.strip()] = [v.strip() for v in val]

def afficherAll(mot, dic):
	afficherIPA(mot, dic)
	afficherXSAMPA(mot, dic)

def afficherIPA(mot, dic):
	afficherPro(mot, dic, 1, "IPA")

def afficherXSAMPA(mot, dic):
	afficherPro(mot, dic, 0, "XSAMPA")

def afficherPro(mot, dic, index, alph):
	if not mot in dic:
		print("ce mot n'est pas present dans le dictionnaire")
	else:
		print("La prononciation de ", mot, " avec l'alphabet ", alph, " est: ", dic[mot][index])

def afficherMots(p, dic):
	mots = [key for key in dic.keys() if p in dic[key]]
	print("Il y a ", len(mots), "mots qui se prononce ", p, ": ", mots)



if __name__ == "__main__":
	main()
