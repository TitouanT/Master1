#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define NbExpr 13

enum {faux, vrai};
enum {false, true};

void attendre();
void tirage_aleatoire (int* a, int* b, int* c);
void expert (int a, int b, int c, int pion1, int pion2);
void maj_modele_apprenant (int choix, int pion_joueur);
void afficher_modele_apprenant();
int conseil (int choix);
int saisie_choix_joueur (int a, int b, int c);
void tour_joueur (int* pion_joueur, int* pion_west);
void tour_west (int* pion_joueur, int* pion_west);

/* Jeu WEST */

/* Caractéristiques d'un déplacement possible */
typedef struct {
	int val_expr;       /* Valeur de l'expression */
	int nouv_posit;     /* Nouvelle position joueur */
	int nouv_posit_adv; /* Nouvelle position adversaire */
	int ville;          /* Usage d'une ville */
	int raccourci;      /* Usage d'un raccourci */
	int collision;      /* Usage d'une collision */
	int max_nombre;
	int max_delta;
	int max_distance;
} t_deplact;

/* Tableau des déplacements possibles */
t_deplact table[NbExpr];

/* Indice du meilleur déplacement */
int meilleur;
int firstPlay = true;

/* Maximums atteignables (plus grand nombre, plus grande
   distance et plus grand delta) */
int max_nombre, max_distance, max_delta;

typedef struct {
	// all of those are counter incremented when:
	int achieved; // the concept is     achieved
	int overused; // the concept is     achieved over the best move
	int bestuse;  // the concept is     achieved as part of the best move
	int avoided;  // the concept is not achieved but was possible
	int missed;   // the concept is not achieved but was possible with the best move
	double precision;
	double rappel;
	double f1score;
} concept, action, strategie;

/* Modele de l'apprenant */
typedef struct {
	strategie nombre;
	strategie distance;
	strategie delta;
	action collision;
	action shortcut;
	action town;
} t_modele;

t_modele modele_appr;


/*--------------------------------------------------------*/
void printMap (int a, int b) {
	const int lines = 33;
	char* map[33] = {
		"┏━━━━━━━━━┓",
		"┃         ┃                                    ",
		"┃      ─┴─╂─┴───┴───┴───┴───┴───┴───┴───┴───┴─┐",
		"┃ Town  0 ┃ 1   2   3   4   5   6   7   8   9 │",
		"┗━━━━━━━━━┛                 └───┐         ┏━━━┿━━━━━┓",
		"                                          ┃   │     ┃",
		"      ┌─┴───┴───┴───┴───┴───┴───┴───┴───┴─╂─┴─┘     ┃",
		"      │ 19  18  17  16  15  14  13  12  11┃ 10 Town ┃",
		"┏━━━━━┿━━━┓                               ┗━━━━━━━━━┛",
		"┃     │   ┃                                    ",
		"┃     └─┴─╂─┴───┴───┴───┴───┴───┴───┴───┴───┴─┐",
		"┃ Town 20 ┃21  22  23  24  25  26  27  28  29 │",
		"┗━━━━━━━━━┛         ┌───────┘             ┏━━━┿━━━━━┓",
		"                                          ┃   │     ┃",
		"      ┌─┴───┴───┴───┴───┴───┴───┴───┴───┴─╂─┴─┘     ┃",
		"      │ 39  38  37  36  35  34  33  32  31┃ 30 Town ┃",
		"┏━━━━━┿━━━┓                               ┗━━━━━━━━━┛",
		"┃     │   ┃                                    ",
		"┃     └─┴─╂─┴───┴───┴───┴───┴───┴───┴───┴───┴─┐",
		"┃ Town 40 ┃41  42  43  44  45  46  47  48  49 │",
		"┗━━━━━━━━━┛             └───┐             ┏━━━┿━━━━━┓",
		"                                          ┃   │     ┃",
		"      ┌─┴───┴───┴───┴───┴───┴───┴───┴───┴─╂─┴─┘     ┃",
		"      │ 59  58  57  56  55  54  53  52  51┃ 50 Town ┃",
		"┏━━━━━┿━━━┓                               ┗━━━━━━━━━┛",
		"┃     │   ┃                                    ",
		"┃     └─┴─╂─┴───┴───┴───┴───┴───┴───┴───┴───┴─┐",
		"┃ Town 60 ┃61  62  63  64  65  66  67  68  69 │",
		"┗━━━━━━━━━┛                               ┏━━━┿━━━━━┓",
		"                                          ┃   │     ┃",
		"                                          ┃ ┴─┘     ┃",
		"                                          ┃ 70 Town ┃",
		"                                          ┗━━━━━━━━━┛"
	};

	if (b < 0)  b =  0;
	if (b > 70) b = 70;
	if (a < 0)  a =  0;
	if (a > 70) a = 70;

	int lineA = a / 10;
	int colA  = a % 10;
	if (lineA % 2 == 1) colA = 9 - colA;
	colA  = 8 + colA  * 4;
	lineA = 1 + lineA * 4;


	int lineB = b / 10;
	int colB  = b % 10;
	if (lineB % 2 == 1) colB = 9 - colB;
	colB  = 8 + colB  * 4;
	lineB = 1 + lineB * 4;

	if (a == b) colA -= 1;

	printf ("\e[1;1H\e[2J");// permet d'afficher la carte tout en haut de la console

	for (int i = 0; i < lines; i++) {
		if (i == lineA || i == lineB) {
			for (int j = 0, col = 0; map[i][j]; col++) {
				if (col == colA && i == lineA) printf ("\e[1m\e[38;2;0;255;0mA\e[0m");
				else if (col == colB && i == lineB) printf ("\e[1m\e[38;2;255;0;0mB\e[0m");
				else if (map[i][j] == ' ') printf (" ");
				else {
					while (map[i][j] && map[i][j] != ' ') {
						printf ("%c", map[i][j]);
						j++;
					}
					j--;
				}
				j++;
			}
		} else printf (map[i]);
		printf ("\n");
	}
}

void attendre() {
	/* Pause entre deux tours de jeu */
	char rc;
	printf ("Tapez entrée pour continuer ");
	scanf ("%c", &rc);
}

void tirage_aleatoire (int* a, int* b, int* c) {
	/* Tire au hasard trois nombres:
	   a compris entre 1 et 3
	   b compris entre 0 et 4
	   c compris entre 1 et 7
	   */
	*a = rand() % 3 + 1;
	*b = rand() % 5;
	*c = rand() % 7 + 1;
}

void expert (int a, int b, int c, int pion1, int pion2) {
	/* Calcule tous les déplacements possibles de pion1
	   en fonction des trois chiffres tirés au hasard */

	int i;
	int nouv_posit_pion2;

	table[1].val_expr  = a * b + c;
	table[2].val_expr  = a * c + b;
	table[3].val_expr  = c * b + a;
	table[4].val_expr  =(a + b)* c;
	table[5].val_expr  =(a + c)* b;
	table[6].val_expr  =(c + b)* a;
	table[7].val_expr  = a * b - c;
	table[8].val_expr  = a * c - b;
	table[9].val_expr  = c * b - a;
	table[10].val_expr = a + b - c;
	table[11].val_expr = a + c - b;
	table[12].val_expr = c + b - a;

	for (i = 1; i < NbExpr; i++) {
		/* Le pion avance du nombre de cases donné par
		   l'expression formée avec les trois chiffres,
		   sans reculer au - delà de la case de départ */
		if (pion1 + table[i].val_expr > 0) table[i].nouv_posit = pion1 + table[i].val_expr;
		else table[i].nouv_posit = 0;

		/* Cas de dépassement de l'arrivée: retour arrière */
		if (table[i].nouv_posit > 70) table[i].nouv_posit = 140 - table[i].nouv_posit;

		/* Cas des raccourcis en cases 5, 25 et 44*/
		if (table[i].nouv_posit == 5) {
			table[i].nouv_posit = 13;
			table[i].raccourci = vrai;
		} else if (table[i].nouv_posit == 25) {
			table[i].nouv_posit = 36;
			table[i].raccourci = vrai;
		} else if (table[i].nouv_posit == 44) {
			table[i].nouv_posit = 54;
			table[i].raccourci = vrai;
		} else table[i].raccourci = faux;

		/* Cas des villes: on passe à la suivante*/
		if (table[i].nouv_posit%10 == 0 && table[i].val_expr != 0 && table[i].nouv_posit != 70 && table[i].nouv_posit != 0) {
			table[i].nouv_posit += 10;
			table[i].ville = vrai;
		} else table[i].ville = faux;


		/* Cas de collision avec l'autre pion:
		   il est renvoyé deux villes en arrière */
		if (table[i].nouv_posit == pion2 && !table[i].ville && table[i].val_expr != 0) {
			nouv_posit_pion2 = pion2 - pion2%10 - 10;
			if (nouv_posit_pion2 < 0) nouv_posit_pion2 = 0;
			table[i].nouv_posit_adv = nouv_posit_pion2;
			table[i].collision = vrai;
		} else {
			table[i].nouv_posit_adv = pion2;
			table[i].collision = faux;
		}
	}

	/* Calcul du maximum possible
	 - pour la valeur de l'expression (max_nombre)
	 - pour la distance parcourue (max_distance)
	 - pour la distance entre les deux pions (max_delta)
	   */
	max_nombre = table[1].val_expr;
	max_distance = table[1].nouv_posit - pion1;
	max_delta = table[1].nouv_posit - table[1].nouv_posit_adv;
	meilleur = 1;

	for (i = 2; i < NbExpr; i++) {
		if (table[i].val_expr > max_nombre) max_nombre = table[i].val_expr;

		if (table[i].nouv_posit - pion1 > max_distance) max_distance = table[i].nouv_posit - pion1;

		if (table[i].nouv_posit - table[i].nouv_posit_adv > max_delta) {
			max_delta = table[i].nouv_posit - table[i].nouv_posit_adv;
			if (table[meilleur].nouv_posit != 70) meilleur = i;
		}
		/* Un coup gagnant est toujours le meilleur */
		if (table[i].nouv_posit == 70) meilleur = i;
	}

	for (i = 1; i < NbExpr; i++) {
		table[i].max_nombre   = table[i].val_expr                             == max_nombre;
		table[i].max_distance = table[i].nouv_posit - pion1                   == max_distance;
		table[i].max_delta    = table[i].nouv_posit - table[i].nouv_posit_adv == max_delta;
	}
}

void majConcept (concept * c, int done, int bybest, int possible) {
	if (done) {
		c -> achieved += 1;
		if (bybest) c -> bestuse += 1;
		else c -> overused += 1;
	} else {
		if (bybest) c -> missed += 1;
		else if (possible) c -> avoided += 1;
	}
	float truePositive = c -> bestuse;
	float falsePositive = c -> overused;
	float falseNegative = c -> missed;
	c -> precision = (truePositive == 0) ? 0 : truePositive / (truePositive + falsePositive);
	c -> rappel =    (truePositive == 0) ? 0 : truePositive / (truePositive + falseNegative);
	c -> f1score = (truePositive == 0) ? 0 : 2 * (c -> precision * c -> rappel) / (c -> precision + c -> rappel);
}

void maj_modele_apprenant (int choix, int pion_joueur) {
	/* Mise à jour du modèle du joueur après son tour de jeu */
	int    nombre_done = false,    nombre_bybest = false,    nombre_possible = false;
	int  distance_done = false,  distance_bybest = false,  distance_possible = false;
	int     delta_done = false,     delta_bybest = false,     delta_possible = false;
	int collision_done = false, collision_bybest = false, collision_possible = false;
	int  shortcut_done = false,  shortcut_bybest = false,  shortcut_possible = false;
	int      town_done = false,      town_bybest = false,      town_possible = false;

	if (table[meilleur].ville)            town_bybest = true;
	if (table[meilleur].collision)   collision_bybest = true;
	if (table[meilleur].raccourci)    shortcut_bybest = true;
	if (table[meilleur].max_delta)       delta_bybest = true;
	if (table[meilleur].max_nombre)     nombre_bybest = true;
	if (table[meilleur].max_distance) distance_bybest = true;

	if (table[choix].ville)            town_done = true;
	if (table[choix].collision)   collision_done = true;
	if (table[choix].raccourci)    shortcut_done = true;
	if (table[choix].max_delta)       delta_done = true;
	if (table[choix].max_nombre)     nombre_done = true;
	if (table[choix].max_distance) distance_done = true;

	for (int i = 0; i < NbExpr; i++) {
		if (table[i].ville)          town_possible = true;
		if (table[i].collision) collision_possible = true;
		if (table[i].raccourci)  shortcut_possible = true;
	}

	majConcept (&(modele_appr.nombre),       nombre_done,    nombre_bybest,    nombre_possible);
	majConcept (&(modele_appr.distance),   distance_done,  distance_bybest,  distance_possible);
	majConcept (&(modele_appr.delta),         delta_done,     delta_bybest,     delta_possible);
	majConcept (&(modele_appr.collision), collision_done, collision_bybest, collision_possible);
	majConcept (&(modele_appr.shortcut),   shortcut_done,  shortcut_bybest,  shortcut_possible);
	majConcept (&(modele_appr.town),           town_done,      town_bybest,      town_possible);
}

void initConcept (concept * c) {
	c -> achieved = 0;
	c -> overused = 0;
	c -> bestuse  = 0;
	c -> avoided  = 0;
	c -> missed   = 0;
}

void initModeleApprenant (t_modele * m) {
	initConcept (&(m -> nombre));
	initConcept (&(m -> distance));
	initConcept (&(m -> delta));
	initConcept (&(m -> collision));
	initConcept (&(m -> shortcut));
	initConcept (&(m -> town));
}

void printConcept (concept c, char * cd) {
	printf (
		"precision %.2f, rappel %.2f, f1score %.2f, achieved %2d, overused %2d, bestuse %2d, avoided %2d, missed %2d (%s)\n",
		c.precision, c.rappel, c.f1score,
		c.achieved, c.overused, c.bestuse, c.avoided, c.missed, cd
	);
}

void afficher_modele_apprenant() {
	/* Affichage du modèle du joueur en fin de partie*/
	printf ("Votre modèle: \n");
	printConcept (modele_appr.nombre,    "maximiser la valeur de l'expression");
	printConcept (modele_appr.distance,  "maximiser la distance parcouru");
	printConcept (modele_appr.delta,     "maximiser l'écart entre vous et l'adveraire");
	printConcept (modele_appr.collision, "collision");
	printConcept (modele_appr.shortcut,  "raccourci");
	printConcept (modele_appr.town,      "ville");
}

int conseil (int choix) {
	static int talkedLastTurn = false;
	/* ┌────────────────────────────────────────────────────┐ */
	/* │ principe 7: feliciter le joueur quand il joue bien │ */
	/* └────────────────────────────────────────────────────┘ */
	if (table[choix].nouv_posit == table[meilleur].nouv_posit) {
		printf ("Parfait ! Je n'aurais pas fait mieux !\n");
		attendre();
		return false;
	}
	/* ┌─────────────────────────────────────────────────────────────────────────────┐ */
	/* │ principe 6: ne pas intervenir tant que le joueur n'as pas découvert le jeu. │ */
	/* └─────────────────────────────────────────────────────────────────────────────┘ */
#ifndef DEBUG
	if (firstPlay) return false;
#endif
	/* ┌───────────────────────────────────────────────┐ */
	/* │ principe 5: ne pas intervenir 2 fois de suite │ */
	/* └───────────────────────────────────────────────┘ */
	if (talkedLastTurn) {
		talkedLastTurn = false;
#ifndef DEBUG
		return false;
#endif
	}

	int mville = table[meilleur].ville;
	int mracc  = table[meilleur].raccourci;
	int mcoll  = table[meilleur].collision;

	int jville = table[choix].ville;
	int jracc  = table[choix].raccourci;
	int jcoll  = table[choix].collision;

	if (!mville && !mracc && !mcoll) {
		/* ┌───────────────────────────────────────────────────────────────────┐ */
		/* │ principe 1: Intervenir sur les stratégies où le joueur est faible │ */
		/* └───────────────────────────────────────────────────────────────────┘ */
		/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
		/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
		/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
#ifndef DEBUG
		if (modele_appr.nombre.f1score > 0.5 && modele_appr.nombre.f1score < 0.9) {
			afficher_modele_apprenant();
			return false;
		}
#endif
		if (jville || jcoll || jracc) {
			if (jcoll && jracc) {
				printf ("Wow !Joli combo, mais une expression plus grande t'aurais permise de creuser encore plus l'écart !");
			} else {
				printf ("C'est bien d'utiliser les ");
				if (jville) printf ("villes, mais quelque fois tu peux aller encore plus loin juste avec une expression plus grande !");
				else if (jcoll) printf ("collisions, mais quelque fois tu peux creuser encore plus l'écart avec une expression plus grande !");
				else printf ("raccourcis, mais quelque fois tu peux aller encore plus loin juste avec une expression plus grande !");
			}
		} else printf ("Oups, tu aurais pu aller plus loin simplement en choississant une expression plus grande.");
	} else if (mville) {
		/* ┌───────────────────────────────────────────────────────────────────┐ */
		/* │ principe 1: Intervenir sur les stratégies où le joueur est faible │ */
		/* └───────────────────────────────────────────────────────────────────┘ */
		/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
		/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
		/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
#ifndef DEBUG
		if (modele_appr.distance.f1score > 0.5 && modele_appr.distance.f1score < 0.9) {
			afficher_modele_apprenant();
			return false;
		}
#endif
		if (jville || jcoll || jracc) {
			if (jcoll && jracc) {
				printf ("Wow !Joli combo !Mais tu aurais pu encore plus creuser l'écart en passant par une ville.");
			} else {
				if (jville) printf ("Tu aurais pu atteindre une ville encore plus loin !");
				else if (jcoll) printf ("Bien joué, tu m'as fait reculer. Mais tu aurais pu encore plus creuser l'écart en passant par une ville.");
				else printf ("Pas mal, mais une ville encore plus loin était atteignable. Quand tu prend un raccourci, vérifie à chaque fois si une ville ne serait pas plus intéréssante.");
			}
		} else {
			/* ┌─────────────────────────────────────────────────────────────────┐ */
			/* │ principe 10: fournir de l'aide selon plusieurs niveau de détail │ */
			/* └─────────────────────────────────────────────────────────────────┘ */
			if (modele_appr.town.f1score <= 0.5)
				printf ("Pssst, quand tu arrive dans une ville, tu es immédiatement téléporté dans la ville suivante !");
			else printf ("Oups, n'oublie pas les villes !");
			/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
			/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
			/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
		}
	} else if (mcoll) {
		/* ┌───────────────────────────────────────────────────────────────────┐ */
		/* │ principe 1: Intervenir sur les stratégies où le joueur est faible │ */
		/* └───────────────────────────────────────────────────────────────────┘ */
		/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
		/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
		/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
#ifndef DEBUG
		if (modele_appr.delta.f1score > 0.5 && modele_appr.delta.f1score < 0.9) {
			afficher_modele_apprenant();
			return false;
		}
#endif
		if (jville || jracc) printf ("Oufff ... Tu aurais pu encore plus creuser l'écart en me faisant reculer !");
		else {
			/* ┌─────────────────────────────────────────────────────────────────┐ */
			/* │ principe 10: fournir de l'aide selon plusieurs niveau de détail │ */
			/* └─────────────────────────────────────────────────────────────────┘ */
			if (modele_appr.shortcut.f1score < 0.5)
				printf ("Pssst, quand tu arrive sur la même case que moi, je suis renvoyer 2 villes en arrière !");
			else printf ("Oups, n'oublie pas les collisions !");
			/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
			/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
			/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
		}
	} else if (mracc) {
		/* ┌───────────────────────────────────────────────────────────────────┐ */
		/* │ principe 1: Intervenir sur les stratégies où le joueur est faible │ */
		/* └───────────────────────────────────────────────────────────────────┘ */
		/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
		/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
		/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
#ifndef DEBUG
		if (modele_appr.distance.f1score > 0.5 && modele_appr.distance.f1score < 0.9) {
			afficher_modele_apprenant();
			return false;
		}
#endif
		if (jville || jcoll || jracc) {
			if (jcoll && jracc) {
				printf ("Wow !Joli combo !Mais tu aurais pu prendre le raccourci suivant pour aller encore plus loin.");
			} else {
				if (jville) printf ("Oups, il y avait un raccourci accessible après cette ville !Il t'aurait amené encore plus loin !");
				else if (jcoll) printf ("Bien joué, tu m'as fait reculer. Mais un raccourci t'aurait permis de creuser encore plus l'écart !");
				else printf ("Pas mal, mais un raccourci encore plus loin était atteignable.");
			}
		} else {
			/* ┌─────────────────────────────────────────────────────────────────┐ */
			/* │ principe 10: fournir de l'aide selon plusieurs niveau de détail │ */
			/* └─────────────────────────────────────────────────────────────────┘ */
			if (modele_appr.shortcut.f1score < 0.5)
				printf ("Pssst, certaines cases te permettent de faire de grands bons à travers la carte ! Sauras-tu deviner les quelles ?");
			else printf ("Oups, n'oublie pas les raccourcis !");
			/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
			/* │ princicpe 12: en cas d'erreur d'inattention potentiel, faire un commentaire au cas où. │ */
			/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
		}
	}

	talkedLastTurn = true;

	/* ┌────────────────────────────────────────────────────────────────────────────────────────┐ */
	/* │ principe 8 et 3: Après un conseil, proposer au joueur de rejouer mais sans l'y obliger │ */
	/* └────────────────────────────────────────────────────────────────────────────────────────┘ */
	char reponse = 'n';
#ifndef DEBUG
	printf ("Veux - tu rejouer ce coup (o/n) ? ");
	scanf ("%c%*c", &reponse);
#else
	afficher_modele_apprenant();
	attendre();
#endif
	return reponse == 'o';

}

int saisie_choix_joueur (int a, int b, int c) {
	/* Saisie de l'expression choisie par le joueur
	   à partir des trois nombres tirés au hasard */

	int choix;

	do {
		printf ("1: %i * %i + %i = %2i    │    7: %i * %i - %i = %2i\n", a, b, c, a * b + c, a, b, c, a * b - c);
		printf ("2: %i * %i + %i = %2i    │    8: %i * %i - %i = %2i\n", a, c, b, a * c + b, a, c, b, a * c - b);
		printf ("3: %i * %i + %i = %2i    │    9: %i * %i - %i = %2i\n", c, b, a, c * b + a, c, b, a, c * b - a);
		printf ("4:(%i + %i)* %i = %2i    │   10: %i + %i - %i = %2i\n", a, b, c,(a + b)* c, a, b, c, a + b - c);
		printf ("5:(%i + %i)* %i = %2i    │   11: %i + %i - %i = %2i\n", a, c, b,(a + c)* b, a, c, b, a + c - b);
		printf ("6:(%i + %i)* %i = %2i    │   12: %i + %i - %i = %2i\n", c, b, a,(c + b)* a, c, b, a, c + b - a);
		printf ("Choisis une expression (entre 1 et 12): ");
		scanf ("%i%*c", &choix);

	} while (choix < 1 || choix > NbExpr - 1);

	return choix;
}

void tour_joueur (int* pion_joueur, int* pion_west) {
	/* Tour de jeu du joueur */

	int a, b, c;
	int choix;
	int firstTry = true;
	int backupj  = *pion_joueur;
	int backupw  = *pion_west;

	tirage_aleatoire (&a, &b, &c);

	do {
		*pion_joueur = backupj;
		*pion_west   = backupw;
		printMap (*pion_joueur, *pion_west);
		if (firstTry) printf ("\nA ton tour de jouer !");
		printf ("Tu es en %i\n", *pion_joueur);

		printf ("Nombres: %i %i %i\n", a, b, c);
		/* Saisie de l'expression choisie par le joueur */
		choix = saisie_choix_joueur (a, b, c);

		/* Calcul de tous les déplacements possibles
		   pour comparaison avec le choix du joueur */
		expert (a, b, c, *pion_joueur, *pion_west);

		/* Mise à jour du modèle de l'apprenant */
		maj_modele_apprenant (choix, *pion_joueur);


		/* Déplacement du pion du joueur*/
		*pion_joueur += table[choix].val_expr;
		if (*pion_joueur <  0) *pion_joueur = 0;
		if (*pion_joueur > 70) *pion_joueur = 140 - *pion_joueur;

		printMap (*pion_joueur, *pion_west);
		printf ("Ton expression vaut %i\n", table[choix ].val_expr);
		printf ("Ton pion avance en %i\n", *pion_joueur);
		attendre();

		if (table[choix].raccourci) {

			if      (*pion_joueur ==  5) *pion_joueur = 13;
			else if (*pion_joueur == 25) *pion_joueur = 36;
			else if (*pion_joueur == 44) *pion_joueur = 54;

			printMap (*pion_joueur, *pion_west);
			printf ("Tu tombes sur un raccourci\n");
			printf ("Ton pion avance en %i\n", *pion_joueur);
			attendre();
		}

		if (table[choix].ville) {
			*pion_joueur += 10;
			printMap (*pion_joueur, *pion_west);
			printf ("Tu tombes sur une ville et tu passes a la suivante\n");
			printf ("Ton pion avance en %i\n", *pion_joueur);
			attendre();
		}

		if (table[choix].collision) {
			*pion_west = table[choix].nouv_posit_adv;
			printMap (*pion_joueur, *pion_west);
			printf ("Ton pion arrive sur la meme case que moi\n");
			printf ("Mon pion recule en %i\n", *pion_west);
			attendre();
		}

		/* Donner un conseil au joueur s'il a mal joué */
		printMap (*pion_joueur, *pion_west);
	} while (firstTry && (firstTry = false, conseil (choix)));

}

void tour_west (int* pion_joueur, int* pion_west) {
	/* Tour de jeu de l'ordinateur */

	int a, b, c;
	int depart = *pion_west;

	tirage_aleatoire (&a, &b, &c);

	/* Calcul de tous les déplacements possibles
	   ainsi que du meilleur (stratégie "delta maximum") */
	expert (a, b, c, *pion_west, *pion_joueur);

	/* Deplacement du pion de West */


	*pion_west += table[meilleur].val_expr;
	if (*pion_west > 70)
		*pion_west = 140 - *pion_west;

	printMap (*pion_joueur, *pion_west);
	printf ("\nA mon tour de jouer !");
	printf ("Je suis en %i\n", depart);
	printf ("Nombres: %i %i %i\n", a, b, c);
	printf ("Je choisis l'expression: ");
	switch (meilleur) {
		case  1: printf (" %i * %i + %i \n", a, b, c); break;
		case  2: printf (" %i * %i + %i \n", a, c, b); break;
		case  3: printf (" %i * %i + %i \n", c, b, a); break;
		case  4: printf ("(%i + %i) * %i\n", a, b, c); break;
		case  5: printf ("(%i + %i) * %i\n", a, c, b); break;
		case  6: printf ("(%i + %i) * %i\n", c, b, a); break;
		case  7: printf (" %i * %i - %i \n", a, b, c); break;
		case  8: printf (" %i * %i - %i \n", a, c, b); break;
		case  9: printf (" %i * %i - %i \n", c, b, a); break;
		case 10: printf (" %i + %i - %i \n", a, b, c); break;
		case 11: printf (" %i + %i - %i \n", a, c, b); break;
		case 12: printf (" %i + %i - %i \n", c, b, a); break;
	}
	printf ("Mon expression vaut %i\n", table[meilleur].val_expr);
	printf ("Mon pion avance en %i\n", *pion_west);
	attendre();

	if (table[meilleur].raccourci) {

		if      (*pion_west ==  5) *pion_west = 13;
		else if (*pion_west == 25) *pion_west = 36;
		else if (*pion_west == 44) *pion_west = 54;

		printMap (*pion_joueur, *pion_west);
		printf ("Je tombe sur un raccourci\n");
		printf ("Mon pion avance en %i\n", *pion_west);
		attendre();
	}

	if (table[meilleur].ville) {
		*pion_west += 10;

		printMap (*pion_joueur, *pion_west);
		printf ("Je tombe sur une ville et je passe a la suivante\n");
		printf ("Mon pion avance en %i\n", *pion_west);
		attendre();
	}

	if (table[meilleur].collision) {
		*pion_joueur = table[meilleur].nouv_posit_adv;

		printMap (*pion_joueur, *pion_west);
		printf ("Mon pion arrive sur la meme case que toi\n");
		printf ("Ton pion recule en %i\n", *pion_joueur);
		attendre();
	}
}

/*--------------------------------------------------------*/

int main() {

#ifdef DEBUG
	printf("Vous avez lancé West en mode DEBUG, tous les conseils seront donné.\n");
	attendre();
#endif

	/* Position des pions sur le parcours et scores*/
	int pion_joueur, score_joueur = 0;
	int pion_west,   score_west   = 0;
	initModeleApprenant (&modele_appr);

	/* Pour jouer une autre partie */
	char reponse;

	/* Initialisation du tirage pseudo-aléatoire */
	srand (time (0));

	/* Début du jeu */
	do {
		pion_joueur = 0;
		pion_west = 0;
		do {
			tour_joueur (&pion_joueur, &pion_west);
			if (pion_joueur < 70) tour_west (&pion_joueur, &pion_west);
		} while (pion_joueur < 70 && pion_west < 70);
		printMap (pion_joueur, pion_west);

		/* Fin de partie */
		if (pion_joueur == 70) {
			score_joueur++;
			printf ("\nBravo, tu as gagné !\n");
		} else {
			score_west++;
			printf ("\nJ'ai gagné !\n");
		}
		firstPlay = false;

		printf ("Joueur: %i, ", score_joueur);
		printf ("West: %i\n", score_west);
		printf ("Veux - tu jouer une autre partie (o/n) ? ");
		scanf ("%c%*c", &reponse);
	} while (reponse != 'n');

	afficher_modele_apprenant();
}
