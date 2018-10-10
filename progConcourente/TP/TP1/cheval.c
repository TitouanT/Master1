#include <stdio.h>
#include <stdlib.h>
#include <sys/msg.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>

#include <commun.h>
#include <liste.h>
#include <piste.h>

elem_t pullElem (liste_t * liste, cell_t cell);
void     pushElem (liste_t * liste, elem_t elem);
void      delElem (liste_t * liste, elem_t elem);

void * getSHM (int cle, size_t size);
int    getSEM (int cle, int size);

piste_t * getPisteSHM (int cle_piste);
int       getPisteSEM (int cle_piste);

liste_t * getListeSHM (int cle_liste);
int       getListeSEM (int cle_liste);

void  verrouiller (int sem, int index);
void deverrouiller (int sem, int index);

void say(char *msg) {
	// printf("%i: %s\n", getpid(), msg);
}

int main (int nb_arg, char * tab_arg[]) {
	/*
	DÉCLARATION
	*/

	// declaration des variables de manipulation de la piste
	// rappel: la piste est un segment de mémoire partagé et chaque cellule de la piste sont protégée par un sémaphore
	int cle_piste; // à la fois la clé de la memoire partagé et de la sémaphore
	int sem_piste;
	piste_t * piste = NULL; // pointeur vers un segment de mémoire partagé

	// declaration des variables de manipulation de la liste
	// rappel: la liste est un segment de mémoire partagé qui contient tous les chevaux en course, l'ensemble de la liste est protégé par un sémaphore
	int cle_liste; // à la fois la clé de la memoire partagé et de la sémaphore
	int sem_liste;
	liste_t * liste = NULL; // pointeur vers un segment de mémoire partagé

	char marque;

	booleen_t fini = FAUX;

	// declaration des indices qui nous permettront de savoir ou ce trouve notre cheval
	piste_id_t deplacement = 0;
	piste_id_t depart = 0;
	piste_id_t arrivee = 0;

	// declaration des variables qui représenteront notre cheval
	cell_t cell_cheval;
	elem_t elem_cheval;

	cell_t cell_cheval_ennemi;
	elem_t elem_cheval_ennemi;



	/*
	LECTURE DES ARGUMENTS
	*/

	if (nb_arg != 4) {
		fprintf (stderr, "usage : %s <cle de piste> <cle de liste> <marque>\n", tab_arg[0]);
		exit(-1);
	}

	if (sscanf (tab_arg[1], "%d", &cle_piste) != 1) {
		fprintf (stderr, "%s : erreur, mauvaise cle de piste (%s)\n",
		tab_arg[0]	, tab_arg[1]);
		exit(-2);
	}


	if (sscanf (tab_arg[2], "%d", &cle_liste) != 1) {
		fprintf (stderr, "%s : erreur, mauvaise cle de liste (%s)\n",
		tab_arg[0]	, tab_arg[2]);
		exit(-2);
	}

	if (sscanf (tab_arg[3], "%c", &marque) != 1) {
		fprintf (stderr, "%s : erreur, mauvaise marque de cheval (%s)\n",
		tab_arg[0]	, tab_arg[3]);
		exit(-2);
	}

	// recuperation de la piste
	piste = getPisteSHM(cle_piste);
	sem_piste = getPisteSEM(cle_piste);

	// recuperation de la liste
	liste = getListeSHM(cle_liste);
	sem_liste = getListeSEM(cle_liste);

	/* Init de l'attente */
	commun_initialiser_attentes(); // initialsation des nombres aléatoires


	/* Init de la cellule du cheval pour faire la course */
	cell_pid_affecter (&cell_cheval	, getpid());
	cell_marque_affecter (&cell_cheval, marque);

	/* Init de l'element du cheval pour l'enregistrement */
	elem_cell_affecter(&elem_cheval, cell_cheval);
	elem_etat_affecter(&elem_cheval, EN_COURSE);
	elem_sem_creer(&elem_cheval);

	/*
	* Enregistrement du cheval dans la liste
	*/
	say("Je m'apprête à m'ajouter dans la liste");
	verrouiller(sem_liste, 0);
	say("J'ai la main sur la liste");
	liste_elem_ajouter(liste, elem_cheval);
	say("je me suis ajouter, et je vais rendre la liste");
	deverrouiller(sem_liste, 0);
	say("je viens de rendre la liste");



	while (! fini) {
		/* Attente entre 2 coup de de */
		say("j'attend mon tour\n\n");
		commun_attendre_tour();

		/*
		Préparation de mon déplacement
		*/

		// debut de mon tour, je prend le controle de la liste
		say("Je veux la liste");
		verrouiller(sem_liste, 0);
		say("J'ai la liste");

		// je récupère l'element qui me représente dans la liste
		elem_cheval = pullElem(liste, cell_cheval);
		// je me verouille afin de me déplacer en toute serenité
		say("je prend ma semaphore");
		elem_sem_verrouiller(&elem_cheval);

		// puis je rend la main sur la liste
		say("je rend la main sur la liste");
		deverrouiller(sem_liste, 0);

		// si decanillé alors la course est fini pour moi
		if (elem_etat_lire(elem_cheval) == DECANILLE){
			say("je viens de voir que je suis decanille, c'est fini pour moi");
			break;
		}



		/*
		* Avancee sur la piste
		*/

		/* Coup de de */
		deplacement = commun_coup_de_de();
		#ifdef _DEBUG_
			printf(" Lancement du De --> %d\n", deplacement);
		#endif

		arrivee = depart+deplacement;

		if (arrivee > PISTE_LONGUEUR-1) {
			arrivee = PISTE_LONGUEUR-1;
			fini = VRAI;
		}
		if (arrivee == depart) {
			piste_afficher_lig (piste);
			continue;
		}

		// decoler -- effacement de la case de départ si besoin
		say("je veux la main sur la piste, pour ma case de depart");
		verrouiller(sem_piste, depart);
		say("j'ai la main sur la piste");
		piste_cell_lire(piste, depart, &cell_cheval_ennemi);
		if (cell_comparer(cell_cheval, cell_cheval_ennemi) == 0) {
			piste_cell_effacer(piste, depart);
			say("je viens d'effacer ma position de depart");
		}
		else {
			say("qqun est present sur ma case, je le laisse");
		}
		say("je vais liberer la piste");
		deverrouiller(sem_piste, depart);
		say("j'ai liberer la piste");

		// je plane
		say("j'attend la fin de mon saut");
		commun_attendre_fin_saut();

		// atterissage -- affectation en case d'arrivée
		say("je veux la main sur la piste, pour ma case d'arrivée");
		verrouiller(sem_piste, arrivee);
		say("j ai la main sur la piste");
		if (piste_cell_occupee(piste, arrivee)) {
			say("ma case d'arrivée est occupée !!");
			piste_cell_lire(piste, arrivee, &cell_cheval_ennemi);
			// deverrouiller(sem_piste, arrivee);
			say("je veux la main sur la liste");
			verrouiller(sem_liste, 0);
			say("j ai la main sur la liste");
			elem_cheval_ennemi = pullElem(liste, cell_cheval_ennemi);
			if (elem_sem_lire(elem_cheval_ennemi) > 0) {
				say("le sem du cheval qui est sur ma case d'arrivée est disponible, donc je le decanille");
				elem_decanille(elem_cheval_ennemi);
				pushElem(liste, elem_cheval_ennemi);
			}
			else {
				say("Le cheval présent sur ma case d'arrivée est en train de sauter ! Je ne le décanille donc pas");
			}
			say("je vais rendre la main sur la liste");
			deverrouiller(sem_liste, 0);
			say("j'ai rendu la main sur la liste");

		}
		piste_cell_affecter(piste, arrivee, cell_cheval);
		say("je me place sur la piste, sur ma case d'arrivée et je rend la main sur la piste");
		deverrouiller(sem_piste, arrivee);
		say("la main sur la piste est rendu");


		#ifdef _DEBUG_
			printf("Deplacement du cheval \"%c\" de %d a %d\n",
			marque, depart, arrivee);
		#endif


		// j'ai fini de sauter, je rend la main sur le sémaphore qui protège mon élément dans la liste
		say("je demande la main sur la liste");
		verrouiller(sem_liste, 0);
		say("j'ai la main sur la liste");
		elem_cheval = pullElem(liste, cell_cheval);
		say("je vais maitenant rendre le sem sur mon cheval");
		elem_sem_deverrouiller(&elem_cheval);
		say("le sem cheval est rendu");
		say("je vais rendre la liste");
		deverrouiller(sem_liste, 0);
		say("la liste est rendu");


		/* Affichage de la piste */
		piste_afficher_lig (piste);

		depart = arrivee;
	}

	if (fini) {
		printf ("Le cheval \"%c\" A FRANCHIT LA LIGNE D ARRIVEE\n", marque);
		//on passe en etat arrivé
		say("je vais me passé en etat ARRIVE");
		say("je demande le controle de la liste");
		verrouiller(sem_liste, 0);
		say("j ai la main sur la liste");
		elem_etat_affecter(&elem_cheval, ARRIVE);
		pushElem(liste, elem_cheval);
		say("j ai maj mon etat, et je vais rendre la liste");
		deverrouiller(sem_liste, 0);
		say("j ai rendu la liste");
	}
	else printf("Le cheval \"%c\" A ÉTÉ DÉCANILLÉ\n", marque);



	/*
	* Suppression du cheval de la liste
	*/
	say("JE VAIS ME SUPPRIMER DE LA PISTE");
	// supression du cheval de la piste:
	say("je demande le controle de la piste");
	verrouiller(sem_piste, arrivee);
	say("je l ai");
	piste_cell_lire(piste, arrivee, &cell_cheval_ennemi);
	if (cell_comparer(cell_cheval, cell_cheval_ennemi) == 0) {
		piste_cell_effacer(piste, arrivee);
		say("je me suis effacer de la piste");
	} else say("je n'y suis déjà plus");
	say("je vais rendre la main sur la piste");
	deverrouiller(sem_piste, arrivee);
	say("je rend la main sur la piste");

	say("JE VAIS ME SUPPRIMER DE LA LISTE");
	// supression de la liste
	say("je demande la main sur la liste");
	verrouiller(sem_liste, 0);
	say("je l ai");
	delElem(liste, elem_cheval);
	say("je me suis retiré et je rend la main");
	deverrouiller(sem_liste, 0);
	say("la liste est rendu");

	say("je supprime ma semaphore");
	elem_sem_detruire(&elem_cheval);


	exit(0);
}

elem_t pullElem(liste_t * liste, cell_t cell) {
	elem_t elem;
	elem_cell_affecter(&elem, cell);
	liste_id_t index;
	liste_elem_rechercher(&index, liste, elem);
	return liste_elem_lire(liste, index);
}

void pushElem(liste_t * liste, elem_t elem) {
	liste_id_t index;
	liste_elem_rechercher(&index, liste, elem);
	liste_elem_affecter(liste, index, elem);
}

void delElem(liste_t * liste, elem_t elem) {
	liste_id_t index;
	liste_elem_rechercher(&index, liste, elem);
	liste_elem_supprimer(liste, index);
}

int getSEM (int cle, int size) {
	int semid = semget(cle, size, 0666);
	if (semid == -1) {
		perror("Pb semget");
		exit(-1);
	}

	return semid;
}
void * getSHM (int cle, size_t size) {
	int shmid = shmget(cle, size, 0666);
	if (shmid == -1) {
		perror("Pb sur shmget");
		exit(-1);
	}
	void * p = shmat(shmid,0,0);
	if (p == (void*) -1) {
		perror("Pb shmat");
		exit(-1);
	}
	return p;
}

piste_t * getPisteSHM(int cle_piste) {
	return (piste_t*) getSHM(cle_piste, sizeof(piste_t));
}
int getPisteSEM(int cle_piste) {
	return getSEM(cle_piste, PISTE_LONGUEUR);
}

liste_t * getListeSHM(int cle_liste) {
	return (liste_t*) getSHM(cle_liste, sizeof(liste_t));
}
int getListeSEM(int cle_liste) {
	return getSEM(cle_liste, 1);
}

void verrouiller(int sem, int index) {
	struct sembuf op_P = { index , -1 , SEM_UNDO };

	if (semop (sem, &op_P, 1) == -1) {
		perror("elem_sem_verrouiller: Pb semop ");
		return;
	}

}
void deverrouiller(int sem, int index) {
	struct sembuf op_P = { index , 1 , SEM_UNDO };

	if (semop (sem, &op_P, 1) == -1) {
		perror("elem_sem_verrouiller: Pb semop ");
		return;
	}
}
