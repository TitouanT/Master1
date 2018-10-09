# Ex2

v = input("Entrez une valeur: ")
print(v);


filename = 'texte.txt'
f = open(filename, "r")
for line in f.readlines():
	print(line, end='')
f.close()

f = open(filename, "a")
f.write("M1: premiere annee de master\n")
f.close()

