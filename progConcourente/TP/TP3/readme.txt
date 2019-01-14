J'ai modifié les fichier trafic_?.c afin de protéger les appels qui concerne les affichage par une sémaphore dans chaque.
J'ai modifié ecran.c afin d'avoir 2 fenêtre pour les messages.


Pour le moniteur:
Ma solution comprend une sémaphore, deux condition et 3 variables.
La sémaphore pour protéger les appels aux fonctions d'entrer et de sortie.
Chaque sens de circulation à une condition et un compteur.
Une dernière variable sert à savoir le nombre maximum de train pouvant circuler en même temps sur la voie.
